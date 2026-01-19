extends CharacterBody2D
 
@onready var _animated_sprite = $AnimatedSprite2D
@onready var interact_ui = $InteractUI
@onready var inventory_ui = $InventoryUI
 
var walk_speed = 150
var gravity = 0
var dodgeCD = 2
var dodgeBool = true
var normal_walk_speed = 150
var normal_run_speed = 200
 
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
	var dodge = Input.is_action_just_pressed("KEY_SPACE")
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
		walk_speed = normal_run_speed
	elif right || left || back || forward || right && forward || right && back || left && back || left && forward:
		walk_speed = normal_walk_speed
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
		_animated_sprite.play("IdleFront")
	if right && forward:
		velocity.x = walk_speed * 0.6
		velocity.y = walk_speed * 0.6
	elif right && back:
		velocity.x = walk_speed * 0.6
		velocity.y = -walk_speed * 0.6
	elif left && back:
		velocity.x = -walk_speed * 0.6
		velocity.y = -walk_speed * 0.6
	elif left && forward:
		velocity.x = -walk_speed * 0.6
		velocity.y = walk_speed * 0.6
 
func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
 
func use_redgem_power_up():
	var powerupduration = 5.0
	print("powerup")
	normal_walk_speed = walk_speed * 2.0
	normal_run_speed = walk_speed * 3.0
	await get_tree().create_timer(powerupduration).timeout
	print("powerdown")
	normal_walk_speed = walk_speed / 2.0
	normal_run_speed = walk_speed / 3.0

func _ready():
	Global.player_node = self


func _input(event):
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused
