-- AetherCore Data Display Module
-- Provides various data display plugins for game information
-- Includes: Clock, Gold, FPS, Latency, and Durability displays

local DataDisplay = {}
DataDisplay.__index = DataDisplay

-- Initialize the DataDisplay module
function DataDisplay:new()
    local self = setmetatable({}, DataDisplay)
    self.plugins = {}
    self.isActive = true
    self.displayMode = "compact" -- compact, detailed, or minimal
    return self
end

-- Clock Plugin
local ClockPlugin = {}
ClockPlugin.__index = ClockPlugin

function ClockPlugin:new()
    local self = setmetatable({}, ClockPlugin)
    self.name = "Clock"
    self.enabled = true
    self.format = "HH:MM:SS" -- 24-hour format
    self.lastUpdate = 0
    self.updateInterval = 1 -- Update every 1 second
    return self
end

function ClockPlugin:getData()
    if not self.enabled then return nil end
    
    local currentTime = os.date("%H:%M:%S")
    return {
        name = self.name,
        value = currentTime,
        format = "text",
        color = {r = 0.8, g = 0.8, b = 0.8},
        icon = "⏰"
    }
end

function ClockPlugin:update(deltaTime)
    self.lastUpdate = self.lastUpdate + deltaTime
    if self.lastUpdate >= self.updateInterval then
        self.lastUpdate = 0
        return true
    end
    return false
end

-- Gold Plugin
local GoldPlugin = {}
GoldPlugin.__index = GoldPlugin

function GoldPlugin:new()
    local self = setmetatable({}, GoldPlugin)
    self.name = "Gold"
    self.enabled = true
    self.lastGold = 0
    self.lastUpdate = 0
    self.updateInterval = 0.5 -- Update twice per second
    self.displayFormat = "abbreviated" -- abbreviated or full
    return self
end

function GoldPlugin:setGold(amount)
    self.lastGold = amount
end

function GoldPlugin:formatGold(amount)
    if self.displayFormat == "abbreviated" then
        if amount >= 1000000 then
            return string.format("%.1fM", amount / 1000000)
        elseif amount >= 1000 then
            return string.format("%.1fK", amount / 1000)
        end
    end
    return tostring(amount)
end

function GoldPlugin:getData()
    if not self.enabled then return nil end
    
    local formattedGold = self:formatGold(self.lastGold)
    return {
        name = self.name,
        value = formattedGold,
        rawValue = self.lastGold,
        format = "text",
        color = {r = 1.0, g = 0.84, b = 0.0}, -- Gold color
        icon = "💰"
    }
end

function GoldPlugin:update(deltaTime)
    self.lastUpdate = self.lastUpdate + deltaTime
    if self.lastUpdate >= self.updateInterval then
        self.lastUpdate = 0
        return true
    end
    return false
end

-- FPS (Frames Per Second) Plugin
local FPSPlugin = {}
FPSPlugin.__index = FPSPlugin

function FPSPlugin:new()
    local self = setmetatable({}, FPSPlugin)
    self.name = "FPS"
    self.enabled = true
    self.currentFPS = 0
    self.frameCount = 0
    self.frameTime = 0
    self.updateInterval = 0.5 -- Update twice per second
    self.lastUpdate = 0
    self.fpsHistory = {}
    self.maxHistorySize = 60
    return self
end

function FPSPlugin:updateFrame(deltaTime)
    self.frameTime = self.frameTime + deltaTime
    self.frameCount = self.frameCount + 1
    
    if self.frameTime >= self.updateInterval then
        self.currentFPS = math.floor(self.frameCount / self.frameTime)
        table.insert(self.fpsHistory, self.currentFPS)
        
        if #self.fpsHistory > self.maxHistorySize then
            table.remove(self.fpsHistory, 1)
        end
        
        self.frameCount = 0
        self.frameTime = 0
    end
end

function FPSPlugin:getAverageFPS()
    if #self.fpsHistory == 0 then return 0 end
    local sum = 0
    for _, fps in ipairs(self.fpsHistory) do
        sum = sum + fps
    end
    return math.floor(sum / #self.fpsHistory)
end

function FPSPlugin:getData()
    if not self.enabled then return nil end
    
    local avgFPS = self:getAverageFPS()
    local color = {r = 0.0, g = 1.0, b = 0.0} -- Green
    
    if self.currentFPS < 30 then
        color = {r = 1.0, g = 0.0, b = 0.0} -- Red
    elseif self.currentFPS < 60 then
        color = {r = 1.0, g = 1.0, b = 0.0} -- Yellow
    end
    
    return {
        name = self.name,
        value = tostring(self.currentFPS),
        average = tostring(avgFPS),
        format = "text",
        color = color,
        icon = "⚡",
        unit = "FPS"
    }
end

function FPSPlugin:update(deltaTime)
    self.lastUpdate = self.lastUpdate + deltaTime
    if self.lastUpdate >= self.updateInterval then
        self.lastUpdate = 0
        return true
    end
    return false
end

-- Latency Plugin
local LatencyPlugin = {}
LatencyPlugin.__index = LatencyPlugin

function LatencyPlugin:new()
    local self = setmetatable({}, LatencyPlugin)
    self.name = "Latency"
    self.enabled = true
    self.currentLatency = 0
    self.lastUpdate = 0
    self.updateInterval = 1 -- Update once per second
    self.latencyHistory = {}
    self.maxHistorySize = 60
    self.averageLatency = 0
    return self
end

function LatencyPlugin:setLatency(ms)
    self.currentLatency = math.max(0, ms)
    table.insert(self.latencyHistory, self.currentLatency)
    
    if #self.latencyHistory > self.maxHistorySize then
        table.remove(self.latencyHistory, 1)
    end
    
    self:calculateAverage()
end

function LatencyPlugin:calculateAverage()
    if #self.latencyHistory == 0 then
        self.averageLatency = 0
        return
    end
    
    local sum = 0
    for _, latency in ipairs(self.latencyHistory) do
        sum = sum + latency
    end
    self.averageLatency = math.floor(sum / #self.latencyHistory)
end

function LatencyPlugin:getData()
    if not self.enabled then return nil end
    
    local color = {r = 0.0, g = 1.0, b = 0.0} -- Green
    
    if self.currentLatency > 200 then
        color = {r = 1.0, g = 0.0, b = 0.0} -- Red
    elseif self.currentLatency > 100 then
        color = {r = 1.0, g = 1.0, b = 0.0} -- Yellow
    end
    
    return {
        name = self.name,
        value = tostring(self.currentLatency),
        average = tostring(self.averageLatency),
        format = "text",
        color = color,
        icon = "📡",
        unit = "ms"
    }
end

function LatencyPlugin:update(deltaTime)
    self.lastUpdate = self.lastUpdate + deltaTime
    if self.lastUpdate >= self.updateInterval then
        self.lastUpdate = 0
        return true
    end
    return false
end

-- Durability Plugin
local DurabilityPlugin = {}
DurabilityPlugin.__index = DurabilityPlugin

function DurabilityPlugin:new()
    local self = setmetatable({}, DurabilityPlugin)
    self.name = "Durability"
    self.enabled = true
    self.items = {} -- Table of items with durability
    self.lastUpdate = 0
    self.updateInterval = 1 -- Update once per second
    self.warningThreshold = 0.25 -- 25% durability
    return self
end

function DurabilityPlugin:addItem(slot, name, currentDurability, maxDurability)
    self.items[slot] = {
        name = name,
        current = currentDurability,
        max = maxDurability,
        percentage = (currentDurability / maxDurability) * 100
    }
end

function DurabilityPlugin:removeItem(slot)
    self.items[slot] = nil
end

function DurabilityPlugin:updateItem(slot, currentDurability, maxDurability)
    if self.items[slot] then
        self.items[slot].current = currentDurability
        self.items[slot].max = maxDurability
        self.items[slot].percentage = (currentDurability / maxDurability) * 100
    end
end

function DurabilityPlugin:getLowestDurability()
    local lowest = nil
    local lowestPercent = 100
    
    for slot, item in pairs(self.items) do
        if item.percentage < lowestPercent then
            lowest = item
            lowestPercent = item.percentage
        end
    end
    
    return lowest, lowestPercent
end

function DurabilityPlugin:getItemsNeedingRepair()
    local needsRepair = {}
    for slot, item in pairs(self.items) do
        if item.percentage <= (self.warningThreshold * 100) then
            table.insert(needsRepair, item)
        end
    end
    return needsRepair
end

function DurabilityPlugin:getData()
    if not self.enabled then return nil end
    
    local lowest, lowestPercent = self:getLowestDurability()
    
    if not lowest then
        return {
            name = self.name,
            value = "N/A",
            format = "text",
            color = {r = 0.8, g = 0.8, b = 0.8},
            icon = "🛡️"
        }
    end
    
    local color = {r = 0.0, g = 1.0, b = 0.0} -- Green
    
    if lowestPercent <= (self.warningThreshold * 100) then
        color = {r = 1.0, g = 0.0, b = 0.0} -- Red
    elseif lowestPercent <= 50 then
        color = {r = 1.0, g = 1.0, b = 0.0} -- Yellow
    end
    
    return {
        name = self.name,
        value = string.format("%.0f%%", lowestPercent),
        itemName = lowest.name,
        format = "text",
        color = color,
        icon = "🛡️",
        itemCount = #self:getItemsNeedingRepair()
    }
end

function DurabilityPlugin:update(deltaTime)
    self.lastUpdate = self.lastUpdate + deltaTime
    if self.lastUpdate >= self.updateInterval then
        self.lastUpdate = 0
        return true
    end
    return false
end

-- Main DataDisplay Methods
function DataDisplay:registerPlugin(plugin)
    if plugin and plugin.name then
        self.plugins[plugin.name] = plugin
        return true
    end
    return false
end

function DataDisplay:unregisterPlugin(name)
    if self.plugins[name] then
        self.plugins[name] = nil
        return true
    end
    return false
end

function DataDisplay:getPlugin(name)
    return self.plugins[name]
end

function DataDisplay:getAllPlugins()
    local pluginList = {}
    for name, plugin in pairs(self.plugins) do
        table.insert(pluginList, {name = name, plugin = plugin})
    end
    return pluginList
end

function DataDisplay:enablePlugin(name)
    local plugin = self.plugins[name]
    if plugin then
        plugin.enabled = true
        return true
    end
    return false
end

function DataDisplay:disablePlugin(name)
    local plugin = self.plugins[name]
    if plugin then
        plugin.enabled = false
        return true
    end
    return false
end

function DataDisplay:update(deltaTime)
    if not self.isActive then return end
    
    for name, plugin in pairs(self.plugins) do
        if plugin.updateFrame then
            plugin:updateFrame(deltaTime)
        end
        if plugin.update then
            plugin:update(deltaTime)
        end
    end
end

function DataDisplay:getAllData()
    local data = {}
    for name, plugin in pairs(self.plugins) do
        if plugin.enabled then
            local pluginData = plugin:getData()
            if pluginData then
                table.insert(data, pluginData)
            end
        end
    end
    return data
end

function DataDisplay:getDataByName(name)
    local plugin = self.plugins[name]
    if plugin and plugin.enabled then
        return plugin:getData()
    end
    return nil
end

function DataDisplay:setDisplayMode(mode)
    if mode == "compact" or mode == "detailed" or mode == "minimal" then
        self.displayMode = mode
        return true
    end
    return false
end

function DataDisplay:activate()
    self.isActive = true
end

function DataDisplay:deactivate()
    self.isActive = false
end

function DataDisplay:isPluginEnabled(name)
    local plugin = self.plugins[name]
    if plugin then
        return plugin.enabled
    end
    return false
end

-- Export public classes for instantiation
DataDisplay.ClockPlugin = ClockPlugin
DataDisplay.GoldPlugin = GoldPlugin
DataDisplay.FPSPlugin = FPSPlugin
DataDisplay.LatencyPlugin = LatencyPlugin
DataDisplay.DurabilityPlugin = DurabilityPlugin

return DataDisplay
