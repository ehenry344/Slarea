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

local abs = math.abs
local fromScale = UDim2.fromScale

-- line element templates

local pointTemplate = Instance.new("Frame")
pointTemplate.Size = PointConfig.Frame.Size
pointTemplate.BackgroundColor3 = PointConfig.Frame.BackgroundColor3
pointTemplate.BorderSizePixel = PointConfig.Frame.BorderSizePixel
pointTemplate.AnchorPoint = Vector2.new(0.5, 0.5)

local lineTemplate = Instance.new("Frame")
lineTemplate.BackgroundColor3 = LineConfig.Frame.BackgroundColor3
lineTemplate.BorderSizePixel = LineConfig.Frame.BorderSizePixel
lineTemplate.AnchorPoint = Vector2.new(0.5, 0.5)

-- // Module //

local LinePlot: Types.LinePlotProto = {} :: Types.LinePlotProto
LinePlot.__index = LinePlot

function LinePlot.new(parent: Types.SlareaFrame)
	local self = {
		Parent = parent,
		Frame = parent:GetPlotFrame(),
		
		_points = {},
		_lines = {},
		
		_frameBounds = {
			Left = PlotConfig.Bounds.Left,
			Right = PlotConfig.Bounds.Right,
			Bottom = PlotConfig.Bounds.Bottom,
			Top = PlotConfig.Bounds.Top
		},
		
		_padding = {
			Left = PlotConfig.Padding.Left,
			Right = PlotConfig.Padding.Right,
			Bottom = PlotConfig.Padding.Bottom,
			Top = PlotConfig.Padding.Top
		}
	}
	
	InterfaceUtil.ApplyProps(self.Frame, PlotConfig.Frame)
	
	self.Frame.Position = UDim2.fromOffset(AxisConfig.Size.Width,0)
	
	self._axis = {
		X = Axis.new(self, "Horizontal", 4, self._padding),
		Y = Axis.new(self, "Vertical", 4, self._padding)
	}

	return setmetatable(self, LinePlot)
end

function LinePlot:_makeLine(index: number, f0: Frame, f1:Frame)
	-- can we reuse a frame?
	local lineFrame = self._lines[index]
	
	if not lineFrame then
		lineFrame = lineTemplate:Clone()	
		lineFrame.Parent = self.Frame
		
		table.insert(self._lines, lineFrame)
	end
		
	-- determine the distance
	local xDist = (f1.AbsolutePosition.X - f0.AbsolutePosition.X)
	local yDist = (f1.AbsolutePosition.Y - f0.AbsolutePosition.Y)
	
	lineFrame.Size = UDim2.new(0, math.sqrt(xDist^2 + yDist^2), 0, 1)
	lineFrame.Rotation = math.deg(math.atan2(yDist, xDist))
	lineFrame.Position = UDim2.fromScale((f1.Position.X.Scale + f0.Position.X.Scale) / 2, (f1.Position.Y.Scale + f0.Position.Y.Scale) / 2)
end

-- eventually get it to where it can identify points that aren't needed and just put a line between the start and end  them in order to save on the number of frames being drawn

-- basically find a series of points with no slope and put straight lines through them (Will require graph to lag behind a bit in order to process these, but will save on runtime)

function LinePlot:PlotData(data: {Vector2})
	local xBoundMin = self._frameBounds.Left + self._padding.Left
	local yBoundMin = self._frameBounds.Bottom + self._padding.Bottom
	
	local xBoundDist = (1 - (self._frameBounds.Right + self._padding.Right)) - xBoundMin
	local yBoundDist = (1 - (self._frameBounds.Top + self._padding.Top)) - yBoundMin
	
	local xMin, xMax, yMin, yMax = InterfaceUtil.GetBounds(data)
	local xDist, yDist = abs(xMax - xMin), abs(yMax - yMin)
	-- draw the points!
		
	for i, point in ipairs(data) do
		-- now optimize
		local frame = self._points[i]
		
		if not frame then
			frame = pointTemplate:Clone()
			frame.Parent = self.Frame
			
			table.insert(self._points, frame)
		end
		
		local xSN = (abs(point.X - xMin) / xDist) * xBoundDist + xBoundMin
		local ySN = (abs(point.Y - yMin) / yDist) * yBoundDist + yBoundMin
		
		frame.Position = fromScale(xSN, ySN)
		
		if i > 1 then
			self:_makeLine(i, frame, self._points[i-1])
		end
	end
end

function LinePlot:ClearPlot()
	local numPoints = #self._points
		
	for i,v in pairs(self._points) do
		v:Destroy()
	end
	
	table.clear(self._points)
end

function LinePlot:GetSize()
	local frameSize = self.Frame.AbsoluteSize

	return Vector2.new(
		frameSize.X + self._axis.Y.Frame.AbsoluteSize.X,
		frameSize.Y + self._axis.X.Frame.AbsoluteSize.Y
	)
end

return LinePlot
