local Text, super = HookSystem.hookScript("Text")

function Text:resetState()
    super.resetState(self)
    -- add our state properties
    TableUtils.merge(self.state, {
        my_letter_position_effect = false
    })
end

function Text:getCharPosition(node, state)
    local x, y = super.getCharPosition(self, node, state)
    if state.my_letter_position_effect then
        x = x + math.sin(self.timer / 30 * 2) * 20
    end
    return x, y
end

return Text
