extends Node


var item_data: Dictionary

func _ready():
	item_data = LoadData("res://Data/ItemData.json")

func LoadData(file_path):
	
	var file_data = FileAccess.open(file_path, FileAccess.READ)
	var json_text = file_data.get_as_text()
	var json_data = JSON.parse_string(json_text)
	return json_data

	return json_data.result
