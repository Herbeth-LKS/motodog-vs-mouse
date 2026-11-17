// Regras de uma tentativa da missão. Estas funções são chamadas pelo obj_game
// e usam as variáveis dele (time_left, collected, delivered...).

// Cria (ou recria) a fase com vida, tempo, caixas e inimigos restaurados.
function mission_start() {
    mission_clear();
    var _level = global.level;

    var _start = level_tile_center(_level.player_start[0], _level.player_start[1]);
    instance_create_layer(_start.x, _start.y, "Instances", obj_player);

    for (var i = 0; i < array_length(_level.cats); i++) {
        var _pos = level_tile_center(_level.cats[i][0], _level.cats[i][1]);
        instance_create_layer(_pos.x, _pos.y, "Instances", obj_enemy, { is_nilo: false });
    }
    var _nilo = level_tile_center(_level.nilo[0], _level.nilo[1]);
    instance_create_layer(_nilo.x, _nilo.y, "Instances", obj_enemy, { is_nilo: true });

    for (var i = 0; i < array_length(_level.boxes); i++) {
        var _pos = level_tile_center(_level.boxes[i][0], _level.boxes[i][1]);
        instance_create_layer(_pos.x, _pos.y, "Instances", obj_box);
    }

    time_left = MISSION_TIME;
    collected = 0;
    delivered = false;
    interaction = undefined;
    state = GameState.PLAYING;
    camera_follow_player();
    audio_ambient_start();
}

function mission_clear() {
    instance_destroy(obj_player);
    instance_destroy(obj_enemy);
    instance_destroy(obj_box);
}

// Atualiza um quadro. Retorna o MissionResult da partida.
function mission_update() {
    time_left -= 1 / FPS;
    if (time_left <= 0) {
        time_left = 0;
        return MissionResult.TIMEOUT;
    }
    if (obj_player.hearts <= 0) return MissionResult.DEAD;

    mission_handle_attack();

    interaction = mission_find_interaction();
    if (interaction != undefined && keyboard_check_pressed(ord("E"))) mission_interact(interaction);

    return delivered ? MissionResult.VICTORY : MissionResult.NONE;
}

function mission_handle_attack() {
    if (!keyboard_check_pressed(vk_space)) return;
    var _hit_area = obj_player.try_attack();
    if (_hit_area == undefined) return;

    sound_play(global.sounds.attack);
    with (obj_enemy) {
        if (rect_overlap(_hit_area, entity_rect(id))) {
            stun();
            sound_play(global.sounds.stun);
        }
    }
}

// Descobre se há uma caixa ou a bancada ao alcance de Brasa.
function mission_find_interaction() {
    var _px = obj_player.x;
    var _py = obj_player.y;

    var _box = instance_nearest(_px, _py, obj_box);
    if (_box != noone && point_distance(_px, _py, _box.x, _box.y) < BOX_INTERACT_RANGE) {
        return { text: "E - recolher", kind: "collect", target: _box };
    }

    var _bench = global.level.bench_center;
    if (point_distance(_px, _py, _bench.x, _bench.y) < BENCH_INTERACT_RANGE) {
        if (collected == BOX_TOTAL) return { text: "E - entregar", kind: "deliver", target: noone };
        return { text: "Reúna os materiais (" + string(collected) + "/" + string(BOX_TOTAL) + ")", kind: "none", target: noone };
    }
    return undefined;
}

function mission_interact(_interaction) {
    if (_interaction.kind == "collect") {
        instance_destroy(_interaction.target);
        collected += 1;
        sound_play(global.sounds.collect);
    } else if (_interaction.kind == "deliver") {
        delivered = true;
    }
}

function mission_finish(_result) {
    audio_ambient_stop();
    sound_play(_result == MissionResult.VICTORY ? global.sounds.victory : global.sounds.defeat);
    mission_clear();
    result = _result;
    result_menu.reset();
    state = GameState.RESULT;
}

// Voltar ao menu encerra a tentativa atual.
function mission_quit() {
    audio_ambient_stop();
    mission_clear();
    main_menu.reset();
    state = GameState.MENU;
}

// Câmera de visão superior que acompanha Brasa e para nos limites do mapa.
function camera_follow_player() {
    if (!instance_exists(obj_player)) return;
    var _x = clamp(obj_player.x - SCREEN_W / 2, 0, room_width - SCREEN_W);
    var _y = clamp(obj_player.y - SCREEN_H / 2, 0, room_height - SCREEN_H);
    camera_set_view_pos(view_camera[0], _x, _y);
}
