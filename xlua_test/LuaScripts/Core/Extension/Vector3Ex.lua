------------------------------------------------
--
--	Lua层扩展Vector3
--
------------------------------------------------
local LuaClass = LuaClass
local super = CS.UnityEngine.Vector3
---@type UnityEngine.Vector3
local Vector3Ex = {}
---@type UnityEngine.Vector3
Vector3Ex.tempVector1 = CS.UnityEngine.Vector3()
---@type UnityEngine.Vector3
Vector3Ex.tempVector2 = CS.UnityEngine.Vector3()
---@type UnityEngine.Vector3
Vector3Ex.tempVector3 = CS.UnityEngine.Vector3()
---@type UnityEngine.Vector3
Vector3Ex.tempVector4 = CS.UnityEngine.Vector3()

local _index = super.__index
local _newindex = super.__newindex

local get_x, set_x = xlua.genaccessor(0, 8)
local get_y, set_y = xlua.genaccessor(4, 8)
local get_z, set_z = xlua.genaccessor(8, 8)

local fields_getters = {
    x = get_x, y = get_y, z = get_z
}
local fields_setters = {
    x = set_x, y = set_y, z = set_z
}

Vector3Ex.__index = function(o, k)
	if fields_getters[k] then
		return fields_getters[k](o)
	end
	local result = rawget(o, k)
	if result ~= nil then
		return result
	end
	return _index(o, k)
end

Vector3Ex.__newindex = function(o, k, v)
	if fields_setters[k] then
		return fields_setters[k](o, v)
	end
	return _newindex(o, k, v)
end

Vector3Ex.__add = function(a, b)
	return LuaClass.Vector3(a.x + b.x, a.y + b.y, a.z + b.z)
end

Vector3Ex.__sub = function(a, b)
	return LuaClass.Vector3(a.x - b.x, a.y - b.y, a.z - b.z)
end

Vector3Ex.__tostring = function(o)
    return string.format('[%.2f, %.2f, %.2f]', o.x, o.y, o.z)
end

---@type ObjectPool 避免频繁创建
local _pool
---@return UnityEngine.Vector3
function Vector3Ex.pop()
	if not _pool then
		_pool = LuaClass.ObjectPool(
				function()
					return LuaClass.Vector3()
				end,
				function(obj)
					obj:Set(0,0)
				end
		)
	end
	return _pool:get()
end

Vector3Ex.push = function(value)
	if not _pool then
		_pool = LuaClass.ObjectPool(function() return LuaClass.Vector3() end)
	end
	_pool:add(value)
end

Vector3Ex.__index = Vector3Ex
setmetatable(Vector3Ex, getmetatable(super))

LuaClass.Vector3 = Vector3Ex

return Vector3Ex