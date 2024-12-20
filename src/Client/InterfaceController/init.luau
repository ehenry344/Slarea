--!strict

-- // Types // 
local Types = require(script.Types)
-- // Services // 
local PlayerService = game:GetService("Players")
-- // Modules // 
local SlareaFrame = require(script.Frame)
local LinePlot = require(script.Frame.Plots.LinePlot)
local LinePlotNp = require(script.Frame.Plots.LinePlotNoPoints)

local SlareaInterface = {}

-- create the screengui that everything is mounted onto

local screenGui = Instance.new("ScreenGui")

screenGui.Name = "slareaGUI"
screenGui.Parent = PlayerService.LocalPlayer.PlayerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- holds onto the frames and stuff

local frames: {[string]: Types.SlareaFrame} = {}

function SlareaInterface.CreateProbeOutput(probeName: string)
	local probeFrame = SlareaFrame.new(probeName, screenGui)
	local probePlot = LinePlotNp.new(probeFrame)
	
	probeFrame:AddPlot(probePlot)
	
	frames[probeName] = probeFrame
		
	return function(data)
		local plotData: {Vector2} = {}		

		for i,v in ipairs(data) do
			table.insert(plotData, Vector2.new(v.timestamp, v.data))
		end

		probePlot:PlotData(plotData)
	end
end

return SlareaInterface
