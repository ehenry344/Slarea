--!strict 

-- // Types //
local Types = require(script.Parent.Parent.Parent.Types)
-- // Config //
local ScatterConfig = require(script.Parent.Parent.Parent.Parent.Config).Interface.Defaults.Plots.Scatter
-- // Dependencies //

local ScatterPlot: Types.ScatterPlotProto = {} :: Types.ScatterPlotProto
ScatterPlot.__index = ScatterPlot

function ScatterPlot.new(frame: Frame)
	local self = {
		_frame = frame,
		_points = {}
	}
	
	self._frame.Size = ScatterConfig.Frame.Size
	
	return setmetatable(self, ScatterPlot)
end

return ScatterPlot
