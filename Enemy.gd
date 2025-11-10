extends CharacterBody2D

@onready var _animated_enemy_sprite = $EnemyAnimatedSprite2D

@export var speed = 160.0
@export var chase_distance = 250.0
@export var stop_distance = 40.0

var player = null

func _ready():
	# Find the player node in the scene
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	if player == null:		
		return 

	var distance_to_player = global_position.distance_to(player.global_position)

	if distance_to_player <= chase_distance and distance_to_player > stop_distance:
		# Move towards the player
		_animated_enemy_sprite.play("run_left")
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * speed
	else:
		_animated_enemy_sprite.play("idle_right")
		velocity = Vector2.ZERO

	move_and_slide()
