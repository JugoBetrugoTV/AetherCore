--[[
    UI/SkinManager.lua
    Component skinning system for AetherCore UI framework
    Manages visual styling for buttons, panels, and status bars
    
    Features:
    - Theme management and switching
    - Component skinning (buttons, panels, status bars)
    - Color schemes and gradients
    - Animation support
    - Style inheritance
]]

local SkinManager = {}
SkinManager.__index = SkinManager

-- Default themes
SkinManager.THEMES = {
    DARK = "dark",
    LIGHT = "light",
    CUSTOM = "custom"
}

-- Color palettes
SkinManager.PALETTES = {
    dark = {
        primary = {r = 0.2, g = 0.2, b = 0.2, a = 1.0},
        secondary = {r = 0.3, g = 0.3, b = 0.3, a = 1.0},
        accent = {r = 0.0, g = 0.7, b = 1.0, a = 1.0},
        text = {r = 1.0, g = 1.0, b = 1.0, a = 1.0},
        textSecondary = {r = 0.8, g = 0.8, b = 0.8, a = 1.0},
        border = {r = 0.4, g = 0.4, b = 0.4, a = 1.0},
        success = {r = 0.2, g = 0.8, b = 0.2, a = 1.0},
        warning = {r = 1.0, g = 0.8, b = 0.0, a = 1.0},
        error = {r = 1.0, g = 0.2, b = 0.2, a = 1.0},
        disabled = {r = 0.4, g = 0.4, b = 0.4, a = 0.5}
    },
    light = {
        primary = {r = 0.95, g = 0.95, b = 0.95, a = 1.0},
        secondary = {r = 0.9, g = 0.9, b = 0.9, a = 1.0},
        accent = {r = 0.2, g = 0.6, b = 0.9, a = 1.0},
        text = {r = 0.1, g = 0.1, b = 0.1, a = 1.0},
        textSecondary = {r = 0.4, g = 0.4, b = 0.4, a = 1.0},
        border = {r = 0.7, g = 0.7, b = 0.7, a = 1.0},
        success = {r = 0.1, g = 0.7, b = 0.1, a = 1.0},
        warning = {r = 0.9, g = 0.7, b = 0.0, a = 1.0},
        error = {r = 0.9, g = 0.1, b = 0.1, a = 1.0},
        disabled = {r = 0.7, g = 0.7, b = 0.7, a = 0.5}
    }
}

-- Button styles
SkinManager.BUTTON_STYLES = {
    default = {
        padding = {x = 12, y = 8},
        borderRadius = 4,
        borderWidth = 1,
        fontSize = 14,
        fontWeight = "normal",
        transition = 0.2
    },
    large = {
        padding = {x = 16, y = 12},
        borderRadius = 6,
        borderWidth = 2,
        fontSize = 16,
        fontWeight = "bold",
        transition = 0.2
    },
    small = {
        padding = {x = 8, y = 4},
        borderRadius = 2,
        borderWidth = 1,
        fontSize = 12,
        fontWeight = "normal",
        transition = 0.15
    },
    icon = {
        padding = {x = 6, y = 6},
        borderRadius = 3,
        borderWidth = 1,
        fontSize = 12,
        transition = 0.15
    }
}

-- Panel styles
SkinManager.PANEL_STYLES = {
    default = {
        padding = {x = 16, y = 16},
        borderRadius = 6,
        borderWidth = 1,
        shadow = {enabled = true, blur = 8, offset = {x = 0, y = 2}},
        transition = 0.3
    },
    compact = {
        padding = {x = 8, y = 8},
        borderRadius = 4,
        borderWidth = 1,
        shadow = {enabled = true, blur = 4, offset = {x = 0, y = 1}},
        transition = 0.2
    },
    dialog = {
        padding = {x = 24, y = 24},
        borderRadius = 8,
        borderWidth = 2,
        shadow = {enabled = true, blur = 16, offset = {x = 0, y = 4}},
        transition = 0.3
    },
    flat = {
        padding = {x = 12, y = 12},
        borderRadius = 0,
        borderWidth = 0,
        shadow = {enabled = false},
        transition = 0.2
    }
}

-- Status bar styles
SkinManager.STATUS_BAR_STYLES = {
    default = {
        height = 24,
        borderRadius = 4,
        borderWidth = 1,
        padding = {x = 4, y = 2},
        transition = 0.3,
        animateProgress = true
    },
    thin = {
        height = 6,
        borderRadius = 3,
        borderWidth = 0,
        padding = {x = 0, y = 0},
        transition = 0.2,
        animateProgress = true
    },
    thick = {
        height = 32,
        borderRadius = 6,
        borderWidth = 2,
        padding = {x = 6, y = 4},
        transition = 0.4,
        animateProgress = true
    },
    segmented = {
        height = 24,
        borderRadius = 4,
        borderWidth = 1,
        padding = {x = 2, y = 0},
        transition = 0.25,
        animateProgress = false,
        segments = 10
    }
}

---@class SkinManager
---@field currentTheme string
---@field customPalette table
---@field componentSkins table
---@field callbacks table
function SkinManager.new(initialTheme)
    local self = setmetatable({}, SkinManager)
    self.currentTheme = initialTheme or SkinManager.THEMES.DARK
    self.customPalette = {}
    self.componentSkins = {}
    self.callbacks = {}
    return self
end

--- Set the active theme
---@param themeName string
---@return boolean success
function SkinManager:setTheme(themeName)
    if not SkinManager.PALETTES[themeName] then
        print("Warning: Theme '" .. themeName .. "' not found")
        return false
    end
    
    self.currentTheme = themeName
    self:_notifyThemeChanged()
    return true
end

--- Get the current color palette
---@return table palette
function SkinManager:getPalette()
    -- Return custom palette if exists, otherwise return theme palette
    if next(self.customPalette) then
        return self.customPalette
    end
    return SkinManager.PALETTES[self.currentTheme] or SkinManager.PALETTES.dark
end

--- Get a specific color from the palette
---@param colorName string
---@return table color
function SkinManager:getColor(colorName)
    local palette = self:getPalette()
    return palette[colorName] or palette.primary
end

--- Set a custom color in the current palette
---@param colorName string
---@param color table {r, g, b, a}
function SkinManager:setColor(colorName, color)
    self.customPalette[colorName] = color
    self:_notifyThemeChanged()
end

--- Skin a button component
---@param button table
---@param styleType string (default|large|small|icon)
---@param state string (normal|hover|pressed|disabled)
---@return table skinData
function SkinManager:skinButton(button, styleType, state)
    styleType = styleType or "default"
    state = state or "normal"
    
    local baseStyle = SkinManager.BUTTON_STYLES[styleType] or SkinManager.BUTTON_STYLES.default
    local palette = self:getPalette()
    
    local skinData = {
        style = baseStyle,
        colors = {},
        state = state
    }
    
    -- Determine colors based on state
    if state == "normal" then
        skinData.colors.background = palette.secondary
        skinData.colors.text = palette.text
        skinData.colors.border = palette.border
    elseif state == "hover" then
        skinData.colors.background = self:_lighten(palette.secondary, 0.1)
        skinData.colors.text = palette.text
        skinData.colors.border = palette.accent
    elseif state == "pressed" then
        skinData.colors.background = self:_darken(palette.secondary, 0.15)
        skinData.colors.text = palette.text
        skinData.colors.border = palette.accent
    elseif state == "disabled" then
        skinData.colors.background = palette.disabled
        skinData.colors.text = self:_blend(palette.text, palette.primary, 0.5)
        skinData.colors.border = palette.border
    end
    
    if button then
        self:_applyButtonSkin(button, skinData)
    end
    
    return skinData
end

--- Skin a panel component
---@param panel table
---@param styleType string (default|compact|dialog|flat)
---@param variant string (primary|secondary|accent)
---@return table skinData
function SkinManager:skinPanel(panel, styleType, variant)
    styleType = styleType or "default"
    variant = variant or "primary"
    
    local baseStyle = SkinManager.PANEL_STYLES[styleType] or SkinManager.PANEL_STYLES.default
    local palette = self:getPalette()
    
    local variantColor = palette[variant] or palette.primary
    
    local skinData = {
        style = baseStyle,
        colors = {
            background = variantColor,
            border = palette.border,
            text = palette.text
        },
        variant = variant
    }
    
    if panel then
        self:_applyPanelSkin(panel, skinData)
    end
    
    return skinData
end

--- Skin a status bar component
---@param statusBar table
---@param styleType string (default|thin|thick|segmented)
---@param progressColor string
---@return table skinData
function SkinManager:skinStatusBar(statusBar, styleType, progressColor)
    styleType = styleType or "default"
    progressColor = progressColor or "accent"
    
    local baseStyle = SkinManager.STATUS_BAR_STYLES[styleType] or SkinManager.STATUS_BAR_STYLES.default
    local palette = self:getPalette()
    
    local skinData = {
        style = baseStyle,
        colors = {
            background = palette.secondary,
            progress = palette[progressColor] or palette.accent,
            border = palette.border,
            text = palette.text
        },
        progressColor = progressColor
    }
    
    if statusBar then
        self:_applyStatusBarSkin(statusBar, skinData)
    end
    
    return skinData
end

--- Apply button skin to a component
---@private
function SkinManager:_applyButtonSkin(button, skinData)
    if not button then return end
    
    button.padding = skinData.style.padding
    button.borderRadius = skinData.style.borderRadius
    button.borderWidth = skinData.style.borderWidth
    button.fontSize = skinData.style.fontSize
    button.fontWeight = skinData.style.fontWeight
    
    button.backgroundColor = skinData.colors.background
    button.textColor = skinData.colors.text
    button.borderColor = skinData.colors.border
    button.transitionTime = skinData.style.transition
    
    button._skinData = skinData
end

--- Apply panel skin to a component
---@private
function SkinManager:_applyPanelSkin(panel, skinData)
    if not panel then return end
    
    panel.padding = skinData.style.padding
    panel.borderRadius = skinData.style.borderRadius
    panel.borderWidth = skinData.style.borderWidth
    panel.shadow = skinData.style.shadow
    
    panel.backgroundColor = skinData.colors.background
    panel.borderColor = skinData.colors.border
    panel.textColor = skinData.colors.text
    panel.transitionTime = skinData.style.transition
    
    panel._skinData = skinData
end

--- Apply status bar skin to a component
---@private
function SkinManager:_applyStatusBarSkin(statusBar, skinData)
    if not statusBar then return end
    
    statusBar.height = skinData.style.height
    statusBar.borderRadius = skinData.style.borderRadius
    statusBar.borderWidth = skinData.style.borderWidth
    statusBar.padding = skinData.style.padding
    
    statusBar.backgroundColor = skinData.colors.background
    statusBar.progressColor = skinData.colors.progress
    statusBar.borderColor = skinData.colors.border
    statusBar.textColor = skinData.colors.text
    statusBar.transitionTime = skinData.style.transition
    statusBar.animateProgress = skinData.style.animateProgress
    
    statusBar._skinData = skinData
end

--- Register a callback for theme changes
---@param callback function
function SkinManager:onThemeChanged(callback)
    table.insert(self.callbacks, callback)
end

--- Notify all callbacks of theme change
---@private
function SkinManager:_notifyThemeChanged()
    for _, callback in ipairs(self.callbacks) do
        if type(callback) == "function" then
            callback(self.currentTheme, self:getPalette())
        end
    end
end

--- Lighten a color
---@private
---@param color table {r, g, b, a}
---@param amount number (0-1)
---@return table lightened color
function SkinManager:_lighten(color, amount)
    return {
        r = math.min(1, color.r + amount),
        g = math.min(1, color.g + amount),
        b = math.min(1, color.b + amount),
        a = color.a or 1.0
    }
end

--- Darken a color
---@private
---@param color table {r, g, b, a}
---@param amount number (0-1)
---@return table darkened color
function SkinManager:_darken(color, amount)
    return {
        r = math.max(0, color.r - amount),
        g = math.max(0, color.g - amount),
        b = math.max(0, color.b - amount),
        a = color.a or 1.0
    }
end

--- Blend two colors
---@private
---@param color1 table
---@param color2 table
---@param ratio number (0-1, 0 = color1, 1 = color2)
---@return table blended color
function SkinManager:_blend(color1, color2, ratio)
    ratio = math.clamp(ratio, 0, 1)
    return {
        r = color1.r * (1 - ratio) + color2.r * ratio,
        g = color1.g * (1 - ratio) + color2.g * ratio,
        b = color1.b * (1 - ratio) + color2.b * ratio,
        a = color1.a * (1 - ratio) + color2.a * ratio
    }
end

--- Create a gradient between two colors
---@param color1 table
---@param color2 table
---@param steps number
---@return table gradient colors
function SkinManager:createGradient(color1, color2, steps)
    steps = steps or 10
    local gradient = {}
    
    for i = 0, steps - 1 do
        local ratio = (i / (steps - 1))
        gradient[i + 1] = self:_blend(color1, color2, ratio)
    end
    
    return gradient
end

--- Get a skin configuration by name
---@param componentType string
---@param styleName string
---@return table config
function SkinManager:getConfig(componentType, styleName)
    if componentType == "button" then
        return SkinManager.BUTTON_STYLES[styleName]
    elseif componentType == "panel" then
        return SkinManager.PANEL_STYLES[styleName]
    elseif componentType == "statusbar" then
        return SkinManager.STATUS_BAR_STYLES[styleName]
    end
    return nil
end

--- Update a custom style configuration
---@param componentType string
---@param styleName string
---@param config table
function SkinManager:updateConfig(componentType, styleName, config)
    if componentType == "button" then
        if SkinManager.BUTTON_STYLES[styleName] then
            for k, v in pairs(config) do
                SkinManager.BUTTON_STYLES[styleName][k] = v
            end
        end
    elseif componentType == "panel" then
        if SkinManager.PANEL_STYLES[styleName] then
            for k, v in pairs(config) do
                SkinManager.PANEL_STYLES[styleName][k] = v
            end
        end
    elseif componentType == "statusbar" then
        if SkinManager.STATUS_BAR_STYLES[styleName] then
            for k, v in pairs(config) do
                SkinManager.STATUS_BAR_STYLES[styleName][k] = v
            end
        end
    end
end

--- Export the current theme as a table
---@return table theme data
function SkinManager:exportTheme()
    return {
        name = self.currentTheme,
        palette = self:getPalette(),
        buttons = SkinManager.BUTTON_STYLES,
        panels = SkinManager.PANEL_STYLES,
        statusbars = SkinManager.STATUS_BAR_STYLES
    }
end

return SkinManager
