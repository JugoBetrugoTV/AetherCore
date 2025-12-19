-- AetherCore - Minimal Working Addon
-- A simple addon that prints to chat and has a test window command

local ADDON_NAME = "AetherCore"
local ADDON_VERSION = "1.0.0"

-- Initialize addon frame
local AetherCore = {}
AetherCore.name = ADDON_NAME
AetherCore.version = ADDON_VERSION

-- Create main frame for the addon
local mainFrame = CreateFrame("Frame")
mainFrame:RegisterEvent("ADDON_LOADED")

-- Chat print helper function
local function Print(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00[AetherCore]|r " .. msg)
end

-- Event handler
mainFrame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == ADDON_NAME then
        Print("Addon loaded successfully! Version: " .. ADDON_VERSION)
        
        -- Register slash commands
        SLASH_AETHERCORE1 = "/aether"
        SLASH_AETHERCORE2 = "/ac"
        SlashCmdList["AETHERCORE"] = function(msg)
            if msg:lower() == "test" then
                AetherCore:ShowTestWindow()
            elseif msg:lower() == "help" then
                Print("Available commands:")
                Print("/aether test - Opens the test window")
                Print("/aether help - Shows this help message")
            else
                Print("Unknown command. Type /aether help for available commands.")
            end
        end
    end
end)

-- Test Window Function
function AetherCore:ShowTestWindow()
    -- Check if window already exists
    if _G.AetherCoreTestWindow then
        _G.AetherCoreTestWindow:Show()
        return
    end
    
    -- Create the window frame
    local testWindow = CreateFrame("Frame", "AetherCoreTestWindow", UIParent, "BackdropTemplate")
    testWindow:SetSize(400, 300)
    testWindow:SetPoint("CENTER", UIParent, "CENTER")
    testWindow:SetMovable(true)
    testWindow:EnableMouse(true)
    testWindow:RegisterForDrag("LeftButton")
    testWindow:SetScript("OnDragStart", testWindow.StartMoving)
    testWindow:SetScript("OnDragStop", testWindow.StopMovingOrSizing)
    
    -- Set backdrop styling
    testWindow:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    testWindow:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
    testWindow:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8)
    
    -- Title text
    local title = testWindow:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
    title:SetPoint("TOP", testWindow, "TOP", 0, -15)
    title:SetText("AetherCore Test Window")
    title:SetTextColor(0, 1, 0)
    
    -- Info text
    local info = testWindow:CreateFontString(nil, "OVERLAY", "GameFontNormal")
    info:SetPoint("TOPLEFT", testWindow, "TOPLEFT", 15, -50)
    info:SetWidth(370)
    info:SetHeight(100)
    info:SetJustifyH("LEFT")
    info:SetJustifyV("TOP")
    info:SetWordWrap(true)
    info:SetText("This is the AetherCore test window.\n\nAddon is working correctly!\n\nYou can drag this window to move it.")
    info:SetTextColor(1, 1, 1)
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, testWindow, "UIPanelCloseButton")
    closeBtn:SetPoint("TOPRIGHT", testWindow, "TOPRIGHT", -5, -5)
    closeBtn:SetScript("OnClick", function()
        testWindow:Hide()
    end)
    
    Print("Test window opened! Type /aether test to toggle.")
end

-- Expose AetherCore globally
_G.AetherCore = AetherCore
