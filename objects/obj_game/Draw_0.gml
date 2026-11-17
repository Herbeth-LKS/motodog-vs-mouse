/// O cenário é desenhado aqui. Como o obj_game tem depth maior que os personagens
/// (definido no Create), ele fica por baixo de todos eles.
if (state == GameState.PLAYING || state == GameState.PAUSED) {
    level_draw(global.level);
}
