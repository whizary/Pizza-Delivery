extends Control
 
@onready var dungeon = $"../Dungeon"
@onready var earth = $"../Earth"
@onready var ice = $"../Ice"
@onready var moon = $"../Moon"
 
@onready var map_label = $MapLabel
@onready var left_button = $LeftButton
@onready var right_button = $RightButton
@onready var play_button = $PlayButton
 
var maps := []
var map_names := []
var map_scenes := []
var current_index := 0
@onready var dungeon_status_button = $"../Dungeon/Button"
@onready var earth_status_button = $"../Earth/Button"
@onready var ice_status_button = $"../Ice/Button"
@onready var moon_status_button = $"../Moon/Button"
 
var status_buttons := []
 
 
func _ready():
	maps = [dungeon, earth, ice, moon]
	map_names = ["Dungeon", "Earth", "Ice", "Moon"]
 
	status_buttons = [
		earth_status_button,
		ice_status_button,
		dungeon_status_button,
		moon_status_button
	]
 
	map_scenes = [
		"res://Dungeon.tscn",
		"res://Maps/Ice Map/Map.tscn",
		"res://Maps/Dungeon_Map/Map.tscn",
		"res://Maps/Moon_Map/Map.tscn"
	]
 
	left_button.pressed.connect(change_map.bind(-1))
	right_button.pressed.connect(change_map.bind(1))
	play_button.pressed.connect(_on_pressed)
 
	play_button.text = "Play" # alltid Play
 
	update_ui()
 
 
func change_map(direction: int):
	current_index += direction
 
	if current_index < 0:
		current_index = maps.size() - 1
	elif current_index >= maps.size():
		current_index = 0
 
	update_ui()
 
func update_ui():
	# Visa bara aktuell karta
	for m in maps:
		m.visible = false
	maps[current_index].visible = true
	map_label.text = map_names[current_index]
 
	# Play-knappen: bara enabled/disabled
	play_button.text = "Play"
	play_button.disabled = not GameManager.unlocked_maps[current_index]
 
	# Status-knappar per karta
	for i in status_buttons.size():
		if GameManager.unlocked_maps[i]:
			status_buttons[i].text = "Unlocked🔓"
		else:
			status_buttons[i].text = "Locked🔒"

 
func _on_pressed():
	if not GameManager.unlocked_maps[current_index]:
		return
 
	get_tree().change_scene_to_file(map_scenes[current_index])
