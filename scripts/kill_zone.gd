extends Area2D
## Cair aqui = voltar pro hub.

func _ready() -> void:
	body_entered.connect(func(b): if b.is_in_group("player"): Game.damage_player(Game.MAX_HP))
