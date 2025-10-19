shader_type canvas_item;

// Controls the maximum horizontal displacement strength
uniform float intensity : hint_range(0.0, 0.5) = 0.05;
// Controls how fast the glitch flickers
uniform float speed : hint_range(0.0, 20.0) = 10.0;
// Controls the vertical size of the glitching blocks
uniform float block_size : hint_range(0.01, 1.0) = 0.08;

// Simple pseudo-random number generator
float rand(vec2 co){
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    vec2 original_uv = UV;
    vec4 original_color = texture(TEXTURE, original_uv);
    
    // We use floor(TIME * speed) to make the glitch "jump" in discrete steps
    // instead of scrolling smoothly.
    float time_step = floor(TIME * speed);
    
    // Quantize the y-coordinate by block_size to create horizontal strips.
    // We use this strip's y-value and the current time step as a seed.
    float block_y = floor(original_uv.y / block_size);
    vec2 block_seed = vec2(block_y, time_step);
    
    // Get a random value for this block at this time.
    float block_rand = rand(block_seed);
    
    // Bias the random value heavily towards 0, so glitches are rare and sudden.
    // Only the highest random values will trigger a glitch.
    float glitch_trigger = pow(block_rand, 15.0);
    
    // This will be 0.0 for most pixels, and a value > 0.0 for glitched blocks.
    // We multiply by our intensity uniform.
    float glitch_strength = glitch_trigger * intensity;
    
    // Use another random value to determine the horizontal offset direction (-1.0 or 1.0)
    float offset_direction = (rand(vec2(time_step, block_y)) * 2.0) - 1.0;
    float horizontal_offset = offset_direction * glitch_strength;

    // --- Apply Glitch Effects ---
    
    // 1. Chromatic Aberration (Color Splitting)
    // Sample the R, G, and B channels from slightly different horizontal positions.
    float r = texture(TEXTURE, vec2(original_uv.x + horizontal_offset, original_uv.y)).r;
    float g = texture(TEXTURE, original_uv).g;
    float b = texture(TEXTURE, vec2(original_uv.x - horizontal_offset, original_uv.y)).b;
    
    // 2. Horizontal Displacement
    // Sample the whole texture from the offset position.
    vec4 displaced_color = texture(TEXTURE, vec2(original_uv.x + horizontal_offset, original_uv.y));
    
    // --- Combine and Output ---
    
    // We can choose how to combine the effects.
    // Option A: Just chromatic aberration
    // vec4 final_color = vec4(r, g, b, original_color.a);
    
    // Option B: Just displacement
    // vec4 final_color = displaced_color;
    
    // Option C: Use the displaced color, but *also* apply the chromatic aberration to it.
    // This gives a nice, layered effect.
    vec4 final_color = vec4(displaced_color.r * (1.0 - glitch_strength) + r * glitch_strength, 
                            g, // Keep green channel "cleaner" for a more classic look
                            displaced_color.b * (1.0 - glitch_strength) + b * glitch_strength,
                            original_color.a);

    // Use mix() to blend between the original color and the glitched color.
    // The glitch_strength acts as the blending factor (0.0 = no glitch, >0.0 = full glitch).
    COLOR = mix(original_color, final_color, glitch_strength * 10.0);
}