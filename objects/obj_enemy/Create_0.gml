/// Gatos infectados e Nilo compartilham o mesmo comportamento: ficar no lugar,
/// perseguir quando Brasa chega perto e voltar quando ele se afasta.
/// A variável is_nilo é informada na criação (instance_create_layer).
size = is_nilo ? NILO_SIZE : CAT_SIZE;
move_speed = is_nilo ? NILO_SPEED : CAT_SPEED;
detect_range = is_nilo ? NILO_DETECT_RANGE : CAT_DETECT_RANGE;
lose_range = is_nilo ? NILO_LOSE_RANGE : CAT_LOSE_RANGE;

home_x = x;
home_y = y;
face_x = 0;
face_y = 1;
enemy_state = EnemyState.IDLE;
stun_timer = 0;

// Move em direção ao alvo. Retorna true quando já chegou.
move_toward = function(_tx, _ty) {
    var _dist = point_distance(x, y, _tx, _ty);
    if (_dist < 2) return true;
    var _step = min(move_speed, _dist);
    face_x = (_tx - x) / _dist;
    face_y = (_ty - y) / _dist;
    entity_move(face_x * _step, face_y * _step);
    return false;
};

stun = function() {
    stun_timer = STUN_TIME;
    enemy_state = EnemyState.RETURN; // ao acordar, volta para sua área
};
