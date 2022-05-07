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
	local npcId = 164967
	-- local npcId = select(6, guid.split("-"))
	local threatTable = AbilityThreatList[npcId]
	if threatTable == nil then
		-- We don't know anything about this unit
		return
	end

	self:AddLine("Threats:")
	for _, threat in ipairs(ListUniqueThreats(threatTable)) do
		self:AddLine(threat)
	end
end

GameTooltip:HookScript("OnTooltipSetUnit", function (self)
	DungeonMobSummary_tooltipUnitWillChange(self)
end)
