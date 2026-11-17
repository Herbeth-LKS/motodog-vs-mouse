if (is_nilo) draw_nilo(x, y, face_x, face_y);
else draw_cat(x, y, face_x, face_y);

if (stun_timer > 0) draw_stun_stars(x, y - 20);
