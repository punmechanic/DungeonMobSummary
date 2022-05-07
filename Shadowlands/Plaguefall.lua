local Threats = DungeonMobSummary.Threats
local abilityList = {
	-- Doctor Ickus
	[164967] = {
		-- Burning Strain
		[322358] = {Threats.TankMustStayInRange}
	}
}

DungeonMobSummary.Plaguefall = {
	Abilities: abilityList,
}
