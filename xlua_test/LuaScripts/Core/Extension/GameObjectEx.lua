-- @Author: Jax
-- @Date:   2020-04-27 11:01:15
-- @Last Modified by:   Jax
-- @Last Modified time: 2020-04-27 11:01:39
------------------------------------------------
--
--	Lua层扩展GameObject
--
------------------------------------------------
---@type UnityEngine.GameObject
local GameObjectEx = Extension(LuaClass.GameObject)

-- 添加一个Lua组件
function GameObjectEx:addLuaComponent(module, ...)
    if self._luaComponent == nil then
        self._luaComponent = 0 -- 此为关键步骤, 初始化C#对象的Lua绑定
        ---@type GameObjectComponent
        self._luaComponent = LuaClass.GameObjectComponent(self)
    end
    if module ~= nil then
        return self._luaComponent:add(module, ...)
    end
end

-- 获得一个Lua组件
function GameObjectEx:getLuaComponent(module)
    if self._luaComponent then
        return self._luaComponent:get(module)
    end
end

-- 移除一个Lua组件
function GameObjectEx:removeLuaComponent(module)
    if self._luaComponent then
        return self._luaComponent:remove(module)
    end
end

function GameObjectEx:sendLuaCompMessage(msg, ...)
    if self._luaComponent then
        return self._luaComponent:sendLuaCompMessage(msg, ...)
    end
end

-- 增加对象销毁的事件监听, 会自动给该对象附加上LuaComponent
function GameObjectEx:addDestroyListener(callback)
    self:addLuaComponent()
    self._luaComponent:addDestroyListener(callback)
end

function GameObjectEx:addTo(node)
    self.transform:SetParent(node.transform, false)
    return self
end

function GameObjectEx:addChild(node)
    node.transform:SetParent(self.transform, false)
    return self
end

function GameObjectEx:removeSelf()
    self.transform:SetParent(nil)
    return self
end

function GameObjectEx:setScaleX(value)
    self.transform:LocalScaleX(value)
    return self
end

function GameObjectEx:setScaleY(value)
    self.transform:LocalScaleY(value)
    return self
end

function GameObjectEx:setScale(value)
    self.transform:LocalScale(value)
    return self
end

local mQuatern = LuaClass.Quaternion(0, 0, 0, 0)

function GameObjectEx:rotate(value)
    value = LuaClass.Mathf.IsNan(value) and 0 or value
    self.transform:LocalRotationZ(value)
    return self
end

function GameObjectEx:getRotation()
    if not self._tempLocalEulerAngles then
        self._tempLocalEulerAngles = LuaClass.Vector3()
    end
    xlua.get_local_eulerangles(self.transform, self.gameObject._tempLocalEulerAngles)
    return self._tempLocalEulerAngles.z
end

function GameObjectEx:setWorldRotation(value)
    value = value or 0
    -- value = 60
    -- --printSL("对象旋转：",value)
    local r = LuaClass.Mathf.Deg2Rad * value * 0.5
    local w = LuaClass.Mathf.Cos(r)
    local z = LuaClass.Mathf.Sin(r)
    mQuatern.x = 0
    mQuatern.y = 0
    mQuatern.z = z
    mQuatern.w = w
    self.transform.rotation = mQuatern
    return self
end

function GameObjectEx:getWorldRotation()
    if not self._tempEulerAngles then
        self._tempEulerAngles = LuaClass.Vector3()
    end
    xlua.get_eulerangles(self.transform, self.gameObject._tempEulerAngles)
    return self._tempEulerAngles.z
end

function GameObjectEx:setVisible(b, layer)
    -- self.gameObject:SetActive(b)
    if isValid(b) then
        self.gameObject:Layer(layer or LuaClass.GlobalConstant.MAP_LAYER)
    else
        self.gameObject:Layer(LuaClass.GlobalConstant.HIDE_LAYER)
    end
    return self
end

function GameObjectEx:addUIToSelf(moduleName, cmpname)
    local panel = self:AddComponent(typeof(LuaClass.GuiUIPanel))
    panel.packageName = moduleName
    panel.componentName = cmpname
    --设置renderMode的方式
    panel.container.renderMode = LuaClass.RenderMode.WorldSpace
    --设置sortingOrder的方式
    panel:SetSortingOrder(9999, true)
    --设置摄像机
    panel.container.renderCamera = App:getFightCamera()--LuaClass.Camera.main
    --设置大小，单位是米，所以要除以100
    panel.container:SetScale(
            panel.container.scale.x / LuaClass.GameConfig.PIXELS_PER_UNIT,
            panel.container.scale.y / LuaClass.GameConfig.PIXELS_PER_UNIT
    )
    panel:CreateUI()

    panel.gameObject:Layer(LuaClass.GlobalConstant.MAP_LAYER)
    return panel
end

return GameObjectEx