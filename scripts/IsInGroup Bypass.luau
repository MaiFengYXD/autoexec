--!optimize 2

local getnamecallmethod
    = getnamecallmethod

local GroupService      = game:GetService("GroupService")
local GetGroupInfoAsync = GroupService.GetGroupInfoAsync

local Speaker = game:GetService("Players").LocalPlayer

local Old_namecall, Old_Function

Old_namecall = hookmetamethod(Speaker, "__namecall", function(self, ...)
    return if getnamecallmethod() == "IsInGroup" and self == Speaker then
        if GetGroupInfoAsync(GroupService, ..., nil) then true else false
    else Old_namecall(self, ...)
end)

Old_Function = hookfunction(Speaker.IsInGroup, function(self, ...)
    return if self == Speaker and GetGroupInfoAsync(GroupService, ..., nil) then
        true
    else Old_Function(self, ...)
end)
