--!optimize 2

if not game.IsLoaded then game.Loaded:Wait() end

local Workspace
    = workspace

local getcallingscript, checkcaller
    = getcallingscript, checkcaller

local ExecutorName = identifyexecutor()
local Initializing = true

local Nan = (0 / 0)

local OldNewIndex
OldNewIndex = hookmetamethod(game, "__newindex", function(self, Key, Value)
    if self == Workspace and Key == "FallenPartsDestroyHeight" and not Initializing then
        local Calling = checkcaller() and `{ExecutorName} LocalScript` or getcallingscript():GetFullName()
        warn(`[Anti Void] "{Calling}" attempted to set FallenPartsDestroyHeight to {Value}!`)

        return OldNewIndex(self, Key, Nan)
    end

    return OldNewIndex(self, Key, Value)
end)

Workspace.FallenPartsDestroyHeight = Nan
Initializing = false
