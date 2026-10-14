extends Area2D
## Portal no hub. Aperte interagir dentro dele para entrar no mundo.

@export var world_id := "triassico"
var inside := false

@onready var label: Label = $Label

func _ready() -> void:
	body_entered.connect(func(b): if b.is_in_group("player"): inside = true; label.visible = true)
	body_exited.connect(func(b): if b.is_in_group("player"): inside = false; label.visible = false)
	label.visible = false
	var w: Dictionary = Game.WORLDS[world_id]
	label.text = w["name"] + ("  ✓" if Game.defeated.has(world_id) else "")
	if Game.defeated.has(world_id):
		modulate = Color(0.5, 0.5, 0.5)

func _unhandled_input(event: InputEvent) -> void:
	if inside and event.is_action_pressed("interact"):
		Game.enter_world(world_id)
