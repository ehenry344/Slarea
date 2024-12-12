--!strict

--@class SlareaFrame: Holds the different Slarea plot elements like the plot themselves and the axis, similar to matplotlib Axes

-- // Types //
local Types = require(script.Parent.Types)

-- // Config //
local FrameConfig = require(script.Parent.Config).Interface.Defaults.SlareaFrame

local SlareaFrame: Types.SlareaFrameProto = {} :: Types.SlareaFrameProto
SlareaFrame.__index = SlareaFrame


function SlareaFrame.new(name: string, screenGui: ScreenGui)
	local self = {
		Frame = Instance.new("Frame"), 
		
		_name = name,
		_plots = {},
	}
	
	self.Frame.Name = "SlareaFrame"..name
	self.Frame.AnchorPoint = FrameConfig.Frame.AnchorPoint
	self.Frame.Position = FrameConfig.Frame.Position
	
	self.Frame.Parent = screenGui
	
	return setmetatable(self, SlareaFrame)
end

function SlareaFrame:AddPlot(plot: Types.LinePlot)
	table.insert(self._plots, plot)
	
	plot.Frame.Parent = self.Frame
	
	self:_accommodate()
end

function SlareaFrame:_accommodate() -- resize frame to make room for its constituents + padding	
	for i,plot in pairs(self._plots) do
		self.Frame.Size = UDim2.fromOffset(
			math.max(self.Frame.AbsoluteSize.X, plot.Frame.AbsoluteSize.X + FrameConfig.Plots.Padding.X),
			math.max(self.Frame.AbsoluteSize.Y, plot.Frame.AbsoluteSize.Y + FrameConfig.Plots.Padding.Y) 
		)
	end
end

return SlareaFrame
