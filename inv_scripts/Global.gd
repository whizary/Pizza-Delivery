extends Node

var inventory = []

signal inventory_updated

var player_node: Node = null

func _ready():
	inventory.resize(6)


func add_item(item: Dictionary) -> bool:
	if not item.has("type") or not item.has("effect") or not item.has("quantity"):
		push_error("Item saknar nödvändiga keys: " + str(item))
		return false
	for i in range(inventory.size()):
		if inventory[i] != null \
		and inventory[i].has("type") \
		and inventory[i].has("effect") \
		and inventory[i]["type"] == item["type"] \
		and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			return true

		elif inventory[i] == null:
			inventory[i] = item.duplicate(true)
			inventory_updated.emit()
			return true

	return false


func remove_item():
	inventory_updated.emit()

func increase_inventory_size():
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player
