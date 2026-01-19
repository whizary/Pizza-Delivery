extends Node

var inventory = []


signal inventory_updated

var player_node: Node = null
@onready var inventory_slot_scene = preload("res://Inventory_Slot.tscn")

func _ready():
	inventory.resize(12)


func add_item(item: Dictionary) -> bool:
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



func remove_item(item_type, item_effect):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -= 1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false

func increase_inventory_size():
	inventory_updated.emit()

func set_player_reference(player):
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
