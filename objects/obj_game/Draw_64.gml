/// Interface fixa na tela e telas de menu.
switch (state) {
    case GameState.MENU: screen_draw_main_menu(main_menu); break;
    case GameState.HELP: screen_draw_help(); break;
    case GameState.INTRO: screen_draw_intro(); break;
    case GameState.RESULT: screen_draw_result(result, result_menu); break;

    case GameState.PLAYING:
    case GameState.PAUSED:
        snow_draw(snow);
        hud_draw(obj_player.hearts, time_left, collected);
        if (state == GameState.PAUSED) screen_draw_pause(pause_menu);
        break;
}
