--!strict

-- // Types //
local Types = require(script.Parent.Parent.Parent.Types)

-- // Utils //
local InterfaceUtil = require(script.Parent.Parent.Parent.Utility)

-- // Dependencies //
local Axis = require(script.Parent.Parent.FrameElements.Axis)
local Label = require(script.Parent.Parent.FrameElements.Label)

-- // Config //
local Config = require(script.Parent.Parent.Parent.Config)

local PlotConfig = Config.Interface.Defaults.Plots.Line
local AxisConfig = Config.Interface.Defaults.PlotElements.Axis
local LineConfig = Config.Interface.Defaults.PlotComponents.Line

-- // Module //

local LinePlot: Types.LinePlotProto = {} :: Types.LinePlotProto
LinePlot.__index = LinePlot

-- when a label is added to a plot it should push the plot down

function LinePlot.new(parent: Types.SlareaFrame, headerText: string?)
	local self = {
		Parent = parent,
		
		Frame = Instance.new("Frame"),
		GridLineFrame = Instance.new("Frame"),
		Path2D = Instance.new("Path2D"),
		
		LowerBound = {
			X = PlotConfig.Bounds.Left,
			Y = PlotConfig.Bounds.Bottom
		},
		
		PlotScale = {
			X = (1 - PlotConfig.Bounds.Right) - PlotConfig.Bounds.Left,
			Y = (1 - PlotConfig.Bounds.Top) - PlotConfig.Bounds.Bottom
		},
	}
	
	self.Frame.Name = "LinePlot"
	self.Frame.Position = UDim2.fromOffset(AxisConfig.Size.Width,0)
	self.Frame.Size = PlotConfig.Frame.Size
	self.Frame.BackgroundColor3 = PlotConfig.Frame.BackgroundColor3
	self.Frame.BorderSizePixel = PlotConfig.Frame.BorderSizePixel
	self.Frame.BorderColor3 = PlotConfig.Frame.BorderColor3
	
	self.Frame.Parent = self.Parent.Frame
	
	self.GridLineFrame.Name = "GridLines"
	self.GridLineFrame.Size = UDim2.fromScale(1, 1)
	self.GridLineFrame.BackgroundTransparency = 1
	self.GridLineFrame.BorderSizePixel = 0
	
	self.GridLineFrame.Parent = self.Frame
	

	if headerText then
		self.Header = Label.newPlotLabel(self, headerText)
		
		self.Frame.Position = UDim2.fromOffset(self.Frame.Position.X.Offset, self.Header:GetSize().Y)
	end
	
	-- need a neater version of this in the future
	
	self.Axis = {
		X = Axis.new(self, "Horizontal", PlotConfig.Ticks.Horizontal),
		Y = Axis.new(self, "Vertical", PlotConfig.Ticks.Vertical)
	}
	
	self.Path2D.Parent = self.Frame
	self.Path2D.ZIndex = self.Path2D.ZIndex + 1
	self.Path2D.Color3 = LineConfig.BackgroundColor3

	return setmetatable(self, LinePlot)
end

function LinePlot:PlotData(data: {Vector2})		
	local xMin, xMax, yMin, yMax = InterfaceUtil.GetBounds(data)
	local xDist, yDist = math.abs(xMax - xMin), math.abs(yMax - yMin)
			
	self.Axis.X:UpdateTicks(xMin, xDist)
	self.Axis.Y:UpdateTicks(yMin, yDist) 
	
	local controlPoints = table.create(#data)
	
	for pathIndex, point in ipairs(data) do
		local xSN = (math.abs(point.X - xMin) / xDist) * self.PlotScale.X + self.LowerBound.X
		local ySN = (1 - (math.abs(point.Y - yMin) / yDist)) * self.PlotScale.Y + self. LowerBound.Y
						
		local pointOffset = UDim2.fromOffset(xSN * self.Frame.AbsoluteSize.X, ySN * self.Frame.AbsoluteSize.Y) 

		controlPoints[pathIndex] = Path2DControlPoint.new(pointOffset)
	end

	self.Path2D:SetControlPoints(controlPoints)
end

function LinePlot:GetSize()
	local frameSize = self.Frame.AbsoluteSize
	local headerSize = self.Header and self.Header:GetSize() or Vector2.new(0, 0)

	return Vector2.new(
		frameSize.X + self.Axis.Y.Frame.AbsoluteSize.X,
		frameSize.Y + self.Axis.X.Frame.AbsoluteSize.Y + headerSize.Y 
	)
end

return LinePlot
