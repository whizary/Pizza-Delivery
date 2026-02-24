extends Control

@onready var main_label: Label = $MainInfo
@onready var welcome: Label = $Welcome

var player_in_range := false
var tutorial_index := 0

func _ready():
	main_label.text = "I will be guiding you through difficult and dangerous\nterrain. I will also guide you to victory!"
	await get_tree().create_timer(5.0).timeout
	
	main_label.text = "Press W to move forward"
	tutorial_index = 1
	
	set_process(true)
	welcome.visible = false

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		if body.has_node("interact_ui"):
			body.interact_ui.visible = true

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		if body.has_node("interact_ui"):
			body.interact_ui.visible = false

func _process(_delta):
	if tutorial_index == 1 and Input.is_action_just_pressed("move_up"):
		main_label.text = "Press S to move backward"
		tutorial_index = 2

	elif tutorial_index == 2 and Input.is_action_just_pressed("move_down"):
		main_label.text = "Press A to move left"
		tutorial_index = 3

	elif tutorial_index == 3 and Input.is_action_just_pressed("move_left"):
		main_label.text = "Press D to move right"
		tutorial_index = 4
	
	elif tutorial_index == 4 and Input.is_action_just_pressed("move_right"):
		main_label.text = "Press shift to run"
		tutorial_index = 5
		
	elif tutorial_index == 5 and Input.is_action_just_pressed("run"):
		main_label.text = "Press space to dodge"
		tutorial_index = 6
	
	elif tutorial_index == 6 and Input.is_action_just_pressed("dodge"):
		main_label.text = "Press E to pick up items"
		tutorial_index = 7

	elif tutorial_index == 7 and Input.is_action_just_pressed("ui_add"):
		if player_in_range:
			main_label.text = "Good! You're ready."
			set_process(false)
		else:
			main_label.text = "Walk up to an item, then press E."
