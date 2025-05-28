--!optimize 2

local getnamecallmethod
    = getnamecallmethod

local GroupService      = game:GetService("GroupService")
local GetGroupInfoAsync = GroupService.GetGroupInfoAsync

local Speaker = game:GetService("Players").LocalPlayer

local Old_namecall, Old_Function

Old_namecall = hookmetamethod(Speaker, "__namecall", function(self, ...)
    if self ~= Speaker then
        return Old_namecall(self, ...)
    elseif getnamecallmethod() ~= "IsInGroup" then
        return Old_namecall(self, ...)
    end

    return true
end)

Old_Function = hookfunction(Speaker.IsInGroup, function(self, GroupId)
    if self ~= Speaker then
        return Old_Function(self, GroupId)
    elseif not GetGroupInfoAsync(GroupService, GroupId) then
        return false
    end

    return true
end)
