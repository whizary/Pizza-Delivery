extends Node2D

var player_in_range = false
var quest_taken = false

@onready var item_scene = preload("res://Inventory_Item.tscn")

@onready var TakeQuest = $"../map/Player/TakeQuest"
@onready var quest1 = $"../map/Player/quest1"
@onready var completequest1 = $"../map/Player/complete_quest1"
@onready var Takecomplete = $"../map/Player/CompleteQuest"
# Called when the node enters the scene tree for the first time.

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		TakeQuest.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not quest_taken:
		player_in_range = true
		TakeQuest.visible = true
	if body.is_in_group("player") and completequest1.visible == true:
		Takecomplete.visible = true
	


func _unhandled_input(event):
	if event.is_action_pressed("take_quest"):
		# Ta questen
		if TakeQuest.visible and not quest_taken:
			take_quest()
			return

		# Slutför questen
		if Takecomplete.visible:
			_completed_quest()
			return

func _completed_quest():
	print("COMPLETED QUEST! Droppar reward...")

	Takecomplete.visible = false
	completequest1.visible = false

	drop_food_reward()

func drop_food_reward():
	var item_instance = item_scene.instantiate()
	get_tree().current_scene.add_child(item_instance)

	# Hämta spelaren (anpassa path om din heter annorlunda)
	var player = get_tree().current_scene.get_node("map/Player")
	item_instance.global_position = player.global_position

	item_instance.set_item_data({
		"quantity": 1,
		"type": "Consumable",
		"name": "Food",
		"texture": preload("res://item_icons/Food.webp"),
		"effect": "Health boost",
		"scene_path": "res://Inventory_Item.tscn"
	})

	print("Spawnade item på:", item_instance.global_position)

func take_quest():
	if player_in_range and TakeQuest.visible and not quest_taken:
		quest_taken = true
		quest1.visible = true
		TakeQuest.visible = false
	

func complete_quest():
	quest1.visible = false
