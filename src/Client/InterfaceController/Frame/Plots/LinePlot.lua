--!strict

-- // Types //
local Types = require(script.Parent.Parent.Parent.Types)

-- // Utils //
local InterfaceUtil = require(script.Parent.Parent.Parent.Utility)

-- // Config //
local PlotConfig = require(script.Parent.Parent.Parent.Config).Interface.Defaults.Plots.Line
local PointConfig = require(script.Parent.Parent.Parent.Config).Interface.Defaults.PlotComponents.Point
local LineConfig = require(script.Parent.Parent.Parent.Config).Interface.Defaults.PlotComponents.Line

local LinePlot: Types.LinePlotProto = {} :: Types.LinePlotProto
LinePlot.__index = LinePlot

local abs = math.abs
local fromScale = UDim2.fromScale

function LinePlot.new()
	local self = {
		Frame = Instance.new("Frame"),
		_points = {},
		_lines = {}		
	}
	
	self.Frame.Size = PlotConfig.Frame.Size
	self.Frame.BackgroundColor3 = PlotConfig.Frame.BackgroundColor3
		
	return setmetatable(self, LinePlot)
end

function LinePlot:PlotData(data: {Vector2})
	local xMin, xMax, yMin, yMax = InterfaceUtil.GetBounds(data)
	local xDist, yDist = abs(xMax - xMin), abs(yMax - yMin)
	
	-- more optimizations
	
	-- make templates
	
	local tempFrame = Instance.new("Frame")
	
	tempFrame.Size = PointConfig.Frame.Size
	tempFrame.BackgroundColor3 = PointConfig.Frame.BackgroundColor3
	tempFrame.BorderSizePixel = PointConfig.Frame.BorderSizePixel
	
	local tempLine = Instance.new("Frame")
	
	tempLine.BackgroundColor3 = LineConfig.Frame.BackgroundColor3
	tempLine.BorderSizePixel = LineConfig.Frame.BorderSizePixel
		
	-- draw the points!
		
	for i, point in ipairs(data) do
		-- now optimize
		local frame = self._points[i]
		
		if not frame then
			local newFrame = tempFrame:Clone()
			
			newFrame.Parent = self.Frame
			
			table.insert(self._points, newFrame)
			
			frame = newFrame
		end
		
		local xSN = abs(point.X - xMin) / xDist
		local ySN = abs(point.Y - yMin) / yDist
		
		frame.Position = fromScale(xSN, ySN)
	end
end

function LinePlot:ClearPlot()
	local numPoints = #self._points
		
	for i,v in pairs(self._points) do
		v:Destroy()
	end
	
	table.clear(self._points)
end

return LinePlot

