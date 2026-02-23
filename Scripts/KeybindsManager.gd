extends Node

const SAVE_PATH := "user://keybinds.save"

# Actions du vill hantera
var rebind_actions: Array[String] = [
	"move_up",
	"move_down",
	"move_left",
	"move_right",
	"dodge",
	"inventory",
	"run",
	"ui_add",
	"hotbar_1",
	"hotbar_2",
	"hotbar_3"
]

# Riktiga defaults (cacheas vid första start)
var _default_events: Dictionary = {} # action -> Array[InputEvent]

func _ready() -> void:
	_cache_defaults_once()
	load_keybinds()

func _cache_defaults_once() -> void:
	if _default_events.size() > 0:
		return

	_default_events.clear()
	for action in rebind_actions:
		var events := InputMap.action_get_events(action)
		var copy: Array[InputEvent] = []
		for ev in events:
			copy.append(ev.duplicate())
		_default_events[action] = copy

func reset_to_defaults() -> void:
	# återställ
	for action in rebind_actions:
		if not InputMap.has_action(action):
			continue
		InputMap.action_erase_events(action)
		if _default_events.has(action):
			for ev in _default_events[action]:
				InputMap.action_add_event(action, ev.duplicate())

	# ta bort custom save
	if FileAccess.file_exists(SAVE_PATH):
		DirAccess.remove_absolute(SAVE_PATH)

func save_keybinds() -> void:
	var data: Dictionary = {}

	for action in rebind_actions:
		var events := InputMap.action_get_events(action)
		if events.size() > 0:
			# spara bara första som primary
			data[action] = _event_to_dict(events[0])

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return
	file.store_var(data)
	file.close()

func load_keybinds() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		return

	var data = file.get_var()
	file.close()

	if typeof(data) != TYPE_DICTIONARY:
		return

	for action in data.keys():
		if not InputMap.has_action(action):
			continue
		var ev := _dict_to_event(data[action])
		if ev == null:
			continue

		InputMap.action_erase_events(action)
		InputMap.action_add_event(action, ev)

# --------- helpers ---------

func get_primary_event(action: String) -> InputEvent:
	var events := InputMap.action_get_events(action)
	return events[0] if events.size() > 0 else null

func get_all_events(action: String) -> Array[InputEvent]:
	return InputMap.action_get_events(action)

func event_to_text(ev: InputEvent) -> String:
	if ev == null:
		return "-"

	var s := ev.as_text()
	if s.strip_edges() != "":
		return s

	if ev is InputEventKey:
		var code: int = int(ev.physical_keycode)
		if code == 0:
			code = int(ev.keycode)
		var k := OS.get_keycode_string(code)
		return k if k != "" else "-"

	if ev is InputEventMouseButton:
		return "Mouse %d" % int(ev.button_index)

	return "-"

func _event_to_dict(ev: InputEvent) -> Dictionary:
	if ev is InputEventKey:
		return {
			"type": "key",
			"keycode": int(ev.keycode),
			"physical": int(ev.physical_keycode),
			"shift": ev.shift_pressed,
			"ctrl": ev.ctrl_pressed,
			"alt": ev.alt_pressed,
			"meta": ev.meta_pressed
		}
	if ev is InputEventMouseButton:
		return {
			"type": "mouse",
			"button_index": int(ev.button_index)
		}
	return {"type": "unknown"}

func _dict_to_event(d: Dictionary) -> InputEvent:
	var t := String(d.get("type", ""))

	if t == "key":
		var e := InputEventKey.new()
		e.keycode = int(d.get("keycode", 0))
		e.physical_keycode = int(d.get("physical", 0))
		e.shift_pressed = bool(d.get("shift", false))
		e.ctrl_pressed = bool(d.get("ctrl", false))
		e.alt_pressed = bool(d.get("alt", false))
		e.meta_pressed = bool(d.get("meta", false))
		return e

	if t == "mouse":
		var e := InputEventMouseButton.new()
		e.button_index = int(d.get("button_index", 1))
		return e

	return null
