--------------------------------------------
-- Author: How
-- Date: 2020/12/9 15:48
-- Desc: 
---------------------------------------------

--require "Module.Config.AppConfig"

function __G__TRACKBACK__(msg)
    -- TODO: Bugly上报
    box(msg)
end

-- 游戏逻辑循环
function __G__UPDATE__ (deltaTime)

    if App then
        App:update(deltaTime)
    end
end

function __G__FIXEDUPDATE__(fixedDeltaTime)
    if App then
        App:fixedUpdate(fixedDeltaTime)
    end
end

function __G__LATEUPDATE__()
    if App then
        App:lateUpdate()
    end
end

function __G__APPLICATIONPAUSE__(pause)
    if App then
        App:onApplicationPause(pause)
    end
end

function __G__QUIT__()
    if App then
        App:quit()
    end
end

function main()
    require("Core.CoreInit")
    print("-- =================初始化游戏=========================")
    TestUI = LuaClass.TestUI
    TestUI:CreateCanvas()
    --- @type UIManager
    UIManager = LuaClass.UIManager()
    ---@field view UI_Package1_lalala
    local view = UIManager:createUI(LuaClass.UI_Package1_lalala)
    UIManager:addChild(view,"WindowLayer")
    --LuaClass.UI_Package1_lalala.Construct(view)
    --view._lalala.text = "222"
    --view:GetChildAt(0).text = "111"
end

-- 由c#驱动的其他模块无法被xpcall(main)捕获
-- 直接调用main，异常统一交由xlua的LuaException捕获
main()

--CS.Main.Instance:GC()