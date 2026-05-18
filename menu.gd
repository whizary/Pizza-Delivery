extends Control

func _physics_process(delta):
	AudioManager.play_music("MenuMusic")

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Play.tscn")


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://settings.tscn")


func _on_quit_pressed():
	get_tree().quit()
