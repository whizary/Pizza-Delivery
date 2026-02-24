extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready():
	progress_bar.value = float(SettingsManager.data["audio"]["music"]) * 100.0

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_set_from_mouse()
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_set_from_mouse()

func _set_from_mouse():
	var mouse := get_viewport().get_mouse_position()
	var rect := progress_bar.get_global_rect()

	var w := rect.size.x
	if w <= 0.0:
		return

	var local_x := mouse.x - rect.position.x
	var t := clampf(local_x / w, 0.0, 1.0)

	progress_bar.value = lerpf(progress_bar.min_value, progress_bar.max_value, t)
	SettingsManager.set_music(progress_bar.value / 100.0)
