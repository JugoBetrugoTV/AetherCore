-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║                      AETHERCORE - UTILITIES                           ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

if not AetherCore then AetherCore = {} end
AetherCore.Utils = {}

local Utils = AetherCore.Utils

-- String Utilities
function Utils:TrimString(str)
    return str:match("^%s*(.-)%s*$")
end

function Utils:SplitString(str, sep)
    local result = {}
    for token in string.gmatch(str, "[^" .. sep .. "]+") do
        table.insert(result, token)
    end
    return result
end

function Utils:ColorToHex(r, g, b)
    return string.format("%02x%02x%02x", r * 255, g * 255, b * 255)
end

function Utils:HexToColor(hex)
    local r = tonumber(hex:sub(1, 2), 16) / 255
    local g = tonumber(hex:sub(3, 4), 16) / 255
    local b = tonumber(hex:sub(5, 6), 16) / 255
    return r, g, b
end

-- Table Utilities
function Utils:TableMerge(t1, t2)
    for k, v in pairs(t2) do
        if type(v) == "table" then
            if type(t1[k] or false) == "table" then
                self:TableMerge(t1[k] or {}, t2[k] or {})
            else
                t1[k] = v
            end
        else
            t1[k] = v
        end
    end
    return t1
end

function Utils:TableCopy(t)
    local copy = {}
    for k, v in pairs(t) do
        if type(v) == "table" then
            copy[k] = self:TableCopy(v)
        else
            copy[k] = v
        end
    end
    return copy
end

-- Number Utilities
function Utils:FormatNumber(num)
    if num >= 1000000 then
        return string.format("%.2fM", num / 1000000)
    elseif num >= 1000 then
        return string.format("%.2fK", num / 1000)
    else
        return tostring(num)
    end
end

function Utils:FormatGold(copper)
    local gold = math.floor(copper / 10000)
    local silver = math.floor((copper % 10000) / 100)
    local copper_rem = copper % 100
    return string.format("|cffffd700%d|r |cfffffffd%02d|r |cffeda55f%02d|r", gold, silver, copper_rem)
end

function Utils:Clamp(value, min, max)
    return math.max(min, math.min(max, value))
end

-- Player Utilities
function Utils:GetPlayerGold()
    return GetMoney()
end

function Utils:GetPlayerLevel()
    return UnitLevel("player")
end

function Utils:GetPlayerClass()
    local _, class = UnitClass("player")
    return class
end

function Utils:IsInCombat()
    return UnitAffectingCombat("player")
end

-- Time Utilities
function Utils:FormatTime(seconds)
    local days = math.floor(seconds / 86400)
    local hours = math.floor((seconds % 86400) / 3600)
    local minutes = math.floor((seconds % 3600) / 60)
    local secs = seconds % 60
    
    if days > 0 then
        return string.format("%dd %dh %dm", days, hours, minutes)
    elseif hours > 0 then
        return string.format("%dh %dm %ds", hours, minutes, secs)
    elseif minutes > 0 then
        return string.format("%dm %ds", minutes, secs)
    else
        return string.format("%ds", secs)
    end
end