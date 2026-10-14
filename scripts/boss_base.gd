class_name BossBase
extends CharacterBody2D
## Base para chefes: vida, dano recebido, morte. Filhos implementam o comportamento.

@export var boss_id := "triassico"
@export var max_hp := 20
@export var contact_damage := 1

var hp: int
var dead := false
var flash := 0.0

@onready var visual: Node2D = $Visual
@onready var player: Node2D = get_tree().get_first_node_in_group("player")

func _ready() -> void:
	hp = max_hp
	add_to_group("boss")
	Game.boss_hp_changed.emit(hp, max_hp, Game.WORLDS[boss_id]["boss"])

func take_hit(damage: int, _from: Vector2) -> void:
	if dead:
		return
	hp = max(0, hp - damage)
	flash = 0.08
	visual.modulate = Color(1, 0.3, 0.3)
	Game.boss_hp_changed.emit(hp, max_hp, Game.WORLDS[boss_id]["boss"])
	if hp == 0:
		die()

func _tick_flash(delta: float) -> void:
	if flash > 0:
		flash -= delta
		if flash <= 0:
			visual.modulate = Color.WHITE

func die() -> void:
	dead = true
	velocity = Vector2.ZERO
	set_collision_layer_value(3, false)
	for c in get_children():
		if c is Hitbox:
			c.monitoring = false
	var t := create_tween()
	t.tween_property(visual, "rotation", deg_to_rad(90), 0.6)
	t.parallel().tween_property(visual, "modulate", Color(0.2, 0.2, 0.2), 0.6)
	Game.on_boss_defeated(boss_id)

func dir_to_player() -> int:
	if player == null:
		return 1
	return 1 if player.global_position.x > global_position.x else -1
