--!strict

local Types = require(script.Parent.Parent.Parent.Types)

local BarConfig = require(script.Parent.Parent.Parent.Parent.Config).Interface.Defaults.PlotComponents.Bar

local Bar: Types.BarElementProto = {} :: Types.BarElementProto
Bar.__index = Bar

function Bar.new() 
	local self = {
		_guiObject = Instance.new("Frame")
	}
	
	self._guiObject.BackgroundColor3 = BarConfig.Frame.BackgroundColor3
	self._guiObject.BorderSizePixel = BarConfig.Frame.BorderSizePixel

	return setmetatable(self, Bar)
end

function Bar:Mount(parent: GuiObject)
	self._guiObject.Parent = parent
end

function Bar:SetPosition(pos: Vector2, xOffset: number, yOffset: number) 
	self._guiObject.Position = UDim2.fromOffset(pos.X + xOffset, pos.Y + yOffset)
end

function Bar:SetSize(size: Vector2)
	self._guiObject.Size = UDim2.fromOffset(size.X, size.Y)
end

return Bar
