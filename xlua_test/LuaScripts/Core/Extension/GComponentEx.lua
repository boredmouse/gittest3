--------------------------------------------
-- Author: Jax
-- Date: 2020/8/24 12:25
-- Desc:
---------------------------------------------

local KWeak = { __mode = "k" }
--KWeak.__index = KWeak

--local VWeak = { __mode = "v" }
--VWeak.__index = VWeak

---@class GComponentEx
local cache = setmetatable({}, KWeak)

function cache:destroy(ui)
    local temp = self[ui]
    if not temp then
        return
    end

    for i, v in pairs(temp) do
        temp[i] = nil
        self:destroy(v)
    end
    self[ui] = nil
end

local tempArr = {
    CS.FairyGUI.GComponent,
    CS.FairyGUI.GProgressBar,
    CS.FairyGUI.GButton,
    CS.FairyGUI.GComboBox,
    CS.FairyGUI.GLabel,
    CS.FairyGUI.GList,
    CS.FairyGUI.GScrollBar,
    CS.FairyGUI.GRoot,
    CS.FairyGUI.GSlider,
    CS.FairyGUI.Window,
    CS.FairyGUI.GGroup,
}
for _, v in ipairs(tempArr) do
    local tempMeta = xlua.getmetatable(v)
    local tempNewIndex = tempMeta.__newindex
    local newindex = function(o, k, v)
        --printJax("__newindex", o, k, v)
        local status, err = pcall(tempNewIndex, o, k, v)
        if not status then
            if string.match(err, "^cannot set ") then
                if cache[o] == nil then
                    cache[o] = {}
                    cache[o][k] = v
                else
                    cache[o][k] = v
                end
            else
                error(err)
            end
        end
    end
    tempMeta.__newindex = newindex
end


for _, v in ipairs(tempArr) do
    local tempMeta = xlua.getmetatable(v)
    local tempIndex = tempMeta.__index
    local index = function(o, k)
        local result = tempMeta[k] or tempIndex(o, k)
        if result ~= nil then
            return result
        else
            if (cache[o] and cache[o][k]) then
                result = cache[o][k]
            else
                local name = string.gsub(k, "^_", "")
                result = o:FindChild(name)
                if result ~= nil then
                    cache[o] = cache[o] or {}
                    cache[o][k] = result
                    --printJax("find", k)
                else
                    --printJax("no find", k)
                end
            end
        end
        return result
    end
    tempMeta.__index = index
end

--local meta = xlua.getmetatable(CS.FairyGUI.GComponent)
--local oldIndex = meta.__index
--meta.__index = function(o, k)
--    local result = meta[k] or oldIndex(o, k)
--    if result ~= nil then
--        return result
--    else
--        if (cache[o] and cache[o][k]) then
--            result = cache[o][k]
--        else
--            local name = string.gsub(k, "^_", "")
--            result = o:FindChild(name)
--            if result ~= nil then
--                cache[o] = cache[o] or setmetatable({}, weak)
--                cache[o][k] = result
--                --printJax("find", k)
--            else
--                --printJax("no find", k)
--            end
--        end
--    end
--    return result
--end

return cache