// GLSL fragment shader cho Niri
void mainImage(out vec4 fragColor, in vec2 fragCoord, in sampler2D texture_sampler) {
    // Lấy màu sắc gốc từ tọa độ màn hình
    vec4 texColor = texture2D(texture_sampler, fragCoord);
    
    // Tính toán độ xám theo chuẩn ITU-R BT.709
    float gray = dot(texColor.rgb, vec3(0.2126, 0.7152, 0.0722));
    
    // Trả về màu trắng đen nhưng giữ nguyên độ trong suốt (alpha)
    fragColor = vec4(vec3(gray), texColor.a);
}
