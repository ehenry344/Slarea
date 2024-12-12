--!strict

-- Probe Types

export type ServerProbeProto = {
	__index: ServerProbeProto,
	
	new: (name: string, pipe: ServerPipe) -> ServerProbe,
	
	TakeReading: (ServerProbe, value: number) -> (),
}

export type ServerProbe = typeof(setmetatable({} :: {
	_name: string,
	_pipe: ServerPipe,
	
	_updateCooldown: number,
	
	_timestamp: number, 
}, {} :: ServerProbeProto))

-- Pipe Types 

export type ServerPipeProto = {
	__index: ServerPipeProto,
	
	new: (name: string, re: RemoteEvent) -> ServerPipe,
	
	Transmit: (ServerPipe, ProbeDataPacket) -> (),
	TransmitProbeRegistration: (ServerPipe, ProbeRegistrationPacket) -> (),
	SetupDownLink: (ServerPipe, callback: (Player, any)->())->(), 

	_sendPacket: (ServerPipe, PipePacket)->(),
}

export type ServerPipe = typeof(setmetatable({} :: {
	_name: string,
	_re: RemoteEvent
}, {} :: ServerPipeProto))

-- Probe Configuration

export type ProbeConfig = {
	cooldown: number?,
}

-- Slarea Remote Packet

export type ProbeDataPacket = {
	packet_type: "DataPacket",
	payload: {
		data: number,
		timestamp: number,
		probename: string
	}
}

export type ProbeRegistrationPacket = {
	packet_type: "RegisterProbe",
	payload: {
		probename: string,
		timestamp: number
	}
}

export type PipePacket = ProbeDataPacket | ProbeRegistrationPacket

return nil
