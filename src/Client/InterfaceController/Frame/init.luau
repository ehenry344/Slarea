--!strict

--@class SlareaFrame: Holds the different Slarea plot elements like the plot themselves and the axis, similar to matplotlib Axes

-- // Types //
local Types = require(script.Parent.Types)

-- // Config //
local FrameConfig = require(script.Parent.Config).Interface.Defaults.SlareaFrame

-- Utility //
local InterfaceUtil = require(script.Parent.Utility)

local SlareaFrame: Types.SlareaFrameProto = {} :: Types.SlareaFrameProto
SlareaFrame.__index = SlareaFrame


function SlareaFrame.new(name: string, screenGui: ScreenGui)
	local self = {
		Frame = Instance.new("Frame"), 
	
		_name = name,
		
		_plotFrame = nil,
		_plots = {},
		
		-- hold the plotframe in here, since the plots are just things that get added and put points on the frame they are given
	}
		
	self.Frame.AnchorPoint = FrameConfig.Frame.AnchorPoint
	self.Frame.Position = FrameConfig.Frame.Position
	self.Frame.BorderSizePixel = FrameConfig.Frame.BorderSizePixel
	self.Frame.BackgroundTransparency = FrameConfig.Frame.BackgroundTransparency
	self.Frame.Name = "SlareaFrame"..name
	
	self.Frame.Parent = screenGui
	
	-- make it draggable
	
	local dragDetector = Instance.new("UIDragDetector")
	dragDetector.BoundingBehavior = Enum.UIDragDetectorBoundingBehavior.EntireObject
	dragDetector.BoundingUI = screenGui
	dragDetector.Parent = self.Frame

	return setmetatable(self, SlareaFrame)
end

function SlareaFrame:AddPlot(plot: Types.Plot)
	table.insert(self._plots, plot)
		
	self:_accommodate()
end

function SlareaFrame:_accommodate() -- resize frame to make room for its constituents + padding	
	for i,v in pairs(self._plots) do
		local plotSize = v:GetSize()
		
		self.Frame.Size = UDim2.fromOffset(
			math.max(self.Frame.AbsoluteSize.X, plotSize.X + FrameConfig.Plots.Margin.X),
			math.max(self.Frame.AbsoluteSize.Y, plotSize.Y, FrameConfig.Plots.Margin.Y)
		)
	end
end

return SlareaFrame
