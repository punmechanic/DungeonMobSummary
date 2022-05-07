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

