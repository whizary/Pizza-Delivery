extends Node2D


func _ready():
	if randi() % 2 == 0:
		$TextureRect.texture = load("res://item_icons/Sword.webp")
	else: 
		$TextureRect.texture = load("res://item_icons/Berries.webp")
