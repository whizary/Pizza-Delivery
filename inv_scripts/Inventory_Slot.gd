extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel


var item = null


func _on_item_button_mouse_exited():
	details_panel.visible = false


func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true


func _on_item_button_pressed():
	if item != null:
		usage_panel.visible = !usage_panel.visible


func set_empty():
	icon.texture = null
	quantity_label.text = ""

func set_item(new_item):
	item = new_item

	# Texture
	if new_item != null and new_item.has("texture") and new_item["texture"] != null:
		icon.texture = new_item["texture"]
	else:
		icon.texture = null

	# Quantity
	if new_item != null and new_item.has("quantity"):
		quantity_label.text = str(new_item["quantity"])
	else:
		quantity_label.text = ""

	# Name
	if new_item != null and new_item.has("name") and new_item["name"] != null:
		item_name.text = str(new_item["name"])
	else:
		item_name.text = ""

	# Type
	if new_item != null and new_item.has("type") and new_item["type"] != null:
		item_type.text = str(new_item["type"])
	else:
		item_type.text = ""

	# Effect
	if new_item != null and new_item.has("effect") and str(new_item["effect"]) != "":
		item_effect.text = "+" + str(new_item["effect"])
	else:
		item_effect.text = ""



func _on_drop_button_pressed() -> void:
	if item != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0, 50)
		drop_offset = drop_offset.rotated(Global.player_node.rotation)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["type"], item["effect"])
		usage_panel.visible = false
