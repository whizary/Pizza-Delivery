extends Node

const SAVE_PATH := "user://settings.save"

# Standardvärden
var data: Dictionary = {
	"audio": {
		"master": 1.0,
		"sfx": 1.0,
		"music": 1.0
	},
	"display": {
		"fullscreen": false,
		"resolution_index": 0
	},
	"gameplay": {
		"vsync": true,
		"particles": true
	}
}

# Samma ordning som i din OptionButton (index matchar)
var resolutions: Array[Vector2i] = [
	Vector2i(1920, 1080),
	Vector2i(2560, 1440),
	Vector2i(1280, 720),
	Vector2i(1600, 900)
]

func _ready() -> void:
	load_settings()
	_sanitize()
	apply_all()

# -------------------- SAVE / LOAD --------------------

func load_settings() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return

	var loaded = file.get_var()
	file.close()

	# Godot 4.5: get_var kan returnera vad som helst (äldre format etc)
	if typeof(loaded) == TYPE_DICTIONARY:
		_merge_dict(data, loaded)
	else:
		# Om du råkat spara fel format tidigare, ignorera istället för att krascha
		return

func save_settings() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_var(data)
	file.close()

func _sanitize() -> void:
	# Se till att allt finns och är rimligt
	if not data.has("audio"): data["audio"] = {}
	if not data.has("display"): data["display"] = {}
	if not data.has("gameplay"): data["gameplay"] = {}

	if not data["audio"].has("master"): data["audio"]["master"] = 1.0
	if not data["audio"].has("sfx"): data["audio"]["sfx"] = 1.0
	if not data["audio"].has("music"): data["audio"]["music"] = 1.0

	data["audio"]["master"] = clampf(float(data["audio"]["master"]), 0.0, 1.0)
	data["audio"]["sfx"] = clampf(float(data["audio"]["sfx"]), 0.0, 1.0)
	data["audio"]["music"] = clampf(float(data["audio"]["music"]), 0.0, 1.0)

	if not data["display"].has("fullscreen"): data["display"]["fullscreen"] = false
	if not data["display"].has("resolution_index"): data["display"]["resolution_index"] = 0

	data["display"]["fullscreen"] = bool(data["display"]["fullscreen"])
	data["display"]["resolution_index"] = clampi(int(data["display"]["resolution_index"]), 0, resolutions.size() - 1)

	if not data["gameplay"].has("vsync"): data["gameplay"]["vsync"] = true
	if not data["gameplay"].has("particles"): data["gameplay"]["particles"] = true

	data["gameplay"]["vsync"] = bool(data["gameplay"]["vsync"])
	data["gameplay"]["particles"] = bool(data["gameplay"]["particles"])

# -------------------- APPLY ALL --------------------

func apply_all() -> void:
	_apply_audio()
	_apply_display()
	_apply_gameplay()

# -------------------- AUDIO --------------------

func set_master(v: float) -> void:
	data["audio"]["master"] = clampf(v, 0.0, 1.0)
	save_settings()
	_apply_audio()

func set_sfx(v: float) -> void:
	data["audio"]["sfx"] = clampf(v, 0.0, 1.0)
	save_settings()
	_apply_audio()

func set_music(v: float) -> void:
	data["audio"]["music"] = clampf(v, 0.0, 1.0)
	save_settings()
	_apply_audio()

func _apply_audio() -> void:
	_set_bus_linear("Master", float(data["audio"]["master"]))
	_set_bus_linear("SFX", float(data["audio"]["sfx"]))
	_set_bus_linear("Music", float(data["audio"]["music"]))

func _set_bus_linear(bus_name: String, linear: float) -> void:
	var idx := AudioServer.get_bus_index(bus_name)
	if idx == -1:
		# Om du inte har skapat busen än: Project > Audio > Buses
		return
	var db := linear_to_db(maxf(linear, 0.0001))
	AudioServer.set_bus_volume_db(idx, db)

# -------------------- DISPLAY --------------------

func set_fullscreen(on: bool) -> void:
	data["display"]["fullscreen"] = on
	save_settings()
	_apply_display()

func set_resolution_index(index: int) -> void:
	data["display"]["resolution_index"] = clampi(index, 0, resolutions.size() - 1)
	save_settings()
	_apply_display()

func _apply_display() -> void:
	var fullscreen := bool(data["display"]["fullscreen"])
	DisplayServer.window_set_mode(
		DisplayServer.WINDOW_MODE_FULLSCREEN if fullscreen
		else DisplayServer.WINDOW_MODE_WINDOWED
	)

	var idx := clampi(int(data["display"]["resolution_index"]), 0, resolutions.size() - 1)
	var new_size: Vector2i = resolutions[idx]
	DisplayServer.window_set_size(new_size)

# -------------------- GAMEPLAY --------------------

func set_vsync(on: bool) -> void:
	data["gameplay"]["vsync"] = on
	save_settings()
	_apply_gameplay()

func set_particles(on: bool) -> void:
	data["gameplay"]["particles"] = on
	save_settings()
	_apply_gameplay()

func _apply_gameplay() -> void:
	# Godot 4.5: vsync mode API finns kvar, men matcha enum korrekt
	DisplayServer.window_set_vsync_mode(
		DisplayServer.VSYNC_ENABLED if bool(data["gameplay"]["vsync"])
		else DisplayServer.VSYNC_DISABLED
	)
	# Particles: använd data["gameplay"]["particles"] i dina scripts när du spawna particles

# -------------------- UTIL --------------------

func _merge_dict(target: Dictionary, src: Dictionary) -> void:
	for k in src.keys():
		if target.has(k) and typeof(target[k]) == TYPE_DICTIONARY and typeof(src[k]) == TYPE_DICTIONARY:
			_merge_dict(target[k], src[k])
		else:
			target[k] = src[k]
