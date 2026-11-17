// Mapa único de Serra Branca (Figura 4 do GDD). Coordenadas em tiles.
// Tudo é floresta, exceto as áreas e trilhas listadas, que são "abertas" no mapa.

function level_create() {
    var _level = {
        cols: 60,
        rows: 40,

        areas: [
            { name: "OFICINA", col: 2, row: 27, w: 13, h: 11, warm: true },
            { name: "DEPÓSITO", col: 2, row: 2, w: 13, h: 9, warm: false },
            { name: "TRILHA", col: 23, row: 11, w: 13, h: 9, warm: false },
            { name: "MIRANTE", col: 43, row: 2, w: 14, h: 10, warm: false },
        ],

        trails: [
            { col: 7, row: 11, w: 3, h: 16 }, // oficina -> depósito
            { col: 15, row: 29, w: 14, h: 3 }, // oficina -> trilha
            { col: 26, row: 20, w: 3, h: 12 },
            { col: 15, row: 34, w: 37, h: 3 }, // oficina -> mirante
            { col: 49, row: 12, w: 3, h: 25 },
        ],

        rocks: [[5, 8], [12, 4], [8, 15], [25, 17], [34, 18], [36, 35], [47, 9], [55, 10], [50, 25]],

        bench: { col: 4, row: 28, w: 2, h: 1 },
        moto: { col: 11, row: 35, w: 2, h: 1 },
        player_start: [8, 32],

        boxes: [[4, 4], [33, 13], [54, 4]], // depósito, trilha, mirante
        cats: [[8, 19], [11, 6], [21, 30], [27, 24], [29, 15], [32, 35], [42, 35], [50, 22], [46, 8]],
        nilo: [53, 6],

        grid: [],
    };

    // Monta a grade de tiles: começa toda com árvores e abre as áreas e trilhas.
    for (var _row = 0; _row < _level.rows; _row++) {
        _level.grid[_row] = array_create(_level.cols, Tile.TREE);
    }
    var _open = array_concat(_level.areas, _level.trails);
    for (var i = 0; i < array_length(_open); i++) {
        level_fill(_level, _open[i], Tile.OPEN);
    }
    for (var i = 0; i < array_length(_level.rocks); i++) {
        var _rock = _level.rocks[i];
        _level.grid[_rock[1]][_rock[0]] = Tile.ROCK;
    }
    level_fill(_level, _level.bench, Tile.PROP);
    level_fill(_level, _level.moto, Tile.PROP);

    _level.bench_center = level_rect_center(_level.bench);
    _level.moto_center = level_rect_center(_level.moto);
    return _level;
}

function level_fill(_level, _rect, _type) {
    for (var _row = _rect.row; _row < _rect.row + _rect.h; _row++) {
        for (var _col = _rect.col; _col < _rect.col + _rect.w; _col++) {
            _level.grid[_row][_col] = _type;
        }
    }
}

function level_tile_center(_col, _row) {
    return { x: (_col + 0.5) * TILE_SIZE, y: (_row + 0.5) * TILE_SIZE };
}

function level_rect_center(_rect) {
    return { x: (_rect.col + _rect.w / 2) * TILE_SIZE, y: (_rect.row + _rect.h / 2) * TILE_SIZE };
}

function level_is_solid(_level, _col, _row) {
    if (_col < 0 || _row < 0 || _col >= _level.cols || _row >= _level.rows) return true;
    return _level.grid[_row][_col] != Tile.OPEN;
}

function level_rect_collides(_level, _rect) {
    var _start_col = floor(_rect.x1 / TILE_SIZE);
    var _end_col = floor((_rect.x2 - 0.01) / TILE_SIZE);
    var _start_row = floor(_rect.y1 / TILE_SIZE);
    var _end_row = floor((_rect.y2 - 0.01) / TILE_SIZE);
    for (var _row = _start_row; _row <= _end_row; _row++) {
        for (var _col = _start_col; _col <= _end_col; _col++) {
            if (level_is_solid(_level, _col, _row)) return true;
        }
    }
    return false;
}

// Move a instância atual separadamente em x e y, para ela deslizar ao encostar em obstáculos.
function entity_move(_dx, _dy) {
    x += _dx;
    if (level_rect_collides(global.level, entity_rect(id))) x -= _dx;
    y += _dy;
    if (level_rect_collides(global.level, entity_rect(id))) y -= _dy;
}

function level_draw(_level) {
    var _ts = TILE_SIZE;
    draw_set_alpha(1);

    draw_set_colour(C_SNOW);
    draw_rectangle(0, 0, _level.cols * _ts, _level.rows * _ts, false);

    draw_set_colour(C_TRAIL);
    for (var i = 0; i < array_length(_level.trails); i++) {
        var _t = _level.trails[i];
        draw_rectangle(_t.col * _ts, _t.row * _ts, (_t.col + _t.w) * _ts, (_t.row + _t.h) * _ts, false);
    }

    for (var i = 0; i < array_length(_level.areas); i++) {
        var _a = _level.areas[i];
        var _x = _a.col * _ts;
        var _y = _a.row * _ts;
        draw_set_colour(_a.warm ? C_WORKSHOP : C_AREA);
        draw_rectangle(_x, _y, _x + _a.w * _ts, _y + _a.h * _ts, false);
        if (_a.warm) {
            draw_set_colour(C_WORKSHOP_LINES); // tábuas do piso
            for (var _r = 1; _r < _a.h; _r++) draw_rectangle(_x, _y + _r * _ts, _x + _a.w * _ts, _y + _r * _ts + 1, false);
        }
    }

    // Só desenha os tiles visíveis pela câmera.
    var _cam = view_camera[0];
    var _view_x = camera_get_view_x(_cam);
    var _view_y = camera_get_view_y(_cam);
    var _start_col = max(0, floor(_view_x / _ts) - 1);
    var _end_col = min(_level.cols - 1, ceil((_view_x + SCREEN_W) / _ts) + 1);
    var _start_row = max(0, floor(_view_y / _ts) - 1);
    var _end_row = min(_level.rows - 1, ceil((_view_y + SCREEN_H) / _ts) + 1);

    for (var _row = _start_row; _row <= _end_row; _row++) {
        for (var _col = _start_col; _col <= _end_col; _col++) {
            var _c = level_tile_center(_col, _row);
            var _tile = _level.grid[_row][_col];
            if (_tile == Tile.TREE) draw_tree(_c.x, _c.y, (_col * 7 + _row * 13) mod 3);
            else if (_tile == Tile.ROCK) draw_rock(_c.x, _c.y);
        }
    }

    draw_bench(_level.bench_center.x, _level.bench_center.y);
    draw_moto(_level.moto_center.x, _level.moto_center.y);

    draw_set_font(fnt_main);
    draw_set_halign(fa_center);
    draw_set_valign(fa_top);
    draw_set_colour(C_LABEL);
    for (var i = 0; i < array_length(_level.areas); i++) {
        var _a = _level.areas[i];
        draw_text((_a.col + _a.w / 2) * _ts, _a.row * _ts + 6, _a.name);
    }
}
