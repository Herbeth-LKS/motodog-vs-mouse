// Funções auxiliares pequenas usadas por vários objetos.

// Retângulo de colisão de uma instância com centro (x, y) e lado "size".
function entity_rect(_inst) {
    var _half = _inst.size / 2;
    return { x1: _inst.x - _half, y1: _inst.y - _half, x2: _inst.x + _half, y2: _inst.y + _half };
}

function rect_overlap(_a, _b) {
    return _a.x1 < _b.x2 && _a.x2 > _b.x1 && _a.y1 < _b.y2 && _a.y2 > _b.y1;
}

function format_time(_seconds) {
    var _total = max(0, ceil(_seconds));
    var _minutes = _total div 60;
    var _secs = _total mod 60;
    return string_replace_all(string_format(_minutes, 2, 0), " ", "0") + ":"
        + string_replace_all(string_format(_secs, 2, 0), " ", "0");
}

function menu_confirm_pressed() {
    return keyboard_check_pressed(vk_enter);
}
