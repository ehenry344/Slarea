--!strict

-- // Types //
local Types = require(script.Parent.Parent.Parent.Types)

-- // Config //
local AxisConfig = require(script.Parent.Parent.Parent.Config).Interface.Defaults.PlotElements.Axis

-- // Utility //
local InterfaceUtil = require(script.Parent.Parent.Parent.Utility)

local Axis: Types.AxisProto = {} :: Types.AxisProto
Axis.__index = Axis

-- axis will get mounted to a frame and be positioned beside the frame for the plot

function Axis.new(plot: Types.Plot, orientation: string, ticks: number, padding: Types.BoxSpacing)
	local self = {
		Parent = plot,
		Frame = Instance.new("Frame"),
		
		_ticks = {},
		
		_orientation = orientation :: Types.AxisOrientation,
		_numTicks = ticks, 		
	}
	
	if self._orientation == "Horizontal" then
		self.Frame.Size = UDim2.fromOffset(
			self.Parent.Frame.AbsoluteSize.X,
			AxisConfig.Size.Height
		)
			
		self.Frame.Position = UDim2.fromOffset(
			self.Parent.Frame.Position.X.Offset,
			self.Parent.Frame.AbsoluteSize.Y
		)
		
		-- make the ticks
		for i = 1, self._numTicks do
			local tickFrame = Instance.new("Frame")
			
			
		end
	else
		self.Frame.Size = UDim2.fromOffset(
			AxisConfig.Size.Width,
			self.Parent.Frame.AbsoluteSize.Y
		)
		
		self.Frame.Position = UDim2.fromOffset(
			self.Parent.Frame.Position.X.Offset - self.Frame.AbsoluteSize.X, -- don't want to go through the position i just set
			self.Parent.Frame.Position.Y.Offset
		)
		
	end
	
	InterfaceUtil.ApplyProps(self.Frame, AxisConfig.Frame)
	
	self.Frame.Parent = self.Parent.Parent.Frame -- the slareaframe its added to
	
	return setmetatable(self, Axis)
end

function Axis:UpdateTicks(min, max)
	local dist = math.abs(min - max)
	
	for tickValue = min, max, dist / self._numTicks do
		
	end
end


return Axis
