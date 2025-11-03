extends Node


func _on_add_potions_pressed():
	$Inventory.add_item(load("res://Inventory-stuff/Berries.webp"))
