if (obj_game.state != GameState.PLAYING) exit;

// Atordoado: não se move nem causa dano.
if (stun_timer > 0) {
    stun_timer -= 1;
    exit;
}

var _player = obj_player;
var _dist = point_distance(x, y, _player.x, _player.y);
if (enemy_state != EnemyState.CHASE && _dist < detect_range) {
    enemy_state = EnemyState.CHASE;
} else if (enemy_state == EnemyState.CHASE && _dist > lose_range) {
    enemy_state = EnemyState.RETURN;
}

if (enemy_state == EnemyState.CHASE) {
    move_toward(_player.x, _player.y);
} else if (enemy_state == EnemyState.RETURN) {
    if (move_toward(home_x, home_y)) enemy_state = EnemyState.IDLE;
}

// Dano por contato
if (rect_overlap(entity_rect(id), entity_rect(_player)) && _player.take_hit()) {
    sound_play(global.sounds.damage);
}
