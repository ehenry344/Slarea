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

local pointTemplate = Instance.new("Frame") do
	pointTemplate.Size = PointConfig.Frame.Size
	pointTemplate.BackgroundColor3 = PointConfig.Frame.BackgroundColor3
	pointTemplate.BorderSizePixel = PointConfig.Frame.BorderSizePixel
	pointTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
end

local lineTemplate = Instance.new("Frame") do
	lineTemplate.BackgroundColor3 = LineConfig.Frame.BackgroundColor3
	lineTemplate.BorderSizePixel = LineConfig.Frame.BorderSizePixel
	lineTemplate.AnchorPoint = Vector2.new(0.5, 0.5)
end

-- // Module //

local LinePlot: Types.LinePlotProto = {} :: Types.LinePlotProto
LinePlot.__index = LinePlot

function LinePlot.new(parent: Types.SlareaFrame)
	local self = {
		Parent = parent,
		Frame = Instance.new("Frame"),
		
		_points = {},
		_lines = {},
		
		_mins = {
			X = PlotConfig.Bounds.Left,
			Y = PlotConfig.Bounds.Bottom
		},
		
		_dists = {
			X = (1 - PlotConfig.Bounds.Right) - PlotConfig.Bounds.Left,
			Y = (1 - PlotConfig.Bounds.Top) - PlotConfig.Bounds.Bottom
		},
	}
	
	self.Frame.Name = "LinePlot"
	
	InterfaceUtil.ApplyProps(self.Frame, PlotConfig.Frame)
	
	self.Frame.Position = UDim2.fromOffset(AxisConfig.Size.Width,0)
	
	-- need a neater version of this in the future
	
	self.Axis = {
		X = Axis.new(self, "Horizontal", PlotConfig.Ticks.Horizontal),
		Y = Axis.new(self, "Vertical", PlotConfig.Ticks.Vertical)
	}
	
	return setmetatable(self, LinePlot)
end

function LinePlot:_makeLine(index: number, f0: Frame, f1:Frame)	
	local lineFrame = self._lines[index-1]
	
	if not lineFrame then
		lineFrame = lineTemplate:Clone()	
		lineFrame.Parent = self.Frame
		
		table.insert(self._lines, lineFrame)
	elseif not lineFrame.Visible then
		lineFrame.Visible = true
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
	local xMin, xMax, yMin, yMax = InterfaceUtil.GetBounds(data)
	local xDist, yDist = abs(xMax - xMin), abs(yMax - yMin)
			
	self.Axis.X:UpdateTicks(xMin, xDist)
	self.Axis.Y:UpdateTicks(yMin, yDist)
	-- draw the points!
	
	-- why is it leaving the first line drawn there???
	
	-- make it so this doesnt use the point frames anymore, and just the lineframesv bv 
		
	for i, point in ipairs(data) do
		local frame = self._points[i]
		
		if not frame then
			frame = pointTemplate:Clone()
			frame.Parent = self.Frame
			
			table.insert(self._points, frame)
		elseif not frame.Visible then
			frame.Visible = true
		end
		
		local xSN = (abs(point.X - xMin) / xDist) * self._dists.X + self._mins.X
		local ySN = (1 - (abs(point.Y - yMin) / yDist)) * self._dists.Y + self._mins.Y
		
		frame.Position = fromScale(xSN, ySN)
		
		if i > 1 then
			self:_makeLine(i, frame, self._points[i-1])
		end
	end
	
	-- make unused frames / lines invisible
	if #data + 1 < #self._points then
		for i = #data + 1, #self._points do
			self._points[i].Visible = false
		end
	end
	
	if #data + 1 < #self._lines then
		for i = #data + 1, #self._lines do
			self._lines[i].Visible = false
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
		frameSize.X + self.Axis.Y.Frame.AbsoluteSize.X,
		frameSize.Y + self.Axis.X.Frame.AbsoluteSize.Y
	)
end

return LinePlot
