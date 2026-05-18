extends Control

@onready var bind_buttons: Dictionary = {
	"move_up":    $"Movement/Forward/Button",
	"move_down":  $"Movement/Back/Button2",
	"move_left":  $"Movement/Left/Button3",
	"move_right": $"Movement/Right/Button4",

	"dodge":      $"Abilities/Dodge/Button5",
	"inventory":  $"Abilities/Inventory/Button6",
	"run":        $"Abilities/Run/Button7",
	"ui_add":     $"Abilities/Pick Up/Button8", # ändra till $"Abilities/PickUp/Button8" om nodnamn saknar space

	"hotbar_1":   $"Hotbar/HotbarOne/Button9",
	"hotbar_2":   $"Hotbar/HotbarTwo/Button10",
	"hotbar_3":   $"Hotbar/HotbarThree/Button11",
}

@onready var reset_button: Button = $Reset

var _listening_action: String = ""
var _previous_text: String = ""

func _ready() -> void:
	# säkerställ att InputMap är laddad (autoload gör det, men detta skadar inte)
	KeybindsManager.load_keybinds()

	_refresh_all_button_text()

	for action in bind_buttons.keys():
		var btn: Button = bind_buttons[action]
		btn.pressed.connect(_on_bind_button_pressed.bind(action))

	reset_button.pressed.connect(_on_reset_pressed)

func _on_bind_button_pressed(action: String) -> void:
	if _listening_action != "":
		_cancel_listen()

	_listening_action = action
	var btn: Button = bind_buttons[action]
	_previous_text = btn.text
	btn.text = "Press a key..."
	set_process_unhandled_input(true)

func _unhandled_input(event: InputEvent) -> void:
	if _listening_action == "":
		return

	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		_cancel_listen()
		accept_event()
		return

	if event is InputEventKey:
		if not event.pressed:
			return
		if event.keycode in [KEY_SHIFT, KEY_CTRL, KEY_ALT, KEY_META]:
			return
		_set_action_event(_listening_action, event)
		accept_event()
		return

	if event is InputEventMouseButton:
		if not event.pressed:
			return
		_set_action_event(_listening_action, event)
		accept_event()
		return

# -------------------- FIXAD UNIQUE CHECK --------------------

func _key_signature(ev: InputEventKey) -> String:
	var code: int = int(ev.physical_keycode)
	if code == 0:
		code = int(ev.keycode)

	return "%d|%s%s%s%s" % [
		code,
		"S" if ev.shift_pressed else "",
		"C" if ev.ctrl_pressed else "",
		"A" if ev.alt_pressed else "",
		"M" if ev.meta_pressed else ""
	]

func _events_equal(a: InputEvent, b: InputEvent) -> bool:
	if a == null or b == null:
		return false

	if a is InputEventKey and b is InputEventKey:
		return _key_signature(a) == _key_signature(b)

	if a is InputEventMouseButton and b is InputEventMouseButton:
		return int(a.button_index) == int(b.button_index)

	return false

func _is_event_already_used(new_ev: InputEvent, except_action: String) -> String:
	# Kolla ALLA events för varje action (inte bara första)
	for action in bind_buttons.keys():
		if action == except_action:
			continue
		var events := KeybindsManager.get_all_events(action)
		for ev in events:
			if _events_equal(ev, new_ev):
				return action
	return ""

func _set_action_event(action: String, ev: InputEvent) -> void:
	var conflict_action := _is_event_already_used(ev, action)
	if conflict_action != "":
		var btn: Button = bind_buttons[action]
		btn.text = "Already used!"
		await get_tree().create_timer(0.8).timeout
		btn.text = "Press a key..."
		return

	# Sätt bind
	InputMap.action_erase_events(action)
	InputMap.action_add_event(action, ev)

	KeybindsManager.save_keybinds()

	_refresh_button_text(action)

	_listening_action = ""
	set_process_unhandled_input(false)

func _cancel_listen() -> void:
	if _listening_action == "":
		return
	var btn: Button = bind_buttons[_listening_action]
	btn.text = _previous_text
	_listening_action = ""
	set_process_unhandled_input(false)

# -------------------- RESET --------------------

func _on_reset_pressed() -> void:
	_cancel_listen()

	KeybindsManager.reset_to_defaults()
	_refresh_all_button_text()

# -------------------- UI REFRESH --------------------

func _refresh_all_button_text() -> void:
	for action in bind_buttons.keys():
		_refresh_button_text(action)

func _refresh_button_text(action: String) -> void:
	var btn: Button = bind_buttons[action]
	var ev := KeybindsManager.get_primary_event(action)
	btn.text = KeybindsManager.event_to_text(ev)

func _physics_process(delta):
	AudioManager.play_music("MenuMusic")

func _process(delta):
	if Global.movement == false:
		InputMap.action_erase_events("dodge")
