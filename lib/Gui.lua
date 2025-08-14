if not _G.UDim2 then _G.UDim2 = require("lib/UDim2") end

local GuiLibrary = {}
GuiLibrary.__index = GuiLibrary

local CLASSNAME = {
    ["Frame"] = "InitFrameObject";
}

function GuiLibrary:Instance(ClassName)
    assert(ClassName, "ClassName not defined!")
    assert(CLASSNAME[ClassName], "ClassName not recognized!")

    local GuiElement = self.NewBaseGuiElement()
    
    return self[CLASSNAME[ClassName]](GuiElement)
end

function GuiLibrary.NewBaseGuiElement()
    return {
        Name = "GuiElement";
        Position = UDim2.FromScale(0,0);
        Size = UDim2.FromOffset(400, 300);
        AnchorPoint = Vector.new(0,0);
        Visible = true;
        ZIndex = 1;
        Children = {};
    }
end

function GuiLibrary.InitFrameObject(GuiElement)
    GuiElement.BackgroundColor = Vector.new(1,1,1,1) --TODO: Create Color3 library with ability for HSV color picking and default color values
    GuiElement.Rotation = 0
    GuiElement.Name = "Frame"

end

return setmetatable({}, GuiLibrary)