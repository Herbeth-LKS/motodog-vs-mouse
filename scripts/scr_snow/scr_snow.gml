// Flocos de neve desenhados sobre a tela para reforçar o clima da nevasca.

function snow_create(_count) {
    var _flakes = array_create(_count);
    for (var i = 0; i < _count; i++) _flakes[i] = snow_new_flake(random(SCREEN_H));
    return _flakes;
}

function snow_new_flake(_y) {
    return {
        x: random(SCREEN_W),
        y: _y,
        radius: random_range(1, 3),
        fall: random_range(0.5, 1.3),
        drift: random_range(-0.4, 0.25),
    };
}

function snow_update(_flakes) {
    for (var i = 0; i < array_length(_flakes); i++) {
        var _f = _flakes[i];
        _f.y += _f.fall;
        _f.x += _f.drift;
        if (_f.y > SCREEN_H) _flakes[i] = snow_new_flake(-5);
        else if (_f.x < 0) _f.x += SCREEN_W;
        else if (_f.x > SCREEN_W) _f.x -= SCREEN_W;
    }
}

function snow_draw(_flakes) {
    draw_set_colour(c_white);
    draw_set_alpha(0.85);
    for (var i = 0; i < array_length(_flakes); i++) {
        var _f = _flakes[i];
        draw_circle(_f.x, _f.y, _f.radius, false);
    }
    draw_set_alpha(1);
}
