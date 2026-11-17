/// Controlador do jogo: telas, menus, regras da missão, câmera e interface.
randomize();
depth = 100; // desenha o cenário atrás dos personagens (depth 0)
display_set_gui_size(SCREEN_W, SCREEN_H);
draw_set_circle_precision(24);

global.level = level_create();
global.sounds = audio_build_sounds();
global.ambient = [];

state = GameState.MENU;
result = MissionResult.NONE;

main_menu = new Menu(["Jogar", "Como jogar", "Sair"]);
pause_menu = new Menu(["Continuar", "Menu inicial"]);
result_menu = new Menu(["Tentar novamente", "Menu inicial"]);

// Dados da tentativa atual (reiniciados em mission_start)
time_left = MISSION_TIME;
collected = 0;
delivered = false;
interaction = undefined;

snow = snow_create(90);
