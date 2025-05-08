local Task = {}
Task.__index = Task
Task.__newindex = nil
Task.__metatable = nil

Task.Schedule = {}

function Task.Delay(Duration, Function)
    if not (Duration and Function) then return end

    local CurrentTimeStamp = os.clock()
    local TimeOnRun = CurrentTimeStamp + Duration

    table.insert(Task.Schedule, {
        Time = TimeOnRun,
        Function = Function
    })
end

Update.RenderStepped:Connect(function (dt)
    local CurrentTime = os.clock()

    local RemoveIndex

    for Index, Info in ipairs(Task.Schedule) do
        if CurrentTime >= Info.Time then
            Info.Function()

            if not RemoveIndex then RemoveIndex = {} end

            table.insert(RemoveIndex, Index)
        end
    end

    if RemoveIndex then
        for _, Index in ipairs(RemoveIndex) do
            table.remove(Task.Schedule, Index)
        end
        RemoveIndex = nil
    end
end)

return setmetatable({}, Task)