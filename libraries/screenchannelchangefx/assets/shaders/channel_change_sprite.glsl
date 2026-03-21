//
// Simple passthrough fragment shader
//

uniform vec2 u_pixelSize;
uniform vec2 texel;
uniform float strength;
uniform float scanx;
uniform Image perlin_texture_page;

vec4 effect(vec4 v_vColour, Image gm_BaseTexture, vec2 v_vTexcoord, vec2 v_vScrcoord)
{
    vec4 noise_data = Texel(perlin_texture_page, vec2(scanx, v_vTexcoord.y * texel.y) / u_pixelSize);
    float offset = (noise_data.x - 0.5) * 2.0;
    v_vTexcoord.x = mod(v_vTexcoord.x - (offset * strength / texel.x), 1.0);
    return v_vColour * Texel(gm_BaseTexture, v_vTexcoord);
}
