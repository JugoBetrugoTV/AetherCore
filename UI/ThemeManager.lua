--[[
    AetherCore Theme Manager
    Advanced theme system with multiple pre-defined themes
    Supports: AetherDark, AetherLight, AetherGold, AetherNeon
    
    Author: JugoBetrugoTV
    Date: 2025-12-19
]]

local ThemeManager = {}
ThemeManager.__index = ThemeManager

-- Theme Definitions
local THEMES = {
    AetherDark = {
        name = "AetherDark",
        description = "Dark theme with deep purples and blues",
        primary = "#1a1a2e",
        secondary = "#16213e",
        accent = "#7c3aed",
        success = "#10b981",
        warning = "#f59e0b",
        error = "#ef4444",
        info = "#06b6d4",
        background = "#0f0f1e",
        surface = "#262641",
        surfaceVariant = "#3d3a52",
        textPrimary = "#f5f5f5",
        textSecondary = "#b0b0b0",
        textMuted = "#757575",
        border = "#404050",
        borderLight = "#505060",
        shadow = "rgba(0, 0, 0, 0.8)",
        overlay = "rgba(0, 0, 0, 0.7)",
    },
    
    AetherLight = {
        name = "AetherLight",
        description = "Light theme with soft pastels and bright accents",
        primary = "#ffffff",
        secondary = "#f8f9fa",
        accent = "#8b5cf6",
        success = "#22c55e",
        warning = "#eab308",
        error = "#f87171",
        info = "#06b6d4",
        background = "#f5f5f7",
        surface = "#ffffff",
        surfaceVariant = "#f0f0f5",
        textPrimary = "#1f2937",
        textSecondary = "#6b7280",
        textMuted = "#9ca3af",
        border = "#e5e7eb",
        borderLight = "#f3f4f6",
        shadow = "rgba(0, 0, 0, 0.1)",
        overlay = "rgba(0, 0, 0, 0.05)",
    },
    
    AetherGold = {
        name = "AetherGold",
        description = "Premium theme with gold and warm tones",
        primary = "#2d2415",
        secondary = "#3d3a2a",
        accent = "#d97706",
        success = "#84cc16",
        warning = "#fbbf24",
        error = "#f87171",
        info = "#0891b2",
        background = "#1a1410",
        surface = "#3d3a2a",
        surfaceVariant = "#4a4633",
        textPrimary = "#fef3c7",
        textSecondary = "#daa520",
        textMuted = "#b8860b",
        border = "#704214",
        borderLight = "#8b5a2b",
        shadow = "rgba(0, 0, 0, 0.6)",
        overlay = "rgba(184, 134, 11, 0.15)",
    },
    
    AetherNeon = {
        name = "AetherNeon",
        description = "Cyberpunk-inspired theme with neon colors",
        primary = "#0a0a0a",
        secondary = "#1a1a1a",
        accent = "#00ff88",
        success = "#39ff14",
        warning = "#ffff00",
        error = "#ff0055",
        info = "#00d9ff",
        background = "#050505",
        surface = "#0f0f0f",
        surfaceVariant = "#1a1a1a",
        textPrimary = "#00ff88",
        textSecondary = "#00d9ff",
        textMuted = "#666688",
        border = "#00ff88",
        borderLight = "#00d9ff",
        shadow = "rgba(0, 255, 136, 0.3)",
        overlay = "rgba(0, 217, 255, 0.1)",
    }
}

-- ThemeManager class
function ThemeManager.new()
    local self = setmetatable({}, ThemeManager)
    self.currentTheme = "AetherDark"
    self.themes = THEMES
    self.callbacks = {}
    self.customThemes = {}
    return self
end

--[[
    Set the current active theme
    @param themeName: string - Name of the theme to activate
    @return: boolean - Success status
]]
function ThemeManager:setTheme(themeName)
    if not self.themes[themeName] and not self.customThemes[themeName] then
        warn("ThemeManager: Theme '" .. themeName .. "' not found")
        return false
    end
    
    self.currentTheme = themeName
    self:_notifyThemeChange()
    return true
end

--[[
    Get the current active theme
    @return: table - Current theme configuration
]]
function ThemeManager:getCurrentTheme()
    return self.themes[self.currentTheme] or self.customThemes[self.currentTheme]
end

--[[
    Get a specific color from the current theme
    @param colorKey: string - The color property name
    @return: string - Color value (hex or rgba)
]]
function ThemeManager:getColor(colorKey)
    local theme = self:getCurrentTheme()
    if not theme then return nil end
    return theme[colorKey]
end

--[[
    Get all colors from the current theme
    @return: table - All color properties
]]
function ThemeManager:getAllColors()
    return self:getCurrentTheme()
end

--[[
    Register a callback function to be called when theme changes
    @param callback: function - Callback function
    @return: string - Callback ID for later removal
]]
function ThemeManager:onThemeChange(callback)
    local callbackId = tostring(math.random(100000, 999999))
    self.callbacks[callbackId] = callback
    return callbackId
end

--[[
    Remove a registered callback
    @param callbackId: string - The callback ID to remove
    @return: boolean - Success status
]]
function ThemeManager:removeCallback(callbackId)
    if self.callbacks[callbackId] then
        self.callbacks[callbackId] = nil
        return true
    end
    return false
end

--[[
    Register a custom theme
    @param themeName: string - Name for the custom theme
    @param colors: table - Color configuration table
    @return: boolean - Success status
]]
function ThemeManager:registerCustomTheme(themeName, colors)
    if self.themes[themeName] then
        warn("ThemeManager: Cannot override built-in theme '" .. themeName .. "'")
        return false
    end
    
    if not colors or type(colors) ~= "table" then
        warn("ThemeManager: Invalid color configuration")
        return false
    end
    
    self.customThemes[themeName] = colors
    return true
end

--[[
    Get list of all available themes
    @return: table - Array of theme names
]]
function ThemeManager:getAvailableThemes()
    local themes = {}
    
    for themeName, _ in pairs(self.themes) do
        table.insert(themes, themeName)
    end
    
    for themeName, _ in pairs(self.customThemes) do
        table.insert(themes, themeName)
    end
    
    return themes
end

--[[
    Blend two colors with a specified ratio
    @param color1: string - First color (hex format)
    @param color2: string - Second color (hex format)
    @param ratio: number - Blend ratio (0-1, 0 = color1, 1 = color2)
    @return: string - Blended color in hex format
]]
function ThemeManager:blendColors(color1, color2, ratio)
    ratio = math.clamp(ratio or 0.5, 0, 1)
    
    local function hexToRgb(hex)
        hex = hex:gsub("#", "")
        return {
            tonumber(hex:sub(1, 2), 16),
            tonumber(hex:sub(3, 4), 16),
            tonumber(hex:sub(5, 6), 16)
        }
    end
    
    local function rgbToHex(r, g, b)
        return string.format("#%02x%02x%02x", r, g, b)
    end
    
    local rgb1 = hexToRgb(color1)
    local rgb2 = hexToRgb(color2)
    
    local r = math.floor(rgb1[1] * (1 - ratio) + rgb2[1] * ratio)
    local g = math.floor(rgb1[2] * (1 - ratio) + rgb2[2] * ratio)
    local b = math.floor(rgb1[3] * (1 - ratio) + rgb2[3] * ratio)
    
    return rgbToHex(r, g, b)
end

--[[
    Adjust color brightness
    @param color: string - Color in hex format
    @param factor: number - Brightness factor (1 = original, >1 = brighter, <1 = darker)
    @return: string - Adjusted color in hex format
]]
function ThemeManager:adjustBrightness(color, factor)
    factor = factor or 1.0
    
    local function hexToRgb(hex)
        hex = hex:gsub("#", "")
        return {
            tonumber(hex:sub(1, 2), 16),
            tonumber(hex:sub(3, 4), 16),
            tonumber(hex:sub(5, 6), 16)
        }
    end
    
    local function rgbToHex(r, g, b)
        r = math.clamp(math.floor(r * factor), 0, 255)
        g = math.clamp(math.floor(g * factor), 0, 255)
        b = math.clamp(math.floor(b * factor), 0, 255)
        return string.format("#%02x%02x%02x", r, g, b)
    end
    
    local rgb = hexToRgb(color)
    return rgbToHex(rgb[1], rgb[2], rgb[3])
end

--[[
    Get theme metadata
    @param themeName: string - Name of the theme
    @return: table - Theme metadata (name, description)
]]
function ThemeManager:getThemeMetadata(themeName)
    local theme = self.themes[themeName] or self.customThemes[themeName]
    if not theme then return nil end
    
    return {
        name = theme.name,
        description = theme.description or "Custom theme"
    }
end

--[[
    Export current theme as a table
    @return: table - Complete theme configuration
]]
function ThemeManager:exportTheme()
    return self:getCurrentTheme()
end

--[[
    Import and register a theme from table
    @param themeName: string - Name for the new theme
    @param themeData: table - Theme configuration
    @return: boolean - Success status
]]
function ThemeManager:importTheme(themeName, themeData)
    return self:registerCustomTheme(themeName, themeData)
end

-- Private function to notify all registered callbacks
function ThemeManager:_notifyThemeChange()
    for _, callback in pairs(self.callbacks) do
        if type(callback) == "function" then
            local success, err = pcall(callback, self:getCurrentTheme())
            if not success then
                warn("ThemeManager: Callback error - " .. err)
            end
        end
    end
end

-- Utility: Clamp function for number constraints
function math.clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

return ThemeManager