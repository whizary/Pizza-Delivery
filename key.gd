extends Area2D
@onready var keysprite = $animatedkeysprite

func _physics_process(delta):
	if Global.bossroomcomplete == true:
		keysprite.visible = true
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if Global.bossroomcomplete == true:
			body.use_key()
			queue_free()
