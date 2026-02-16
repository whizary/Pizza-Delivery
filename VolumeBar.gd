extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

func _ready():
	# läs sparad master (0.0–1.0) och visa som 0–100
	progress_bar.value = float(SettingsManager.data["audio"]["master"]) * 100.0

func _gui_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_set_from_mouse()
	elif event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_set_from_mouse()

func _set_from_mouse():
	var mouse := get_viewport().get_mouse_position() # Vector2 i viewport coords
	var rect := progress_bar.get_global_rect()       # Rect2 i viewport coords

	var w := rect.size.x
	if w <= 0.0:
		return

	var local_x := mouse.x - rect.position.x
	var t := clampf(local_x / w, 0.0, 1.0)

	progress_bar.value = lerpf(progress_bar.min_value, progress_bar.max_value, t)
	SettingsManager.set_master(progress_bar.value / 100.0)
