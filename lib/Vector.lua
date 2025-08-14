local OFF_LIMIT_VECTOR_METHODS = {
    new = true,

}

local INDEX_TO_AXIS = {
    X = 1,
    R = 1,
    Y = 2,
    G = 2,
    Z = 3,
    B = 3,
    W = 4,
    A = 4,
}

local GET_VALUE_FROM_FUNCTION = {
    Magnitude = true,
    Unit = true
}

local Vector = {}
Vector.__index = function(Table, Index)
    if not rawget(Table, "IsVector") then return rawget(Table, Index) end

    assert(OFF_LIMIT_VECTOR_METHODS[Index], "ERR: Use Vector library!")

    local ReturnValue = INDEX_TO_AXIS[Index] and rawget(Table, INDEX_TO_AXIS[Index]) or rawget(Table, Index)

    if not ReturnValue and GET_VALUE_FROM_FUNCTION[Index] then
        local Function = rawget(Vector, Index)
        assert(type(Function) == "function")
        ReturnValue = Function(Table)
    end

    if not ReturnValue then ReturnValue = rawget(Vector, Index) end

    return ReturnValue
end
Vector.__newindex = nil
Vector.__add = AddVector
Vector.__sub = SubVector
Vector.__mul = MulVector
Vector.__div = DivVector
Vector.__unm = UnmVector
Vector.__mod = ModVector
Vector.__tostring = ToStringVector
Vector.__len = LenVector

function Vector.new(...)
    local VectorInfo = table.pack(...)
    VectorInfo["IsVector"] = true

    for _, Value in ipairs(VectorInfo) do
        if type(Value) ~= "number" then
            print("ERR:: Vector Parameter includes type non-number, returning nil.")
            return nil
        end
    end

    return setmetatable(VectorInfo, Vector)
end

function Vector:Magnitude()
    assert(type(self) == "table" and self.IsVector, "ERR: Non vector!")
    
    local ReturnValue = 0
    for _, Value in ipairs(self) do
        ReturnValue = ReturnValue + Value ^ 2
    end
    assert(ReturnValue > 0, "ERR: I don't even know bro, like how the actual fuck")

    if ReturnValue == 0 then
        rawset(self, "Magnitude", 0)
        return 0
    end

    local SqrtResult = math.sqrt(ReturnValue)
    rawset(self, "Magnitude", SqrtResult)
    return SqrtResult
end

function Vector:Unit()
    assert(type(self) == "table" and self.IsVector, "ERR: Non vector!")
    
    return self / self.Magnitude
end

function AddVector(Vector1, Vector2)
    assert(type(Vector1) == "table" and Vector1.IsVector and type(Vector2) == "table" and Vector2.IsVector, "ERR: Adding non vectors!")
    assert(#Vector1 == #Vector2, "ERR: Mismatch axis count!")

    local ReturnValue = {}
    for Index, Value in ipairs(Vector1) do
        assert(Vector2[Index], "ERR: Index axis "..tostring(Index).." not existing in secondary vector!")
        ReturnValue[Index] = Value + Vector2[Value]
    end

    return ReturnValue
end

function SubVector(Vector1, Vector2)
    assert(type(Vector1) == "table" and Vector1.IsVector and type(Vector2) == "table" and Vector2.IsVector, "ERR: Subbing non vectors!")
    assert(#Vector1 == #Vector2, "ERR: Mismatch axis count!")
    
    return AddVector(Vector1, UnmVector(Vector2))
end

function UnmVector(Value)
    assert(type(Value) == "table" and Value.IsVector, "ERR: Non vector!")

    local ReturnValue = {}
    for Index, AxisValue in ipairs(Value) do
        assert(AxisValue ~= nil, "ERR: Value at "..Index.." nil!")
        assert(type(AxisValue) == "number", "ERR: Value at "..Index.." not number!")
        ReturnValue[Index] = -AxisValue
    end

    return ReturnValue
end

function ModVector(Value, Limit)
    assert(type(Value) == "table" and Value.IsVector, "ERR: Non vector!")
    assert(type(Limit) == "number", "ERR: Attempting to mod with non string!")

    local ReturnValue = {}
    for Index, AxisValue in ipairs(Value) do
        assert(AxisValue ~= nil, "ERR: Value at "..Index.." nil!")
        assert(type(AxisValue) == "number", "ERR: Value at "..Index.." not number!")
        ReturnValue[Index] = AxisValue % Limit
    end

    return ReturnValue
end

function MulVector(Vector1, Value2)
    local IsValue2Number = type(Value2) == "number"
    assert(type(Vector1) == "table" and Vector1.IsVector and ((type(Value2) == "table" and Value2.IsVector) or IsValue2Number), "ERR: Multiplying non vectors!")
    assert(IsValue2Number or #Vector1 == #Value2, "ERR: Mismatch axis count!")

    local ReturnValue = {}
    for Index, Value in ipairs(Vector1) do
        local MulBy = IsValue2Number and Value2 or Value2[Index]
        assert(MulBy, "ERR: Index axis "..tostring(Index).." not existing in secondary vector!")
        ReturnValue[Index] = Value * MulBy
    end

    return ReturnValue
end

function DivVector(Vector1, Value2)
    local IsValue2Number = type(Value2) == "number"
    assert(type(Vector1) == "table" and Vector1.IsVector and ((type(Value2) == "table" and Value2.IsVector) or IsValue2Number), "ERR: Dividing non vectors!")
    assert(IsValue2Number or #Vector1 == #Value2, "ERR: Mismatch axis count!")

    local ReturnValue = {}
    for Index, Value in ipairs(Vector1) do
        local DivBy = IsValue2Number and Value2 or Value2[Index]
        assert(DivBy, "ERR: Index axis "..tostring(Index).." not existing in secondary vector!")
        ReturnValue[Index] = Value / DivBy
    end

    return ReturnValue
end

function PowVector(Value, Pow)
    assert(type(Value) == "table" and Value.IsVector, "ERR: Non vector!")
    assert(type(Pow) == "number", "ERR: Attempting to pow with non string!")
    
    local ReturnValue = {}
    for Index, AxisValue in ipairs(Value) do
        assert(AxisValue ~= nil, "ERR: Value at "..Index.." nil!")
        assert(type(AxisValue) == "number", "ERR: Value at "..Index.." not number!")
        ReturnValue[Index] = AxisValue ^ Pow
    end

    return ReturnValue
end

function ToStringVector(Value)
    assert(type(Value) == "table" and Value.IsVector, "ERR: Non vector!")

    local ReturnValue
    for _, AxisValue in ipairs(Value) do
        if ReturnValue then
            ReturnValue = ReturnValue .. ", "
        else
            ReturnValue = ""
        end

        ReturnValue = ReturnValue .. tostring(AxisValue)
    end

    return ReturnValue
end

function LenVector(Value)
    assert(type(Value) == "table" and Value.IsVector, "ERR: Non vector!")
    return Value.Magnitude
end

return setmetatable({}, Vector)