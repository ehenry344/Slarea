--!strict

-- // Types //
local Types = require(script.Parent.Parent.Parent.Types)

-- // Utils //
local InterfaceUtil = require(script.Parent.Parent.Parent.Utility)

-- // Dependencies //
local Axis = require(script.Parent.Parent.FrameElements.Axis)

-- // Config //
local Config = require(script.Parent.Parent.Parent.Config)

local PlotConfig = Config.Interface.Defaults.Plots.Line
local AxisConfig = Config.Interface.Defaults.PlotElements.Axis

local PointConfig = Config.Interface.Defaults.PlotComponents.Point
local LineConfig = Config.Interface.Defaults.PlotComponents.Line

-- line element templates

local lineTemplate = Instance.new("Frame") do
	lineTemplate.BackgroundColor3 = LineConfig.Frame.BackgroundColor3
	lineTemplate.BorderSizePixel = LineConfig.Frame.BorderSizePixel
	lineTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
end

-- // Module //

local LinePlotNp: Types.LinePlotNpProto = {} :: Types.LinePlotNpProto
LinePlotNp.__index = LinePlotNp

function LinePlotNp.new(parent: Types.SlareaFrame)
	local self = {
		Parent = parent,
		Frame = Instance.new("Frame"),
		
		LowerBound = {
			X = PlotConfig.Bounds.Left,
			Y = PlotConfig.Bounds.Bottom
		},
		
		PlotScale = {
			X = (1 - PlotConfig.Bounds.Right) - PlotConfig.Bounds.Left,
			Y = (1 - PlotConfig.Bounds.Top) - PlotConfig.Bounds.Bottom
		},
		
		_deployedFrames = {},
		_reserveFrames = {},
	}
	
	self.Frame.Name = "LinePlot"
	self.Frame.Position = UDim2.fromOffset(AxisConfig.Size.Width,0)
	self.Frame.Size = PlotConfig.Frame.Size
	self.Frame.BackgroundColor3 = PlotConfig.Frame.BackgroundColor3
	self.Frame.BorderSizePixel = PlotConfig.Frame.BorderSizePixel
	self.Frame.BorderColor3 = PlotConfig.Frame.BorderColor3
	
	self.Frame.Parent = self.Parent.Frame
	
	-- need a neater version of this in the future
	
	self.Axis = {
		X = Axis.new(self, "Horizontal", PlotConfig.Ticks.Horizontal),
		Y = Axis.new(self, "Vertical", PlotConfig.Ticks.Vertical)
	}

	return setmetatable(self, LinePlotNp)
end

function LinePlotNp:_getFrame(index: number)
	if self._deployedFrames[index - 1] then
		return self._deployedFrames[index - 1]
	elseif #self._reserveFrames > 0 then
		local resFrame = table.remove(self._reserveFrames) :: Frame
		resFrame.Visible = true
		
		table.insert(self._deployedFrames, resFrame)
		
		return resFrame
	else
		local newFrame = lineTemplate:Clone()
		newFrame.Parent = self.Frame

		table.insert(self._deployedFrames, newFrame)
		
		return newFrame
	end
end

function LinePlotNp:_reserve(usedFrames: number)
	for i = usedFrames, #self._deployedFrames do
		local frame = table.remove(self._deployedFrames) :: Frame
		
		frame.Visible = false
		
		table.insert(self._reserveFrames, frame)
	end 
end

function LinePlotNp:_makeLine(index: number, p0: Vector2, p1: Vector2)	
	local lineFrame: Frame = self:_getFrame(index)
	
	local diffVector = p1 - p0
		
	lineFrame.Size = UDim2.new(0, diffVector.Magnitude, 0, 1)
	lineFrame.Rotation = math.deg(math.atan2(diffVector.Y, diffVector.X))
	lineFrame.Position = UDim2.fromOffset((p1.X + p0.X) / 2, (p1.Y + p0.Y) / 2)
end

-- going to use the Ramer-Douglas-Peucker algorithm to reduce the number of points needed to show this curve. Or could use the Visvalingam-Whyatt algorithm

function LinePlotNp:PlotData(data: {Vector2})		
	local xMin, xMax, yMin, yMax = InterfaceUtil.GetBounds(data)
	local xDist, yDist = math.abs(xMax - xMin), math.abs(yMax - yMin)
			
	self.Axis.X:UpdateTicks(xMin, xDist)
	self.Axis.Y:UpdateTicks(yMin, yDist)
	
	local prevPoint: Vector2? = nil
		
	for i, point in ipairs(data) do
		local xSN = (math.abs(point.X - xMin) / xDist) * self.PlotScale.X + self.LowerBound.X
		local ySN = (1 - (math.abs(point.Y - yMin) / yDist)) * self.PlotScale.Y + self.LowerBound.Y
						
		local pointOffset = Vector2.new(xSN * self.Frame.AbsoluteSize.X, ySN * self.Frame.AbsoluteSize.Y)
		
		if prevPoint then
			self:_makeLine(i, pointOffset, prevPoint)
		end
		
		prevPoint = pointOffset
	end
	
	self:_reserve(#data + 1)
end

function LinePlotNp:GetSize()
	local frameSize = self.Frame.AbsoluteSize

	return Vector2.new(
		frameSize.X + self.Axis.Y.Frame.AbsoluteSize.X,
		frameSize.Y + self.Axis.X.Frame.AbsoluteSize.Y
	)
end

return LinePlotNp
