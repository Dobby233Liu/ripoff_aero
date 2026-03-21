---@class DarkItemMenu
local DarkItemMenu, super = HookSystem.hookScript(DarkItemMenu)

function DarkItemMenu:onKeyPressed(key)
    if Input.isMenu(key) or Input.isCancel(key) then
        --[[Game.world:closeMenu()
        return]]
    end
    if super.onKeyPressed then
        return super.onKeyPressed(self, key)
    end
end

return DarkItemMenu
