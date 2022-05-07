local DungeonMobSummary = LibStub("AceAddon-3.0"):NewAddon("DungeonMobSummary")
local T = DungeonMobSummary.Threats

DungeonMobSummary:AddAbilityTable({
	-- Doctor Ickus
	[164967] = {
		-- Burning Strain
		[322358] = {T.TankMustStayInRange}
	}
})
