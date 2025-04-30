--!optimize 2

local game
    = game

local checkcaller, getnamecallmethod
    = checkcaller, getnamecallmethod

local OldFunction, OldNameCall, OldIndex

local ErrorMessage = "The current thread cannot access 'CoreGui' (lacking capability Plugin)"

OldFunction = hookfunction(game.GetService, function(self: Instance, ServiceName: string)
    if ServiceName == "CoreGui" and not checkcaller() then
        return if pcall(OldNameCall, self, ServiceName) then nil else error(ErrorMessage, 2)
    end

    return OldFunction(self, ServiceName)
end)

OldNameCall = hookmetamethod(game, "__namecall", function(self: Instance, ...: string?)
    if self == game and getnamecallmethod() == "GetService" and not checkcaller() and ... == "CoreGui" then
        return if pcall(OldNameCall, self, ...) then nil else error(ErrorMessage, 2)
    end

    return OldNameCall(self, ...)
end)

OldIndex = hookmetamethod(game, "__index", function(self: Instance, Key: string)
    if self == game and Key == "CoreGui" and not checkcaller() then
        return error(ErrorMessage, 2)
    end

    return OldIndex(self, Key)
end)
