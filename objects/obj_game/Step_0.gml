/// Máquina de estados das telas.
switch (state) {
    case GameState.MENU:
        var _choice = main_menu.update();
        if (_choice == 0) state = GameState.INTRO;
        if (_choice == 1) state = GameState.HELP;
        if (_choice == 2) game_end();
        break;

    case GameState.HELP:
        if (menu_confirm_pressed() || keyboard_check_pressed(vk_escape)) state = GameState.MENU;
        break;

    case GameState.INTRO:
        // O relógio só começa depois da abertura.
        if (menu_confirm_pressed()) mission_start();
        break;

    case GameState.PLAYING:
        if (keyboard_check_pressed(vk_escape)) {
            pause_menu.reset();
            state = GameState.PAUSED;
            break;
        }
        var _result = mission_update();
        if (_result != MissionResult.NONE) mission_finish(_result);
        break;

    case GameState.PAUSED:
        // A pausa congela relógio e ação: nada da missão é atualizado aqui.
        if (keyboard_check_pressed(vk_escape)) {
            state = GameState.PLAYING;
            break;
        }
        var _pause_choice = pause_menu.update();
        if (_pause_choice == 0) state = GameState.PLAYING;
        if (_pause_choice == 1) mission_quit();
        break;

    case GameState.RESULT:
        var _result_choice = result_menu.update();
        if (_result_choice == 0) mission_start();
        if (_result_choice == 1) mission_quit();
        break;
}
