uniform number sine; // usually time, in seconds
uniform vec2 texture_dim;

uniform number freq;
uniform number diff_freq;
uniform number mag;
uniform vec2 thickness;

uniform number clamp_chunk_dim; // -1 = crop out, 0 = no clamping
uniform bool clamp_final_coords; // false = crop out

uniform bool broken_freq;
uniform bool y_cos;
uniform bool ref_other_axis;

vec2 round(vec2 x) {
    return floor(x + 0.5);
}

bool in_bounds(number x, number a, number b) {
    return x >= a && x <= b;
}

vec2 align(vec2 a, vec2 b) {
    return round(a / b) * b;
}

number calc_siner(number diff) {
    return broken_freq ? ((sine + diff * diff_freq) * freq) : (sine * freq + diff * diff_freq);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec2 _thickness = max(vec2(0.0), thickness);

    vec2 texture_coords_physical = texture_coords * texture_dim;
    vec2 chunk = align(texture_coords_physical, _thickness);
    vec2 chunk_ref = chunk;
    if (ref_other_axis) {
        vec2 texture_coords_yx_physical = texture_coords.yx * texture_dim;
        chunk_ref = align(texture_coords_yx_physical, _thickness);
    }

    if (_thickness.x > 0.0) {
        number x_siner = calc_siner(chunk_ref.x);
        texture_coords_physical.x += sin(x_siner) * mag;
    }
    if (_thickness.y > 0.0) {
        number y_siner = calc_siner(chunk_ref.y);
        texture_coords_physical.y += (y_cos ? cos(y_siner) : sin(y_siner)) * mag;
    }

    vec2 chunk_end = chunk + _thickness;
    if (clamp_chunk_dim > 0.0) {
        texture_coords_physical = clamp(texture_coords_physical, chunk, chunk_end);
    } else if (clamp_chunk_dim < 0.0) {
        if (_thickness.x > 0.0) {
            if (!in_bounds(texture_coords_physical.x, chunk.x, chunk_end.x))
                discard;
        }
        if (_thickness.y > 0.0) {
            if (!in_bounds(texture_coords_physical.y, chunk.y, chunk_end.y))
                discard;
        }
    }

    texture_coords = texture_coords_physical / texture_dim;
    if (clamp_final_coords)
        texture_coords = clamp(texture_coords, 0.0, 1.0);
    else if (!in_bounds(texture_coords.x, 0.0, 1.0) || !in_bounds(texture_coords.y, 0.0, 1.0))
        discard;

    return Texel(texture, texture_coords) * color;
}
