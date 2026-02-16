extends Node2D

var player_in_range = false
var quest_taken = false

@onready var TakeQuest = $"../map/Player/TakeQuest"
@onready var quest1 = $"../map/Player/quest1"
# Called when the node enters the scene tree for the first time.

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		TakeQuest.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not quest_taken:
		player_in_range = true
		TakeQuest.visible = true


func _unhandled_input(event):
	if event.is_action_pressed("take_quest"):
		take_quest()


func take_quest():
	if player_in_range and TakeQuest.visible and not quest_taken:
		quest_taken = true
		quest1.visible = true
		TakeQuest.visible = false


func complete_quest():
	quest1.visible = false
