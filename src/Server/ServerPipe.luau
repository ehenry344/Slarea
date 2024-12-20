--!strict

-- // Services //
local PlayerService = game:GetService("Players")
-- // Types //
local Types = require(script.Parent.Types)
-- // Config //
local Config = require(script.Parent.Config)

local ServerPipe: Types.ServerPipeProto = {} :: Types.ServerPipeProto
ServerPipe.__index = ServerPipe

function ServerPipe.new(name: string, re: RemoteEvent): Types.ServerPipe
	local self = {
		_name = name,
		_re = re
	}
	
	return setmetatable(self, ServerPipe)
end

function ServerPipe:_sendPacket(packet: Types.PipePacket)
	local clients = Config.RegisteredClients
	
	for _, client in PlayerService:GetPlayers() do
		if clients[client.UserId] then
			self._re:FireClient(client, packet)
		end
	end
end

function ServerPipe:TransmitProbeRegistration(regPacket: Types.ProbeRegistrationPacket)
	self:_sendPacket(regPacket)
end

function ServerPipe:Transmit(value: Types.ProbeDataPacket)
	self:_sendPacket(value)
end

-- deals with the registration request packets sent by clients
function ServerPipe:SetupDownLink(callback: (Player, any)->())
	self._re.OnServerEvent:Connect(function(sender, data)
		if Config.RegisteredClients[sender.UserId] then
			callback(sender, data) 
		end
	end)
end


return ServerPipe
