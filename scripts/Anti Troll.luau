--!optimize 2

local Instancenew,  taskwait
    = Instance.new, task.wait

local getnamecallmethod, checkcaller
    = getnamecallmethod, checkcaller

local ExecutorName = identifyexecutor()

local OldFunction, OldNameCall, OldIsHooked = {}, nil, nil
local StarterGui = cloneref(game:GetService("StarterGui"))

local function Notify(Title, Text, Callback)
    StarterGui:SetCore("SendNotification", {
        Title = Title,
        Text  = Text,
        Duration = (1 / 0),
        Callback = Callback,
        Button1  = "Accept",
        Button2  = "Decline"
    })
end

OldFunction.Shutdown = hookfunction(game.Shutdown, function(self)
    if not checkcaller() then
        return OldFunction.Shutdown(self)
    end

    warn(`[Anti Troll] {ExecutorName} LocalScript attempted to call game.Shutdown!`)
    return (function()
        repeat taskwait(9e9) until nil
    end)
end)

OldNameCall = hookmetamethod(game, "__namecall", function(self, ...)
    if getnamecallmethod() ~= "Shutdown" or not checkcaller() then
        return OldNameCall(self, ...)
    end

    warn(`[Anti Troll] {ExecutorName} LocalScript attempted to call game:Shutdown! (__namecall)`)
    return (function()
        repeat taskwait(9e9) until nil
    end)
end)

OldFunction.delfile = hookfunction(delfile, function(FileName)
    local Bindable = Instancenew("BindableFunction")
    function Bindable.OnInvoke(Accepted)
        return Accepted and OldFunction.delfile(FileName)
    end

    Notify("Anti Troll", `Attempted to delete file: {tostring(FileName)}`, Bindable)
end)

OldFunction.delfolder = hookfunction(delfolder, function(FolderName)
    local Bindable = Instancenew("BindableFunction")
    function Bindable.OnInvoke(Accepted)
        return Accepted and OldFunction.delfolder(FolderName)
    end

    Notify("Anti Troll", `Attempted to delete folder: {tostring(FolderName)}`, Bindable)
end)

OldIsHooked = hookfunction(isfunctionhooked, function(Function)
    if (
        Function == game.Shutdown or
        Function == delfile or
        Function == delfolder or
        Function == isfunctionhooked
    ) then return false end

    return OldIsHooked(Function)
end)
