if not _G.UDim then _G.UDim = require("lib/UDim") end

local UDim2Lib = {}
UDim2Lib.__index = UDim2Lib
UDim2Lib.__newindex = function (Table, Key, Value)
    if Table == UDim2Lib then return end

    rawset(Table, Key, Value)
end

function ValidateUDim2(Value)
    if type(Value) ~= "table" then return false end

    local ValueMeta = getmetatable(Value)

    if ValueMeta ~= UDim2Lib then return false end

    return true
end

function UDim2Lib.New(XScale, XOffset, YScale, YOffset)
    local NewUDim2 = {
        UDim.New(XScale, XOffset),
        UDim.New(YScale, YOffset)
    }

    return setmetatable(NewUDim2, UDim2Lib)
end

function UDim2Lib.FromScale(XScale, YScale)
    local NewUDim2 = {
        UDim.New(XScale, 0),
        UDim.New(YScale, 0)
    }

    return setmetatable(NewUDim2, UDim2Lib)
end

function UDim2Lib.FromOffset(XOffset, YOffset)
    local NewUDim2 = {
        UDim.New(0, XOffset),
        UDim.New(0, YOffset)
    }

    return setmetatable(NewUDim2, UDim2Lib)
end

UDim2Lib.__add = function (Value1, Value2)
    if not (ValidateUDim2(Value1) and ValidateUDim2(Value2)) then return end

    local NewUDim2 = {
        Value1[1] + Value2[1],
        Value1[2] + Value2[2]
    }

    return setmetatable(NewUDim2, UDim2Lib)
end

UDim2Lib.__sub = function (Value1, Value2)
    if not (ValidateUDim2(Value1) and ValidateUDim2(Value2)) then return end

    local NewUDim2 = {
        Value1[1] - Value2[1],
        Value1[2] - Value2[2]
    }

    return setmetatable(NewUDim2, UDim2Lib)
end

UDim2Lib.__mul = function (Value1, Value2)
    if not ValidateUDim2(Value1) then return end
    
    local Value2IsTable = ValidateUDim2(Value2)

    if not Value2IsTable then
        if type(Value2) ~= "number" then return end
    end

    local NewUDim2 = {
        Value1[1] * (Value2IsTable and Value2[1] or Value2),
        Value1[2] * (Value2IsTable and Value2[2] or Value2)
    }

    return setmetatable(NewUDim2, UDim2Lib)
end

UDim2Lib.__div = function (Value1, Value2)
    if not ValidateUDim2(Value1) then return end
    
    local Value2IsTable = ValidateUDim2(Value2)

    if not Value2IsTable then
        if type(Value2) ~= "number" then return end
    end

    local NewUDim2 = {
        Value1[1] / (Value2IsTable and Value2[1] or Value2),
        Value1[2] / (Value2IsTable and Value2[2] or Value2)
    }

    return setmetatable(NewUDim2, UDim2Lib)
end

return setmetatable({}, UDim2Lib)