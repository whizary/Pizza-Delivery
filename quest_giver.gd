extends Node2D

var player_in_range = false
var quest_taken = false

@onready var item_scene = preload("res://Inventory_Item.tscn")

@onready var TakeQuest = $"../map/TakeQuest"
@onready var completequest1 = $"../map/Completequest1"
@onready var quest = $TextureRect

var player
var quest1

func _ready():
	if get_tree().get_nodes_in_group("player"):
		player = get_tree().get_nodes_in_group("player")[0]
		quest1 = player.get_node("quest1")

	TakeQuest.visible = false
	completequest1.visible = false

func _process(delta):
	# När slutdialogen med Ally är klar
	if Global.allyTurnInFinished == true and Global.allyRewardGiven == false:
		Global.allyTurnInFinished = false
		Global.allyRewardGiven = true
		Global.AllyquestComplete = false
		completequest1.visible = false
		quest_taken = false
		give_food_reward()

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		player_in_range = false
		#TakeQuest.visible = false
		completequest1.visible = false
		Global.allyQ = false

func _on_area_2d_body_entered(body):
	if body.is_in_group("player") and quest_taken == false and Global.allyRewardGiven == false and Global.AllyquestComplete == false:
		player_in_range = true
		#TakeQuest.visible = true
		Global.allyQ = true

	if body.is_in_group("player") and Global.AllyquestComplete == true and Global.allyRewardGiven == false:
		player_in_range = true
		completequest1.visible = true
		Global.allyQ = true

func _unhandled_input(event):
	if !player_in_range:
		return

	if Input.is_action_just_pressed("take_quest"):
		# första pratet, key_quest.gd sköter dialogen
		if TakeQuest.visible and quest_taken == false:
			quest_taken = true
			TakeQuest.visible = false
			return

		# återvänd efter klarad quest, key_quest.gd sköter slutdialogen
		if completequest1.visible == true:
			await get_tree().create_timer(5.0).timeout
			return

func give_food_reward():
	var food_data = {
		"quantity": 1,
		"type": "Consumable",
		"name": "Food",
		"texture": preload("res://item_icons/Food.webp"),
		"effect": "Health boost",
		"scene_path": "res://Inventory_Item.tscn"
	}

	# Försök lägga direkt i inventory först
	if player != null:
		if player.has_method("add_item_to_inventory"):
			player.add_item_to_inventory(food_data)
			print("Food lades till i inventory")
			return
		elif player.has_method("add_item"):
			player.add_item(food_data)
			print("Food lades till i inventory")
			return

	# Fallback: droppa item på marken
	drop_food_reward()

func drop_food_reward():
	if player == null:
		return

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
