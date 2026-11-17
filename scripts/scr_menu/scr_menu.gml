// Lista de opções navegável com as setas e confirmada com Enter.
function Menu(_options) constructor {
    options = _options;
    selected = 0;

    static reset = function() {
        selected = 0;
    };

    // Retorna o índice escolhido quando o jogador confirma, ou -1.
    static update = function() {
        var _count = array_length(options);
        if (keyboard_check_pressed(vk_up)) {
            selected = (selected - 1 + _count) mod _count;
            sound_play(global.sounds.select);
        }
        if (keyboard_check_pressed(vk_down)) {
            selected = (selected + 1) mod _count;
            sound_play(global.sounds.select);
        }
        return menu_confirm_pressed() ? selected : -1;
    };

    static draw = function(_x, _y, _spacing = 44) {
        draw_set_font(fnt_main);
        draw_set_halign(fa_center);
        draw_set_valign(fa_middle);
        for (var i = 0; i < array_length(options); i++) {
            var _item_y = _y + i * _spacing;
            var _is_selected = (i == selected);
            var _col = _is_selected ? C_HIGHLIGHT : C_TEXT_DIM;
            draw_set_colour(_col);
            draw_text_transformed(_x, _item_y, options[i], 1.6, 1.6, 0);
            if (_is_selected) {
                var _half = string_width(options[i]) * 0.8 + 22;
                shape_triangle(_x - _half - 8, _item_y - 7, _x - _half - 8, _item_y + 7, _x - _half + 4, _item_y, _col);
                shape_triangle(_x + _half + 8, _item_y - 7, _x + _half + 8, _item_y + 7, _x + _half - 4, _item_y, _col);
            }
        }
    };
}
