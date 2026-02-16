extends Node

const SAVE_PATH := "user://progress.save"

var unlocked_maps: Array[bool] = []
var unlocked_characters: Array[bool] = []

func _ready():
	load_progress()

func load_progress():
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		var data = file.get_var()
		file.close()

		if typeof(data) == TYPE_DICTIONARY:
			unlocked_maps = _to_bool_array(data.get("maps", []))
			unlocked_characters = _to_bool_array(data.get("chars", []))
		else:
			# gammal save (array)
			unlocked_maps = _to_bool_array(data)
			unlocked_characters = []
	else:
		unlocked_maps = [true, false, false, false]
		unlocked_characters = [true, false, false, false]
		save_progress()

	_ensure_size(unlocked_maps, 4)
	_ensure_size(unlocked_characters, 4)

func save_progress():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_var({
		"maps": unlocked_maps,
		"chars": unlocked_characters
	})
	file.close()

func complete_map(map_index: int):
	var next := map_index + 1
	if next < unlocked_maps.size():
		unlocked_maps[next] = true
		unlocked_characters[next] = true
		save_progress()

# -----------------------
# Hjälpfunktioner
# -----------------------

func _to_bool_array(arr) -> Array[bool]:
	var result: Array[bool] = []
	for v in arr:
		result.append(bool(v))
	return result

func _ensure_size(arr: Array[bool], size: int):
	while arr.size() < size:
		arr.append(false)
