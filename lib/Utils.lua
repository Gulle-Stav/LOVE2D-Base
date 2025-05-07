local Utils = {}
Utils.__index = Utils
Utils.__newindex = nil

function Utils:PrintTable(input, iter)
    if not iter then iter = 0 end

    local SpaceChar = ""

    if iter > 0 then
        for i = 1, iter do
            SpaceChar = SpaceChar .. "  "
        end
    end

    if type(input) ~= "table" then return end
    
    for Index, Value in pairs(input) do
        if type(Value) == "table" then
            print(SpaceChar..tostring(Index).." | {")
            self:PrintTable(Value, iter + 1)
            print(SpaceChar.."}")
        else
            print(SpaceChar..tostring(Index).." | "..tostring(Value))
        end
    end
end

function Utils.Lerp(a, b, t)
    return a + (b - a) * t
end

return setmetatable({}, Utils)