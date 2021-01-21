--------------------------------------------
-- Author: How
-- Date: 2020/12/10 16:32
-- Desc: 
---------------------------------------------
------@class UIManager
local UIManager = class("UiManager", nil)

UIManager.LayerSort = {
    "FixedLayer",
    "WindowLayer",
    "TipsLayer",
    "TopLayer",
}

function UIManager:ctor()
    print("UIManager:ctor()")
    --- 所有界面以层级为key的字典,key为 层级名称 value 为 这个层级上面界面的数组
    self._layerAllViewDic = {}
    --- 层级容器对象
    ---@type table<string, FairyGUI.GComponent>
    self._layerDic = {}

    for index, value in ipairs(self.LayerSort) do
        local layer = LuaClass.GuiGComponent()
        layer:setDisplayerName(value)
        LuaClass.GuiGRoot.inst:AddChild(layer)

        ---UI居中适配
        layer.width = 1920
        layer.height = 1080
        layer:Center(true)

        self._layerDic[value] = layer
        self._layerAllViewDic[value] = {}
    end
end

function UIManager:createUI(uiConfig)
    ---ui资源的模块路径
    --local pkgpath = LuaClass.AssetPathUtilEx.getPkgUrl(uiConfig.PackageName)
    local pkgpath = LuaClass.StringUtil.format("Assets/GameAssets/UI/Module/{1}/{2}", uiConfig.PackageName, uiConfig.PackageName)
    ---ui资源中的组件名称
    local cmpname = uiConfig.Path

    if isValid(pkgpath) and isValid(cmpname) then
        local package = LuaClass.GuiUIPackage.AddPackage(pkgpath)
        local view = package:CreateObject(cmpname)
        ---控制组件是否启用深度调整
        view.fairyBatching = true
        --- 开发者需要手动触发深度调整
        --- 还可以强制动效每帧都执行深度调整
        view:InvalidateBatchingState(true)
        return view
    end

end

function UIManager:addChild(obj, layerType)
    self._layerDic[layerType]:AddChild(obj)
end







return UIManager