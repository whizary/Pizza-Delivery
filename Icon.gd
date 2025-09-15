extends Sprite2D
var normal_speed := 500


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta:float) -> void:
	var direction := Vector2(0, 0)
	direction.x += Input.get_axis("move_left", "move_right")
	direction.y += Input.get_axis("move_up", "move_down")
	
	direction = direction.normalized()
	position += direction * delta * normal_speed
	var speed := "hej jwajdasdfasdfja"
	
	if direction.length() > 0:
		rotation = direction.angle() + PI / 2  # Samma som -90°
		
	
