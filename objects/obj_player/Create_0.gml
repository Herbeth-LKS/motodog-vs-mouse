/// Brasa: anda nas quatro direções, aplica um golpe curto e tem três corações.
size = PLAYER_SIZE;
hearts = PLAYER_MAX_HEARTS;
face_x = 0;
face_y = 1;
invulnerable_timer = 0;
attack_timer = 0;
attack_cooldown = 0;
step_timer = 0;

// Retorna a área atingida pelo golpe, ou undefined se o golpe ainda estiver em recarga.
try_attack = function() {
    if (attack_cooldown > 0) return undefined;
    attack_cooldown = ATTACK_COOLDOWN;
    attack_timer = ATTACK_DURATION;

    var _reach = size / 2 + ATTACK_RANGE / 2;
    var _cx = x + face_x * _reach;
    var _cy = y + face_y * _reach;
    var _half_w = (face_x != 0 ? ATTACK_RANGE : size + 16) / 2;
    var _half_h = (face_y != 0 ? ATTACK_RANGE : size + 16) / 2;
    return { x1: _cx - _half_w, y1: _cy - _half_h, x2: _cx + _half_w, y2: _cy + _half_h };
};

// Retorna true se o dano foi aplicado (fora do período de proteção).
take_hit = function() {
    if (invulnerable_timer > 0) return false;
    hearts -= 1;
    invulnerable_timer = PLAYER_INVULNERABLE_TIME;
    return true;
};
