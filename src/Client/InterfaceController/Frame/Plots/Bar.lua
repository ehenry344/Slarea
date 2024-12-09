--!strict 

-- // Types //
local Types = require(script.Parent.Parent.Parent.Types)
-- // Config //

local ScatterConfig = require(script.Parent.Parent.Parent.Parent.Config).Interface.Defaults.Plots.Bar

-- // Dependencies //
local Bar = require(script.Parent.Parent.PlotElements.Bar)

local BarPlot: Types.BarPlotProto = {} :: Types.BarPlotProto
BarPlot.__index = BarPlot

function BarPlot.new(frame: Frame)
	local self = {
		_frame = frame, 
		_bars = {}
	}

	return setmetatable(self, BarPlot)
end



return BarPlot
