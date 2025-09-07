--!strict

-- // Types //
local Types = require(script.Parent.Parent.Parent.Types)

-- // Config //
local AxisConfig = require(script.Parent.Parent.Parent.Config).Interface.Defaults.PlotElements.Axis

local ROUND_CONST = math.pow(10, AxisConfig.TickLabels.Constants.RoundingPrecision)

-- // Utility //
local Axis: Types.AxisProto = {} :: Types.AxisProto
Axis.__index = Axis

-- axis will get mounted to a frame and be positioned beside the frame for the plot

function Axis.new(plot: Types.Plot, orientation: string, ticks: number)
	local self = setmetatable({
		Parent = plot,
		Frame = Instance.new("Frame"),
		
		_ticks = {},
		_tickLabels = {},
		
		_gridLines = {},
		
		_orientation = orientation :: Types.AxisOrientation,
		_numTicks = ticks, 		
	}, Axis)
	
	if self._orientation == "Horizontal" then
		self:_setupHorizontal()
	else
		self:_setupVertical()
	end
	
	self.Frame.BackgroundTransparency = AxisConfig.Frame.BackgroundTransparency	
	self.Frame.Parent = self.Parent.Parent.Frame -- the slareaframe its added to
	
	return self
end

function Axis:_setupHorizontal() -- setup x axis
	local ticks = self._numTicks - 1
	
	self.Frame.Size = UDim2.fromOffset(self.Parent.Frame.AbsoluteSize.X, AxisConfig.Size.Height)
	self.Frame.Position = UDim2.fromOffset(self.Parent.Frame.Position.X.Offset, self.Parent.Frame.AbsoluteSize.Y + self.Parent.Frame.Position.Y.Offset) 
	self.Frame.Name = "XAxis"

	-- make templates
	local tickTemp = Instance.new("Frame")

	tickTemp.BorderSizePixel = AxisConfig.Ticks.Frame.BorderSizePixel
	tickTemp.BackgroundColor3 = AxisConfig.Ticks.Frame.BackgroundColor3
	tickTemp.Size = AxisConfig.Ticks.Size.Horizontal
	tickTemp.AnchorPoint = Vector2.new(0.5, 0)

	local tickLabelTemp = Instance.new("TextLabel")

	tickLabelTemp.Size = UDim2.fromOffset(15, 15)
	tickLabelTemp.AnchorPoint = Vector2.new(0.5, 0)
	tickLabelTemp.BackgroundTransparency = 1
	tickLabelTemp.TextColor3 = Color3.fromRGB(255, 255, 255)
	tickLabelTemp.Text = ""

	local gridLineTemp = Instance.new("Frame")

	gridLineTemp.BorderSizePixel = AxisConfig.GridLines.Frame.BorderSizePixel
	gridLineTemp.BackgroundColor3 = AxisConfig.GridLines.Frame.BackgroundColor3		
	gridLineTemp.AnchorPoint = Vector2.new(0.5, 0)
	gridLineTemp.Size = UDim2.new(0, tickTemp.Size.X.Offset / 2, 1)

	-- clone temps and place elems

	for i = 0, ticks do
		local instanceNumber = tostring(i + 1)

		local xPosScale = (i / ticks) * self.Parent.PlotScale.X + self.Parent.LowerBound.X

		-- make ticks
		local tickFrame = tickTemp:Clone()

		tickFrame.Name = "XTick"..instanceNumber
		tickFrame.Position = UDim2.fromScale(xPosScale, 0)
		tickFrame.Parent = self.Frame

		table.insert(self._ticks, tickFrame)

		-- make ticklabel

		local tickLabel = tickLabelTemp:Clone()

		tickLabel.Name = "XTickLabel"..instanceNumber
		tickLabel.Position = UDim2.new(xPosScale, 0, 0, tickFrame.AbsoluteSize.Y)
		tickLabel.Parent = self.Frame

		table.insert(self._tickLabels, tickLabel)

		-- make gridline

		local gridLine = gridLineTemp:Clone()

		gridLine.Name = "XGridLine"..instanceNumber
		gridLine.Position = UDim2.fromScale(xPosScale, 0)
		gridLine.Parent = self.Parent.GridLineFrame

		table.insert(self._gridLines, gridLine)
	end
end

function Axis:_setupVertical() -- setup the y axis
	local ticks = self._numTicks - 1
	
	self.Frame.Size = UDim2.fromOffset(AxisConfig.Size.Width, self.Parent.Frame.AbsoluteSize.Y)
	self.Frame.Position = UDim2.fromOffset(self.Parent.Frame.Position.X.Offset - self.Frame.AbsoluteSize.X, self.Parent.Frame.Position.Y.Offset)
	self.Frame.Name = "YAxis"
	
	local tickTemp = Instance.new("Frame")

	tickTemp.BorderSizePixel = AxisConfig.Ticks.Frame.BorderSizePixel
	tickTemp.BackgroundColor3 = AxisConfig.Ticks.Frame.BackgroundColor3
	tickTemp.Size =  AxisConfig.Ticks.Size.Vertical
	tickTemp.AnchorPoint = Vector2.new(1, 0.5)

	local tickLabelTemp = Instance.new("TextLabel")

	tickLabelTemp.Size = UDim2.fromOffset(15, 15)
	tickLabelTemp.AnchorPoint = Vector2.new(0, 0.5)
	tickLabelTemp.BackgroundTransparency = 1
	tickLabelTemp.TextColor3 = Color3.fromRGB(255, 255, 255)
	tickLabelTemp.Text = ""

	local gridLineTemp = Instance.new("Frame")

	gridLineTemp.BorderSizePixel = AxisConfig.GridLines.Frame.BorderSizePixel
	gridLineTemp.BackgroundColor3 = AxisConfig.GridLines.Frame.BackgroundColor3		
	gridLineTemp.AnchorPoint = Vector2.new(0, 0.5)
	gridLineTemp.Size = UDim2.new(1, 0, 0, tickTemp.Size.Y.Offset / 2)
	
	for i = 0, ticks do
		local instanceNumber = tostring(i + 1)
		local yPosScale = (i / ticks) * self.Parent.PlotScale.Y + self.Parent.LowerBound.Y
		
		local tickFrame = tickTemp:Clone()
	
		tickFrame.Name = "YTick"..instanceNumber
		tickFrame.Position = UDim2.fromScale(1, 1 - yPosScale)
		tickFrame.Parent = self.Frame

		table.insert(self._ticks, tickFrame)

		local tickLabel = tickLabelTemp:Clone()

		tickLabel.Name = "YTickLabel"..instanceNumber
		tickLabel.Position = UDim2.new(0, (self.Frame.AbsoluteSize.X - tickFrame.AbsoluteSize.X) - 30, 1 - yPosScale)
		tickLabel.Parent = self.Frame

		table.insert(self._tickLabels, tickLabel)

		local gridLine = gridLineTemp:Clone()

		gridLine.Name = "YGridLine"..instanceNumber
		gridLine.Position = UDim2.fromScale(0, 1 - yPosScale)
		gridLine.Parent = self.Parent.GridLineFrame

		table.insert(self._gridLines, gridLine)
	end
end

function Axis:UpdateTicks(min, dist)
	local scaleValue = dist / (self._numTicks - 1)

	for i = 1, self._numTicks do
		local tickLabel = self._tickLabels[i]
		
		local roundedValue = math.round((scaleValue * (i - 1)) * ROUND_CONST) / ROUND_CONST
		tickLabel.Text = tostring(roundedValue)
	end
end


return Axis
