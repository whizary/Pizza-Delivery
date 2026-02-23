extends CharacterBody2D

@onready var _animated_enemy_sprite = $EnemyAnimatedSprite2D


var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")
	
func _physics_process(_delta):
	
	if player == null:
		return

	var distance_to_player = global_position.distance_to(player.global_position)
	var direction_to_player = player.global_position - global_position

	if distance_to_player <= Global.chase_distance and distance_to_player > Global.stop_distance:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * Global.enemy_speed
		if direction_to_player.x > 0:
			_animated_enemy_sprite.play("run_right")
		else:
			_animated_enemy_sprite.play("run_left")

	elif distance_to_player <= Global.stop_distance:
		velocity = Vector2.ZERO
		if player.global_position.x > global_position.x:
			_animated_enemy_sprite.play("idle_right")
		else:
			_animated_enemy_sprite.play("idle_left")

	move_and_slide()
 
 
func _on_area_2d_body_entered(body):
	if Global.death == false and Global.iframes == false:
		if body.is_in_group("player"):
			Global.iframes = true
			Global.iframesTimer = 1.0
			print("Player hit")
			Global.health -= 10.0
	else:
		Global.iframes = true
