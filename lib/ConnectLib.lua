local ConnectionLibraryMetatable = {}

local ConnectionLibrary = {}

ConnectionLibraryMetatable.__index = ConnectionLibrary

ConnectionLibraryMetatable.__call = function(Table, ...)
    local EventFunctions = rawget(Table, "connectedEventFunctions")

    if not (EventFunctions and type(EventFunctions) == "table") then return end

    for _, Function in pairs(EventFunctions) do
        if type(Function) == "function" then
            Function(...)
        end
    end
end

function ConnectionLibrary:Connect(Function)
    if self == ConnectionLibrary or self == ConnectionLibraryMetatable then return end
    
    local EventFunctions = rawget(self, "connectedEventFunctions")
    if not EventFunctions then EventFunctions = {} end

    EventFunctions[tostring(Function)] = Function

    rawset(self, "connectedEventFunctions", EventFunctions)

    local ConnectionInformation = {
        Function = tostring(Function),
        Disonnect = function(ConnectionInformation)
            if not (ConnectionInformation and type(ConnectionInformation) == "table" and ConnectionInformation.Function) then return end
            
            local LocalEventFunctions = rawget(self, "connectedEventFunctions")
            
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

function ConnectionLibrary:GetConnections()
    if self == ConnectionLibrary or self == ConnectionLibraryMetatable then return end
    
    return rawget(self, "connectedEventFunctions")
end

return ConnectionLibraryMetatable