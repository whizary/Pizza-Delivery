
extends Node2D

@export var item_type = ""
@export var item_name = ""
@export var item_texture: Texture2D
@export var item_effect: String = "health"
@onready var icon_sprite = $Sprite2D

var player_in_range = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if not Engine.is_editor_hint():
		icon_sprite.texture = item_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if player_in_range and Input.is_action_just_pressed("ui_add"):
		pickup_item()
		print("item")


func pickup_item():
	var item = {
		"quantity": 1,
		"type": item_type,
		"name": item_name,
		"texture": item_texture,
		"effect": item_effect,
	}
	var added: bool = Global.add_item(item)

	if added:
		queue_free()
	else:
		print("Inventory full / kunde inte lägga till item")


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = false
		body.interact_ui.visible = false


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_range = true
		body.interact_ui.visible = true
