extends CharacterBody2D

@onready var _animated_enemy_sprite = $AnimatedBossSprite2D
@onready var BossArea = $BossArea2D
@onready var agent = $NavigationAgent2D
@onready var attack_telegraph = $AttackTelegraph
@onready var BossAttackCollision = $AttackTelegraph/CollisionShape2D
@onready var AttackAreaVisible = $AttackTelegraph/ColorRect

var player = null
var is_dead = false
var is_taking_damage = false
var is_attacking = false
var attack_delay = 0.8

var phase_2 = false
var phase_2_speed_multiplier = 1.5
var phase_2_attack_speed_multiplier = 1.5

var stomp_cooldown := 0.0
var stomp_interval := 0.8

func _ready():
	player = get_tree().get_first_node_in_group("player")
	_animated_enemy_sprite.play("idle_right")
	_animated_enemy_sprite.position.y = -40
	BossArea.position.y = -40
	attack_telegraph.visible = false
	agent.avoidance_enabled = true
	agent.radius = 8.0
	agent.neighbor_distance = 64.0

func _physics_process(delta):
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

	stomp_cooldown -= delta

	var bodies = attack_telegraph.get_overlapping_bodies()
	var player_in_attack_zone = false
	for b in bodies:
		if b.is_in_group("player"):
			player_in_attack_zone = true
			break

	if player_in_attack_zone:
		_start_attack()
		return

	agent.target_position = player.global_position
	var next_point = agent.get_next_path_position()
	var direction = (next_point - global_position).normalized()

	velocity = direction * Global.boss_speed
	agent.set_velocity(velocity)
	move_and_slide()

	if velocity.length() > 0.1:
		if player.global_position.x > global_position.x:
			_animated_enemy_sprite.play("Boss_Walk_Right")
			_play_stomp()
			BossAttackCollision.position = Vector2(70, 20)
			AttackAreaVisible.position = Vector2(-5, -15)
		else:
			_animated_enemy_sprite.play("Boss_Walk_Left")
			_play_stomp()
			BossAttackCollision.position = Vector2(-55, 20)
			AttackAreaVisible.position = Vector2(-130, -15)
	else:
		_idle_face_player()

func _play_stomp():
	if stomp_cooldown <= 0.0:
		AudioManager.play_boss_sound(self, "BossWalk")
		stomp_cooldown = stomp_interval

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

	var facing_right = player.global_position.x > global_position.x
	if facing_right:
		_animated_enemy_sprite.play("Boss_Attack_Right")
		BossAttackCollision.position = Vector2(70, 20)
		AttackAreaVisible.position = Vector2(-5, -15)
	else:
		_animated_enemy_sprite.play("Boss_Attack_Left")
		BossAttackCollision.position = Vector2(-55, 20)
		AttackAreaVisible.position = Vector2(-130, -15)

	attack_telegraph.visible = true
	BossAttackCollision.visible = true
	AttackAreaVisible.visible = true

	await get_tree().create_timer(attack_delay).timeout

	var bodies = attack_telegraph.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			if Global.iframes == false:
				Global.iframes = true
				Global.iframesTimer = Global.iframesTimer
				Global.health -= 20

	attack_telegraph.visible = false
	BossAttackCollision.visible = false
	AttackAreaVisible.visible = false
	
	await _animated_enemy_sprite.animation_finished
	is_attacking = false

func _on_boss_area_2d_body_entered(body):
	if is_dead:
		return
	if Global.death == true:
		return
	if body.is_in_group("player"):
		if is_attacking:
			Global.boss_health -= 10
			_check_phase_2()
			if Global.boss_health <= 0:
				die()
			return
		if is_taking_damage:
			return
		
		is_taking_damage = true
		velocity = Vector2.ZERO
		
		if player.global_position.x > global_position.x:
			_animated_enemy_sprite.play("Boss_Damage_Right")
		else:
			_animated_enemy_sprite.play("Boss_Damage_Left")

		Global.boss_health -= 10
		_check_phase_2()

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

func die():
	is_dead = true
	velocity = Vector2.ZERO
	if player.global_position.x > global_position.x:
		_animated_enemy_sprite.play("Boss_Death_Right")
	else:
		_animated_enemy_sprite.play("Boss_Death_Left")
	await _animated_enemy_sprite.animation_finished
	queue_free()

func _check_phase_2():
	if phase_2:
		return
	if Global.boss_health <= Global.boss_max_health * 0.5:
		phase_2 = true
		_enter_phase_2()

func _enter_phase_2():
	Global.boss_speed *= phase_2_speed_multiplier
	attack_delay /= phase_2_attack_speed_multiplier
	_animated_enemy_sprite.speed_scale = phase_2_attack_speed_multiplier
	stomp_interval /= phase_2_speed_multiplier

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
