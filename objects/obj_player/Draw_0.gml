// Arco branco do golpe
if (attack_timer > 0) {
    var _angle = facing_angle(face_x, face_y);
    var _radius = size / 2 + ATTACK_RANGE * 0.7;
    for (var _a = -45; _a < 45; _a += 9) {
        var _a1 = _angle + _a;
        var _a2 = _angle + _a + 9;
        shape_line(x + lengthdir_x(_radius, _a1), y + lengthdir_y(_radius, _a1),
            x + lengthdir_x(_radius, _a2), y + lengthdir_y(_radius, _a2), 5, c_white);
    }
}

// Pisca enquanto está protegido após o dano.
var _blinking = invulnerable_timer > 0 && (invulnerable_timer div 6) mod 2 == 0;
if (!_blinking) draw_brasa(x, y, face_x, face_y);
