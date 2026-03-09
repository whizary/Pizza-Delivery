extends Node
 
#inventory items
var inventory = []
var player_hit = false
 
var detect_distance = 255
var enemy_speed = 155.0
var stamina = 100.0
var maxStamina = 100.0
var staminaDrain = 25.0
var staminaRecovery = 25.0
var stop_distance = 35.0 

var health = 100.0
var maxHealth = 100.0
var iframesTimer = 1.0
var iframes = false
var death = false
var bossroomcomplete = false
var bossdooropen = true


var current_wave: int
var moving_to_next_wave: bool
 
#Hotbar Items
var hotbar_size = 3
var hotbar_inventory = []
signal inventory_updated
var player_node: Node = null
@onready var inventory_slot_scene = preload("res://Inventory_Slot.tscn")

func _ready():
	inventory.resize(12)
	hotbar_inventory.resize(hotbar_size)

func add_item(item: Dictionary, to_hotbar = false) -> bool:
	var added_to_hotbar = false
	#Add to hotbar
	if to_hotbar:
		added_to_hotbar = add_hotbar_item(item)
		inventory_updated.emit()
		#Add to inventory
	if not added_to_hotbar:
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i]["name"] == item["name"]:
				inventory[i]["quantity"] += item["quantity"]
				inventory_updated.emit()
				print("Item stacked", inventory)
				return true
			elif inventory[i] == null:
				inventory[i] = item
				inventory_updated.emit()
				print("Item added", inventory)
				return true
		print("Inventory full", inventory)
		return false
	return false

func remove_item(item_type, item_effect):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false
func increase_inventory_size(extra_slots):
	inventory.resize(inventory.size() + extra_slots)
	inventory_updated.emit()
func set_player_reference(player: Node) -> void:
	player_node = player
func adjust_drop_position(position):
	var radius = 100
	var nearby_items = get_tree().get_nodes_in_group("Items")
	for item in nearby_items:
		if item.global_position.distance_to(position) < radius:
			var random_offset = Vector2(randf_range(-radius, radius), randf_range(-radius, radius))
			position += random_offset
			break
	return position
func drop_item(item_data, drop_position):
	if not item_data.has("scene_path"):
		print("Missing scene_path in item_data:", item_data)
		return
	var item_scene: PackedScene = load(item_data["scene_path"])
	if item_scene == null:
		print("Could not load scene:", item_data["scene_path"])
		return
	var item_instance = item_scene.instantiate()
	item_instance.set_item_data(item_data)
	drop_position = adjust_drop_position(drop_position)
	item_instance.global_position = drop_position
	get_tree().current_scene.add_child(item_instance)
func add_hotbar_item(item):
	for i in range(hotbar_size):
		if hotbar_inventory[i] == null:
			hotbar_inventory[i] = item
			return true
	return false
func remove_hotbar_item(item_type, item_effect):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["type"] == item_type and hotbar_inventory[i]["effect"] == item_effect:
			if hotbar_inventory[i]["quantity"] <= 0:
				hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false

func unassign_hotbar_item(item_type, item_effect):
	for i in range(hotbar_inventory.size()):
		if hotbar_inventory[i] != null and hotbar_inventory[i]["type"] == item_type and hotbar_inventory[i]["effect"] == item_effect:
			hotbar_inventory[i] = null
			inventory_updated.emit()
			return true
	return false

func is_item_assigned_to_hotbar(item_to_check):
	return item_to_check in hotbar_inventory

func swap_inventory_items(index1: int, index2: int) -> bool:
	if index1 < 0 or index1 >= inventory.size() or index2 < 0 or index2 >= inventory.size():
		return false
	print("BEFORE SWAP:", index1, index2, inventory[index1], inventory[index2])
	var temp = inventory[index1]
	inventory[index1] = inventory[index2]
	inventory[index2] = temp
	print("AFTER SWAP:", inventory[index1], inventory[index2])
	inventory_updated.emit()
	return true

func swap_hotbar_items(index1: int, index2: int) -> bool:
	if index1 < 0 or index1 >= hotbar_inventory.size() or index2 < 0 or index2 >= hotbar_inventory.size():
		return false
	print("BEFORE SWAP:", index1, index2, inventory[index1], inventory[index2])
	var temp = hotbar_inventory[index1]
	hotbar_inventory[index1] = hotbar_inventory[index2]
	hotbar_inventory[index2] = temp
	print("AFTER SWAP:", hotbar_inventory[index1], hotbar_inventory[index2])
	inventory_updated.emit()
	return true
