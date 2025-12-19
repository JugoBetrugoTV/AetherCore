-- AetherCore Addon
-- A comprehensive WoW addon framework with UI management and chat commands

local ADDON_NAME = "AetherCore"
local VERSION = "1.0.0"

-- Main addon namespace
AetherCore = {}
AetherCore.version = VERSION
AetherCore.frames = {}
AetherCore.commands = {}

-- Color scheme for addon messages
local COLORS = {
    primary = "|cFF00D4FF",      -- Cyan
    success = "|cFF00FF00",      -- Green
    warning = "|cFFFFAA00",      -- Orange
    error = "|cFFFF0000",         -- Red
    reset = "|r"
}

-- ============================================================================
-- Utility Functions
-- ============================================================================

--- Print a formatted message to chat
---@param message string The message to print
---@param color string Optional color code (defaults to primary)
local function Print(message, color)
    color = color or COLORS.primary
    print(color .. "[" .. ADDON_NAME .. "]" .. COLORS.reset .. " " .. message)
end

--- Create a simple text frame for debug messages
---@param text string The text to display
---@param x number X position
---@param y number Y position
local function CreateDebugText(text, x, y)
    local frame = CreateFrame("Frame", nil, UIParent)
    frame:SetSize(300, 30)
    frame:SetPoint("TOPLEFT", UIParent, "TOPLEFT", x or 50, -(y or 50))
    
    local fontString = frame:CreateFontString(nil, "OVERLAY")
    fontString:SetAllPoints(frame)
    fontString:SetFont(GameFontNormal:GetFont(), 12, "OUTLINE")
    fontString:SetText(text)
    fontString:SetTextColor(0, 1, 1)  -- Cyan text
    
    return frame
end

-- ============================================================================
-- Frame Creation Functions
-- ============================================================================

--- Create the main addon window
---@return Frame The main window frame
local function CreateMainWindow()
    local frame = CreateFrame("Frame", ADDON_NAME .. "MainWindow", UIParent, "BackdropTemplate")
    frame:SetSize(400, 300)
    frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
    
    -- Set backdrop (background and border)
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0.1, 0.1, 0.15, 0.95)
    frame:SetBackdropBorderColor(0, 0.8, 1, 0.8)
    
    -- Make frame movable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
    
    -- Title bar
    local titleBar = CreateFrame("Frame", nil, frame)
    titleBar:SetSize(400, 30)
    titleBar:SetPoint("TOPLEFT", frame, "TOPLEFT", 0, 0)
    titleBar:SetBackdropColor(0, 0.6, 0.9, 0.9)
    
    local title = frame:CreateFontString(nil, "OVERLAY")
    title:SetFont(GameFontNormalLarge:GetFont(), 14, "OUTLINE")
    title:SetPoint("CENTER", titleBar, "CENTER", 0, 0)
    title:SetText("AetherCore v" .. VERSION)
    title:SetTextColor(1, 1, 1)
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetSize(24, 24)
    closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    closeBtn:SetScript("OnClick", function()
        frame:Hide()
    end)
    
    -- Content area
    local contentArea = CreateFrame("Frame", nil, frame, "BackdropTemplate")
    contentArea:SetSize(390, 260)
    contentArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 5, -35)
    contentArea:SetBackdropColor(0.05, 0.05, 0.1, 0.8)
    contentArea:SetBackdropBorderColor(0, 0.6, 0.8, 0.5)
    
    -- Status text in content area
    local statusText = frame:CreateFontString(nil, "OVERLAY")
    statusText:SetFont(GameFontNormal:GetFont(), 11)
    statusText:SetPoint("TOPLEFT", contentArea, "TOPLEFT", 10, -10)
    statusText:SetWidth(370)
    statusText:SetHeight(100)
    statusText:SetWordWrap(true)
    statusText:SetText(
        "Welcome to AetherCore!\n\n" ..
        "Commands:\n" ..
        "/aether show - Toggle main window\n" ..
        "/aether button - Create test button\n" ..
        "/aether notify - Create notification\n" ..
        "/aether help - Show all commands"
    )
    statusText:SetTextColor(0, 1, 1)
    
    -- Store content area for later updates
    frame.statusText = statusText
    frame.contentArea = contentArea
    
    -- Hidden by default
    frame:Hide()
    
    return frame
end

--- Create a test button window
---@return Frame The button window frame
local function CreateButtonWindow()
    local frame = CreateFrame("Frame", ADDON_NAME .. "ButtonWindow", UIParent, "BackdropTemplate")
    frame:SetSize(250, 150)
    frame:SetPoint("CENTER", UIParent, "CENTER", -250, 150)
    
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0.15, 0.1, 0.1, 0.95)
    frame:SetBackdropBorderColor(1, 0.4, 0, 0.8)
    
    -- Make frame movable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
    
    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY")
    title:SetFont(GameFontNormalLarge:GetFont(), 12, "OUTLINE")
    title:SetPoint("TOP", frame, "TOP", 0, -10)
    title:SetText("Test Buttons")
    title:SetTextColor(1, 0.8, 0)
    
    -- Button 1
    local btn1 = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    btn1:SetSize(200, 25)
    btn1:SetPoint("TOP", frame, "TOP", 0, -35)
    btn1:SetText("Click Me!")
    btn1:SetScript("OnClick", function()
        Print("Button 1 clicked!", COLORS.success)
    end)
    
    -- Button 2
    local btn2 = CreateFrame("Button", nil, frame, "GameMenuButtonTemplate")
    btn2:SetSize(200, 25)
    btn2:SetPoint("TOP", btn1, "BOTTOM", 0, -5)
    btn2:SetText("Close Window")
    btn2:SetScript("OnClick", function()
        frame:Hide()
    end)
    
    frame:Hide()
    return frame
end

--- Create a notification popup
---@param title string The notification title
---@param message string The notification message
---@param duration number How long to show (in seconds)
---@return Frame The notification frame
local function CreateNotification(title, message, duration)
    duration = duration or 5
    
    local frame = CreateFrame("Frame", ADDON_NAME .. "Notification" .. GetTime(), UIParent, "BackdropTemplate")
    frame:SetSize(300, 100)
    frame:SetPoint("TOPRIGHT", UIParent, "TOPRIGHT", -20, -20)
    
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0.1, 0.15, 0.1, 0.95)
    frame:SetBackdropBorderColor(0, 1, 0.5, 0.8)
    
    -- Title
    local titleText = frame:CreateFontString(nil, "OVERLAY")
    titleText:SetFont(GameFontNormalLarge:GetFont(), 12, "OUTLINE")
    titleText:SetPoint("TOPLEFT", frame, "TOPLEFT", 10, -10)
    titleText:SetText(title)
    titleText:SetTextColor(0, 1, 0.5)
    
    -- Message
    local messageText = frame:CreateFontString(nil, "OVERLAY")
    messageText:SetFont(GameFontNormal:GetFont(), 11)
    messageText:SetPoint("TOPLEFT", titleText, "BOTTOMLEFT", 0, -5)
    messageText:SetWidth(280)
    messageText:SetHeight(60)
    messageText:SetWordWrap(true)
    messageText:SetText(message)
    messageText:SetTextColor(1, 1, 1)
    
    -- Auto-hide after duration
    frame:SetScript("OnUpdate", function(self, elapsed)
        self.elapsed = (self.elapsed or 0) + elapsed
        if self.elapsed >= duration then
            self:Hide()
        end
    end)
    
    return frame
end

--- Create a command help window
---@return Frame The help window frame
local function CreateHelpWindow()
    local frame = CreateFrame("Frame", ADDON_NAME .. "HelpWindow", UIParent, "BackdropTemplate")
    frame:SetSize(350, 400)
    frame:SetPoint("CENTER", UIParent, "CENTER", 250, 100)
    
    frame:SetBackdrop({
        bgFile = "Interface/Tooltips/UI-Tooltip-Background",
        edgeFile = "Interface/Tooltips/UI-Tooltip-Border",
        tile = true,
        tileSize = 16,
        edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    frame:SetBackdropColor(0.1, 0.1, 0.15, 0.95)
    frame:SetBackdropBorderColor(0.5, 0.5, 1, 0.8)
    
    -- Make movable
    frame:SetMovable(true)
    frame:EnableMouse(true)
    frame:RegisterForDrag("LeftButton")
    frame:SetScript("OnDragStart", function(self)
        self:StartMoving()
    end)
    frame:SetScript("OnDragStop", function(self)
        self:StopMovingOrSizing()
    end)
    
    -- Title
    local title = frame:CreateFontString(nil, "OVERLAY")
    title:SetFont(GameFontNormalLarge:GetFont(), 14, "OUTLINE")
    title:SetPoint("TOP", frame, "TOP", 0, -15)
    title:SetText("AetherCore Commands")
    title:SetTextColor(0.5, 0.5, 1)
    
    -- Close button
    local closeBtn = CreateFrame("Button", nil, frame, "UIPanelCloseButton")
    closeBtn:SetSize(24, 24)
    closeBtn:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -5, -5)
    closeBtn:SetScript("OnClick", function()
        frame:Hide()
    end)
    
    -- Scrollable content area
    local scrollArea = CreateFrame("ScrollFrame", nil, frame, "UIPanelScrollFrameTemplate")
    scrollArea:SetSize(320, 340)
    scrollArea:SetPoint("TOPLEFT", frame, "TOPLEFT", 15, -45)
    
    local scrollChild = CreateFrame("Frame", nil, scrollArea)
    scrollChild:SetSize(300, 600)
    scrollArea:SetScrollChild(scrollChild)
    
    -- Help text
    local helpText = scrollChild:CreateFontString(nil, "OVERLAY")
    helpText:SetFont(GameFontNormal:GetFont(), 11)
    helpText:SetPoint("TOPLEFT", scrollChild, "TOPLEFT", 0, 0)
    helpText:SetWidth(300)
    helpText:SetHeight(600)
    helpText:SetWordWrap(true)
    
    local commandList = {
        "/aether show - Toggle the main window on/off",
        "/aether button - Open a window with test buttons",
        "/aether notify - Display a test notification",
        "/aether clear - Clear all notifications",
        "/aether help - Display this help menu",
        "/aether version - Show addon version",
        "",
        "Features:",
        "• Movable UI windows",
        "• Chat command handlers",
        "• Notification system",
        "• Multiple frame creation examples",
        "• Customizable colors and styling"
    }
    
    helpText:SetText(table.concat(commandList, "\n"))
    helpText:SetTextColor(0.7, 0.7, 1)
    
    frame:Hide()
    return frame
end

-- ============================================================================
-- Chat Command Handlers
-- ============================================================================

--- Register chat commands
local function RegisterCommands()
    SLASH_AETHER1 = "/aether"
    SlashCmdList["AETHER"] = function(msg, editBox)
        local command, args = msg:match("^(%S*)%s*(.*)")
        command = command:lower()
        
        if command == "" or command == "show" then
            -- Toggle main window
            local mainWindow = AetherCore.frames.mainWindow
            if mainWindow:IsShown() then
                mainWindow:Hide()
                Print("Main window hidden.", COLORS.warning)
            else
                mainWindow:Show()
                Print("Main window shown.", COLORS.success)
            end
            
        elseif command == "button" then
            -- Show button window
            local buttonWindow = AetherCore.frames.buttonWindow
            if buttonWindow:IsShown() then
                buttonWindow:Hide()
                Print("Button window hidden.", COLORS.warning)
            else
                buttonWindow:Show()
                Print("Button window shown.", COLORS.success)
            end
            
        elseif command == "notify" then
            -- Create notification
            local notif = CreateNotification(
                "Test Notification",
                "This is a test notification from AetherCore. It will auto-dismiss in 5 seconds.",
                5
            )
            Print("Notification displayed.", COLORS.success)
            
        elseif command == "clear" then
            -- Clear all notifications (hide all notification frames)
            for name, frame in pairs(AetherCore.frames) do
                if name:match("Notification") then
                    frame:Hide()
                end
            end
            Print("Notifications cleared.", COLORS.success)
            
        elseif command == "help" then
            -- Show help window
            local helpWindow = AetherCore.frames.helpWindow
            if helpWindow:IsShown() then
                helpWindow:Hide()
            else
                helpWindow:Show()
            end
            Print("Help window toggled.", COLORS.info or COLORS.primary)
            
        elseif command == "version" then
            -- Show version
            Print("Version: " .. VERSION, COLORS.success)
            
        else
            Print("Unknown command: " .. command, COLORS.error)
            Print("Type '/aether help' for available commands.", COLORS.warning)
        end
    end
end

-- ============================================================================
-- Initialization
-- ============================================================================

--- Initialize the addon
local function Initialize()
    -- Create main event frame
    local eventFrame = CreateFrame("Frame")
    eventFrame:RegisterEvent("ADDON_LOADED")
    
    eventFrame:SetScript("OnEvent", function(self, event, addon)
        if event == "ADDON_LOADED" and addon == ADDON_NAME then
            -- Create all UI frames
            AetherCore.frames.mainWindow = CreateMainWindow()
            AetherCore.frames.buttonWindow = CreateButtonWindow()
            AetherCore.frames.helpWindow = CreateHelpWindow()
            
            -- Register chat commands
            RegisterCommands()
            
            -- Print welcome message
            Print("Loaded successfully! Type '/aether help' for commands.", COLORS.success)
            
            -- Unregister this event since we only need it once
            self:UnregisterEvent("ADDON_LOADED")
        end
    end)
end

-- Start addon initialization
Initialize()

-- Print startup message to confirm the file loaded
Print("AetherCore addon file loaded.", COLORS.primary)
