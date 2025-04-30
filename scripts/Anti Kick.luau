--!optimize 2

local game, typeof, tostring, pcall, warn, taskwait
    = game, typeof, tostring, pcall, warn, task.wait

local getcallingscript, checkcaller, getnamecallmethod, GetFullName
    = getcallingscript, checkcaller, getnamecallmethod, game.GetFullName

local ExecutorName = identifyexecutor()

local Global  = getgenv()
local Speaker = game:GetService("Players").LocalPlayer

local OldIsHooked, OldIndex, OldNameCall
local OldFunction = clonefunction(Speaker.Kick)

local function GetCalling(CallingScript, ExecutorCall)
    local Calling = CallingScript or ExecutorCall and (`{ExecutorName} LocalScript`)

    if typeof(Calling) == "Instance" then Calling = GetFullName(Calling)
    elseif not Calling then Calling = "Unknown" end

    return Calling
end

local function NewAntiKick(Method, Old)
    return function(self, ...)
        if Global.SafeRJ then return Old(self, ...) end
        if Method == "__namecall" and getnamecallmethod() ~= "Kick" then return Old(self, ...) end

        local Calling = GetCalling(getcallingscript(), checkcaller())
        local Message = not pcall(tostring, ...) and "" or tostring(...)

        warn(`[Anti Kick] Something trying to call 'Player.Kick', calling script: "{Calling}"`)
        warn(`[Anti Kick] Bypassed kick! Kick message: "{Message}"`)
        return (function()
            repeat taskwait(9e9) until nil
        end)()
    end
end

OldNameCall = hookmetamethod(game, "__namecall", function(...)
    return OldNameCall(...)
end)

OldIsHooked = hookfunction(isfunctionhooked, function(Function)
    if Function == Speaker.Kick then return false end
    return OldIsHooked(Function)
end)

hookfunction  (Speaker.Kick,       NewAntiKick("hookfunction", OldFunction))
hookmetamethod(game, "__namecall", NewAntiKick("__namecall",   OldNameCall))

OldIndex = hookmetamethod(game, "__index", function(self, Key)
    if Global.SafeRJ then return OldIndex(self, Key) end
    if self ~= Speaker or Key ~= "Kick" then return OldIndex(self, Key) end

    local Calling = GetCalling(getcallingscript(), checkcaller())

    warn(`[Anti Kick] Something trying to index kick, calling script: "{Calling}"`)
    return OldIndex(self, Key)
end)
