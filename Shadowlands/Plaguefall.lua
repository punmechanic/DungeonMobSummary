local DungeonMobSummary = LibStub("AceAddon-3.0"):NewAddon("DungeonMobSummary")
local T = DungeonMobSummary.Threats
local abilityList = {
	-- Doctor Ickus
	[164967] = {
		-- Burning Strain
		[322358] = {T.TankMustStayInRange}
	}
}

DungeonMobSummary:AddAbilityTable(DevTest, { ZoneID = 13228 })
