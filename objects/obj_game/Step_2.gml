/// Fim do Step: a câmera segue Brasa depois que todos se moveram.
if (state == GameState.PLAYING) {
    camera_follow_player();
    snow_update(snow);
}
