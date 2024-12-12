--!strict

-- // Types // 
local Types = require(script.Types)
-- // Services // 
local PlayerService = game:GetService("Players")
-- // Modules // 
local SlareaFrame = require(script.Frame)
local LinePlot = require(script.Frame.Plots.LinePlot)

local SlareaInterface = {}

-- create the screengui that everything is mounted onto

local screenGui = Instance.new("ScreenGui")

screenGui.Name = "slareaGUI"
screenGui.Parent = PlayerService.LocalPlayer.PlayerGui

-- holds onto the frames and stuff

local frames: {[string]: Types.SlareaFrame} = {}

function SlareaInterface.CreateProbeOutput(probeName: string)
	local probeFrame = SlareaFrame.new(probeName, screenGui)
	local probePlot = LinePlot.new()
	
	probeFrame:AddPlot(probePlot)
	
	frames[probeName] = probeFrame
	
	return function(data)
		local plotData: {Vector2} = {}
		
		print("RUNNING")
		

		for i,v in ipairs(data) do
			table.insert(plotData, Vector2.new(v.timestamp, v.data))
		end

		probePlot:PlotData(plotData)
	end
end

return SlareaInterface
