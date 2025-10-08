-- DONT EXECUTE THIS SCRIPT IF YOU DONT KNOW WHAT IT DOES

-- This is a utilities/template, not a universal anticheat bypass!
-- You can safe insert your cheats in this script

-- For more details, see the bottom of the script

assert((
    clonefunction and
    setreadonly and
    newcclosure
), "Your executor doesn't support some functions that are required for this script to work")

local table_remove, unpack, string_gsub, string_sub, error, pcall, type
    = table.remove, unpack, string.gsub, string.sub, error, pcall, type

local debug_info = clonefunction(debug.info)

local function BypassErrorMessage(
    CallbackThatTriggeresError: Function,
    OriginalCallLine:           number,
    IsMetamethod:               boolean?,
    ...:                        any
): (boolean, ...string | any)
    local Results = {pcall(CallbackThatTriggeresError, ...)}

    if Results[1] then
        table_remove(Results, 1)
        return true, Results
    elseif IsMetamethod then
        return false, Results[2]
    end

    return false, string_gsub(Results[2], "^:2:%s", `:{OriginalCallLine}: `)
end

local BypassDebugInfo;do
    local Bypassed = {} -- {[BypassTarget]: Replacements}

    function BypassDebugInfo(BypassTarget: Function, Name: string, IsMetamethod: boolean?)
        Bypassed[BypassTarget] = {
            __ismetamethod = IsMetamethod,

            s = "[C]",
            l = -1,
            n = Name,
            f = BypassTarget
        }
    end

    local debug = debug

    setreadonly(debug, false)

    debug.info = newcclosure(function(Target, ThreadLevelOrFlags, ThreadFlags)
        local TargetType = type(Target)

        if TargetType == "number" then
            Target += 2
        end

        local Success, TargetInfoOrError = BypassErrorMessage(
            debug_info,
            debug_info(3, "l"),
            false,
            TargetType == "number" and Target + 2 or Target,
            ThreadLevelOrFlags,
            ThreadFlags
        )

        if not Success then
            error(TargetInfoOrError)
        end

        if TargetType == "thread" then
            return unpack(TargetInfoOrError)
        end

        local RealTargetFunction = debug_info(Target, "f")
        local Replacements       = Bypassed[RealTargetFunction]

        if Replacements then
            local IndexOffset = 0

            for Index = 1, #ThreadLevelOrFlags do
                local CurrentFlag = string_sub(ThreadLevelOrFlags, Index, Index)
                local Replacement = Replacements[CurrentFlag]

                if Replacement then
                    TargetInfoOrError[Index + IndexOffset] = Replacement
                elseif CurrentFlag == "a" then
                    IndexOffset += 1

                    TargetInfoOrError[Index]     = 0
                    TargetInfoOrError[Index + 1] = true
                end
            end
        end

        return unpack(TargetInfoOrError)
    end)

    setreadonly(debug, true)
end

BypassDebugInfo(debug.info, "info")

if getrawmetatable then
    local RawGameMetatable = getrawmetatable(game);do
        BypassDebugInfo(RawGameMetatable.__index,    "", true)
        BypassDebugInfo(RawGameMetatable.__newindex, "", true)
        BypassDebugInfo(RawGameMetatable.__namecall, "", true)
        BypassDebugInfo(RawGameMetatable.__tostring, "", true)
    end
end

--==== INSERT YOUR CHEATS BELOW ====--

-- Note: you should always use the `BypassErrorMessage` instead of pcall or returning directly
-- Also, use the `BypassDebugInfo` to bypass every FUNCTION that you want to hook on

--[[
    Example usage:

    ```luau
    local getnamecallmethod, print
        = getnamecallmethod, print

    local Old
    Old = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local Method = getnamecallmethod()

        if Method == "FireServer" then
            print(...)
        end

        -- Always use the `debug_info` and DONT use `debug.info` ↓
        -- Use `BypassErrorMessage` instead of `pcall`

        local Success, ErrorOrResults = BypassErrorMessage(Old, debug_info(3, "l"), true, self, ...)
        if not Success then
            -- You dont need to worry about the error line and error level issues cause *most of the executors auto wrap your hook into a c-closure (or you do that by yourself)
            -- And c-closure's traceback (including lines etc.) will never show on error
            error(ErrorOrResults)
        end

        return unpack(ErrorOrResults)
    end))
    ```
--]]
