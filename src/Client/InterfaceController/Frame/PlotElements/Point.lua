--!strict

local Types = require(script.Parent.Parent.Parent.Types)

local PointConfig = require(script.Parent.Parent.Parent.Parent.Config).Interface.Defaults.PlotComponents.Point

local Point: Types.PointElementProto = {} :: Types.PointElementProto
Point.__index = Point

function Point.new() 
	local self = {
		_guiObject = Instance.new("Frame")
	}
	
	self._guiObject.Size = PointConfig.Frame.Size
	self._guiObject.BackgroundColor3 = PointConfig.Frame.BackgroundColor3
	self._guiObject.BorderSizePixel = PointConfig.Frame.BorderSizePixel
	
	return setmetatable(self, Point)
end

function Point:Mount(parent: GuiObject)
	self._guiObject.Parent = parent
end

function Point:SetPosition(pos: Vector2, xOffset: number, yOffset: number) 
	self._guiObject.Position = UDim2.fromOffset(pos.X + xOffset, pos.Y + yOffset)
end

return Point
