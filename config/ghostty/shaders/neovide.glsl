void mainImage(out vec4 fragColor, in vec2 fragCoord) {
    // Current pixel position
    vec2 uv = fragCoord / iResolution.xy;
    
    // Ghostty provides iCursor in pixels (x, y, width, height)
    vec2 cursor = iCursor.xy / iResolution.xy;
    
    // Ghostty provides velocity in pixels per second
    vec2 vel = iCursorVelocity.xy / iResolution.xy;
    float speed = length(vel);
    
    // The physics: Stretch the 'detection' radius based on speed
    float dist = distance(uv, cursor);
    
    // Increase the 4.0 to 10.0 if you want an absurdly long trail
    float trailLength = 0.02 + (speed * 4.0);
    float alpha = smoothstep(trailLength, 0.0, dist);

    // Color: Pure white
    fragColor = vec4(1.0, 1.0, 1.0, alpha);
}
