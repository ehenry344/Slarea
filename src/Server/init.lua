--!strict

-- // Services //
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- // Dependencies //
local SlareaServerProbe = require(script.ServerProbe)
local SlareaServerPipe = require(script.ServerPipe)

local ServerMonitor = {}

local registry = {
	probes = {}
}

-- build the remote event for the library

local SlareaRemote = Instance.new("RemoteEvent")

SlareaRemote.Name = "SlareaEngineLink"
SlareaRemote.Parent = ReplicatedStorage

local ServerPipe = SlareaServerPipe.new("ServerPipe", SlareaRemote)

ServerPipe:SetupDownLink(function(player: Player, data)
	if data.packet_type == "SetupLink" then
		print("Poked by " .. player.UserId)
		
		for name, probe in pairs(registry.probes) do
			ServerPipe:TransmitProbeRegistration({
				packet_type = "RegisterProbe",
				payload = {
					probename = name,
					timestamp = os.clock()
				}
			})
		end	
	end
end)

function ServerMonitor.RegisterProbe(name: string)
	if not registry.probes[name] then
		registry.probes[name] = SlareaServerProbe.new(name, ServerPipe)
		
		-- inform authorized clients of the probe
				
		ServerPipe:TransmitProbeRegistration({
			packet_type = "RegisterProbe",
			payload = {
				probename = name,
				timestamp = os.clock()
			}
		})
		
		return registry.probes[name]
	else
		error("Attempted to use same probe identifier twice")
	end
end

return ServerMonitor
