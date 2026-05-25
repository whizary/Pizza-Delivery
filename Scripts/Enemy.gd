extends CharacterBody2D
 
@onready var _animated_enemy_sprite = $EnemyAnimatedSprite2D
@onready var hp_bar = $enemy_HP_bar
@onready var agent = $NavigationAgent2D
 
var player = null
var enemy_health = 100.0
var is_dead = false
 
func _ready():
	player = get_tree().get_first_node_in_group("player")
	_animated_enemy_sprite.play("idle_right")
	agent.avoidance_enabled = true
	agent.radius = 8.0
	agent.neighbor_distance = 64.0
func _physics_process(_delta):
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return
	if player == null:
		return
	hp_bar.value = enemy_health
	var distance_to_player = global_position.distance_to(player.global_position)
	if distance_to_player > Global.detect_distance:
		_idle_face_player()
		return
	var offset_dir = (global_position - player.global_position).normalized()
	var target_pos = player.global_position + offset_dir * Global.stop_distance
	agent.target_position = target_pos
	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	var distance_to_next = global_position.distance_to(next_point)
	if distance_to_player <= Global.stop_distance:
		_idle_face_player()
		return
	if distance_to_next < 6.0:
		_idle_face_player()
		return
	var steering = _get_steering()
	var final_dir = (direction + steering).normalized()
 
	velocity = final_dir * Global.enemy_speed
	agent.set_velocity(velocity)
	move_and_slide()
	if velocity.length() > 0.1:
		if player.global_position.x > global_position.x:
			_animated_enemy_sprite.play("run_right")
		else:
			_animated_enemy_sprite.play("run_left")
	else:
		_idle_face_player()
func _idle_face_player():
	velocity = Vector2.ZERO
	move_and_slide()
	if player.global_position.x > global_position.x:
		_animated_enemy_sprite.play("idle_right")
	else:
		_animated_enemy_sprite.play("idle_left")
	
func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.name == "AttackArea":
		if is_dead:
			return
		enemy_health -= Global.damage
		print("Enemy hit")
		if enemy_health <= 0:
			die()
			return
	
	if Global.death == false and Global.iframes == false:
		if area.is_in_group("player"):
			Global.health -= 10.0
			Global.iframes = true
			Global.iframesTimer = 1.0
	else:
		Global.iframes = true
func die():
	is_dead = true
	velocity = Vector2.ZERO
	if player.global_position.x > global_position.x:
		_animated_enemy_sprite.play("death_right")
	else:
		_animated_enemy_sprite.play("death_left")
	await _animated_enemy_sprite.animation_finished
	queue_free()
func _is_enemy_in_front() -> bool:
	if velocity.length() < 1:
		return false
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		global_position + velocity.normalized() * 20.0
	)
	query.exclude = [self]
	query.collision_mask = 1
	var result = space.intersect_ray(query)
	return result and result.collider.is_in_group("enemy")
func _get_steering() -> Vector2:
	if not _is_enemy_in_front():
		return Vector2.ZERO
	var side = Vector2(-velocity.y, velocity.x).normalized()
	return side * 0.5
