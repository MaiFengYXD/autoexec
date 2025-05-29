--!optimize 2

if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(1)

local typeof, warn
    = typeof, warn

local      GetFullName, getcallingscript, checkcaller
    = game.GetFullName, getcallingscript, checkcaller

local ExecutorScript = identifyexecutor() .. " LocalScript"
local Workspace      = game:GetService("Workspace")

local Old_newindex

Old_newindex = hookmetamethod(Workspace, "__newindex", function(self, Key, Value)
    if self == Workspace and Key == "FallenPartsDestroyHeight" and Value == Value then
        local CallingScript = getcallingscript()
        local Calling = if typeof(CallingScript) == "Instance" then
            GetFullName(CallingScript)
        else if checkcaller() then ExecutorScript else "Unknown"

        warn("[Anti Void] Bypassed setting FallenPartsDestroyHeight! Calling script: \"" .. Calling .. "\".")
        return Old_newindex(self, Key, (0 / 0))
    end

    return Old_newindex(self, Key, Value)
end)

Workspace.FallenPartsDestroyHeight = (0 / 0)
