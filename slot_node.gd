extends TextureRect

@export var itemResource: Item

@onready var icon = $icon
@onready var label = $Label


func _ready():
	if not itemResource: return
	
	icon.texture = itemResource.icon
	label.text = str(itemResource.bagQuantity)
	label.visible = true
