// Constantes e valores de equilíbrio do jogo, concentrados para facilitar ajustes nos testes.
// O jogo roda a 60 quadros por segundo: velocidades em pixels/quadro e tempos em quadros.

#macro FPS 60
#macro SCREEN_W 960
#macro SCREEN_H 540
#macro TILE_SIZE 40

#macro MISSION_TIME 300 // segundos (~5 minutos até a nevasca)
#macro BOX_TOTAL 3

#macro PLAYER_SIZE 26
#macro PLAYER_SPEED 2.7
#macro PLAYER_MAX_HEARTS 3
#macro PLAYER_INVULNERABLE_TIME 90 // proteção breve após o dano (1,5 s)
#macro ATTACK_RANGE 44
#macro ATTACK_DURATION 9
#macro ATTACK_COOLDOWN 30

#macro CAT_SIZE 26
#macro CAT_SPEED 1.6
#macro CAT_DETECT_RANGE 190 // começa a perseguir
#macro CAT_LOSE_RANGE 300 // desiste da perseguição

#macro NILO_SIZE 24
#macro NILO_SPEED 1.9
#macro NILO_DETECT_RANGE 170
#macro NILO_LOSE_RANGE 260

#macro STUN_TIME 150 // 2,5 s
#macro BOX_INTERACT_RANGE 42
#macro BENCH_INTERACT_RANGE 66

// Cores
#macro C_SNOW #E6EDF4
#macro C_TRAIL #C9D5E1
#macro C_AREA #EEF3F8
#macro C_WORKSHOP #C98F57
#macro C_WORKSHOP_LINES #B07A46
#macro C_LABEL #6B7D90
#macro C_TEXT #F2F5F8
#macro C_TEXT_DIM #A9B8C8
#macro C_HIGHLIGHT #F0A050
#macro C_PANEL #101824
#macro C_BACKGROUND #18222F
#macro C_HEART #E0473C
#macro C_HEART_LOST #5A6470
#macro C_DANGER #FF6B5B

enum GameState {
    MENU,
    HELP,
    INTRO,
    PLAYING,
    PAUSED,
    RESULT
}

enum MissionResult {
    NONE,
    VICTORY,
    DEAD,
    TIMEOUT
}

enum Tile {
    OPEN,
    TREE,
    ROCK,
    PROP
}

enum EnemyState {
    IDLE,
    CHASE,
    RETURN
}
