-- ╔═══════════════════════════════════════════════════════════════════════╗
-- ║                      AETHERCORE - CORE FRAMEWORK                      ║
-- ╚═══════════════════════════════════════════════════════════════════════╝

if not AetherCore then AetherCore = {} end

local AC = AetherCore

-- Constants
AC.WoWVersion = select(4, GetBuildInfo())
AC.IsRetail = WOW_PROJECT_ID == WOW_PROJECT_MAINLINE
AC.IsClassic = WOW_PROJECT_ID == WOW_PROJECT_CLASSIC

-- Module Registry
AC.Modules = {}
AC.ModuleOrder = {}

function AC:RegisterModule(name, module)
    if self.Modules[name] then
        self:Print("Module " .. name .. " already registered", "WARNING")
        return false
    end
    self.Modules[name] = module
    table.insert(self.ModuleOrder, name)
    self:Print("Module registered: " .. name, "DEBUG")
    return true
end

function AC:GetModule(name)
    return self.Modules[name]
end

function AC:EnableModule(name)
    local module = self:GetModule(name)
    if module and module.Enable then
        module:Enable()
        self:Print("Module enabled: " .. name)
    end
end

function AC:DisableModule(name)
    local module = self:GetModule(name)
    if module and module.Disable then
        module:Disable()
        self:Print("Module disabled: " .. name)
    end
end