--!optimize 2

if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(1)

local rawget, type, debug_info, unpack, string_find, checkcaller
    = rawget, type, debug.info, unpack, string.find, checkcaller

local DetectedMethod = "None"
local Old_debug_info

for _, Grabage in getgc(true) do
    if type(Grabage) ~= "table" then
        continue
    end

    local Detected = rawget(Grabage, "Detected")

    if type(Detected) ~= "function" or debug_info(Detected, "s") ~= ".Core.Anti" then
        continue
    end

    Old_debug_info = hookfunction(debug_info, function(FunctionOrLevel, ...)
        if FunctionOrLevel == Detected and not checkcaller() then
            print("Bypassing Adonis!")
            repeat until not task.wait(9e9)
        end

        return Old_debug_info(FunctionOrLevel, ...)
    end)

    DetectedMethod = "Adonis"
    break
end

if DetectedMethod == "None" then
    DetectedMethod = "Universal"

    local Metamethod_index, Metamethod_namecall, Metamethod_newindex;do
        xpcall(function()
            local _ = game.________
        end, function()
            Metamethod_index = debug_info(2, "f")
        end)

        xpcall(function()
            game:________()
        end, function()
            Metamethod_namecall = debug_info(2, "f")
        end)

        xpcall(function()
            game.________ = Enum
        end, function()
            Metamethod_newindex = debug_info(2, "f")
        end)
    end

    local Metamethods = {
        [Metamethod_index] = true,
        [Metamethod_namecall] = true,
        [Metamethod_newindex] = true
    }

    Old_debug_info = hookfunction(debug_info, function(FunctionOrLevel, ...)
        local OldResult = {Old_debug_info(FunctionOrLevel, ...)}

        if checkcaller() then
            return unpack(OldResult)
        end

        if Metamethods[Old_debug_info(FunctionOrLevel, "f")] then
            local Source = string_find(..., "s")
            local Arity  = string_find(..., "a")
            local Name   = string_find(..., "n")
            local Line   = string_find(..., "l")

            for Index in OldResult do
                if Index == Source then
                    OldResult[Index] = "[C]"
                elseif Index == Arity then
                    OldResult[Index] = 0
                elseif Index == Name then
                    OldResult[Index] = ""
                elseif Index == Line then
                    OldResult[Index] = -1
                end
            end
        end

        return unpack(OldResult)
    end)
end

print(`Bypass is ready! (method: {DetectedMethod})`)
