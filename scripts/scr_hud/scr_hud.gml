// Interface da partida: vida (esquerda), tempo (centro) e materiais (direita).

function hud_panel(_x, _y, _w, _h) {
    draw_set_colour(C_PANEL);
    draw_set_alpha(0.78);
    draw_roundrect_ext(_x, _y, _x + _w, _y + _h, 14, 14, false);
    draw_set_alpha(1);
}

function hud_draw(_hearts, _time_left, _collected) {
    var _y = 14;
    var _h = 40;
    var _mid = _y + _h / 2;
    draw_set_font(fnt_main);
    draw_set_valign(fa_middle);

    // Vida
    hud_panel(16, _y, 190, _h);
    draw_set_halign(fa_left);
    draw_set_colour(C_TEXT);
    draw_text(30, _mid, "Vida:");
    for (var i = 0; i < PLAYER_MAX_HEARTS; i++) {
        draw_heart(100 + i * 30, _mid, i < _hearts ? C_HEART : C_HEART_LOST);
    }

    // Tempo (fica vermelho no último minuto)
    var _cx = SCREEN_W / 2;
    hud_panel(_cx - 95, _y, 190, _h);
    var _time_col = _time_left <= 60 ? C_DANGER : C_TEXT;
    draw_set_colour(_time_col);
    draw_circle(_cx - 62, _mid, 8, true); // ícone de relógio
    draw_line(_cx - 62, _mid, _cx - 62, _mid - 5);
    draw_line(_cx - 62, _mid, _cx - 58, _mid);
    draw_set_halign(fa_left);
    draw_text(_cx - 46, _mid, "Tempo: " + format_time(_time_left));

    // Materiais
    var _rx = SCREEN_W - 206;
    hud_panel(_rx, _y, 190, _h);
    shape_rect(_rx + 16, _mid - 8, 16, 16, #A0703C); // ícone de caixa
    shape_rect(_rx + 21, _mid - 3, 6, 6, #F2F5F8);
    draw_set_colour(C_TEXT);
    draw_text(_rx + 42, _mid, "Materiais: " + string(_collected) + "/" + string(BOX_TOTAL));
}

// Mensagem junto ao personagem (em coordenadas do mundo).
function hud_prompt(_text, _x, _y) {
    draw_set_font(fnt_main);
    var _w = string_width(_text) + 20;
    hud_panel(_x - _w / 2, _y - 14, _w, 28);
    draw_set_colour(C_TEXT);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_text(_x, _y, _text);
}
