local DungeonMobSummary = LibStub("AceAddon-3.0"):NewAddon("DungeonMobSummary")
local L = LibStub("AceLocale-3.0"):GetLocale("DungeonMobSummary", true)
local Threats = {
	TankMustStayInRange = {
		Label = L["Stay in range"]
	},
	TankBuster = {
		Label = L["Tank Buster"]
	},
	Interrupt = {},
	Decurse = {},
	Purge = {},
	Disease = {
		Label = L["Applies disease"]
	},
	Poison = {
		Label = L["Applies poison"]
	},
	Bleed = {}
}

-- This would benefit more from being specific to specialisation capabilities,
-- like showing threats for classes with decurses, rather than showing decurses for healers.
local RoleThreats = {
	ALL = {
		[Threats.Interrupt] = true
	},
	TANK = {
		[Threats.TankMustStayInRange] = true,
		[Threats.TankBuster] = true
	},
	HEALER = {},
	DAMAGER = {}
}

DungeonMobSummary.Threats = Threats
DungeonMobSummary.RoleThreats = RoleThreats

-- FilterThreatsFilterThreatsByActiveRole splits threats into two groups,
-- one group for the threats that a player with the given activeRole might
-- care more about, and another group for all other threats
local function FilterThreatsByActiveRole(activeRole, threats)
	-- This can happen if the user is not in a group.
	if activeRole == "NONE" then
		return threats
	end

	local roleThreatIds = DungeonMobSummary.RoleThreats[activeRole]
	local relevantThreats = {}
	local otherThreats = {}
	for _, threatId in ipairs(threats) do
		local dest = roleThreatIds[threatId] and relevantThreats or otherThreats
		table.insert(dest, threatId)
	end

	return relevantThreats, otherThreats
end

function ListUniqueThreats(abilities)
	local uniqueThreats = {}
	for _, threats in pairs(abilities) do
		for _, v in pairs(threats) do
			uniqueThreats[v] = true
		end
	end

	local components = {}
	for threat, _true in pairs(uniqueThreats) do
		table.insert(components, threat.Label)
	end

	return components
end

function DungeonMobSummary:tooltipUnitWillChange(tooltip)
	local _name, id = tooltip:GetUnit()
	local guid = UnitGUID(id)
	local npcId = string.match(guid, "%w+-%w+-%w+-%w+-%w+-(%w+)-*")
	local threatTable = self.NpcAbilityTable[npcId]
	if threatTable == nil then
		-- We don't know anything about this unit
		return
	end

	local activeRole = UnitGroupRolesAssigned("player")
	local uniqueThreats = ListUniqueThreats(threatTable)
	local roleThreats, otherThreats = FilterThreatsByActiveRole(activeRole, uniqueThreats)

	-- Intentionally left blank
	tooltip:AddLine(" ")

	for _, threat in ipairs(roleThreats) do
		tooltip:AddLine(threat)
	end

	for _, threat in ipairs(otherThreats) do
		tooltip:AddLine(threat, 0.1, 0.1, 0.1)
	end
end

function DungeonMobSummary:AddAbilityTable(tbl)
	if self.NpcAbilityTable == nil then
		self.NpcAbilityTable = {}
	end

	-- Ability tables have the following format:
	-- { [npcID]: { [abilityID] = {threats} } }
	for k, v in pairs(tbl) do
		-- Users can pass numbers which will cause subtle bugs
		if type(k) == "number" then
			k = tostring(k)
		end

		-- Merge entries that already exist.
		if self.NpcAbilityTable[k] == nil then
			self.NpcAbilityTable[k] = {}
		end

		for abilityID, threats in pairs(v) do
			if self.NpcAbilityTable[k][abilityID] == nil then
				self.NpcAbilityTable[k][abilityID] = threats
			else
				for _, threat in ipairs(threats) do
					table.insert(self.NpcAbilityTable[k][abilityID], threat)
				end
			end
		end
	end
end

function DungeonMobSummary:OnInitialize()
	local addon = self
	GameTooltip:HookScript("OnTooltipSetUnit", function (self)
		addon:tooltipUnitWillChange(self)
	end)
end
