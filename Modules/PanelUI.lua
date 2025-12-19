-- PanelUI Module
-- Main panel UI module for creating and managing top and bottom panels
-- Provides functionality to create, position, and manage UI panels

local PanelUI = {}
PanelUI.__index = PanelUI

-- Panel configuration constants
local PANEL_CONFIG = {
    TOP = {
        position = "top",
        defaultHeight = 60,
        defaultPadding = 10,
        backgroundColor = Color3.fromRGB(30, 30, 35),
        borderSize = 1,
        borderColor = Color3.fromRGB(50, 50, 60),
        transparency = 0.1
    },
    BOTTOM = {
        position = "bottom",
        defaultHeight = 60,
        defaultPadding = 10,
        backgroundColor = Color3.fromRGB(30, 30, 35),
        borderSize = 1,
        borderColor = Color3.fromRGB(50, 50, 60),
        transparency = 0.1
    }
}

-- Create a new PanelUI instance
function PanelUI.new(screenSize)
    local self = setmetatable({}, PanelUI)
    
    self.screenSize = screenSize or Vector2.new(1920, 1080)
    self.panels = {}
    self.elements = {}
    self.callbacks = {}
    
    return self
end

-- Create a top panel
function PanelUI:createTopPanel(height, config)
    height = height or PANEL_CONFIG.TOP.defaultHeight
    config = config or {}
    
    local panelConfig = {
        position = Vector2.new(0, 0),
        size = Vector2.new(self.screenSize.X, height),
        backgroundColor = config.backgroundColor or PANEL_CONFIG.TOP.backgroundColor,
        borderSize = config.borderSize or PANEL_CONFIG.TOP.borderSize,
        borderColor = config.borderColor or PANEL_CONFIG.TOP.borderColor,
        transparency = config.transparency or PANEL_CONFIG.TOP.transparency,
        zIndex = config.zIndex or 100
    }
    
    local panel = self:_createPanel("top", panelConfig)
    self.panels.top = panel
    
    return panel
end

-- Create a bottom panel
function PanelUI:createBottomPanel(height, config)
    height = height or PANEL_CONFIG.BOTTOM.defaultHeight
    config = config or {}
    
    local panelConfig = {
        position = Vector2.new(0, self.screenSize.Y - height),
        size = Vector2.new(self.screenSize.X, height),
        backgroundColor = config.backgroundColor or PANEL_CONFIG.BOTTOM.backgroundColor,
        borderSize = config.borderSize or PANEL_CONFIG.BOTTOM.borderSize,
        borderColor = config.borderColor or PANEL_CONFIG.BOTTOM.borderColor,
        transparency = config.transparency or PANEL_CONFIG.BOTTOM.transparency,
        zIndex = config.zIndex or 100
    }
    
    local panel = self:_createPanel("bottom", panelConfig)
    self.panels.bottom = panel
    
    return panel
end

-- Internal function to create a panel
function PanelUI:_createPanel(panelType, config)
    local panel = {
        type = panelType,
        position = config.position,
        size = config.size,
        backgroundColor = config.backgroundColor,
        borderSize = config.borderSize,
        borderColor = config.borderColor,
        transparency = config.transparency,
        zIndex = config.zIndex,
        elements = {},
        visible = true
    }
    
    return panel
end

-- Add an element to a panel
function PanelUI:addElement(panelType, elementName, element, properties)
    if not self.panels[panelType] then
        error("Panel type '" .. tostring(panelType) .. "' does not exist")
    end
    
    properties = properties or {}
    
    local elementData = {
        name = elementName,
        element = element,
        panelType = panelType,
        position = properties.position or Vector2.new(0, 0),
        size = properties.size or Vector2.new(100, 40),
        visible = properties.visible ~= false,
        enabled = properties.enabled ~= false,
        properties = properties
    }
    
    self.panels[panelType].elements[elementName] = elementData
    self.elements[elementName] = elementData
    
    return elementData
end

-- Remove an element from a panel
function PanelUI:removeElement(elementName)
    if self.elements[elementName] then
        local element = self.elements[elementName]
        if element.panelType and self.panels[element.panelType] then
            self.panels[element.panelType].elements[elementName] = nil
        end
        self.elements[elementName] = nil
        return true
    end
    return false
end

-- Show or hide a panel
function PanelUI:setPanel(panelType, visible)
    if self.panels[panelType] then
        self.panels[panelType].visible = visible
        return true
    end
    return false
end

-- Show or hide an element
function PanelUI:setElement(elementName, visible)
    if self.elements[elementName] then
        self.elements[elementName].visible = visible
        return true
    end
    return false
end

-- Enable or disable an element
function PanelUI:setElementEnabled(elementName, enabled)
    if self.elements[elementName] then
        self.elements[elementName].enabled = enabled
        return true
    end
    return false
end

-- Update element properties
function PanelUI:updateElement(elementName, properties)
    if not self.elements[elementName] then
        return false
    end
    
    local element = self.elements[elementName]
    
    if properties.position then
        element.position = properties.position
    end
    if properties.size then
        element.size = properties.size
    end
    if properties.properties then
        for key, value in pairs(properties.properties) do
            element.properties[key] = value
        end
    end
    
    return true
end

-- Register a callback for an element
function PanelUI:registerCallback(elementName, eventType, callback)
    if not self.callbacks[elementName] then
        self.callbacks[elementName] = {}
    end
    
    self.callbacks[elementName][eventType] = callback
    return true
end

-- Trigger a callback
function PanelUI:triggerCallback(elementName, eventType, ...)
    if self.callbacks[elementName] and self.callbacks[elementName][eventType] then
        return self.callbacks[elementName][eventType](...)
    end
end

-- Get panel information
function PanelUI:getPanelInfo(panelType)
    return self.panels[panelType]
end

-- Get element information
function PanelUI:getElementInfo(elementName)
    return self.elements[elementName]
end

-- Get all panels
function PanelUI:getAllPanels()
    return self.panels
end

-- Get all elements in a panel
function PanelUI:getPanelElements(panelType)
    if self.panels[panelType] then
        return self.panels[panelType].elements
    end
    return nil
end

-- Clear all panels
function PanelUI:clear()
    self.panels = {}
    self.elements = {}
    self.callbacks = {}
end

-- Resize screen (useful for responsive design)
function PanelUI:setScreenSize(width, height)
    self.screenSize = Vector2.new(width, height)
    
    -- Update panel positions if they exist
    if self.panels.bottom then
        self.panels.bottom.position = Vector2.new(0, height - self.panels.bottom.size.Y)
    end
end

return PanelUI
