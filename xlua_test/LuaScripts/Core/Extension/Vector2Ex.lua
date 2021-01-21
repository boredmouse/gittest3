------------------------------------------------
--
--	Lua层扩展Vector2
--
------------------------------------------------

local LuaClass = LuaClass
local super = CS.UnityEngine.Vector2
---@type UnityEngine.Vector2
local Vector2Ex = {}

---@type UnityEngine.Vector2
Vector2Ex.tempVector1 = CS.UnityEngine.Vector2()
---@type UnityEngine.Vector2
Vector2Ex.tempVector2 = CS.UnityEngine.Vector2()
---@type UnityEngine.Vector2
Vector2Ex.tempVector2 = CS.UnityEngine.Vector2()
---@type UnityEngine.Vector2
Vector2Ex.tempVector4 = CS.UnityEngine.Vector2()

local _index = super.__index
local _newindex = super.__newindex

local get_x, set_x = xlua.genaccessor(0, 8)
local get_y, set_y = xlua.genaccessor(4, 8)

local fields_getters = {
    x = get_x, y = get_y
}
local fields_setters = {
    x = set_x, y = set_y
}

Vector2Ex.__index = function(o, k)
	if fields_getters[k] then
		return fields_getters[k](o)
	end
	local result = rawget(o, k)
	if result ~= nil then
		return result
	end
	return _index(o, k)
end

Vector2Ex.__newindex = function(o, k, v)
	if fields_setters[k] then
		return fields_setters[k](o, v)
	end
	return _newindex(o, k, v)
end

Vector2Ex.__add = function(a, b)
	return LuaClass.Vector2(a.x + b.x, a.y + b.y)
end

Vector2Ex.__sub = function(a, b)
	return LuaClass.Vector2(a.x - b.x, a.y - b.y)
end

Vector2Ex.__tostring = function(o)
    return string.format('[%.2f, %.2f]', o.x, o.y)
end

---@type ObjectPool 避免频繁创建
local _pool
---@return UnityEngine.Vector2
function Vector2Ex.pop()
	if not _pool then
		_pool = LuaClass.ObjectPool(
				function()
					return LuaClass.Vector2()
				end,
				function(obj)
					obj:Set(0,0)
				end
		)
	end
	return _pool:get()
end

Vector2Ex.push = function(value)
	if not _pool then
		_pool = LuaClass.ObjectPool(function() return LuaClass.Vector2() end)
	end
	_pool:add(value)
end

Vector2Ex.__index = Vector2Ex
setmetatable(Vector2Ex, getmetatable(super))

LuaClass.Vector2 = Vector2Ex

return Vector2Ex