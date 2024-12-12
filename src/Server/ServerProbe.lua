--!strict

local Types = require(script.Parent.Types)

local SlareaServerProbe: Types.ServerProbeProto = {} :: Types.ServerProbeProto
SlareaServerProbe.__index = SlareaServerProbe

function SlareaServerProbe.new(name: string, pipe: Types.ServerPipe, config: Types.ProbeConfig?)
	local self = {
		_name = name,
		_pipe = pipe,
		
		_updateCooldown = config and config.cooldown or 0,
		
		_timestamp = os.clock()
	} 
	
	return setmetatable(self, SlareaServerProbe)
end

function SlareaServerProbe:TakeReading(v: number)
	local currentTime = os.clock()
	
	if currentTime - self._timestamp > self._updateCooldown then
		self._timestamp = currentTime
		
		local packet: Types.ProbeDataPacket = {
			packet_type = "DataPacket",
			payload = {
				data = v,
				probename = self._name,
				timestamp = currentTime
			}
		}
		
		self._pipe:Transmit(packet)
	end
end

return SlareaServerProbe
