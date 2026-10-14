# Teiniaguá

Plataforma de ação 2D com chefes, feita em Godot 4.7. Um gaúcho missioneiro atravessa as ruínas de São Miguel e enfrenta os mundos da Teiniaguá.

## Rodar
Abra a pasta no Godot 4.7+ e aperte F5, ou:

```bash
/Applications/Godot.app/Contents/MacOS/Godot --path .
```

## Controles
| Ação | Teclado | Controle |
|---|---|---|
| Mover | A / D ou setas | Analógico |
| Pular | Espaço / W | A |
| Facão | J | X |
| Dash | K / Shift | B |
| Entrar no portal | E / Enter | Y |

## Estrutura
- `scenes/player` — personagem
- `scenes/hub` — ruínas com os portais
- `scenes/levels` — fases de cada mundo
- `scenes/bosses` — chefes
- `scenes/ui` — HUD
- `scripts/` — GDScript
- `docs/GDD.md` — design do jogo · `docs/ROADMAP.md` — caminho até a Steam
