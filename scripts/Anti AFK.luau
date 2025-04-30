--!optimize 2

local pcall
    = pcall

for _, SkibidiConnection in getconnections(game:GetService("Players").LocalPlayer.Idled) do
    pcall(SkibidiConnection.Disable   , SkibidiConnection)
    pcall(SkibidiConnection.Disconnect, SkibidiConnection)
end
