extends Control

@onready var main_label: Label = $TextureRect/Text
var inventory

var tutorial_index := 0

func _ready():
	main_label.text = "I will be guiding you through difficult and dangerous terrain."
	await get_tree().create_timer(3.0).timeout
	main_label.text = "I will also guide you to victory!"
	await get_tree().create_timer(2.0).timeout
	main_label.text = "Press W to move forward"
	tutorial_index = 1
	set_process(true)

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
		main_label.text = "Press E to talk to Ally"
		tutorial_index = 5

	elif tutorial_index == 5 and Input.is_action_just_pressed("take_quest"):  #Kolla om player är inuti Ally
		main_label.text = "Your quest appeared in the top left!"
		await get_tree().create_timer(2.0).timeout
		main_label.text = "Finish the quest"
		tutorial_index = 6
		
	elif tutorial_index == 6 and Global.inventory[0]:
		main_label.text = "Good, now go back to Ally"
		tutorial_index = 7

	elif tutorial_index == 7 and Input.is_action_just_pressed("take_quest"): #kolla om player är inuti Ally
		main_label.text = "Nice work! press tab to open your inventory"
		tutorial_index = 8

	elif tutorial_index == 8 and Input.is_action_just_pressed("inventory"):
		main_label.text = "Good! You're ready."
		
		set_process(false)

		
