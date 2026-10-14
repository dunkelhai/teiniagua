class_name Hurtbox
extends Area2D
## Área que recebe dano. O dono precisa implementar take_hit(damage, from_position).

@export var owner_path: NodePath

func _ready() -> void:
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		var target := get_parent() if owner_path.is_empty() else get_node(owner_path)
		if target.has_method("take_hit"):
			target.take_hit(area.damage, area.global_position)
