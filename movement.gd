extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

var walk_speed = 150
var gravity = 0

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('move_right')	
	var left = Input.is_action_pressed('move_left')
	
	velocity.y = 0
	var back = Input.is_action_pressed('move_up')
	var forward = Input.is_action_pressed('move_down')
	
	var run = Input.is_key_pressed(KEY_SHIFT)
	
	if run:
		walk_speed = 225
	elif right || left || back || forward || right && forward || right && back || left && back || left && forward:
		walk_speed = 150

	if right:
		velocity.x += walk_speed
		_animated_sprite.play("WalkRight")
		
	elif left:
		velocity.x -= walk_speed
		_animated_sprite.play("WalkLeft")

	elif back:
		velocity.y -= walk_speed
		_animated_sprite.play("WalkBack")
	
	elif forward:
		velocity.y += walk_speed
		_animated_sprite.play("WalkForward")	
	
	else:
		_animated_sprite.stop()
	
	if right && forward:
		velocity.x = walk_speed
		velocity.y = walk_speed
	
	elif right && back:
		velocity.x = walk_speed
		velocity.y = -walk_speed
	
	elif left && back:
		velocity.x = -walk_speed
		velocity.y = -walk_speed
	
	elif left && forward:
		velocity.x = -walk_speed
		velocity.y = walk_speed


func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
