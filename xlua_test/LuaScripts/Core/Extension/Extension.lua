------------------------------------------------
--
--	Lua层扩展C#对象的基础方法，操作metatable
--
------------------------------------------------
Extension = function(ctype)
	local meta = xlua.getmetatable(ctype)
	local mt = {}
	for k,v in pairs(meta) do
		mt[k] = v
	end
	mt.__index = function(o, k)
		if mt[k] then
			return mt[k]
		elseif mt[o] and mt[o][k] then
			return mt[o][k]
		else
			return meta.__index(o, k)
		end
	end
	-- 允许给GameObject绑定Lua变量
	if ctype == CS.UnityEngine.GameObject then
		mt.__newindex = function(o, k, v)
			if mt[o] == nil then
				mt[o] = {}
				mt[o][k] = v
				o:addLuaComponent()
			else
				mt[o][k] = v
			end
		end
	end
	xlua.setmetatable(ctype, mt)
	return mt
end