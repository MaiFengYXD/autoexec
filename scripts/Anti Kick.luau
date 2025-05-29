--!optimize 2

if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(1)

local typeof, tostring, xpcall, warn
    = typeof, tostring, xpcall, warn

local      GetFullName, getcallingscript, checkcaller, getnamecallmethod
    = game.GetFullName, getcallingscript, checkcaller, getnamecallmethod

local ExecutorScript = identifyexecutor() .. " LocalScript"
local Speaker        = game:GetService("Players").LocalPlayer

local function GetCalling(CallingScript, IsExecutor)
    return if typeof(CallingScript) == "Instance" then
        GetFullName(CallingScript)
    else if IsExecutor then ExecutorScript else "Unknown"
end

local function Bypass(Calling, Message)
    local _, _Message = xpcall(tostring, function()
        return ""
    end, Message)
    warn("[Anti Kick] Bypassed Kick! Calling script: \"" .. Calling .. "\". Message: " .. _Message)
end

local Old_index, Old_namecall, Old_Function

Old_Function = hookfunction(Speaker.Kick, function(self, ...)
    return if typeof(self) == "Instance" and self == Speaker then
        Bypass(GetCalling(getcallingscript(), checkcaller()), ...)
    else Old_Function(self, ...)
end)

Old_index = hookmetamethod(Speaker, "__index", function(self, ...)
    return typeof(self) == "Instance" and self == Speaker and ... == "Kick" and
        warn("[Anti Kick] " .. GetCalling(getcallingscript(), checkcaller()) .. " is trying to index Kick") 
    or Old_index(self, ...)
end)

Old_namecall = hookmetamethod(Speaker, "__namecall", function(self, ...)
    return if typeof(self) == "Instance" and self == Speaker and getnamecallmethod() == "Kick" then
        Bypass(GetCalling(getcallingscript(), checkcaller()), ...)
    else Old_namecall(self, ...)
end)
