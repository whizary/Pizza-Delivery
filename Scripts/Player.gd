extends CharacterBody2D
@onready var powerupsound = $powerup
@onready var powerdownsound = $powerdown
@onready var pickupcoinsound = $pickupcoin
@onready var _animated_sprite = $AnimatedSprite2D
@onready var interact_ui = $InteractUI
@onready var inventory_ui = $InventoryUI
 
var gravity = 0
var bluepowerup = false
 
#Dodge variables
var dodgeCD = 2.0
var dodgeBool = true
 
#Movement variables
var walk_speed = 150.0
var normal_walk_speed = 150.0
var normal_run_speed = 200.0
 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
 
func _process(delta):
	dodgeCD -= delta
	if dodgeCD <=0 && dodgeBool == false:
		dodgeBool = true
 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ 

func _physics_process(delta):
	$Camera2D/Label.text = "STA: " + str(round(Global.stamina))
	$Camera2D/Label2.text = "HP: " + str(round(Global.health))
	velocity.y += gravity * delta
	move_and_slide()
	velocity.x = 0
	velocity.y = 0

	#Movement variables
	var run = Input.is_action_pressed("run")
	var forward = Input.is_action_pressed('move_down')
	var right = Input.is_action_pressed('move_right')
	var left = Input.is_action_pressed('move_left')
	var back = Input.is_action_pressed('move_up')
	var dodge = Input.is_action_just_pressed("dodge")

	#DODGE
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
		dodgeCD = 2.0

	#HEALTH
	if Global.health <= 0 and Global.death == false:
		Global.death = true
		Global.health = 0
		print("GAME OVER")
	if Global.iframes == true and Global.death == false:
		Global.iframesTimer -= delta
	if Global.iframesTimer <= 0:
		Global.iframes = false
	#STAMINA AND RUN CODE
	if Global.stamina > Global.maxStamina:
		Global.stamina = Global.maxStamina
	if Global.stamina <= 0 and run == false or Global.stamina >= 0 and run == false:
		Global.stamina += delta * Global.staminaRecovery
	if run and Global.stamina > 0:
		walk_speed = normal_run_speed
		Global.stamina -= delta * Global.staminaDrain
	elif right or left or forward or back  or left && forward or left && back or right && forward or right && back:		
		walk_speed = normal_walk_speed

	#MOVEMENT
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
 
#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

func _on_player_area_2d_body_entered(body):
	if body.name == "Enemy" and Global.iframes == false:
		Global.iframes = true
		Global.iframesTimer = 1.0
		print("Player hit")
		Global.health -= 10.0
	if bluepowerup == true and body.name == "Enemy":
		$forceshield.visible = false # hide
		print("bluegem_powerdown")
		powerdownsound.play()
		bluepowerup = false
	#if body.is_in_group("enemy"):
		#body.queue_free()
 
func use_redgem_power_up(): # damage boost
	var powerupduration = 5.0
	print("redgem_powerup")
	powerupsound.play()
	await get_tree().create_timer(powerupduration).timeout
	print("redgem_powerdown")
	powerdownsound.play()

func use_bluegem_power_up(): #force shield
	bluepowerup = true
	print("bluegem_powerup")
	powerupsound.play()
	$forceshield.visible = true  # show

func use_yellowgem_power_up(): # speed boost
	var powerupduration = 8.0
	print("yellowgem_powerup")
	normal_walk_speed = walk_speed * 1.4
	normal_run_speed = walk_speed * 1.7
	powerupsound.play()
	await get_tree().create_timer(powerupduration).timeout
	print("yellowgem_powerdown")
	normal_walk_speed = 150.0
	normal_run_speed = 200.0
	powerdownsound.play()

func use_greengem_power_up(): # health boost
	print("greengem_powerup")
	Global.health = 100.0
	powerupsound.play()

func use_blackgem_power_up(): #invisibility men lite slowness
	var powerupduration = 10.0
	print("blackgem_powerup")
	normal_walk_speed = walk_speed * 0.75
	normal_run_speed = (walk_speed + 50) * 0.75
	Global.chase_distance = 0
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 0.4) # blir mer transparent
	powerupsound.play()
	await get_tree().create_timer(powerupduration).timeout
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1) # resetar transparency
	Global.chase_distance = 250.0
	normal_walk_speed = 150.0
	normal_run_speed = 200.0
	powerdownsound.play()
	print("blackgem_powerdown")

func use_blackcoin_power_up(): #invert movement
	var powerupduration = 25.0
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
	pickupcoinsound.play()
	await get_tree().create_timer(powerupduration).timeout
	InputMap.action_erase_events("move_right")
	InputMap.action_erase_events("move_left")
	InputMap.action_erase_events("move_up")
	InputMap.action_erase_events("move_down")
	event_d = InputEventKey.new()
	event_d.physical_keycode = KEY_D
	InputMap.action_add_event("move_right", event_d)
	event_a = InputEventKey.new()
	event_a.physical_keycode = KEY_A
	InputMap.action_add_event("move_left", event_a)
	event_s = InputEventKey.new()
	event_s.physical_keycode = KEY_S
	InputMap.action_add_event("move_down", event_s)
	event_w = InputEventKey.new()
	event_w.physical_keycode = KEY_W
	InputMap.action_add_event("move_up", event_w)
	print("blackcoin_powerdown")

func use_redcoin_power_up(): # blindness and slowness
	var powerupduration = 18.0
	print("redcoin_powerup")
	$Blackscreenmode.modulate = Color(1, 1, 1, 1) # show
	$Blackscreenmega.modulate = Color(1, 1, 1, 1) # show
	normal_walk_speed = walk_speed * 0.6
	normal_run_speed = (walk_speed + 50) * 0.6
	pickupcoinsound.play()
	await get_tree().create_timer(powerupduration).timeout
	$Blackscreenmode.modulate = Color(1, 1, 1, 0) # hide
	$Blackscreenmega.modulate = Color(1, 1, 1, 0) # hide
	normal_walk_speed = 150
	normal_run_speed = 200
	print("redcoin_powerdown")

#func _ready():
#	Global.player_node = self
 
func _input(event):
	if event.is_action_pressed("inventory"):
		inventory_ui.visible = !inventory_ui.visible
		get_tree().paused = !get_tree().paused
