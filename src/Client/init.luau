--!strict

-- // Services //
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Dependencies //
local ClientProbe = require(script.ClientProbe)
local ClientStream = require(script.ClientStream)

-- // Types Module //
local Types = require(script.Types)

-- TEST DEPENDENCY
local InterfaceController = require(script.InterfaceController)

-- // Remotes //
local SlareaLink: RemoteEvent = ReplicatedStorage:WaitForChild("SlareaEngineLink")

local ClientMonitor = {}

local registry = {
	clientStreams = {} :: {[string]: Types.ClientStream},
	serverStreams = {} :: {[string]: Types.ClientStream}
}

function ClientMonitor.RegisterProbe(probeName: string)
	if not registry.clientStreams[probeName] then
		local probeStream = ClientStream.new(
			probeName,
			InterfaceController.CreateProbeOutput(probeName)
		)
		local newProbe = ClientProbe.new(probeName, probeStream)
		
		registry.clientStreams[probeName] = probeStream
		
		return newProbe
	else
		error("Attempted to use same probe identifier twice")
	end
end

SlareaLink.OnClientEvent:Connect(function(data)	
	if data.packet_type == "RegisterProbe" then
		local probeName = data.payload.probename
		
		if not registry.serverStreams[probeName] then
			local stream = ClientStream.new(
				"Serverprobe_"..probeName.."_Stream", 
				InterfaceController.CreateProbeOutput(probeName)
			)
			
			registry.serverStreams[probeName] = stream
		end
	elseif data.packet_type == "DataPacket" then
		local stream = registry.serverStreams[data.payload.probename]
				
		if stream then
			stream:WriteData({data = data.payload.data, timestamp = data.payload.timestamp})
		end
	end
end)

-- poke network to get the link setup
SlareaLink:FireServer({packet_type = "SetupLink"})

return ClientMonitor
