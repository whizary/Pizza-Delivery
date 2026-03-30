extends Control


func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Dungeon.tscn")

func _on_menu_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")

func _on_quit_pressed():
	get_tree().quit()
