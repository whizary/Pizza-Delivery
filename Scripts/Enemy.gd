extends CharacterBody2D

@onready var _animated_enemy_sprite = $EnemyAnimatedSprite2D

@export var speed = 140.0
@export var stop_distance = 35.0

var player = null

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:
		return 

	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player <= Global.chase_distance and distance_to_player > stop_distance:
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
		if velocity.x >= 0.000001:
			_animated_enemy_sprite.play("run_right")
		elif velocity.x <= -0.000001:
			_animated_enemy_sprite.play("run_left")
	else:
		_animated_enemy_sprite.play("idle_right")
		velocity = Vector2.ZERO
	move_and_slide()

func _on_player_area_2d_body_entered(body):
	if body.name == "Enemy" and Global.iframes == false:
		queue_free()

