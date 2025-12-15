extends CharacterBody2D
 
@onready var _animated_sprite = $AnimatedSprite2D
 
var walk_speed = 150
var gravity = 0
var dodgeCD = 2
var dodgeBool = true
var normal_walk_speed = 150
var normal_run_speed = 200
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
	if dodge and dodgeBool:
		if back and right:
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
		elif back:
			position += Vector2(0, -100)
		elif forward:
			position += Vector2(0, 100)
		dodgeBool = false
		dodgeCD = 2
	#MOVEMENT MECHANICS
	if run:
		walk_speed = normal_run_speed
	elif right || left || forward || back  || left && forward || left && back || right && forward || right && back:
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
	if left && back:
		velocity.x = -walk_speed * 0.7
		velocity.y = -walk_speed * 0.7
	elif right && forward:
		velocity.x = walk_speed * 0.7
		velocity.y = walk_speed * 0.7
	elif right && back:
		velocity.x = walk_speed * 0.7
		velocity.y = -walk_speed * 0.7
	elif left && forward:
		velocity.x = -walk_speed * 0.7
		velocity.y = walk_speed * 0.7
 
func _physics_process(delta):
	velocity.y += gravity * delta
	get_input()
	move_and_slide()
 
func use_redgem_power_up(): #speed boost
	var powerupduration = 8.0
	print("redgem_powerup")
	normal_walk_speed = walk_speed * 1.5
	normal_run_speed = walk_speed * 1.8
	await get_tree().create_timer(powerupduration).timeout
	print("redgem_powerdown")
	normal_walk_speed = 150
	normal_run_speed = 200

func use_bluegem_power_up(): #invisibility
	var powerupduration = 10.0
	print("bluegem_powerup")
	Global.chase_distance = 0
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 0.4) # blir mer transparent
	await get_tree().create_timer(powerupduration).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1) # resetar transparency
	Global.chase_distance = 250
	print("bluegem_powerdown")
	
func use_yellowgem_power_up():
	var powerupduration = 5.0
	print("yellowgem_powerup")
	
	await get_tree().create_timer(powerupduration).timeout
	print("yellowgem_powerdown")
	
func use_greengem_power_up():
	var powerupduration = 5.0
	print("greengem_powerup")
	
	await get_tree().create_timer(powerupduration).timeout
	print("greengem_powerdown")
	
func use_blackgem_power_up():
	var powerupduration = 5.0
	print("blackgem_powerup")
	
	await get_tree().create_timer(powerupduration).timeout
	print("blackgem_powerdown")
	
func use_blackcoin_power_up(): #invert movement
	var powerupduration = 5.0
	print("blackcoin_powerup")
	InputMap.action_erase_events("move_right")
	InputMap.action_erase_events("move_left")
	InputMap.action_erase_events("move_up")
	InputMap.action_erase_events("move_down")
	var event_d = InputEventKey.new()
	event_d.physical_keycode = KEY_D
	InputMap.action_add_event("move_left", event_d)
	var event_a = InputEventKey.new()
	event_a.physical_keycode = KEY_A
	InputMap.action_add_event("move_right", event_a)
	var event_s = InputEventKey.new()
	event_s.physical_keycode = KEY_S
	InputMap.action_add_event("move_up", event_s)
	var event_w = InputEventKey.new()
	event_w.physical_keycode = KEY_W
	InputMap.action_add_event("move_down", event_w)
	
	await get_tree().create_timer(powerupduration).timeout
	
	print("blackcoin_powerdown")
	
func _on_pickup_zone_body_entered(body):
	pass # Replace with function body.

func _on_pickup_zone_body_exited(body):
	pass # Replace with function body.
