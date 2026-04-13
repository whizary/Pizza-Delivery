extends Control

@onready var main_label: Label = $TextureRect/Text
@onready var texture_rect = $TextureRect

var inventory
var barrier1
var barrier2
var tutorial
var hotbar
var step_7_started = false

func _ready():
	Global.tut = true
	Global.tut_pause = false

	main_label.text = "Greetings, Player. I hope you are ready for a challenge!"
	await get_tree().create_timer(2.0).timeout
	main_label.text = "I will be guiding you through difficult and dangerous terrain."
	await get_tree().create_timer(3.0).timeout
	main_label.text = "I will also guide you to victory!"
	await get_tree().create_timer(2.0).timeout
	main_label.text = "Press W to move forward"

	Global.tutorial_index = 1
	set_process(true)

	barrier1 = get_tree().get_first_node_in_group("barrier")
	barrier2 = get_tree().get_first_node_in_group("Barrier2")
	tutorial = get_tree().get_first_node_in_group("tutorial")
	hotbar = get_tree().get_first_node_in_group("hotbar")

func _process(_delta):
	# Visa/göm tutorial
	if Global.tut and !Global.tut_pause:
		texture_rect.visible = true
	else:
		texture_rect.visible = false

	# Pausa all tutorial-logik medan Ally-dialog är öppen
	if Global.tut_pause:
		return

	if Global.tutorial_index == 1 and Input.is_action_just_pressed("move_up"):
		main_label.text = "Press S to move backward"
		Global.tutorial_index = 2

	elif Global.tutorial_index == 2 and Input.is_action_just_pressed("move_down"):
		main_label.text = "Press A to move left"
		Global.tutorial_index = 3

	elif Global.tutorial_index == 3 and Input.is_action_just_pressed("move_left"):
		main_label.text = "Press D to move right"
		Global.tutorial_index = 4

	elif Global.tutorial_index == 4 and Input.is_action_just_pressed("move_right"):
		main_label.text = "Press Space to dash"
		Global.tutorial_index = 5

	elif Global.tutorial_index == 5:
		main_label.text = "Press E to talk to Ally"
		barrier1.get_node("CollisionShape2D").disabled = true

		if Input.is_action_just_pressed("take_quest") and Global.allyQ:
			Global.tutorial_index = 6

	elif Global.tutorial_index == 7 and !step_7_started:
		step_7_started = true
		main_label.text = "Your quest appeared in the top left!"
		await get_tree().create_timer(2.0).timeout

		if Global.tut_pause:
			step_7_started = false
			return

		main_label.text = "Press E to pick up items"
		await get_tree().create_timer(2.0).timeout

		if Global.tut_pause:
			step_7_started = false
			return

		main_label.text = "Finish the quest"
		await get_tree().create_timer(2.0).timeout

		if Global.tut_pause:
			step_7_started = false
			return

		Global.tutorial_index = 8
		step_7_started = false

	elif Global.tutorial_index == 8 and Global.inventory[0]:
		main_label.text = "Good, now go back to Ally"
		Global.tutorial_index = 9

	elif Global.tutorial_index == 9 and Input.is_action_just_pressed("take_quest"):
		main_label.text = "Nice work! Press tab to open your inventory"
		Global.tutorial_index = 10

	elif Global.tutorial_index == 10 and Input.is_action_just_pressed("inventory"):
		main_label.text = "Good! You're ready."
		barrier2.get_node("CollisionShape2D").disabled = true
		await get_tree().create_timer(2.0).timeout
		tutorial.visible = false
		hotbar.visible = true
		set_process(false)
