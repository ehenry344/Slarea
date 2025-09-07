--!strict

-- // Types //
local Types = require(script.Parent.Parent.Parent.Types)

-- Generic label class for things like axis labels and headers for plots

local Label: Types.LabelProto = {} :: Types.LabelProto
Label.__index = Label

function Label.newPlotLabel(parent: Types.Plot, text: string)
	local self = setmetatable({
		Parent = parent,
		
		_textLabel = Instance.new("TextLabel")
	}, Label)
	
	self._textLabel.Size = UDim2.fromOffset(self.Parent.Frame.AbsoluteSize.X, 30)
	self._textLabel.BackgroundTransparency = 1
	self._textLabel.BorderSizePixel = 0
	self._textLabel.Text = text
	self._textLabel.Name = "Header"
	self._textLabel.Position = UDim2.fromOffset(self.Parent.Frame.Position.X.Offset, 0)
	self._textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	
	self._textLabel.Parent = self.Parent.Parent.Frame

	return self
end

function Label.newAxisLabel(parent: Types.Axis, text: string)
	local self = setmetatable({
		Parent = parent,
		_textLabel = Instance.new("TextLabel")
	}, Label)
	
	return self
end

function Label:GetSize()
	return self._textLabel.AbsoluteSize
end

return Label
