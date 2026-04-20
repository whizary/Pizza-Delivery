extends TileMapLayer
var temp = false

func _physics_process(delta):
	if Global.bossalive == false and temp == false:
		temp = true
		print("dungeondoorentered")
		visible = true
