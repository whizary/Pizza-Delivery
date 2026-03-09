extends Node2D
@onready var player_collision_shape_2d = $Player/PlayerCollisionShape2D
@onready var PressE = $"../map/PressE"


func _on_area_2d_area_entered(area):
	if area.is_in_group("player"):
		PressE.visible = true

func _on_area_2d_area_exited(area):
	if area.is_in_group("player"):
		PressE.visible = false
