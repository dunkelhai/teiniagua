extends CharacterBody2D
## O gaúcho missioneiro. Corre, pula, dá dash e golpeia com o facão.

const SPEED := 150.0
const ACCEL := 1400.0
const JUMP_VELOCITY := -420.0
const DASH_SPEED := 380.0
const DASH_TIME := 0.16
const DASH_COOLDOWN := 0.45
const COYOTE_TIME := 0.1
const JUMP_BUFFER := 0.12
const ATTACK_TIME := 0.22
const INVULN_TIME := 0.8

var facing := 1
var coyote := 0.0
var jump_buffer := 0.0
var dash_timer := 0.0
var dash_cooldown := 0.0
var attack_timer := 0.0
var invuln := 0.0
var dead := false

@onready var hitbox: Hitbox = $Visual/Hitbox
@onready var hitbox_shape: CollisionShape2D = $Visual/Hitbox/CollisionShape2D
@onready var visual: Node2D = $Visual
@onready var facao: Node2D = $Visual/Facao

func _ready() -> void:
	hitbox.monitoring = false
	add_to_group("player")

func _physics_process(delta: float) -> void:
	if dead:
		velocity.x = move_toward(velocity.x, 0, ACCEL * delta)
		velocity.y += get_gravity().y * delta
		move_and_slide()
		return

	coyote = COYOTE_TIME if is_on_floor() else coyote - delta
	jump_buffer = JUMP_BUFFER if Input.is_action_just_pressed("jump") else jump_buffer - delta
	dash_cooldown -= delta
	invuln -= delta
	visual.modulate.a = 0.5 if invuln > 0 and int(invuln * 20) % 2 == 0 else 1.0

	var dir := Input.get_axis("move_left", "move_right")
	if dir != 0 and dash_timer <= 0:
		facing = int(signf(dir))
		visual.scale.x = facing

	if dash_timer > 0:
		dash_timer -= delta
		velocity.x = facing * DASH_SPEED
		velocity.y = 0
	else:
		if not is_on_floor():
			velocity.y += get_gravity().y * delta
		velocity.x = move_toward(velocity.x, dir * SPEED, ACCEL * delta)
		if jump_buffer > 0 and coyote > 0:
			velocity.y = JUMP_VELOCITY
			jump_buffer = 0
			coyote = 0
		if Input.is_action_just_released("jump") and velocity.y < 0:
			velocity.y *= 0.45
		if Input.is_action_just_pressed("dash") and dash_cooldown <= 0:
			dash_timer = DASH_TIME
			dash_cooldown = DASH_COOLDOWN
			invuln = max(invuln, DASH_TIME)

	if attack_timer > 0:
		attack_timer -= delta
		facao.rotation = lerp(-1.4, 0.9, 1.0 - attack_timer / ATTACK_TIME)
		if attack_timer <= 0:
			hitbox.monitoring = false
			facao.rotation = -0.6
	elif Input.is_action_just_pressed("attack"):
		attack_timer = ATTACK_TIME
		hitbox.monitoring = true

	move_and_slide()

func take_hit(damage: int, from: Vector2) -> void:
	if invuln > 0 or dead:
		return
	invuln = INVULN_TIME
	var knock := int(signf(global_position.x - from.x))
	if knock == 0:
		knock = -facing
	velocity = Vector2(knock * 220, -260)
	Game.damage_player(damage)
	if Game.player_hp == 0:
		dead = true
		visual.rotation = deg_to_rad(90)
