// Desenhos simples, em visão de cima, feitos com formas primitivas.
// Cada desenho usa coordenadas locais (personagens "olham" para +x) e a matriz de mundo
// posiciona, gira e escala o resultado.

function sprite_begin(_x, _y, _angle = 0, _scale = 1) {
    matrix_set(matrix_world, matrix_build(_x, _y, 0, 0, 0, _angle, _scale, _scale, 1));
}

function sprite_end() {
    matrix_set(matrix_world, matrix_build_identity());
}

// Converte um vetor de direção no ângulo do GameMaker (graus, sentido anti-horário),
// o mesmo usado por sprite_begin e por lengthdir_x/lengthdir_y.
function facing_angle(_fx, _fy) {
    return point_direction(0, 0, _fx, _fy);
}

function shape_circle(_x, _y, _r, _col, _alpha = 1) {
    draw_set_colour(_col);
    draw_set_alpha(_alpha);
    draw_circle(_x, _y, _r, false);
    draw_set_alpha(1);
}

function shape_ellipse(_x, _y, _rx, _ry, _col, _alpha = 1) {
    draw_set_colour(_col);
    draw_set_alpha(_alpha);
    draw_ellipse(_x - _rx, _y - _ry, _x + _rx, _y + _ry, false);
    draw_set_alpha(1);
}

function shape_rect(_x, _y, _w, _h, _col) {
    draw_set_colour(_col);
    draw_rectangle(_x, _y, _x + _w, _y + _h, false);
}

function shape_line(_x1, _y1, _x2, _y2, _width, _col) {
    draw_set_colour(_col);
    draw_line_width(_x1, _y1, _x2, _y2, _width);
}

function shape_triangle(_x1, _y1, _x2, _y2, _x3, _y3, _col) {
    draw_set_colour(_col);
    draw_triangle(_x1, _y1, _x2, _y2, _x3, _y3, false);
}

function shape_shadow(_x, _y, _rx, _ry) {
    shape_ellipse(_x, _y, _rx, _ry, #1E2D46, 0.22);
}

function draw_brasa(_x, _y, _fx, _fy, _scale = 1) {
    sprite_begin(_x, _y, 0, _scale);
    shape_shadow(0, 10, 15, 6);
    sprite_begin(_x, _y, facing_angle(_fx, _fy), _scale);
    shape_circle(-15, 0, 4, #C98A4B); // cauda
    shape_ellipse(0, 0, 13, 12, #4A3426); // jaqueta
    shape_ellipse(4, 0, 6, 10, #E0702A); // cachecol
    shape_circle(7, -8, 4, #8A5A30); // orelhas
    shape_circle(7, 8, 4, #8A5A30);
    shape_circle(16, 0, 5, #D9A066); // focinho
    shape_circle(20, 0, 2, #222222);
    shape_circle(8, 0, 8, #E0702A); // capacete
    shape_circle(12, -4, 2.5, #9FD3E6); // óculos
    shape_circle(12, 4, 2.5, #9FD3E6);
    sprite_end();
}

function draw_cat(_x, _y, _fx, _fy, _cured = false, _scale = 1) {
    var _body = _cured ? #D9A066 : #8A7F99;
    var _dark = _cured ? #A8743F : #5E556B;
    var _eyes = _cured ? #2B2B2B : #E8F6FF;

    sprite_begin(_x, _y, 0, _scale);
    shape_shadow(0, 9, 14, 5);
    sprite_begin(_x, _y, facing_angle(_fx, _fy), _scale);
    shape_line(-11, 0, -18, -3, 3, _dark); // cauda
    shape_line(-18, -3, -22, -10, 3, _dark);
    shape_ellipse(0, 0, 13, 9, _body);
    shape_ellipse(-2, 0, 7, 3, _dark); // costas curvadas
    shape_circle(12, 0, 7, _body);
    shape_triangle(10, -4, 14, -11, 16, -4, _dark); // orelhas
    shape_triangle(10, 4, 14, 11, 16, 4, _dark);
    shape_circle(16, -3, 1.8, _eyes);
    shape_circle(16, 3, 1.8, _eyes);
    sprite_end();
}

function draw_nilo(_x, _y, _fx, _fy) {
    sprite_begin(_x, _y);
    shape_shadow(0, 9, 13, 5);
    sprite_begin(_x, _y, facing_angle(_fx, _fy));
    shape_line(-10, 0, -18, 6, 2, #D89AA3); // cauda
    shape_line(-18, 6, -27, 3, 2, #D89AA3);
    shape_ellipse(0, 0, 11, 9, #556B3A); // casaco verde
    shape_circle(8, -7, 4.5, #D89AA3); // orelhas
    shape_circle(8, 7, 4.5, #D89AA3);
    shape_ellipse(11, 0, 7, 6, #8D8D8D); // cabeça
    shape_circle(18, 0, 2, #D89AA3); // nariz
    shape_circle(13, -3, 1.4, #111111);
    shape_circle(13, 3, 1.4, #111111);
    sprite_end();
}

function draw_stun_stars(_x, _y) {
    var _time = current_time / 1000;
    for (var i = 0; i < 3; i++) {
        var _angle = _time * 5 + i * 2 * pi / 3;
        shape_circle(_x + cos(_angle) * 10, _y + sin(_angle) * 4, 2.5, #FFD84A);
    }
}

function draw_box(_x, _y) {
    var _pulse = 0.3 + sin(current_time / 250) * 0.15;
    draw_set_colour(#F0A050);
    draw_set_alpha(_pulse);
    for (var _r = 21; _r <= 23; _r++) draw_circle(_x, _y, _r, true);
    draw_set_alpha(1);

    sprite_begin(_x, _y);
    shape_shadow(0, 12, 14, 4);
    shape_rect(-14, -14, 28, 28, #6B4520);
    shape_rect(-12, -12, 24, 24, #A0703C);
    shape_rect(-6, -6, 12, 12, #F2F5F8);
    shape_rect(-1.5, -4.5, 3, 9, #3A8FD0); // cruz da pesquisa
    shape_rect(-4.5, -1.5, 9, 3, #3A8FD0);
    sprite_end();
}

function draw_bench(_x, _y, _scale = 1) {
    sprite_begin(_x, _y, 0, _scale);
    shape_shadow(0, 18, 42, 6);
    shape_rect(-40, -18, 80, 36, #7A4B22);
    shape_rect(-37, -15, 74, 30, #B07A43);
    shape_rect(-28, -8, 18, 5, #7D8590); // ferramentas
    shape_rect(-24, 2, 5, 9, #7D8590);
    shape_circle(18, -2, 7, #9FD3E6); // frasco da cura
    shape_circle(18, -2, 3, #3A8FD0);
    sprite_end();
}

function draw_moto(_x, _y, _scale = 1) {
    sprite_begin(_x, _y, 0, _scale);
    shape_shadow(0, 14, 38, 6);
    shape_rect(-36, -6, 16, 12, #1E1E22); // rodas
    shape_rect(20, -6, 16, 12, #1E1E22);
    shape_ellipse(0, 0, 24, 10, #E0702A); // corpo
    shape_ellipse(-8, 0, 10, 6, #5A3A22); // banco
    shape_line(18, -14, 18, 14, 3, #555555); // guidão
    sprite_end();
}

function draw_tree(_x, _y, _variant, _scale = 1) {
    var _shades = [ #2D4A4C, #33504A, #29444F ];
    sprite_begin(_x, _y, 0, _scale);
    shape_circle(0, 4, 23, #142332, 0.25);
    shape_circle(0, 0, 22, _shades[_variant]);
    shape_circle(-3, -3, 14, #3E6461);
    shape_circle(-6, -7, 8, #F0F6FA, 0.85); // neve
    sprite_end();
}

function draw_rock(_x, _y) {
    sprite_begin(_x, _y);
    draw_set_colour(#6F7884);
    draw_primitive_begin(pr_trianglefan);
    draw_vertex(0, 0);
    draw_vertex(-18, 12);
    draw_vertex(-15, -8);
    draw_vertex(-2, -17);
    draw_vertex(14, -10);
    draw_vertex(18, 12);
    draw_vertex(-18, 12);
    draw_primitive_end();
    shape_ellipse(-3, -9, 9, 5, #F0F5FA);
    sprite_end();
}

function draw_heart(_x, _y, _col) {
    shape_circle(_x - 5, _y - 3, 5.5, _col);
    shape_circle(_x + 5, _y - 3, 5.5, _col);
    shape_triangle(_x - 10.5, _y - 1, _x + 10.5, _y - 1, _x, _y + 10, _col);
}
