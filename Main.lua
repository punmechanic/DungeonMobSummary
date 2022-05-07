function DungeonMobSummaryController__OnEvent(self, event, ...)
	if event == "PLAYER_TARGET_CHANGED" then
		DungeonMobSummaryController__OnTargetChanged(self, TargetFrame, event, ...)
	end
end

-- Parent should be TargetFrame, not UIParent, but it is UIParent for testing
local targetFrameTextFrame = CreateFrame("Frame", "DungeonMobSummaryTargetFrameText", TargetFrame)
-- Anchors the top of the text frame to the bottom of the target frame
targetFrameTextFrame:SetPoint("TOP", TargetFrame, "BOTTOM", 0, 0)
targetFrameTextFrame:SetAlpha(1.0)
targetFrameTextFrame:SetHeight(50)
targetFrameTextFrame:SetWidth(200)

targetFrameTextFrame.text = targetFrameTextFrame:CreateFontString(nil, "ARTWORK")
targetFrameTextFrame.text:SetPoint("TOP", 0, 0)
targetFrameTextFrame.text:SetFont("Fonts\\ARIALN.ttf", 13, "OUTLINE")
targetFrameTextFrame.text:SetText("Interrupt me")

function DungeonMobSummaryController__OnTargetChanged(self, targetFrame, event, ...)
	print("IMPLEMENT ME: Update text to show info for mob!")
end

local addonFrame = CreateFrame("Frame", "DungeonMobSummaryController")
addonFrame:RegisterEvent("PLAYER_TARGET_CHANGED")
addonFrame:SetScript("OnEvent", DungeonMobSummaryController__OnEvent)

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

function CreateThreatDescription(abilities)
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

	return table.concat(components, "·")
end

local td = CreateThreatDescription(AbilityThreatList[164967])
targetFrameTextFrame.text:SetText(td)