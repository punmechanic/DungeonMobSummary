local DungeonMobSummary = LibStub("AceAddon-3.0"):NewAddon("DungeonMobSummary")
local L = LibStub("AceLocale-3.0"):GetLocale("DungeonMobSummary", true)
DungeonMobSummary.Threats = {
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
DungeonMobSummary.RoleThreats = {
	ALL = {
		[Threats.Interrupt] = true
	},
	TANK = {
		[Threats.TankMustStayInRange] = true,
		[Threats.TankBuster] = true,
	},
	HEALER = {},
	DAMAGER = {}
}

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
		table.insert(components, ThreatTranslations[threat])
	end

	return components
end

function DungeonMobSummary_tooltipUnitWillChange(self)
	-- TODO: Work out what Zone we are in to determine the ability list.
	local abilityList = DungeonMobSummary.Plaguefall.Abilities

	local _name, id = self:GetUnit()
	local guid = UnitGUID(id)
	local npcId = select(6, guid.split("-"))
	local threatTable = abilityList[npcId]
	if threatTable == nil then
		-- We don't know anything about this unit
		return
	end

	local activeRole = UnitGroupRolesAssigned("player")
	local uniqueThreats = ListUniqueThreats(threatTable)
	local roleThreats, otherThreats = FilterThreatsByActiveRole(activeRole, uniqueThreats)

	-- Intentionally left blank
	self:AddLine(" ")

	for _, threat in ipairs(roleThreats) do
		self:AddLine(threat)
	end

	for _, threat in ipairs(otherThreats) do
		self:AddLine(threat, 0.1, 0.1, 0.1)
	end
end

function DungeonMobSummary:AddAbilityTable(table, predicates)
	print(self.AbilityTables)
	print(table)
end

function DungeonMobSummary:OnInitialize()
	GameTooltip:HookScript("OnTooltipSetUnit", function (self)
		DungeonMobSummary_tooltipUnitWillChange(self)
	end)
end
