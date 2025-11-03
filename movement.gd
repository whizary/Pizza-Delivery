extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

var walk_speed = 150
var gravity = 0
var dodgeCD = 2
var dodgeBool = true

func _process(delta):
	dodgeCD -= delta
	if dodgeCD <=0 && dodgeBool == false:
		dodgeBool = true

func get_input():
	velocity.x = 0
	velocity.y = 0
	
	#VARIABLES
	var right = Input.is_action_pressed('move_right')	
	var left = Input.is_action_pressed('move_left')
	
	var back = Input.is_action_pressed('move_up')
	var forward = Input.is_action_pressed('move_down')
	
	var run = Input.is_key_pressed(KEY_SHIFT)
	var dodge = Input.is_action_just_pressed("KEY_Q")
	
	#DODGE MECHANICS
	if dodge && right && dodgeBool == true:
		position.x += 100
		dodgeBool = false
		dodgeCD = 2
		
	elif dodge && left && dodgeBool == true:
		position.x -= 100
		dodgeBool = false
		dodgeCD = 2
		
	elif dodge && back && dodgeBool == true:
		position.y -= 100
		dodgeBool = false
		dodgeCD = 2
		
	elif dodge && forward && dodgeBool == true:
		position.y += 100
		dodgeBool = false
		dodgeCD = 2
	
	#MOVEMENT MECHANICS
	if run:
		walk_speed = 200
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
		velocity.x = walk_speed * 0.7
		velocity.y = walk_speed * 0.7
	
	elif right && back:
		velocity.x = walk_speed * 0.7
		velocity.y = -walk_speed * 0.7
	
	elif left && back:
		velocity.x = -walk_speed * 0.7
		velocity.y = -walk_speed * 0.7
	
	elif left && forward:
		velocity.x = -walk_speed * 0.7
		velocity.y = walk_speed * 0.7

func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
