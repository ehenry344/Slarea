--!strict

local InterfaceUtil = {}

function InterfaceUtil.GetBounds(t: {Vector2}): (number, number, number, number) -- fix this later its just for now...
	assert(#t > 0, "Attempted to get the bounds of an empty array")
	
	local v1 = t[1]
	local xMin, xMax, yMin, yMax = t[1].X, t[1].X, t[1].Y, t[1].Y
		
	for i, v: Vector2 in pairs(t) do
		xMin = math.min(xMin, v.X)
		xMax = math.max(xMax, v.X)
		yMin = math.min(yMin, v.Y)
		yMax = math.max(yMax, v.Y)
	end
	
	return xMin, xMax, yMin, yMax
end

function InterfaceUtil.ApplyProps(guiObject: GuiObject, props: {[string]: any})
	for i,v in pairs(props) do 
		guiObject[i] = v
	end
end

return InterfaceUtil
