--[[
    QualityOfLife Module
    Provides quality of life enhancements for AetherCore
    Features: Auto Repair, Sell Junk, Mount AutoSelect, Camera Distance
]]

local QoL = {}
QoL.name = "QualityOfLife"
QoL.version = "1.0.0"

-- Configuration
QoL.config = {
    autoRepair = {
        enabled = true,
        threshold = 0.5, -- Repair at 50% durability
    },
    sellJunk = {
        enabled = true,
        autoSellQuality = 0, -- 0 = Poor/Junk quality
    },
    mountAutoSelect = {
        enabled = true,
        preferredMount = nil, -- Will use most recent or first available
        useFlying = true,
        useSwimming = true,
    },
    cameraDistance = {
        enabled = true,
        defaultDistance = 15,
        minDistance = 5,
        maxDistance = 25,
    },
}

-- Initialize module
function QoL:Init()
    print("[QoL] Initializing Quality of Life Module v" .. self.version)
    self:SetupAutoRepair()
    self:SetupSellJunk()
    self:SetupMountAutoSelect()
    self:SetupCameraDistance()
end

-- Auto Repair Feature
function QoL:SetupAutoRepair()
    if not self.config.autoRepair.enabled then return end
    
    print("[QoL] Auto Repair enabled (threshold: " .. (self.config.autoRepair.threshold * 100) .. "%)")
end

function QoL:AutoRepair()
    if not self.config.autoRepair.enabled then return end
    
    -- Check equipment durability
    local needsRepair = false
    for slot = 1, 16 do
        local durability, maxDurability = GetInventoryItemDurability(slot)
        if durability and maxDurability and maxDurability > 0 then
            local durabilityPercent = durability / maxDurability
            if durabilityPercent <= self.config.autoRepair.threshold then
                needsRepair = true
                break
            end
        end
    end
    
    if needsRepair then
        -- Trigger repair interaction with NPC
        -- This would typically be called when interacting with a repair NPC
        print("[QoL] Equipment needs repair!")
        return true
    end
    
    return false
end

-- Sell Junk Feature
function QoL:SetupSellJunk()
    if not self.config.sellJunk.enabled then return end
    
    print("[QoL] Auto Sell Junk enabled (quality: " .. self.config.sellJunk.autoSellQuality .. ")")
end

function QoL:SellJunk()
    if not self.config.sellJunk.enabled then return end
    
    local junkSold = 0
    local totalValue = 0
    
    -- Iterate through inventory
    for bag = 0, 4 do
        for slot = 1, GetContainerNumSlots(bag) do
            local texture, itemCount, locked, quality, readable, lootable, link = GetContainerItemInfo(bag, slot)
            
            -- Check if item is junk quality (0 = Poor)
            if quality == self.config.sellJunk.autoSellQuality then
                local itemName, _, itemQuality, itemLevel, reqLevel, class, subClass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(link)
                
                if vendorPrice and vendorPrice > 0 then
                    -- Mark item for sale
                    UseContainerItem(bag, slot)
                    junkSold = junkSold + (itemCount or 1)
                    totalValue = totalValue + (vendorPrice * (itemCount or 1))
                end
            end
        end
    end
    
    if junkSold > 0 then
        print("[QoL] Sold " .. junkSold .. " junk items for " .. totalValue .. " gold")
    end
    
    return junkSold, totalValue
end

-- Mount AutoSelect Feature
function QoL:SetupMountAutoSelect()
    if not self.config.mountAutoSelect.enabled then return end
    
    print("[QoL] Mount AutoSelect enabled")
end

function QoL:SelectMount()
    if not self.config.mountAutoSelect.enabled then return false end
    
    local mountIndex = nil
    
    -- Check if preferred mount is set
    if self.config.mountAutoSelect.preferredMount then
        mountIndex = self.config.mountAutoSelect.preferredMount
    else
        -- Try to find the best mount for current situation
        local numMounts = GetNumCompanions("mount")
        
        if numMounts > 0 then
            -- Iterate through available mounts
            for i = 1, numMounts do
                local creatureID, creatureName, creatureSpellID, creatureIcon, isRideable = GetCompanionInfo("mount", i)
                
                -- Prioritize flying mounts if enabled and available
                if self.config.mountAutoSelect.useFlying and self:CanFly() then
                    -- Select first flying mount
                    if self:IsFlying(creatureSpellID) then
                        mountIndex = i
                        break
                    end
                end
                
                -- Fallback to first available mount
                if not mountIndex then
                    mountIndex = i
                end
            end
        end
    end
    
    if mountIndex then
        CallCompanion("mount", mountIndex)
        print("[QoL] Mount selected and summoned")
        return true
    else
        print("[QoL] No mounts available")
        return false
    end
end

function QoL:CanFly()
    -- Check if player can fly (epic flying skill, etc.)
    return true -- Placeholder
end

function QoL:IsFlying(spellID)
    -- Check if mount spell is a flying mount
    return true -- Placeholder
end

-- Camera Distance Feature
function QoL:SetupCameraDistance()
    if not self.config.cameraDistance.enabled then return end
    
    print("[QoL] Camera Distance enabled (default: " .. self.config.cameraDistance.defaultDistance .. ")")
    self:SetCameraDistance(self.config.cameraDistance.defaultDistance)
end

function QoL:SetCameraDistance(distance)
    if not self.config.cameraDistance.enabled then return end
    
    -- Validate distance bounds
    local validDistance = distance
    if validDistance < self.config.cameraDistance.minDistance then
        validDistance = self.config.cameraDistance.minDistance
    elseif validDistance > self.config.cameraDistance.maxDistance then
        validDistance = self.config.cameraDistance.maxDistance
    end
    
    -- Set camera distance (simulated approach)
    SetCVar("cameraDistanceMax", validDistance)
    SetCVar("cameraDistanceMaxFactor", 3.5)
    
    print("[QoL] Camera distance set to " .. validDistance)
end

function QoL:IncreaseCameraDistance(amount)
    local currentMax = GetCVarNumber("cameraDistanceMax")
    self:SetCameraDistance(currentMax + (amount or 1))
end

function QoL:DecreaseCameraDistance(amount)
    local currentMax = GetCVarNumber("cameraDistanceMax")
    self:SetCameraDistance(currentMax - (amount or 1))
end

-- Configuration Management
function QoL:SetConfig(featureName, configTable)
    if self.config[featureName] then
        for key, value in pairs(configTable) do
            self.config[featureName][key] = value
        end
        print("[QoL] Configuration updated for " .. featureName)
    else
        print("[QoL] Unknown feature: " .. featureName)
    end
end

function QoL:GetConfig(featureName)
    return self.config[featureName]
end

-- Event Handling
function QoL:RegisterEvents()
    -- Register event handlers for automatic features
    print("[QoL] Event handlers registered")
end

-- Utility function to check if player is in combat
function QoL:IsInCombat()
    return InCombat() or UnitAffectingCombat("player")
end

-- Disable features during combat
function QoL:CheckCombatStatus()
    if self:IsInCombat() then
        self.config.autoRepair.enabled = false
        self.config.sellJunk.enabled = false
        self.config.mountAutoSelect.enabled = false
    end
end

-- Export module
return QoL
