--!strict

-- // Types // 
local Types = require(script.Types)
-- // Services // 
local PlayerService = game:GetService("Players")
-- // Modules // 
local SlareaFrame = require(script.Frame)

local SlareaInterface = {}

function SlareaInterface.init()
	SlareaInterface._objects = {}
	
	SlareaInterface._objects.screenGui = Instance.new("ScreenGui")
	
	SlareaInterface._objects.screenGui.Name = "slareaInterface"
	SlareaInterface._objects.screenGui.Parent = PlayerService.LocalPlayer.PlayerGui
	
	SlareaInterface._objects.frames = {} :: {Types.SlareaFrame}
end

function SlareaInterface.addFrame(): Types.SlareaFrame
	local newFrameId = #SlareaInterface._objects.frames
	
	local newFrame = SlareaFrame.new(newFrameId)
	
	table.insert(SlareaInterface._objects.frames, newFrame)
	
	newFrame:Mount(SlareaInterface._objects.screenGui)
	
	return newFrame
end

return SlareaInterface
