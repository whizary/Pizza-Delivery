extends Node2D

var player_in_range = false

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("take_quest"):
		Global.movement = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_in_range = true
		Global.keyQ = true
		print("boss key")

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		Global.keyQ = false
		Global.movement = true
