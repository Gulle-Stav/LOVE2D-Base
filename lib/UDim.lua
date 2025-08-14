local UDimLib = {}
UDimLib.__index = UDimLib
UDimLib.__newindex = function (Table, Key, Value)
    if Table == UDimLib then return end

    rawset(Table, Key, Value)
end

function ValidateUDim(Value)
    if type(Value) ~= "table" then return false end

    if type(Value.Scale) ~= "number" or type(Value.Offset) ~= "number" then return false end

    return true
end

function UDimLib.New(Scale, Offset)
    local NewUDim = {
        Scale = Scale or 0,
        Offset = Offset or 0
    }

    return setmetatable(NewUDim, UDimLib)
end

UDimLib.__add = function (Value1, Value2)
    if not (ValidateUDim(Value1) and ValidateUDim(Value2)) then return end

    local NewUDim = {
        Scale = Value1.Scale + Value2.Scale,
        Offset = Value1.Offset + Value2.Offset
    }
    
    return setmetatable(NewUDim, UDimLib)
end

UDimLib.__sub = function (Value1, Value2)
    if not (ValidateUDim(Value1) and ValidateUDim(Value2)) then return end

    local NewUDim = {
        Scale = Value1.Scale - Value2.Scale,
        Offset = Value1.Offset - Value2.Offset
    }
    
    return setmetatable(NewUDim, UDimLib)
end

UDimLib.__mul = function (Value1, Value2)
    if not ValidateUDim(Value1) then return end
    
    local Value2IsTable = ValidateUDim(Value2)

    if not Value2IsTable then
        if type(Value2) ~= "number" then return end
    end

    local NewUDim = {
        Scale = Value1.Scale * (Value2IsTable and Value2.Scale or Value2),
        Offset = Value1.Offset * (Value2IsTable and Value2.Scale or Value2)
    }
    
    return setmetatable(NewUDim, UDimLib)
end

UDimLib.__div = function (Value1, Value2)
    if not ValidateUDim(Value1) then return end

    local Value2IsTable = ValidateUDim(Value2)

    if not Value2IsTable then
        if type(Value2) ~= "number" then return end
    end

    local NewUDim = {
        Scale = Value1.Scale / (Value2IsTable and Value2.Scale or Value2),
        Offset = Value1.Offset / (Value2IsTable and Value2.Scale or Value2)
    }
    
    return setmetatable(NewUDim, UDimLib)
end

return setmetatable({}, UDimLib)