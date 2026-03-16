extends Area2D
@onready var keysprite = $animatedkeysprite

func _physics_process(delta):
	if Global.bossalive == false:
		keysprite.visible = true
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		if Global.bossalive == false:
			body.use_key()
			queue_free()
