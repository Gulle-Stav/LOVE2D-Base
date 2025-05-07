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
Config.__newindex = function (Table, Index, Value)
    rawset(Table, Index, Value)
end

function Config.UpdateInput(NewFile)
    local CurrentFile = io.input()
    if CurrentFile then
        if CurrentFile == NewFile then return end

        io.close(CurrentFile)
    end

    if not NewFile then return end

    io.input(NewFile)
end

function Config.UpdateOutput(NewFile)
    local CurrentFile = io.output()

    if not NewFile or CurrentFile == NewFile then return end

    io.output(NewFile)
end

function Config:Write(File, ...)
    if File then
        self.UpdateOutput(File)
    end

    local Content = {...}

    if #Content > 0 then
        io.write(...)
    end
    
    if File then
        io.close(File)
    end
end

function Config:GetConfig()
    if self.File then return self.File end

    for _, Name in ipairs(NAME_CHECK) do
        local Success, ConfigFile = pcall(function()
            return io.open(Name, "r+")
        end)
    
        if Success then
            return ConfigFile, Name
        end
    end
end

function Config:LoadConfig()
    self.UpdateInput(self.File)
    local ConfigText = io.read("a")

    for line in ConfigText:gmatch("[^%c]+%c?") do
        local lineNoBr = line:gsub("\n", "")
        local sepStart = lineNoBr:find("=")

        local index, value = lineNoBr:sub(0, sepStart-1):gsub("[%s]", ""), lineNoBr:sub(sepStart+1, #lineNoBr):gsub("[%s]", "")
        rawset(self.Config, index, self:StringToValue(value))
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

function Config:SaveConfig()
    local SaveText

    for Index, Value in pairs(self.Config) do
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
        local RewriteConfig = io.open(self.FileName, "w+")
        if self.File and RewriteConfig then
            self:Write(RewriteConfig, SaveText)
        end
    end
end

function Config.New()
    local self = setmetatable({}, Config)
    
    self.File, self.FileName = self:GetConfig()
    self.Config = setmetatable({}, {
        __newindex = function(t, i, v)
            rawset(t, i, v)
            print("Updating config! "..i)
            self:SaveConfig()
        end,
    })

    self:LoadConfig()

    Utils:PrintTable(self)

    print("Save this shit please!")
    self.Config.VSYNC = false

    return self
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

return Config.New()