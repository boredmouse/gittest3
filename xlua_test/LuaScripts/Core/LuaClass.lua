-- @Author: ang
-- @Date:   2019-04-10 17:49:32
-- @Last Modified by:   Jax
-- @Last Modified time: 2020-04-26 18:27:08


--lua文件访问入口
-- LuaClass={}
-- 加载文件列表
require "Core.LuaClassList"

local function initLuaClass()
	local metaTable={}
	metaTable.__index = function(t,key)
		local keyLow = string.lower(key)
		if LuaClassList[keyLow] == nil then
			error("Error: No Lua Script:" .. key)
			return nil
		end
		t[key] = require(LuaClassList[keyLow])
		return t[key]
	end
	setmetatable(LuaClass, metaTable)
end

--需要提前require的全局模块(单例请在App.lua中定义)
local function preLoadClass()
	local temp
	local preLoadClassNameArr = {
		-- "Timer",
		-- "Coroutine",
		-- "LuaComponentNodeEx",
		-- "SpineAnimation",
		-- "PbInit"
	}
	for _, name in ipairs(preLoadClassNameArr) do
		temp = LuaClass[name]
	end
end


-- 执行初始化函数
initLuaClass()

-- 加载初始模块
preLoadClass()