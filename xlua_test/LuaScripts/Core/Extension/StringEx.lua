--------------------------------------------
-- Author: Jax
-- Date: 2020/9/10 14:07
-- Desc: 
---------------------------------------------
---@class string
---@field localize fun(key:string, ...):string
local string = string

--- 本地化字符串
function string.localize(key, ...)
    return App.localizationMgr:getString(key, ...)
end

return string