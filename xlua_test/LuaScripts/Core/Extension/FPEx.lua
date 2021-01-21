--------------------------------------------
-- Author: Jax
-- Date: 2020/9/11 12:04
-- Desc: 
---------------------------------------------
local LuaClass = LuaClass
local super = CS.TrueSync.FP
---@type TrueSync.FP
local FPEx = {}

FPEx.FP_100 = LuaClass.FP(100)
FPEx.FP_1000 = LuaClass.FP(1000)
FPEx.FP_10000 = LuaClass.FP(10000)
FPEx.FP_90 = LuaClass.FP(90)
FPEx.FP_180 = LuaClass.FP(180)
FPEx.FP_270 = LuaClass.FP(270)
FPEx.FP_360 = LuaClass.FP(360)

--- -90
FPEx.FP_negative_90 = LuaClass.FP(-90)
FPEx.FP_negative_180 = LuaClass.FP(-180)
FPEx.FP_negative_360 = LuaClass.FP(-360)
FPEx.FP_negative_1 = LuaClass.FP(-1)

FPEx.tempFP1 = LuaClass.FP(0)
FPEx.tempFP2 = LuaClass.FP(0)
FPEx.tempFP3 = LuaClass.FP(0)
FPEx.tempFP4 = LuaClass.FP(0)

---@type ObjectPool 避免频繁创建
local _pool
---@return TrueSync.FP
function FPEx.pop()
    if not _pool then
        _pool = LuaClass.ObjectPool(
                function()
                    return LuaClass.FP()
                end,
                function(obj)
                    obj:Set(0)
                end
        )
    end
    return _pool:get()
end

FPEx.push = function(value)
    if not _pool then
        _pool = LuaClass.ObjectPool(function() return LuaClass.FP() end)
    end
    _pool:add(value)
end

FPEx.__index = FPEx
setmetatable(FPEx, getmetatable(super))

LuaClass.FP = FPEx
return FPEx