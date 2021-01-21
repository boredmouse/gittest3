---@class UI_Package1_lalala:FairyGUI.GComponent
---@field _lalala FairyGUI.GTextField
local UI_Package1_lalala = class("UI_Package1_lalala")

UI_Package1_lalala.PackageName = "Package1"
UI_Package1_lalala.Path = "/Component/lalala"

function UI_Package1_lalala.Construct(view)
    ---@type FairyGUI.GTextField
    view._lalala = view:GetChildAt(0)
    --view:GetChildAt(0).text = "111"

end

return UI_Package1_lalala