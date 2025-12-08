extends Area2D

func _on_body_entered(body: Node2D) -> void:
	print("test")
	if body.is_in_group("player"):
		body.use_redgem_power_up()
		queue_free()
