-- ╔══════════════════════════════════════════════════════════════════════════╗
-- ║                           AETHERCORE v1.0.0                             ║
-- ║     Advanced WoW Addon Framework - Panel System & QoL Features           ║
-- ║                    © 2025 JugoBetrugoTV - MIT License                   ║
-- ╚══════════════════════════════════════════════════════════════════════════╝

local AetherCore = {}
AetherCore.Version = "1.0.0"
AetherCore.Author = "JugoBetrugoTV"
AetherCore.Debug = false

-- Color codes
AetherCore.Colors = {
    Primary = "|cff0070dd",
    Secondary = "|cffffffff",
    Success = "|cff1eff00",
    Warning = "|cffff8000",
    Error = "|cffff0000",
    Reset = "|r"
}

function AetherCore:Print(msg, level)
    level = level or "INFO"
    if level == "DEBUG" and not self.Debug then return end
    print(self.Colors.Primary .. "[AetherCore] " .. self.Colors.Reset .. msg)
end

function AetherCore:Initialize()
    self:Print("Initializing AetherCore v" .. self.Version)
    
    -- Initialize core systems
    self:InitializeCore()
    self:InitializeUI()
    self:InitializeModules()
    
    self:Print(self.Colors.Success .. "AetherCore loaded successfully!")
end

function AetherCore:InitializeCore()
    self:Print("Initializing core systems...", "DEBUG")
end

function AetherCore:InitializeUI()
    self:Print("Initializing UI system...", "DEBUG")
end

function AetherCore:InitializeModules()
    self:Print("Initializing modules...", "DEBUG")
end

-- Event handler
local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "AetherCore" then
        AetherCore:Initialize()
    end
end)

_G.AetherCore = AetherCore