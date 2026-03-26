extends CharacterBody2D

@onready var _animated_enemy_sprite = $AnimatedBossSprite2D
@onready var BossArea = $BossArea2D
@onready var agent = $NavigationAgent2D
@onready var attack_telegraph = $AttackTelegraph
@onready var BossAttackCollision = $AttackTelegraph/CollisionShape2D

var player = null
var is_dead = false
var is_taking_damage = false
var is_attacking = false

var attack_delay = 0.7    
var attack_range = 90

func _ready():
	player = get_tree().get_first_node_in_group("player")
	_animated_enemy_sprite.play("idle_right")

	_animated_enemy_sprite.position.y = -40
	BossArea.position.y = -40
	attack_telegraph.position.y = -40
	BossAttackCollision.position = Vector2(-5, 20)
	
	attack_telegraph.visible = false
	
	agent.avoidance_enabled = true
	agent.radius = 8.0
	agent.neighbor_distance = 64.0


func _physics_process(_delta):
	if is_dead:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	if is_taking_damage:
		velocity = Vector2.ZERO
		move_and_slide()
		return
		
	if is_attacking:
		return
		
	if player == null:
		return
	
	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player <= attack_range:
		_start_attack()
		return

	if distance_to_player > Global.detect_distance + 300:
		_idle_face_player()
		return
	
	var offset_dir = (global_position - player.global_position).normalized()
	var target_pos = player.global_position + offset_dir * Global.stop_distance
	agent.target_position = target_pos
	
	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()
	var distance_to_next = global_position.distance_to(next_point)
	
	if distance_to_player <= Global.stop_distance + 20:
		_idle_face_player()
		return

	if distance_to_next < 6.0:
		_idle_face_player()
		return

	var steering = _get_steering()
	var final_dir = (direction + steering).normalized()

	velocity = final_dir * Global.boss_speed
	agent.set_velocity(velocity)
	move_and_slide()

	if velocity.length() > 0.1:
		if player.global_position.x > global_position.x:
			_animated_enemy_sprite.play("Boss_Walk_Right")
		else:
			_animated_enemy_sprite.play("Boss_Walk_Left")
	else:
		_idle_face_player()

func _idle_face_player():
	if is_taking_damage or is_attacking:
		return

	velocity = Vector2.ZERO
	move_and_slide()

	if player.global_position.x > global_position.x:
		_animated_enemy_sprite.play("Boss_Idle_Right")
	else:
		_animated_enemy_sprite.play("Boss_Idle_Left")

func _start_attack():
	if is_dead or is_taking_damage or is_attacking:
		return

	is_attacking = true
	velocity = Vector2.ZERO
	move_and_slide()

	# Face the player and animate attack
	var facing_right = player.global_position.x > global_position.x
	if facing_right:
		_animated_enemy_sprite.play("Boss_Attack_Right")
		BossAttackCollision.position = Vector2(20, 20)
	else:
		_animated_enemy_sprite.play("Boss_Attack_Left")
		BossAttackCollision.position = Vector2(-5, 20)

	attack_telegraph.visible = true

	var attack_offset = Vector2(50, 0)   # attack moves to left or right side

	if facing_right:
		attack_telegraph.global_position = global_position + attack_offset
	else:
		attack_telegraph.global_position = global_position - attack_offset

	# Delay before hit happens
	await get_tree().create_timer(attack_delay).timeout

	# ------------------------------
	# ACTUAL HIT CHECK
	# ------------------------------
	var bodies = attack_telegraph.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			if Global.iframes == false:
				Global.iframes = true
				Global.iframesTimer = 1.0
				Global.health -= 20

	# Hide telegraph
	attack_telegraph.visible = false

	# wait for animation
	await _animated_enemy_sprite.animation_finished

	is_attacking = false



# -------------------------------
#      Bowss Collision Damage
# -------------------------------
func _on_boss_area_2d_body_entered(body):
	if is_dead or is_taking_damage or is_attacking:
		return

	if body.is_in_group("player"):
		is_taking_damage = true
		velocity = Vector2.ZERO

		if player.global_position.x > global_position.x:
			_animated_enemy_sprite.play("Boss_Damage_Right")
		else:
			_animated_enemy_sprite.play("Boss_Damage_Left")

		Global.boss_health -= 10

		if Global.boss_health <= 0:
			die()
			return

		await _animated_enemy_sprite.animation_finished
		is_taking_damage = false

		if Global.death == false and Global.iframes == false:
			Global.iframes = true
			Global.iframesTimer = 1.0
			Global.health -= 10.0
		else:
			Global.iframes = true


# -------------------------------
#             DEATH
# -------------------------------
func die():
	is_dead = true
	velocity = Vector2.ZERO
	
	if player.global_position.x > global_position.x:
		_animated_enemy_sprite.play("Boss_Death_Right")
	else:
		_animated_enemy_sprite.play("Boss_Death_Left")
	
	await _animated_enemy_sprite.animation_finished
	queue_free()


# -------------------------------
#   LOCAL AVOIDANCE / STEERING
# -------------------------------
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
