/// Fim do Draw: mensagem de interação junto ao personagem, acima de tudo no mundo.
if (state == GameState.PLAYING && interaction != undefined && instance_exists(obj_player)) {
    hud_prompt(interaction.text, obj_player.x, obj_player.y - 36);
}
