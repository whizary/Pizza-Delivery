extends TileMapLayer

func _physics_process(delta):
	if Global.bossdooropen == true:
		visible = false
