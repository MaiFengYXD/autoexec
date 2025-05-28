--!optimize 2

if not game:IsLoaded() then
    game.Loaded:Wait()
end

task.wait(1)

local rawget, type, debug_info
    = rawget, type, debug.info

for _, Grabage in getgc(true) do
    if type(Grabage) ~= "table" then
        continue
    end

    local Detected = rawget(Grabage, "Detected")

    if type(Detected) ~= "function" or debug_info(Detected, "s") ~= ".Core.Anti" then
        continue
    end

    local Old_debug_info

    Old_debug_info = hookfunction(debug_info, function(Function, ...)
        if Function == Detected then
            print("Bypassing!")
            repeat until not task.wait(9e9)
        end

        return Old_debug_info(Function, ...)
    end)

    print("Adonis Bypassed")
    break
end
