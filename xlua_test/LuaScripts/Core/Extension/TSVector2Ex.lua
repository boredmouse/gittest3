--------------------------------------------
-- Author: Jax
-- Date: 2020/9/8 16:12
-- Desc: 
---------------------------------------------
local LuaClass = LuaClass
local super = CS.TrueSync.TSVector2
---@type TrueSync.TSVector2
local TSVector2Ex = {}

TSVector2Ex.zero = CS.TrueSync.TSVector2.zero
TSVector2Ex.one = CS.TrueSync.TSVector2.one
TSVector2Ex.right = CS.TrueSync.TSVector2.right
TSVector2Ex.left = CS.TrueSync.TSVector2.left
TSVector2Ex.up = CS.TrueSync.TSVector2.up
TSVector2Ex.down = CS.TrueSync.TSVector2.down

local fp100 = CS.TrueSync.FP(100)
local fp10000 = CS.TrueSync.FP(10000)
---@type TrueSync.TSVector2
TSVector2Ex.Vec2_100 = super(fp100, fp100)
---@type TrueSync.TSVector2
TSVector2Ex.Vec2_10000 = super(fp10000, fp10000)
TSVector2Ex.Vec3_100 = CS.TrueSync.TSVector(fp100, fp100, fp100)

---@type TrueSync.TSVector2
TSVector2Ex.tempVec1 = super(fp100, fp100)
---@type TrueSync.TSVector2
TSVector2Ex.tempVec2 = super(fp100, fp100)
---@type TrueSync.TSVector2
TSVector2Ex.tempVec3 = super(fp100, fp100)
---@type TrueSync.TSVector2
TSVector2Ex.tempVec4 = super(fp100, fp100)

---@type ObjectPool 避免频繁创建
local _pool
---@return TrueSync.TSVector2
function TSVector2Ex.pop()
    if not _pool then
        _pool = LuaClass.ObjectPool(
            function()
                return LuaClass.TSVector2()
            end,
            function(obj)
                obj:SetNumber(0,0)
            end
        )
    end
    return _pool:get()
end

TSVector2Ex.push = function(value)
    if not _pool then
        _pool = LuaClass.ObjectPool(function() return LuaClass.TSVector2() end)
    end
    _pool:add(value)
end

TSVector2Ex.__index = TSVector2Ex
setmetatable(TSVector2Ex, getmetatable(super))

LuaClass.TSVector2 = TSVector2Ex
return TSVector2Ex

