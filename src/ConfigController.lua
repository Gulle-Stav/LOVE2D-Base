local NAME_CHECK = {
    "game.config",
    "game.conf",
    "settings.config",
    "settings.conf",
    ".config",
    ".conf"
}

local Config = {}
Config.__index = Config

function Config:GetConfig()
    if self.File then return self.File end

    for _, Name in ipairs(NAME_CHECK) do
        local Success, ConfigFile = pcall(function()
            return io.open(Name, "r+")
        end)
    
        if Success and ConfigFile then
            io.close(ConfigFile)
            return Name
        end
    end
end

function Config:LoadConfig()
    assert(self.FileName, "No File Name!")

    local ConfigFile = io.open(self.FileName, "r+")

    if ConfigFile then
        local ConfigText = ConfigFile:read("a")

        for line in ConfigText:gmatch("[^%c]+%c?") do
            local lineNoBr = line:gsub("\n", "")
            local sepStart = lineNoBr:find("=")

            local index, value = lineNoBr:sub(0, sepStart-1):gsub("[%s]", ""), lineNoBr:sub(sepStart+1, #lineNoBr):gsub("[%s]", "")
            
            ConfigValues[index] = self:StringToValue(value)
        end
    end
end

function Config:SaveConfig()
    local SaveText

    for Index, Value in pairs(ConfigValues) do
        print(Index, Value)
        if not SaveText then
            SaveText = ""
        else
            SaveText = SaveText .. "\n"
        end

        if type(Value) ~= "table" then
            SaveText = SaveText .. Index .. " = " .. tostring(Value)
        else
            local TranslatedTable = self:IterateTableToString(Value)
            SaveText = SaveText .. Index .. " = " .. TranslatedTable
        end
    end

    if SaveText and self.FileName then
        local ConfigFile = io.open(self.FileName, "w+")
        if ConfigFile then
            ConfigFile:write(SaveText)
            io.close(ConfigFile)
        end
    end
end

function Config:IterateTableToString(Table)
    local ReturnValue = nil

    for Index, Value in pairs(Table) do
        if not ReturnValue then
            ReturnValue = ""
        else
            ReturnValue = ReturnValue .. ", "
        end

        local SetValue
        if type(Value) == "table" then
            SetValue = self:IterateTableToString(Value)
        else
            SetValue = tostring(Value)
        end

        ReturnValue = ReturnValue .. Index .. " = " .. SetValue
    end

    if not ReturnValue then
        return "{}"
    end

    return "{"..ReturnValue.."}"
end

function Config:StringToValue(String)
    if String:match("^true") then
        return true
    elseif String:match("^false") then
        return false
    end

    local NumMatch = String:match("^%d+")

    if NumMatch and #NumMatch == #String then
        return tonumber(String)
    end

    local TableMatch = String:match("^%b{}")
    if TableMatch then
        local SubbedTableMatch = TableMatch:sub(2,#TableMatch-1)
        local ReturnTable = {}
    
        for foovar in SubbedTableMatch:gmatch("[^,]+,?") do
            local noCom = foovar:gsub(",", "")
            local sepStart = noCom:find("=")

            local index = #ReturnTable + 1
            local value = noCom

            if sepStart then
                index, value = noCom:sub(0, sepStart-1), noCom:sub(sepStart+1, #noCom)
            end

            ReturnTable[index] = self:StringToValue(value)
        end

        return ReturnTable
    end

    return String
end

function Config.New()
    local self = setmetatable({}, Config)

    self.FileName = self:GetConfig()
    self.Config = self:LoadConfig()

    print("Save this shit please!")

    Task.Delay(3, function ()
        print("Config VSYNC set to false!")
        self.NEWVARIABLE = true
    end)

    Task.Delay(5, function ()
        self.NEWVARIABLE = nil
    end)

    return self
end

return Config.New()