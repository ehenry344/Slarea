--!strict

-- // Types //
local Types = require(script.Parent.Types)

local ClientStream: Types.ClientStreamProto = {} :: Types.ClientStreamProto
ClientStream.__index = ClientStream

function ClientStream.new(name: string, callback: (any)->(), expireTime: number?)
	local self = {
		_name = name,
		_rawData = {},
		_callback = callback,
		_expirationTime = expireTime or 60
	}

	return setmetatable(self, ClientStream)
end

function ClientStream:_flushExpired()
	local currentTimestamp = self._rawData[#self._rawData].timestamp
	
	for i,v in ipairs(self._rawData) do
		if currentTimestamp - v.timestamp >= self._expirationTime then
			table.remove(self._rawData, i)
		end
	end
end

function ClientStream:WriteData(data: any)
	table.insert(self._rawData, data)
	
	self:_flushExpired()
	
	self._callback(self._rawData)
end

return ClientStream
