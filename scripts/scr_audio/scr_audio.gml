// Sons gerados por código (sem arquivos externos): cada efeito é uma lista de amostras
// convertida em um som de buffer.

#macro AUDIO_RATE 22050

function sfx_to_sound(_samples) {
    var _count = array_length(_samples);
    var _buffer = buffer_create(_count * 2, buffer_fixed, 2);
    for (var i = 0; i < _count; i++) {
        buffer_write(_buffer, buffer_s16, round(clamp(_samples[i], -1, 1) * 32767));
    }
    return audio_create_buffer_sound(_buffer, buffer_s16, AUDIO_RATE, 0, _count * 2, audio_mono);
}

// Tom com decaimento. _wave: "square", "triangle", "saw" ou "sine".
function sfx_tone(_freq, _duration, _wave, _volume, _slide_to = _freq, _decay = true) {
    var _count = floor(_duration * AUDIO_RATE);
    var _out = array_create(_count, 0);
    var _phase = 0;
    for (var i = 0; i < _count; i++) {
        var _t = i / _count;
        _phase += lerp(_freq, _slide_to, _t) / AUDIO_RATE;
        var _p = frac(_phase);
        var _sample;
        switch (_wave) {
            case "square": _sample = _p < 0.5 ? 1 : -1; break;
            case "triangle": _sample = 1 - 4 * abs(_p - 0.5); break;
            case "saw": _sample = 2 * _p - 1; break;
            default: _sample = sin(2 * pi * _phase); break;
        }
        var _envelope = _decay ? power(0.001, _t) : 1;
        _out[i] = _sample * _volume * _envelope;
    }
    return _out;
}

// Ruído suavizado (quanto menor _smooth, mais grave).
function sfx_noise(_duration, _volume, _smooth, _decay = true) {
    var _count = floor(_duration * AUDIO_RATE);
    var _out = array_create(_count, 0);
    var _value = 0;
    for (var i = 0; i < _count; i++) {
        _value += _smooth * (random_range(-1, 1) - _value);
        var _envelope = _decay ? power(0.001, i / _count) : 1;
        _out[i] = _value * _volume * _envelope;
    }
    return _out;
}

// Sequência de notas (usada nos sons de vitória e derrota).
function sfx_melody(_freqs, _note_duration, _gap) {
    var _out = array_create(floor((_gap * (array_length(_freqs) - 1) + _note_duration) * AUDIO_RATE), 0);
    for (var n = 0; n < array_length(_freqs); n++) {
        var _note = sfx_tone(_freqs[n], _note_duration, "triangle", 0.4);
        var _offset = floor(n * _gap * AUDIO_RATE);
        for (var i = 0; i < array_length(_note); i++) _out[_offset + i] += _note[i];
    }
    return _out;
}

function audio_build_sounds() {
    return {
        step: sfx_to_sound(sfx_noise(0.06, 0.8, 0.2)),
        attack: sfx_to_sound(sfx_noise(0.12, 1.0, 0.6)),
        stun: sfx_to_sound(sfx_tone(600, 0.15, "triangle", 0.4, 300)),
        collect: sfx_to_sound(array_concat(sfx_tone(520, 0.1, "triangle", 0.4), sfx_tone(780, 0.18, "triangle", 0.4))),
        damage: sfx_to_sound(sfx_tone(180, 0.3, "saw", 0.35, 70)),
        select: sfx_to_sound(sfx_tone(440, 0.06, "square", 0.15)),
        victory: sfx_to_sound(sfx_melody([523, 659, 784, 1047], 0.3, 0.15)),
        defeat: sfx_to_sound(sfx_melody([392, 330, 262, 196], 0.35, 0.2)),
        wind: sfx_to_sound(sfx_noise(3, 3.0, 0.05, false)), // vento contínuo
        drone: sfx_to_sound(sfx_tone(55, 1, "sine", 0.5, 55, false)), // música ambiente discreta
    };
}

function sound_play(_sound) {
    audio_play_sound(_sound, 1, false);
}

function audio_ambient_start() {
    audio_ambient_stop();
    global.ambient = [
        audio_play_sound(global.sounds.wind, 0, true, 0.5),
        audio_play_sound(global.sounds.drone, 0, true, 0.3),
    ];
}

function audio_ambient_stop() {
    for (var i = 0; i < array_length(global.ambient); i++) audio_stop_sound(global.ambient[i]);
    global.ambient = [];
}
