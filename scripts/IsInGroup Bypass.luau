--!optimize 2

local getnamecallmethod
    = getnamecallmethod

local Speaker = cloneref(game:GetService("Players")).LocalPlayer

local OldNameCall

OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    if self ~= Speaker or getnamecallmethod() ~= "IsInGroup" then
        return OldNameCall(self, ...)
    end

    return true
end)

hookfunction(Speaker.IsInGroup, function(self, ...)
    return true
end)
