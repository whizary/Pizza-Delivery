extends TileMapLayer

func _physics_process(delta):
	if Global.dooropen == true:
		visible = false
