--!optimize 2

if not game:IsLoaded() then game.Loaded:Wait() end

local stringlower
    = string.lower

local select, checkcaller, getnamecallmethod
    = select, checkcaller, getnamecallmethod

local Remote

for _, Instance in getnilinstances() do
    if Instance.Name == "" then
        Remote = game:GetService("ReplicatedStorage"):WaitForChild(Instance:WaitForChild("Special").Value)
        break
    end
end

if not Remote then return end

local OldFireServer: (self: Instance, ...any) -> (...any)
local OldNameCall:   (self: DataModel | Instance, ...any) -> (...any)

OldFireServer = hookfunction(Remote.FireServer, function(self, ...)
    if stringlower(select(3, ...)) == "kick" then
        warn(`[Adonis Bypass] Prevented a kick! Kick message: "{select(4, ...)}"`)
        return
    end

    return OldFireServer(self, ...)
end)

OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    if checkcaller() then return OldNameCall(self, ...) end

    local Method = getnamecallmethod()

    if Method == "FireServer" and self == Remote and stringlower(select(3, ...)) == "kick" then
        warn(`[Adonis Bypass] Prevented a kick! Kick message: "{select(4, ...)}"`)
        return
    end

    return OldNameCall(self, ...)
end)
