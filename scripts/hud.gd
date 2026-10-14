extends CanvasLayer

@onready var hearts: Label = $Hearts
@onready var boss_bar: ProgressBar = $BossBar
@onready var boss_name: Label = $BossBar/Name
@onready var msg: Label = $Message

func _ready() -> void:
	Game.player_hp_changed.connect(_hp)
	Game.boss_hp_changed.connect(_boss)
	Game.message.connect(_msg)
	_hp(Game.player_hp, Game.MAX_HP)
	boss_bar.visible = false
	msg.visible = false
	call_deferred("_sync_boss")

func _sync_boss() -> void:
	var b := get_tree().get_first_node_in_group("boss")
	if b:
		_boss(b.hp, b.max_hp, Game.WORLDS[b.boss_id]["boss"])

func _hp(hp: int, max_hp: int) -> void:
	hearts.text = "♥".repeat(hp) + "♡".repeat(max_hp - hp)

func _boss(hp: int, max_hp: int, bname: String) -> void:
	boss_bar.visible = hp > 0
	boss_bar.max_value = max_hp
	boss_bar.value = hp
	boss_name.text = bname

func _msg(text: String) -> void:
	msg.text = text
	msg.visible = true
	var t := create_tween()
	t.tween_interval(2.0)
	t.tween_callback(func(): msg.visible = false)
