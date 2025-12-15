extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D

var walk_speed = 150
var gravity = 0
var dodgeCD = 2
var dodgeBool = true
var normal_walk_speed = 150
var normal_run_speed = 200
var stamina = 100
var staminaDrain = 5
@onready var inventory = $Inventory

func _process(delta):
	dodgeCD -= delta
	if dodgeCD <=0 && dodgeBool == false:
		dodgeBool = true

func _input(event):
	if event.is_action_pressed("inventory"):
		inventory.visible = !inventory.visible
		$Inventory.initialize_inventory()
	if event.is_action_pressed("pickup"):
		if $PickupZone.items_in_range.size() > 0:
			var pickup_item = $PickupZone.items_in_range.values()[0]
			pickup_item.pick_up_item(self)
			$PickupZone.items_in_range.erase(pickup_item)

func _physics_process(delta):
	velocity.y += gravity * delta
	move_and_slide()
	velocity.x = 0
	velocity.y = 0
	
	var run = Input.is_action_pressed("run")
	var forward = Input.is_action_pressed('move_down')
	var right = Input.is_action_pressed('move_right')
	var left = Input.is_action_pressed('move_left')
	var back = Input.is_action_pressed('move_up')
	
	var dodge = Input.is_action_just_pressed("dodge")
	
		#DODGE MECHANICS
	if dodge and dodgeBool:
		if back:
			position += Vector2(0, -100)
		elif back and right:
			position += Vector2(70, -70)
		elif back and left:
			position += Vector2(-70, -70)
		elif forward and right:
			position += Vector2(70, 70)
		elif forward and left:
			position += Vector2(-70, 70)
		elif right:
			position += Vector2(100, 0)
		elif left:
			position += Vector2(-100, 0)
		elif forward:
			position += Vector2(0, 100)
	
		dodgeBool = false
		dodgeCD = 2
	
	#MOVEMENT MECHANICS
	if run && stamina >= 0:
		walk_speed = normal_run_speed
		stamina = -delta
		
	elif right or left or forward or back  or left && forward or left && back or right && forward or right && back:
		walk_speed = normal_walk_speed
	
	#if stamina <= 0:
		#stamina = -2
	
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
		velocity.x = walk_speed * 0.7
		velocity.y = walk_speed * 0.7
	
	elif left && back:
		velocity.x = -walk_speed * 0.7
		velocity.y = -walk_speed * 0.7
		
	elif right && back:
		velocity.x = walk_speed * 0.7
		velocity.y = -walk_speed * 0.7
	
	elif left && forward:
		velocity.x = -walk_speed * 0.7
		velocity.y = walk_speed * 0.7

func use_redgem_power_up():
	var powerupduration = 5.0
	print("powerup")
	normal_walk_speed = walk_speed * 2.0
	normal_run_speed = walk_speed * 3.0
	await get_tree().create_timer(powerupduration).timeout
	print("powerdown")
	normal_walk_speed = 150
	normal_run_speed = 200
 
func _on_pickup_zone_body_entered(body):
	pass # Replace with function body.
 
 
func _on_pickup_zone_body_exited(body):
	pass # Replace with function body.
