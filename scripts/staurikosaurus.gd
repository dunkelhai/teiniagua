extends BossBase
## Staurikosaurus pricei, o dinossauro de Santa Maria.
## Ciclo: espreita → investida → (às vezes) salto com queda → recua.

enum State { IDLE, CHARGE, LEAP, RECOVER }

const WALK := 70.0
const CHARGE_SPEED := 330.0
const LEAP_V := Vector2(230, -520)

var state := State.IDLE
var timer := 1.2
var charges := 0

@onready var bite: Hitbox = $Visual/Bite

func _physics_process(delta: float) -> void:
	_tick_flash(delta)
	if dead:
		velocity.y += get_gravity().y * delta
		move_and_slide()
		return
	if not is_on_floor():
		velocity.y += get_gravity().y * delta
	timer -= delta
	var d := dir_to_player()
	match state:
		State.IDLE:
			visual.scale.x = d
			velocity.x = move_toward(velocity.x, d * WALK, 600 * delta)
			bite.monitoring = false
			if timer <= 0:
				if charges >= 2 and randf() < 0.6:
					_start_leap(d)
				else:
					_start_charge(d)
		State.CHARGE:
			velocity.x = visual.scale.x * CHARGE_SPEED
			if is_on_wall() or timer <= 0:
				_recover()
		State.LEAP:
			if is_on_floor() and timer < 0.3:
				_shake()
				_recover()
		State.RECOVER:
			velocity.x = move_toward(velocity.x, 0, 900 * delta)
			if timer <= 0:
				state = State.IDLE
				timer = randf_range(0.6, 1.1)
	move_and_slide()

func _start_charge(d: int) -> void:
	state = State.CHARGE
	visual.scale.x = d
	timer = 0.9
	charges += 1
	bite.monitoring = true

func _start_leap(d: int) -> void:
	state = State.LEAP
	visual.scale.x = d
	velocity = Vector2(LEAP_V.x * d, LEAP_V.y)
	timer = 0.5
	charges = 0
	bite.monitoring = true

func _recover() -> void:
	state = State.RECOVER
	timer = 0.7
	bite.monitoring = false

func _shake() -> void:
	var cam := get_viewport().get_camera_2d()
	if cam:
		var t := create_tween()
		for i in 4:
			t.tween_property(cam, "offset", Vector2(randf_range(-4, 4), randf_range(-4, 4)), 0.03)
		t.tween_property(cam, "offset", Vector2.ZERO, 0.03)
