--------------------------------------------
-- Author: How
-- Date: 2020/12/9 16:07
-- Desc: 
---------------------------------------------
------ @class TestUI
local TestUI = {}
function TestUI:CreateCanvas()
    local canvasPrefab = CS.UnityEngine.Resources.Load("MainCanvas")
    local canvas = CS.UnityEngine.GameObject.Instantiate(canvasPrefab)
end

return TestUI