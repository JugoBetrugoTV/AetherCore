-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║                      AETHERCORE - CONFIG MANAGER                      ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

if not AetherCore then AetherCore = {} end
AetherCore.Config = {}

local Config = AetherCore.Config
local DefaultConfig = {}

-- Default Configuration
DefaultConfig.version = "1.0.0"
DefaultConfig.enabled = true
DefaultConfig.debug = false
DefaultConfig.theme = "AetherDark"
DefaultConfig.scale = 1.0
DefaultConfig.alpha = 0.95

DefaultConfig.modules = {
    panelUI = { enabled = true },
    dataDisplay = { enabled = true },
    qualityOfLife = { enabled = true },
    minimap = { enabled = true },
    database = { enabled = true }
}

DefaultConfig.panel = {
    topBar = { enabled = true, height = 32 },
    bottomBar = { enabled = true, height = 32 }
}

DefaultConfig.appearance = {
    fontSize = 12,
    fontFamily = "Arial",
    borderSize = 2
}

function Config:LoadConfig()
    if not AetherCoreSV then
        AetherCoreSV = {}
    end
    
    -- Merge with defaults
    for k, v in pairs(DefaultConfig) do
        if AetherCoreSV[k] == nil then
            AetherCoreSV[k] = v
        end
    end
    
    return AetherCoreSV
end

function Config:SaveConfig()
    AetherCoreSV = AetherCoreSV or {}
end

function Config:GetConfig(key)
    local cfg = AetherCoreSV or DefaultConfig
    if key then
        return cfg[key]
    end
    return cfg
end

function Config:SetConfig(key, value)
    AetherCoreSV = AetherCoreSV or {}
    AetherCoreSV[key] = value
    self:SaveConfig()
end

function Config:ResetConfig()
    AetherCoreSV = AetherCore.Utils:TableCopy(DefaultConfig)
    self:SaveConfig()
end