# Motodog vs Mouse

Implementação do GDD *Motodog vs Mouse* (versão 1.1) para a disciplina Desenvolvimento de Jogos.
Jogo 2D de ação e sobrevivência com visão de cima, feito no **GameMaker** com GML.

## Executar

1. Abra `MotodogVsMouse.yyp` no GameMaker. O projeto foi compilado com o GameMaker LTS2026, runtime 2026.0.0.23.
2. Escolha o destino de execução local da sua instalação e pressione **F5**.

O projeto não usa sprites, sons importados, extensões nem bibliotecas externas. Os personagens e o cenário são desenhados com formas primitivas, e os sons são gerados por código. A fonte (DejaVu Sans, com acentos) está incluída como recurso.

## Controles

| Tecla | Ação |
|---|---|
| W, A, S, D | Mover Brasa |
| E | Recolher caixa / entregar na bancada |
| Espaço | Golpe curto na última direção de movimento (atordoa o inimigo) |
| Esc | Pausar |
| Setas + Enter | Navegar nos menus |

## Regras (Quadro 1 do GDD)

- Recolha as 3 caixas (Depósito, Trilha e Mirante) em qualquer ordem e entregue-as na bancada da oficina.
- 3 corações: cada contato com um gato infectado ou com o Nilo tira um coração, seguido de 1,5 s de proteção.
- 5 minutos até a nevasca. O relógio começa depois da abertura, e a pausa congela o relógio e a ação.
- Derrota: perder os 3 corações ou deixar o tempo acabar. "Tentar novamente" recria a fase com vida, tempo, caixas e inimigos restaurados.

## Organização

| Recurso | Responsabilidade |
|---|---|
| `rm_game` | Sala única (2400×1600) com câmera de 960×540. Contém apenas o `obj_game`. |
| `obj_game` | Controlador: estados das telas, regras da missão, câmera, cenário e interface. |
| `obj_player` | Brasa: movimento com colisão, golpe, corações e proteção após o dano. |
| `obj_enemy` | Gatos infectados e Nilo (mesmo comportamento; `is_nilo` muda aparência e valores). |
| `obj_box` | Caixa de materiais, removida ao ser recolhida. |
| `scr_config` | Macros de equilíbrio (tempo, velocidades, alcances), cores e enums. |
| `scr_level` | Dados do mapa (Figura 4 do GDD), grade de colisão e desenho do cenário. |
| `scr_mission` | Início, atualização, interação, vitória/derrota e reinício da missão. |
| `scr_menu` | Construtor `Menu`, reutilizado pelo menu inicial, pela pausa e pelo resultado. |
| `scr_screens` | Menu inicial, ajuda, telas narrativas, pausa e resultado. |
| `scr_hud` | Vida, tempo, materiais e mensagem de interação junto ao personagem. |
| `scr_sprites` | Desenhos de Brasa, Nilo, gatos, caixa, bancada, moto, árvores e rochas. |
| `scr_audio` | Efeitos (passos, coleta, golpe, dano, resultado) e som ambiente gerados por código. |
| `scr_snow` | Neve caindo na tela. |
| `scr_utils` | Funções auxiliares (retângulos de colisão, formatação do tempo). |

Os valores de equilíbrio ficam em `scr_config`, e as posições do mapa, das caixas e dos inimigos ficam em `level_create()`, no `scr_level`. Assim dá para ajustar a dificuldade sem mexer na lógica.
