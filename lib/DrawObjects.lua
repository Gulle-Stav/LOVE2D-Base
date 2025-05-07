--[[ Information ]]

local OBJECT_FUNCTION_REFERENCE = {
    ["line"] = "CreateLine",
    ["polygon"] = "CreatePolygon",
    ["texture"] = "CreateTexture"
}

local DrawObjects = {}
DrawObjects.__index = function(_, Index)
    if OBJECT_FUNCTION_REFERENCE[Index] then
        return DrawObjects[OBJECT_FUNCTION_REFERENCE[Index]]
    end

    local ReturnValue = rawget(DrawObjects, Index)
    if not ReturnValue then ReturnValue = _G.love[Index] end

    return ReturnValue
end

--[[ Functions ]]
function DrawObjects:CreateLine()
    
end

function DrawObjects:CreatePolygon()
    
end

function DrawObjects:CreateTexture()
    
end

return setmetatable({}, DrawObjects)