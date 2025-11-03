extends Control


@onready var bagContainer = $TextureRect/BagSlots
@onready var keyBarContainer = $TextureRect/KeyBar

var items = []

func add_item(item: Item):
	item.bagQuantity += 1
	
	if not item in items:
		items.append(item)
		_put_item_in_free_slot(item)
	
	update_Inventory()
	
func update_Inventory():
	for slot in bagContainer.get_children():
		slot.update()

func _put_item_in_free_slot(item):
	for slot in bagContainer.get_children():
		if slot.itemResource == null:
			slot.itemResource = item
			return

func _get_drag_data(at_position):
	var dragSlotNode = get_slot_node_at_position(at_position)
	
	if dragSlotNode == null:
		return
	
	if dragSlotNode.texture == null: return
	
	var dragPreviewNode = dragSlotNode.duplicate()
	dragPreviewNode.custom_minimum_size = Vector2(115, 115)
	set_drag_preview(dragPreviewNode)
	
	return dragSlotNode

func _can_drop_data(at_position, data):
	var targetSlotNode = get_slot_node_at_position(at_position)
	
	return targetSlotNode != null


func _drop_data(at_position, dragSlotNode):
	var targetSlotNode = get_slot_node_at_position(at_position)
	var targetTexture = targetSlotNode.texture
	
	targetSlotNode.texture = dragSlotNode.texture
	
	if targetTexture == null:
		dragSlotNode.texture = null 
	else:
		dragSlotNode.texture = targetTexture

func get_slot_node_at_position(position):
	var allSlotNodes = (bagContainer.get_children() + keyBarContainer.get_children())
	
	for node: TextureRect in allSlotNodes:
		var nodeRect = node.get_global_rect()
		
		if nodeRect.has_point(position): return node


func _on_button_pressed():
	pass # Replace with function body.
