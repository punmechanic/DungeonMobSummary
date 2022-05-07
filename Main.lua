-- These are not bit flags.
-- The numbers are used so we can refer to each threat by its key in code.
local Threats = {
	TankMustStayInRange = 0x01,
	TankBuster = 0x02,
	Interrupt = 0x03,
	Decurse = 0x04,
	Purge = 0x05,
	Disease = 0x06,
	Poison = 0x07,
	Bleed = 0x08
}

local ThreatTranslations = {
	[Threats.TankMustStayInRange] = "Stay in range",
	[Threats.TankBuster] = "Tank Buster",
	[Threats.Poison] = "Applies poison",
	[Threats.Disease] = "Applies disease"
}

-- This would benefit more from being specific to specialisation capabilities,
-- like showing threats for classes with decurses, rather than showing decurses for healers.
local RoleThreats = {
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
function FilterThreatsByActiveRole(activeRole, threats)
	-- This can happen if the user is not in a group.
	if activeRole == "NONE" then
		return threats
	end

	local roleThreatIds = RoleThreats[activeRole]
	local relevantThreats = {}
	local otherThreats = {}
	for _, threatId in ipairs(threats) do
		local dest = roleThreatIds[threatId] and relevantThreats or otherThreats
		table.insert(dest, threatId)
	end

	return relevantThreats, otherThreats
end

local AbilityThreatList = {
	-- Doctor Ickus
	[164967] = {
		-- Burning Strain
		[322358] = {Threats.TankMustStayInRange},
		-- TODO: Dummy threat
		[1234] = {Threats.TankBuster, Threats.Poison, Threats.Disease}
	}
}

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
	local _name, id = self:GetUnit()
	local guid = UnitGUID(id)
	local npcId = select(6, guid.split("-"))
	local threatTable = AbilityThreatList[npcId]
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

GameTooltip:HookScript("OnTooltipSetUnit", function (self)
	DungeonMobSummary_tooltipUnitWillChange(self)
end)
