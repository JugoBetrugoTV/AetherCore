-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║                      AETHERCORE - EVENT MANAGER                       ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

if not AetherCore then AetherCore = {} end
AetherCore.Events = {}

local Events = AetherCore.Events
local EventRegistry = {}

function Events:RegisterEvent(event, callback)
    if not EventRegistry[event] then
        EventRegistry[event] = {}
    end
    
    table.insert(EventRegistry[event], callback)
    AetherCore:Print("Event registered: " .. event, "DEBUG")
end

function Events:UnregisterEvent(event, callback)
    if EventRegistry[event] then
        for i, cb in ipairs(EventRegistry[event]) do
            if cb == callback then
                table.remove(EventRegistry[event], i)
                break
            end
        end
    end
end

function Events:TriggerEvent(event, ...)
    if EventRegistry[event] then
        for _, callback in ipairs(EventRegistry[event]) do
            if type(callback) == "function" then
                pcall(callback, event, ...)
            end
        end
    end
end

function Events:SendMessage(prefix, ...)
    local event = "AETHER_" .. prefix
    self:TriggerEvent(event, ...)
end