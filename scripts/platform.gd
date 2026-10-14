@tool
extends StaticBody2D
## Bloco sólido simples. Define `size` e `color` no inspetor; colisão e desenho são gerados.

@export var size := Vector2(120, 16):
	set(v):
		size = v
		_rebuild()
		queue_redraw()
@export var color := Color(0.16, 0.15, 0.18):
	set(v):
		color = v
		queue_redraw()

var _shape: CollisionShape2D

func _ready() -> void:
	collision_layer = 1
	collision_mask = 0
	_rebuild()

func _rebuild() -> void:
	if not is_inside_tree():
		return
	if _shape == null:
		_shape = CollisionShape2D.new()
		_shape.shape = RectangleShape2D.new()
		add_child(_shape)
	_shape.shape.size = size
	_shape.position = size / 2

func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), color)
	draw_rect(Rect2(Vector2.ZERO, Vector2(size.x, 3)), color.lightened(0.18))
