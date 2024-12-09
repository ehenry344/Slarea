--!strict

--@class SlareaFrame: Holds the different Slarea plot elements like the plot themselves and the axis, similar to matplotlib Axes

-- // Types //
local Types = require(script.Parent.Types)

-- // Config //
local FrameConfig = require(script.Parent.Parent.Config).Interface.Defaults.SlareaFrame

local SlareaFrame: Types.SlareaFrameProto = {} :: Types.SlareaFrameProto
SlareaFrame.__index = SlareaFrame


function SlareaFrame.new(frameId: number)
	local self = {
		_frame = Instance.new("Frame"), 
		_frameId = frameId,
		
		_plots = {},
		
	}
	
	self._frame.Name = "slareaFrame"..tostring(frameId)
	-- size of SlareaFrame is based on accomodating the elements inside of the plot aswell as the padding and things like that
	self._frame.AnchorPoint = FrameConfig.Frame.AnchorPoint
	self._frame.Position = FrameConfig.Frame.Position
	
	return setmetatable(self, SlareaFrame)
end

function SlareaFrame:Mount(screenGui: ScreenGui)
	self._frame.Parent = screenGui
end

function SlareaFrame:_accommodate() -- resize frame to make room for its constituents + padding
	
end






return SlareaFrame
