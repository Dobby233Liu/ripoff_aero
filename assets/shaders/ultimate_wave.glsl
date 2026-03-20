uniform number sine; // usually time, in seconds
uniform vec2 texture_dim;

uniform number freq;
uniform vec2 diff_freq;
uniform number mag;
uniform vec2 thickness;

uniform number clamp_chunk_dim; // -1 = crop out, 0 = no clamping
uniform bool clamp_final_coords; // false = crop out

uniform bool broken_freq;
uniform bool y_cos;
uniform bool ref_other_axis;
uniform vec2 diff_origin;

vec2 align(vec2 a, vec2 b) {
    return floor((a / b) + 0.5) * b;
}

bool in_bounds(number x, number a, number b) {
    return x >= a && x <= b;
}
bool in_bounds(vec2 x, vec2 a, vec2 b) {
    return in_bounds(x.x, a.x, b.x) && in_bounds(x.y, a.y, b.y);
}

/*
number wrap(number val, number min, number max) {
    return mod(val - min, max - min) + min;
}

number M_PI = 3.14159265358979323846;
number degtorad(number degrees) {
    return degrees / 180.0 * M_PI;
}
number RAD_360DEG;
*/

number calc_siner(number diff, number _diff_freq) {
    return /*number result =*/
        broken_freq ? (sine + diff * _diff_freq) * freq
        : sine * freq + diff * _diff_freq;
    // return wrap(result, 0.0, RAD_360DEG);
}

vec4 effect(vec4 color, Image texture, vec2 texture_coords_norm, vec2 screen_coords) {
    // RAD_360DEG = degtorad(360.0);

    vec2 _thickness = max(vec2(0.0), thickness);

    vec2 texture_coords = texture_coords_norm * texture_dim;
    vec2 chunk = align(texture_coords, _thickness);
    vec2 chunk_ref_base = (texture_coords_norm - diff_origin) * texture_dim;
    vec2 chunk_ref = align(!ref_other_axis ? chunk_ref_base : chunk_ref_base.yx, _thickness);

    if (_thickness.x > 0.0)
        texture_coords.x += sin(calc_siner(chunk_ref.x, diff_freq.x)) * mag;
    if (_thickness.y > 0.0) {
        number siner_y = calc_siner(chunk_ref.y, diff_freq.y);
        texture_coords.y += (y_cos ? cos(siner_y) : sin(siner_y)) * mag;
    }

    vec2 chunk_end = chunk + _thickness;
    if (clamp_chunk_dim > 0.0) {
        texture_coords = clamp(texture_coords, chunk, chunk_end);
    } else if (clamp_chunk_dim < 0.0) {
        if ((_thickness.x > 0.0 && !in_bounds(texture_coords.x, chunk.x, chunk_end.x))
            || (_thickness.y > 0.0 && !in_bounds(texture_coords.y, chunk.y, chunk_end.y)))
            discard;
    }

    vec2 texture_topleftmost = vec2(0.0);
    if (clamp_final_coords)
        texture_coords = clamp(texture_coords, texture_topleftmost, texture_dim);
    else if (!in_bounds(texture_coords, texture_topleftmost, texture_dim))
        discard;

    texture_coords_norm = texture_coords / texture_dim;
    return Texel(texture, texture_coords_norm) * color;
}
