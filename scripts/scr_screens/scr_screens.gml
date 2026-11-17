// Telas estáticas: menu inicial, ajuda, narrativas, pausa e resultado.
// Todas são desenhadas no evento Draw GUI do obj_game.

function screen_text_intro() {
    return [
        "Um vírus transformou os gatos de Serra Branca em criaturas agressivas.",
        "Brasa chegou de moto à oficina e descobriu que três caixas de materiais da pesquisa ficaram espalhadas pela montanha.",
        "Nilo, um rato que teme a volta dos gatos, vigia o material do mirante.",
        "Objetivo: reúna as três caixas e entregue-as na bancada da oficina antes que a nevasca bloqueie o caminho.",
    ];
}

function screen_text_result(_result) {
    switch (_result) {
        case MissionResult.VICTORY:
            return ["Brasa reuniu os materiais na oficina e a cura ficou pronta.",
                "Os moradores de Serra Branca estão recuperados. Missão concluída!"];
        case MissionResult.DEAD:
            return ["Brasa perdeu toda a vida antes de entregar os materiais.", "A missão fracassou."];
        default:
            return ["A nevasca chegou antes da entrega dos materiais.", "A missão fracassou."];
    }
}

function screen_text_help() {
    return [
        "Objetivo: recolha as três caixas de materiais (Depósito, Trilha e Mirante)",
        "e entregue-as na bancada da oficina antes do fim do tempo.",
        "",
        "W, A, S, D: mover Brasa",
        "E: recolher caixa / entregar na bancada",
        "Espaço: golpe curto que atordoa inimigos",
        "Esc: pausar",
        "Setas + Enter: menus",
        "",
        "Você tem três corações: cada contato com um inimigo tira um.",
    ];
}

function screen_background() {
    draw_set_alpha(1);
    draw_set_colour(C_BACKGROUND);
    draw_rectangle(0, 0, SCREEN_W, SCREEN_H, false);
}

function screen_title(_text, _y, _scale = 3, _col = C_TEXT) {
    draw_set_font(fnt_main);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(_col);
    draw_text_transformed(SCREEN_W / 2, _y, _text, _scale, _scale, 0);
}

// Desenha parágrafos centralizados, com quebra de linha automática.
function screen_paragraphs(_lines, _y, _col = C_TEXT) {
    var _scale = 1.2;
    var _line_height = 22;
    var _max_width = 760 / _scale;
    draw_set_font(fnt_main);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(_col);
    for (var i = 0; i < array_length(_lines); i++) {
        var _line = _lines[i];
        if (_line == "") {
            _y += _line_height / 2;
            continue;
        }
        draw_text_ext_transformed(SCREEN_W / 2, _y, _line, _line_height, _max_width, _scale, _scale, 0);
        _y += string_height_ext(_line, _line_height, _max_width) * _scale + 4;
    }
}

function screen_hint(_text) {
    draw_set_font(fnt_main);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_colour(C_TEXT_DIM);
    draw_text(SCREEN_W / 2, SCREEN_H - 28, _text);
}

// Ilustração estática que reaproveita os desenhos do próprio jogo.
// _kind: "intro", "victory" ou "defeat".
function screen_scene(_kind) {
    var _w = 520;
    var _h = 170;
    var _x = (SCREEN_W - _w) / 2;
    var _y = 40;
    var _cx = _x + _w / 2;
    var _cy = _y + _h / 2;
    var _s = 2;

    draw_set_colour(_kind == "defeat" ? #9FB2C6 : C_WORKSHOP);
    draw_roundrect_ext(_x, _y, _x + _w, _y + _h, 24, 24, false);

    if (_kind == "intro") {
        draw_tree(_cx - 200, _cy - 40, 1, 1.6);
        draw_tree(_cx + 200, _cy - 40, 0, 1.6);
        draw_moto(_cx - 120, _cy + 20, _s);
        draw_brasa(_cx + 20, _cy + 20, 1, 0, _s);
    } else if (_kind == "victory") {
        draw_bench(_cx, _cy - 20, _s);
        draw_brasa(_cx, _cy + 50, 0, -1, _s);
        draw_cat(_cx - 160, _cy + 30, 1, 0, true, _s);
        draw_cat(_cx + 160, _cy + 30, -1, 0, true, _s);
    } else {
        draw_tree(_cx - 200, _cy - 40, 2, 1.6);
        draw_tree(_cx + 200, _cy - 40, 0, 1.6);
        draw_brasa(_cx, _cy + 20, 0, 1, _s);
        draw_cat(_cx - 140, _cy, 1, 0, false, _s);
        draw_cat(_cx + 140, _cy + 30, -1, 0, false, _s);
    }
}

function screen_draw_main_menu(_menu) {
    screen_background();
    screen_scene("intro");
    screen_title("MOTODOG VS MOUSE", 260);
    _menu.draw(SCREEN_W / 2, 340);
    screen_hint("Setas para escolher · Enter para confirmar");
}

function screen_draw_help() {
    screen_background();
    screen_title("Como jogar", 60, 2.4);
    screen_paragraphs(screen_text_help(), 110);
    screen_hint("Enter ou Esc para voltar");
}

function screen_draw_intro() {
    screen_background();
    screen_scene("intro");
    screen_paragraphs(screen_text_intro(), 240);
    screen_hint("Pressione Enter para iniciar a missão");
}

function screen_draw_pause(_menu) {
    draw_set_colour(#0A101A);
    draw_set_alpha(0.7);
    draw_rectangle(0, 0, SCREEN_W, SCREEN_H, false);
    draw_set_alpha(1);
    screen_title("PAUSA", 190);
    _menu.draw(SCREEN_W / 2, 270);
}

function screen_draw_result(_result, _menu) {
    var _won = (_result == MissionResult.VICTORY);
    screen_background();
    screen_scene(_won ? "victory" : "defeat");
    screen_title(_won ? "VITÓRIA" : "DERROTA", 250, 2.6, _won ? C_HIGHLIGHT : C_DANGER);
    screen_paragraphs(screen_text_result(_result), 290);
    _menu.draw(SCREEN_W / 2, 400);
}
