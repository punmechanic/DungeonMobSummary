local DungeonMobSummary = LibStub("AceAddon-3.0"):GetAddon("DungeonMobSummary")
local T = DungeonMobSummary.Threats
-- This file contains testing abilities and should not enabled unless explicitly requested by the end-user.
local DevTest = {
	-- Elysian Bulwark in Elysian Hold
	[154631] = {
		-- Dummy threat
		[0] = {T.TankBuster, T.TankMustStayInRange, T.Interrupt}
	}
}

-- Bastion
DungeonMobSummary:AddAbilityTable(DevTest, { ZoneID = 10534 })
