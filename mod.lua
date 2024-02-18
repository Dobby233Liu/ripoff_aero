function Mod:getUISkin()
    return "aero"
end

Mod.WAVY_LAKE = modRequire("ultimate_wave")

function Mod:postInit()
    Game.world:addFX(ShaderFX(Mod.WAVY_LAKE, {
        sine = function() return Kristal.getTime() end,
        texture_dim = {SCREEN_WIDTH, SCREEN_HEIGHT},
        clamp_chunk_dim = 0,
        freq = 8,
        mag = 8,
        thickness = {1, 0},
        ref_other_axis = true
    }))
end