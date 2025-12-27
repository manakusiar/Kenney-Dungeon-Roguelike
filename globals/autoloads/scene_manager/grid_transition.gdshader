shader_type canvas_item;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform vec2 grid_size = vec2(10.0, 8.0);
uniform vec4 tile_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float tile_fade : hint_range(0.0, 0.5) = 0.15;
uniform bool reverse = false;

void fragment() {
    // Determine which tile this pixel belongs to
    vec2 tile = floor(UV * grid_size);
    
    // Calculate distance from top-right corner
    // Top-right = earliest, Bottom-left = latest
    float dist_x = (grid_size.x - 1.0) - tile.x;
    float dist_y = tile.y;
    float distance = dist_x + dist_y;
    
    // Normalize distance (0 = top-right, 1 = bottom-left)
    float max_distance = grid_size.x + grid_size.y - 2.0;
    float delay = distance / max(max_distance, 1.0);
    
    // Reverse if needed (for transition out)
    if (reverse) {
        delay = 1.0 - delay;
    }
    
    // Calculate when this tile starts and finishes fading
    float start_time = delay * (1.0 - tile_fade);
    float end_time = start_time + tile_fade;
    
    // Smooth fade for each tile
    float alpha = smoothstep(start_time, end_time, progress);
    
    COLOR = vec4(tile_color.rgb, alpha);
}