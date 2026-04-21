extends Control

@onready var icon = $InnerBorder/ItemIcon
@onready var quantity_label = $InnerBorder/ItemQuantity
@onready var details_panel = $DetailsPanel
@onready var item_name = $DetailsPanel/ItemName
@onready var item_type = $DetailsPanel/ItemType
@onready var item_effect = $DetailsPanel/ItemEffect
@onready var usage_panel = $UsagePanel
@onready var assign_button = $UsagePanel/AssignButton
@onready var outer_border = $OuterBorder


signal drag_start(slot)
signal drag_end()


var item = null
var slot_index = -1
var is_assigned = false

func set_slot_index(new_index):
	slot_index = new_index


func _on_item_button_mouse_exited():
	details_panel.visible = false


func _on_item_button_mouse_entered():
	if item != null:
		usage_panel.visible = false
		details_panel.visible = true


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
	update_assignment_status()

func _on_drop_button_pressed() -> void:
	if item != null:
		var drop_position = Global.player_node.global_position
		var drop_offset = Vector2(0, 50)
		drop_offset = drop_offset.rotated(Global.player_node.rotation)
		Global.drop_item(item, drop_position + drop_offset)
		Global.remove_item(item["type"], item["effect"])
		Global.remove_hotbar_item(item["type"], item["effect"])
		usage_panel.visible = false


func _on_use_button_pressed():
	usage_panel.visible = false
	if is_instance_valid(Global.player_node):
		Global.player_node.apply_item_effect(item)
		Global.remove_item(item["type"], item["effect"])
	else:
		print("Player could not be found")

func update_assignment_status():
	is_assigned = Global.is_item_assigned_to_hotbar(item)
	if is_assigned:
		assign_button.text = "Unassign"
	else:
		assign_button.text = "Assign"

func _on_assign_button_pressed():
	if item != null:
		if is_assigned:
			Global.unassign_hotbar_item(item["type"], item["effect"])
			is_assigned = false
		else:
			Global.add_item(item, true)
			is_assigned = true
		update_assignment_status()


func _on_item_button_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
			if item != null:
				usage_panel.visible = !usage_panel.visible
			
			#Drag system
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.is_pressed():
				outer_border.modulate = Color(1, 1, 0)
				drag_start.emit(self)
			else:
				outer_border.modulate = Color(1, 1, 1)
				drag_end.emit()
