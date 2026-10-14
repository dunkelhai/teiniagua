extends Node
## Estado global: vida do jogador entre cenas, chefes derrotados, troca de fase.

signal player_hp_changed(hp: int, max_hp: int)
signal boss_hp_changed(hp: int, max_hp: int, boss_name: String)
signal boss_defeated(boss_id: String)
signal message(text: String)

const MAX_HP := 5

var player_hp: int = MAX_HP
var defeated: Dictionary = {}   # boss_id -> true
var current_boss: Node = null

const WORLDS := {
	"triassico": {"name": "Triássico de Santa Maria", "scene": "res://scenes/levels/triassico.tscn", "boss": "Staurikosaurus"},
	"pampa":     {"name": "Pampa Negro",               "scene": "",                                   "boss": "Negrinho do Pastoreio"},
	"lagoa":     {"name": "Lagoa Afogada",             "scene": "",                                   "boss": "Tubarão da Capela"},
	"yomi":      {"name": "Yomi",                      "scene": "",                                   "boss": "Nure-onna"},
	"pista":     {"name": "A Pista",                   "scene": "",                                   "boss": "A Diva"},
}

func damage_player(amount: int) -> void:
	player_hp = max(0, player_hp - amount)
	player_hp_changed.emit(player_hp, MAX_HP)
	if player_hp == 0:
		await get_tree().create_timer(1.2).timeout
		heal_full()
		go_to_hub()

func heal_full() -> void:
	player_hp = MAX_HP
	player_hp_changed.emit(player_hp, MAX_HP)

func enter_world(id: String) -> void:
	var w: Dictionary = WORLDS.get(id, {})
	if w.is_empty() or w["scene"] == "":
		message.emit("%s — em construção" % w.get("name", id))
		return
	get_tree().call_deferred("change_scene_to_file", w["scene"])

func go_to_hub() -> void:
	get_tree().call_deferred("change_scene_to_file", "res://scenes/hub/hub.tscn")

func on_boss_defeated(boss_id: String) -> void:
	defeated[boss_id] = true
	boss_defeated.emit(boss_id)
	message.emit("%s derrotado" % WORLDS[boss_id]["boss"])
	await get_tree().create_timer(2.5).timeout
	heal_full()
	go_to_hub()

# --- utilitário de desenvolvimento: `godot --path . cena.tscn -- --shot=/caminho.png [--frames=N]` ---
func _ready() -> void:
	var shot := ""
	var frames := 30
	for a in OS.get_cmdline_user_args():
		if a.begins_with("--shot="):
			shot = a.trim_prefix("--shot=")
		elif a.begins_with("--frames="):
			frames = int(a.trim_prefix("--frames="))
	if shot != "":
		for i in frames:
			await get_tree().process_frame
		get_viewport().get_texture().get_image().save_png(shot)
		get_tree().quit()
