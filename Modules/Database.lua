--[[
    AetherCore Database Module
    Handles tracking and logging of:
    - Gold history
    - Playtime statistics
    - Loot drops and collection
    
    Date Created: 2025-12-19
    Version: 1.0
]]

local Database = {}
Database.__index = Database

-- Constants
local DB_VERSION = "1.0"
local MAX_HISTORY_ENTRIES = 1000
local SAVE_INTERVAL = 300 -- 5 minutes in seconds

-- Database structure
local db_schema = {
    version = DB_VERSION,
    last_updated = 0,
    player_data = {},
    gold_history = {},
    playtime_log = {},
    loot_log = {}
}

---@class Database
---@field data table The main database table
---@field dirty boolean Whether the database has unsaved changes
---@field save_timer number Timer for auto-save functionality

---Initialize a new Database instance
---@return Database
function Database.new()
    local self = setmetatable({}, Database)
    self.data = {}
    self:reset()
    self.dirty = false
    self.save_timer = 0
    return self
end

---Reset the database to default schema
function Database:reset()
    self.data = {
        version = DB_VERSION,
        last_updated = os.time(),
        player_data = {},
        gold_history = {},
        playtime_log = {},
        loot_log = {}
    }
    self.dirty = true
end

---@class GoldTransaction
---@field timestamp number Unix timestamp
---@field amount number Amount of gold (positive or negative)
---@field source string Source of transaction (quest, kill, vendor, etc.)
---@field description string Description of the transaction

---Log a gold transaction
---@param amount number Amount of gold gained/lost
---@param source string Source of the transaction
---@param description string Optional description
---@return boolean success
function Database:logGoldTransaction(amount, source, description)
    if not amount or type(amount) ~= "number" then
        return false
    end
    
    local transaction = {
        timestamp = os.time(),
        amount = amount,
        source = source or "unknown",
        description = description or ""
    }
    
    table.insert(self.data.gold_history, transaction)
    
    -- Maintain max history entries
    if #self.data.gold_history > MAX_HISTORY_ENTRIES then
        table.remove(self.data.gold_history, 1)
    end
    
    self.dirty = true
    return true
end

---Get total gold accumulated from history
---@return number total_gold
function Database:getTotalGold()
    local total = 0
    for _, transaction in ipairs(self.data.gold_history) do
        total = total + transaction.amount
    end
    return total
end

---Get gold history for a specific time period
---@param start_time number Start timestamp
---@param end_time number End timestamp
---@return table filtered_history
function Database:getGoldHistoryByTime(start_time, end_time)
    local filtered = {}
    for _, transaction in ipairs(self.data.gold_history) do
        if transaction.timestamp >= start_time and transaction.timestamp <= end_time then
            table.insert(filtered, transaction)
        end
    end
    return filtered
end

---Get gold history by source
---@param source string Source filter
---@return table filtered_history
function Database:getGoldHistoryBySource(source)
    local filtered = {}
    for _, transaction in ipairs(self.data.gold_history) do
        if transaction.source == source then
            table.insert(filtered, transaction)
        end
    end
    return filtered
end

---@class PlaytimeEntry
---@field timestamp number Unix timestamp
---@field session_start number Session start time
---@field session_duration number Duration in seconds
---@field zone string Zone played in
---@field notes string Optional notes

---Log a playtime session
---@param duration number Duration in seconds
---@param zone string Zone name
---@param notes string Optional notes
---@return boolean success
function Database:logPlaytimeSession(duration, zone, notes)
    if not duration or type(duration) ~= "number" or duration <= 0 then
        return false
    end
    
    local session = {
        timestamp = os.time(),
        session_start = os.time() - duration,
        session_duration = duration,
        zone = zone or "Unknown",
        notes = notes or ""
    }
    
    table.insert(self.data.playtime_log, session)
    self.dirty = true
    return true
end

---Get total playtime in seconds
---@return number total_playtime
function Database:getTotalPlaytime()
    local total = 0
    for _, session in ipairs(self.data.playtime_log) do
        total = total + session.session_duration
    end
    return total
end

---Get playtime summary by zone
---@return table zone_summary
function Database:getPlaytimeSummaryByZone()
    local summary = {}
    for _, session in ipairs(self.data.playtime_log) do
        local zone = session.zone
        if not summary[zone] then
            summary[zone] = { total_time = 0, sessions = 0 }
        end
        summary[zone].total_time = summary[zone].total_time + session.session_duration
        summary[zone].sessions = summary[zone].sessions + 1
    end
    return summary
end

---Get playtime by specific date (Unix timestamp day)
---@param day_timestamp number Timestamp for the day
---@return number playtime_seconds
function Database:getPlaytimeByDay(day_timestamp)
    local day_start = math.floor(day_timestamp / 86400) * 86400
    local day_end = day_start + 86400
    
    local total = 0
    for _, session in ipairs(self.data.playtime_log) do
        if session.timestamp >= day_start and session.timestamp < day_end then
            total = total + session.session_duration
        end
    end
    return total
end

---@class LootEntry
---@field timestamp number Unix timestamp
---@field item_name string Name of the item
---@field item_id number Item ID
---@field rarity string Rarity (common, uncommon, rare, epic, legendary)
---@field quantity number Quantity looted
---@field source string Source (mob, chest, quest, etc.)
---@field zone string Zone where looted
---@field notes string Optional notes

---Log a loot entry
---@param item_name string Name of the item
---@param quantity number Quantity looted
---@param source string Source of loot
---@param rarity string Item rarity
---@param item_id number Optional item ID
---@param zone string Optional zone
---@param notes string Optional notes
---@return boolean success
function Database:logLoot(item_name, quantity, source, rarity, item_id, zone, notes)
    if not item_name or not quantity or quantity <= 0 then
        return false
    end
    
    local loot = {
        timestamp = os.time(),
        item_name = item_name,
        item_id = item_id or 0,
        rarity = rarity or "common",
        quantity = quantity,
        source = source or "unknown",
        zone = zone or "Unknown",
        notes = notes or ""
    }
    
    table.insert(self.data.loot_log, loot)
    
    -- Maintain max history entries
    if #self.data.loot_log > MAX_HISTORY_ENTRIES then
        table.remove(self.data.loot_log, 1)
    end
    
    self.dirty = true
    return true
end

---Get loot summary by item
---@return table item_summary
function Database:getLootSummaryByItem()
    local summary = {}
    for _, loot in ipairs(self.data.loot_log) do
        local item_key = loot.item_id > 0 and loot.item_id or loot.item_name
        if not summary[item_key] then
            summary[item_key] = {
                item_name = loot.item_name,
                item_id = loot.item_id,
                total_quantity = 0,
                rarity = loot.rarity,
                sources = {}
            }
        end
        summary[item_key].total_quantity = summary[item_key].total_quantity + loot.quantity
        
        -- Track sources
        if not summary[item_key].sources[loot.source] then
            summary[item_key].sources[loot.source] = 0
        end
        summary[item_key].sources[loot.source] = summary[item_key].sources[loot.source] + loot.quantity
    end
    return summary
end

---Get loot by rarity
---@param rarity string Rarity filter
---@return table filtered_loot
function Database:getLootByRarity(rarity)
    local filtered = {}
    for _, loot in ipairs(self.data.loot_log) do
        if loot.rarity == rarity then
            table.insert(filtered, loot)
        end
    end
    return filtered
end

---Get loot by source
---@param source string Source filter
---@return table filtered_loot
function Database:getLootBySource(source)
    local filtered = {}
    for _, loot in ipairs(self.data.loot_log) do
        if loot.source == source then
            table.insert(filtered, loot)
        end
    end
    return filtered
end

---Get loot summary by rarity
---@return table rarity_summary
function Database:getLootSummaryByRarity()
    local summary = {}
    for _, loot in ipairs(self.data.loot_log) do
        local rarity = loot.rarity
        if not summary[rarity] then
            summary[rarity] = { total_items = 0, item_count = 0 }
        end
        summary[rarity].total_items = summary[rarity].total_items + loot.quantity
        summary[rarity].item_count = summary[rarity].item_count + 1
    end
    return summary
end

---Store player-specific data
---@param player_id string Unique player identifier
---@param data table Player data to store
function Database:setPlayerData(player_id, data)
    if not player_id then
        return false
    end
    self.data.player_data[player_id] = data or {}
    self.dirty = true
    return true
end

---Retrieve player-specific data
---@param player_id string Unique player identifier
---@return table|nil player_data
function Database:getPlayerData(player_id)
    return self.data.player_data[player_id]
end

---Save database to string (JSON-like format)
---@return string serialized_data
function Database:serialize()
    local json = {}
    
    -- Simple JSON serialization
    json.version = DB_VERSION
    json.last_updated = self.data.last_updated
    json.gold_history = self.data.gold_history
    json.playtime_log = self.data.playtime_log
    json.loot_log = self.data.loot_log
    json.player_data = self.data.player_data
    
    -- Convert to string (you may want to use a JSON library like json.lua)
    return self:tableToString(json)
end

---Load database from string
---@param serialized_data string Serialized database data
---@return boolean success
function Database:deserialize(serialized_data)
    if not serialized_data then
        return false
    end
    
    -- Parse serialized data (implement based on your serialization method)
    -- This is a placeholder - adjust based on your actual serialization format
    local success = true
    if success then
        self.dirty = false
    end
    return success
end

---Convert table to string (basic implementation)
---@param t table Table to convert
---@param indent string Indentation string
---@return string stringified_table
function Database:tableToString(t, indent)
    indent = indent or ""
    local result = "{\n"
    
    for k, v in pairs(t) do
        result = result .. indent .. "  " .. tostring(k) .. " = "
        
        if type(v) == "table" then
            result = result .. self:tableToString(v, indent .. "  ") .. ",\n"
        elseif type(v) == "string" then
            result = result .. '"' .. v .. '",\n'
        else
            result = result .. tostring(v) .. ",\n"
        end
    end
    
    result = result .. indent .. "}"
    return result
end

---Update database with automatic dirty flag tracking
---@param delta number Time elapsed since last update
function Database:update(delta)
    self.save_timer = self.save_timer + delta
    
    if self.save_timer >= SAVE_INTERVAL and self.dirty then
        self:save()
        self.save_timer = 0
    end
end

---Mark database as needing save
function Database:markDirty()
    self.dirty = true
end

---Save the database
---@return boolean success
function Database:save()
    -- Implement actual save logic (file I/O, network, etc.)
    self.data.last_updated = os.time()
    self.dirty = false
    return true
end

---Get database statistics
---@return table stats
function Database:getStatistics()
    return {
        version = self.data.version,
        last_updated = self.data.last_updated,
        total_gold = self:getTotalGold(),
        total_playtime = self:getTotalPlaytime(),
        gold_history_entries = #self.data.gold_history,
        playtime_entries = #self.data.playtime_log,
        loot_entries = #self.data.loot_log,
        player_count = self:countPlayers()
    }
end

---Count total registered players
---@return number player_count
function Database:countPlayers()
    local count = 0
    for _ in pairs(self.data.player_data) do
        count = count + 1
    end
    return count
end

return Database
