if not love then _G.love = require("love") end
if not ConnectLib then _G.ConnectLib = require("lib/ConnectLib") end

local Update = {}

Update.PreRender = setmetatable({}, ConnectLib)
Update.RenderStepped = setmetatable({}, ConnectLib)
Update.Draw = setmetatable({}, ConnectLib)

love.update = function(dt)
    Update.PreRender(dt)
    Update.RenderStepped(dt)
end

love.draw = function()
    Update.Draw()
end

return Update