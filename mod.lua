function Mod:getUISkin()
    return "aero"
end

Mod.WAVY_LAKE = love.graphics.newShader[[
    extern number sine; // usually time, in seconds
    extern vec2 texture_dim;

    extern number freq = 1.0;
    extern number diff_freq = 1.0/30.0;
    extern number mag = 2.0;
    extern vec2 thickness = vec2(1.0, 0.0);

    extern number clamp_chunk_dim = 0.0; // -1 = crop out, 0 = no clamping
    extern bool clamp_final_coords = true; // false = crop out

    extern bool broken_freq = false;
    extern bool y_cos = false;
    extern bool ref_other_axis = false;

    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords) {
        vec2 chunk = vec2(
            thickness.x > 0.0 ? floor(texture_coords.x * texture_dim.x / thickness.x) * thickness.x : 0.0,
            thickness.y > 0.0 ? floor(texture_coords.y * texture_dim.y / thickness.y) * thickness.y : 0.0
        );
        vec2 chunk_ref = chunk;
        if (ref_other_axis)
            chunk_ref = vec2(
                thickness.x > 0.0 ? floor(texture_coords.y * texture_dim.y / thickness.x) * thickness.x : 0.0,
                thickness.y > 0.0 ? floor(texture_coords.x * texture_dim.x / thickness.y) * thickness.y : 0.0
            );

        if (thickness.x > 0.0) {
            number x_diff = chunk_ref.x;
            number x_siner = broken_freq ? (sine + x_diff * diff_freq) * freq : sine * freq + x_diff * diff_freq;
            texture_coords.x += sin(x_siner) * mag / texture_dim.x;
        }
        if (thickness.y > 0.0) {
            number y_diff = chunk_ref.y;
            number y_siner = broken_freq ? (sine + y_diff * diff_freq) * freq : sine * freq + y_diff * diff_freq;
            if (y_cos)
                texture_coords.y += cos(y_siner) * mag / texture_dim.y;
            else
                texture_coords.y += sin(y_siner) * mag / texture_dim.y;
        }

        if (clamp_chunk_dim > 0.0) {
            if (thickness.x > 0.0)
                texture_coords.x = clamp(texture_coords.x * texture_dim.x, chunk.x, chunk.x + thickness.x) / texture_dim.x;
            if (thickness.y > 0.0)
                texture_coords.y = clamp(texture_coords.y * texture_dim.y, chunk.y, chunk.y + thickness.y) / texture_dim.y;
        } else if (clamp_chunk_dim < 0.0) {
            if (
                texture_coords.x * texture_dim.x < chunk.x || texture_coords.x * texture_dim.x > chunk.x + thickness.x
                || texture_coords.y * texture_dim.y < chunk.y || texture_coords.y * texture_dim.y > chunk.y + thickness.y
            )
                return vec4(0);
        }

        if (clamp_final_coords)
            texture_coords = clamp(texture_coords, 0.0, 1.0);
        else if (texture_coords.x < 0.0 || texture_coords.x > 1.0 || texture_coords.y < 0.0 || texture_coords.y > 1.0)
            return vec4(0);

        return Texel(tex, texture_coords) * color;
    }
]]

function Mod:postInit()
    Game.world:addFX(ShaderFX(Mod.WAVY_LAKE, {
        sine = function() return Kristal.getTime() end,
        texture_dim = {SCREEN_WIDTH, SCREEN_HEIGHT},
        clamp_chunk_dim = 0,
        freq = 8,
        mag = 4,
        thickness = {1, 0},
        ref_other_axis = true
    }))
end