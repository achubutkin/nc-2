void main() {
    // find the current pixel color
    vec4 current_color = texture2D(u_texture, v_tex_coord);
    gl_FragColor = current_color;
}
