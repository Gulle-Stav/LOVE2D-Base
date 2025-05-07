local ConnectionLibrary = {}
ConnectionLibrary.__index = ConnectionLibrary

ConnectionLibrary.__index = function(Table, Index)
    if Table == ConnectionLibrary then return end

    local ReturnValue = rawget(Table, Index)

    if not ReturnValue then ReturnValue = rawget(ConnectionLibrary, Index) end

    return ReturnValue
end

ConnectionLibrary.__call = function(Table, ...)
    local EventFunctions = rawget(Table, "connectedEventFunctions")

    if not (EventFunctions and type(EventFunctions) == "table") then return end

    for _, Function in pairs(EventFunctions) do
        if type(Function) == "function" then
            Function(...)
        end
    end
end

function ConnectionLibrary.Connect(Table, Function)
    if type(Table) ~= "table" or Table == ConnectionLibrary then return end
    
    local EventFunctions = rawget(Table, "connectedEventFunctions")
    if not EventFunctions then EventFunctions = {} end

    EventFunctions[tostring(Function)] = Function

    rawset(Table, "connectedEventFunctions", EventFunctions)

    local ConnectionInformation = {
        Function = tostring(Function),
        Disonnect = function(ConnectionInformation)
            if not (ConnectionInformation and type(ConnectionInformation) == "table" and ConnectionInformation.Function) then return end
            
            local LocalEventFunctions = rawget(Table, "connectedEventFunctions")
            
            if LocalEventFunctions then
                LocalEventFunctions[ConnectionInformation.Function] = nil
            end

            for Index, _ in pairs(ConnectionInformation) do
                rawset(ConnectionInformation, Index, nil)
            end
        end
    }

    return ConnectionInformation
end

function ConnectionLibrary.GetConnections(Table)
    if type(Table) ~= "table" or Table == ConnectionLibrary then return end
    
    return rawget(Table, "connectedEventFunctions")
end

return setmetatable({}, ConnectionLibrary)