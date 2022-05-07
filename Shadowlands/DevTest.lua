-- This file contains testing abilities and should not enabled unless explicitly requested by the end-user.
local DungeonMobSummary = LibStub("AceAddon-3.0"):GetAddon("DungeonMobSummary")
local T = DungeonMobSummary.Threats

DungeonMobSummary:AddAbilityTable({
	-- Elysian Bulwark in Elysian Hold
	[154631] = {
		-- Dummy threat
		[0] = {T.TankBuster, T.TankMustStayInRange, T.Interrupt}
	}
})
