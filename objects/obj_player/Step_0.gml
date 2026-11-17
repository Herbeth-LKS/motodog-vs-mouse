if (obj_game.state != GameState.PLAYING) exit;

invulnerable_timer = max(0, invulnerable_timer - 1);
attack_timer = max(0, attack_timer - 1);
attack_cooldown = max(0, attack_cooldown - 1);

var _dx = keyboard_check(ord("D")) - keyboard_check(ord("A"));
var _dy = keyboard_check(ord("S")) - keyboard_check(ord("W"));
if (_dx == 0 && _dy == 0) exit;

var _length = point_distance(0, 0, _dx, _dy);
entity_move(_dx / _length * PLAYER_SPEED, _dy / _length * PLAYER_SPEED);

// O golpe sai na última direção principal em que Brasa se moveu.
if (_dx != 0) {
    face_x = _dx;
    face_y = 0;
} else {
    face_x = 0;
    face_y = _dy;
}

step_timer -= 1;
if (step_timer <= 0) {
    sound_play(global.sounds.step);
    step_timer = 20;
}
