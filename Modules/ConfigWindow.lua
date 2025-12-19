--[[
    ConfigWindow.lua
    Custom configuration interface with tabbed system for AetherCore
    Provides a user-friendly UI for managing application settings
]]

local ConfigWindow = {}
ConfigWindow.__index = ConfigWindow

--[[
    Initialize ConfigWindow with customizable options
    @param options table Configuration options
    @return ConfigWindow instance
]]
function ConfigWindow.new(options)
    local self = setmetatable({}, ConfigWindow)
    
    self.title = options.title or "Configuration"
    self.width = options.width or 600
    self.height = options.height or 500
    self.x = options.x or 100
    self.y = options.y or 100
    
    self.tabs = {}
    self.activeTab = nil
    self.window = nil
    self.callbacks = {}
    self.settings = options.settings or {}
    
    return self
end

--[[
    Add a new tab to the configuration window
    @param tabName string Name of the tab
    @param displayName string Display name for the tab
    @param options table Tab options
]]
function ConfigWindow:addTab(tabName, displayName, options)
    if not tabName or not displayName then
        error("Tab name and display name are required")
    end
    
    local tab = {
        name = tabName,
        displayName = displayName,
        sections = {},
        button = nil,
        content = nil,
        options = options or {}
    }
    
    table.insert(self.tabs, tab)
    
    if not self.activeTab then
        self.activeTab = tabName
    end
    
    return tab
end

--[[
    Add a section to a specific tab
    @param tabName string The tab to add section to
    @param sectionName string Unique section identifier
    @param sectionTitle string Display title for the section
]]
function ConfigWindow:addSection(tabName, sectionName, sectionTitle)
    local tab = self:getTab(tabName)
    if not tab then
        error("Tab '" .. tabName .. "' does not exist")
    end
    
    local section = {
        name = sectionName,
        title = sectionTitle,
        items = {},
        frame = nil
    }
    
    tab.sections[sectionName] = section
    return section
end

--[[
    Add a configuration item to a section
    @param tabName string The tab containing the section
    @param sectionName string The section containing the item
    @param itemConfig table Item configuration
]]
function ConfigWindow:addItem(tabName, sectionName, itemConfig)
    local tab = self:getTab(tabName)
    if not tab then
        error("Tab '" .. tabName .. "' does not exist")
    end
    
    local section = tab.sections[sectionName]
    if not section then
        error("Section '" .. sectionName .. "' does not exist in tab '" .. tabName .. "'")
    end
    
    local item = {
        id = itemConfig.id or ("item_" .. #section.items),
        label = itemConfig.label or "Item",
        type = itemConfig.type or "input", -- input, checkbox, dropdown, slider, color
        value = itemConfig.value or "",
        tooltip = itemConfig.tooltip or "",
        options = itemConfig.options or {}, -- for dropdown/radio
        min = itemConfig.min or 0,
        max = itemConfig.max or 100,
        step = itemConfig.step or 1,
        widget = nil,
        onChange = itemConfig.onChange or nil
    }
    
    table.insert(section.items, item)
    return item
end

--[[
    Get a tab by name
    @param tabName string
    @return tab table or nil
]]
function ConfigWindow:getTab(tabName)
    for _, tab in ipairs(self.tabs) do
        if tab.name == tabName then
            return tab
        end
    end
    return nil
end

--[[
    Register a callback function for setting changes
    @param itemId string The item identifier
    @param callback function Called when item value changes
]]
function ConfigWindow:onItemChange(itemId, callback)
    self.callbacks[itemId] = callback
end

--[[
    Create and display the configuration window
]]
function ConfigWindow:show()
    if self.window then
        self.window:bringToFront()
        return
    end
    
    -- Create main window frame
    self.window = self:createWindowFrame()
    
    -- Create tab bar
    self:createTabBar()
    
    -- Create content area
    self:createContentArea()
    
    -- Show first tab
    self:switchTab(self.activeTab)
end

--[[
    Create the main window frame
    @return window frame
]]
function ConfigWindow:createWindowFrame()
    local window = {
        title = self.title,
        x = self.x,
        y = self.y,
        width = self.width,
        height = self.height,
        visible = true,
        closeButton = true,
        children = {}
    }
    
    return window
end

--[[
    Create the tab bar navigation
]]
function ConfigWindow:createTabBar()
    local tabBarHeight = 40
    local tabWidth = 120
    local startX = 10
    
    for i, tab in ipairs(self.tabs) do
        local xPos = startX + (i - 1) * (tabWidth + 5)
        
        tab.button = {
            text = tab.displayName,
            x = xPos,
            y = 10,
            width = tabWidth,
            height = 30,
            active = (tab.name == self.activeTab),
            tabName = tab.name,
            onClick = function()
                self:switchTab(tab.name)
            end
        }
    end
end

--[[
    Create the content area for displaying tab contents
]]
function ConfigWindow:createContentArea()
    local contentY = 50
    local contentHeight = self.height - contentY - 40
    
    for _, tab in ipairs(self.tabs) do
        tab.content = {
            x = 10,
            y = contentY,
            width = self.width - 20,
            height = contentHeight,
            visible = (tab.name == self.activeTab),
            sections = {}
        }
        
        self:createTabContent(tab)
    end
end

--[[
    Create the content for a specific tab
    @param tab table The tab to create content for
]]
function ConfigWindow:createTabContent(tab)
    local currentY = 0
    local sectionSpacing = 20
    local itemSpacing = 25
    
    for sectionName, section in pairs(tab.sections) do
        -- Section title
        section.titleElement = {
            text = section.title,
            x = 10,
            y = currentY,
            fontSize = 14,
            bold = true,
            color = {r = 1, g = 1, b = 1}
        }
        
        currentY = currentY + 25
        
        -- Create items in section
        for _, item in ipairs(section.items) do
            item.widget = self:createItemWidget(item)
            item.widget.y = currentY
            currentY = currentY + itemSpacing
        end
        
        currentY = currentY + sectionSpacing
    end
end

--[[
    Create a widget for a configuration item
    @param item table The item to create widget for
    @return widget table
]]
function ConfigWindow:createItemWidget(item)
    local widget = {
        id = item.id,
        x = 20,
        type = item.type,
        label = item.label,
        value = item.value,
        tooltip = item.tooltip
    }
    
    if item.type == "input" then
        widget.inputField = {
            text = tostring(item.value),
            width = 250,
            placeholder = "Enter value..."
        }
    elseif item.type == "checkbox" then
        widget.checkbox = {
            checked = item.value or false,
            label = item.label
        }
    elseif item.type == "dropdown" then
        widget.dropdown = {
            options = item.options,
            selectedIndex = 1,
            width = 250
        }
    elseif item.type == "slider" then
        widget.slider = {
            min = item.min,
            max = item.max,
            step = item.step,
            value = item.value or item.min,
            width = 250
        }
    elseif item.type == "color" then
        widget.colorPicker = {
            color = item.value or {r = 1, g = 1, b = 1},
            width = 100,
            height = 30
        }
    end
    
    return widget
end

--[[
    Switch to a different tab
    @param tabName string The tab to switch to
]]
function ConfigWindow:switchTab(tabName)
    local targetTab = self:getTab(tabName)
    if not targetTab then
        return
    end
    
    -- Hide all tabs
    for _, tab in ipairs(self.tabs) do
        if tab.content then
            tab.content.visible = false
        end
        if tab.button then
            tab.button.active = false
        end
    end
    
    -- Show selected tab
    targetTab.content.visible = true
    targetTab.button.active = true
    self.activeTab = tabName
end

--[[
    Get all current settings as a table
    @return table containing all setting values
]]
function ConfigWindow:getSettings()
    local settings = {}
    
    for _, tab in ipairs(self.tabs) do
        for sectionName, section in pairs(tab.sections) do
            for _, item in ipairs(section.items) do
                settings[item.id] = item.value
            end
        end
    end
    
    return settings
end

--[[
    Set values for items
    @param values table Key-value pairs of item IDs and values
]]
function ConfigWindow:setSettings(values)
    if not values then return end
    
    for _, tab in ipairs(self.tabs) do
        for sectionName, section in pairs(tab.sections) do
            for _, item in ipairs(section.items) do
                if values[item.id] ~= nil then
                    item.value = values[item.id]
                end
            end
        end
    end
end

--[[
    Update an item's value and trigger callbacks
    @param itemId string The item identifier
    @param newValue value The new value
]]
function ConfigWindow:updateItemValue(itemId, newValue)
    for _, tab in ipairs(self.tabs) do
        for sectionName, section in pairs(tab.sections) do
            for _, item in ipairs(section.items) do
                if item.id == itemId then
                    item.value = newValue
                    if self.callbacks[itemId] then
                        self.callbacks[itemId](newValue)
                    end
                    return
                end
            end
        end
    end
end

--[[
    Close the configuration window
]]
function ConfigWindow:close()
    if self.window then
        self.window.visible = false
        self.window = nil
    end
end

--[[
    Reset all settings to their default values
]]
function ConfigWindow:reset()
    for _, tab in ipairs(self.tabs) do
        for sectionName, section in pairs(tab.sections) do
            for _, item in ipairs(section.items) do
                item.value = item.defaultValue or ""
            end
        end
    end
end

--[[
    Export settings to a table (for saving to file)
    @return table containing all settings
]]
function ConfigWindow:exportSettings()
    return self:getSettings()
end

--[[
    Import settings from a table (for loading from file)
    @param data table containing settings to import
]]
function ConfigWindow:importSettings(data)
    self:setSettings(data)
end

return ConfigWindow
