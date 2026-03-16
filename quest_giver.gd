extends Node2D

var player_in_range = false
var quest_taken = false

@onready var item_scene = preload("res://Inventory_Item.tscn")

@onready var TakeQuest = $"../map/TakeQuest"
@onready var completequest1 = $"../map/Completequest1"
@onready var pressE = $"../map/Control"

# Called when the node enters the scene tree for the first time.

var player
var quest1
var Takecomplete

func _ready():
	if get_tree().get_nodes_in_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]
		quest1 = player.get_node("quest1")
		Takecomplete = player.get_node("complete_quest1")


func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		TakeQuest.visible = false
		Global.tut = false
	if body.is_in_group("player") and Takecomplete.visible == true:
		player_in_range = true
		completequest1.visible = false
		Global.tut = false
	

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and quest_taken == false:
		player_in_range = true
		TakeQuest.visible = true
		Global.tut = true
	if body.is_in_group("player") and Takecomplete.visible == true:
		completequest1.visible = true
		Global.tut = true

func _unhandled_input(event):
	if event.is_action_pressed("take_quest"):
		# Ta questen
		if TakeQuest.visible and quest_taken == false:
			take_quest()
			return

		# Slutför questen
		if completequest1.visible == true:
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
	
	item_instance.global_position = player.global_position + Vector2(
	randf_range(-30, 30),
	randf_range(0, 30)
	)

	
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
