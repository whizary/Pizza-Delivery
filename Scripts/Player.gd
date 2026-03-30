extends CharacterBody2D
@onready var door: Node2D = $"map/door"
@onready var _animated_sprite = $AnimatedSprite2D
@onready var interact_ui = $InteractUI
@onready var inventory_ui = $InventoryUI
@onready var inventory_hotbar = $InventoryHotbar

var player_in_range = false
var gravity = 0
var bluepowerup = false

var delay = 0
var dooropen = false

#Dodge variables
var dodgeCD = 2.0
var dodgeBool = true

#Movement variables

var walk_speed = 150.0
var normal_walk_speed = 150.0
var normal_run_speed = 200.0

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

func _ready():
	Global.movement = true
	
func _process(delta):
	dodgeCD -= delta
	if dodgeCD <=0 && dodgeBool == false:
		dodgeBool = true

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

func _physics_process(delta):
	$Camera2D/STA_bar.value = Global.stamina
	$Camera2D/HP_bar.value = Global.health
	Global.player_node = self

	if Global.movement == false:
		velocity = Vector2.ZERO
		_animated_sprite.play("IdleFront")
		move_and_slide()
		return

	velocity = Vector2.ZERO
	velocity.y += gravity * delta
	
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

	if Global.health <= 0.0 and Global.death == false:

		Global.death = true
		print("GAME OVER")

	if Global.iframes == true and Global.death == false:

		Global.iframesTimer -= delta

	if Global.iframesTimer <= 0.0:

		Global.iframes = false
	
	#STAMINA AND RUN CODE

	if Global.stamina > Global.maxStamina:

		Global.stamina = Global.maxStamina

	if Global.stamina <= 0.0 and run == false or Global.stamina >= 0.0 and run == false:

		Global.stamina += delta * Global.staminaRecovery

	if run and Global.stamina > 0.0:

		walk_speed = normal_run_speed

		Global.stamina -= delta * Global.staminaDrain

	elif right or left or forward or back  or left && forward or left && back or right && forward or right && back:

		walk_speed = normal_walk_speed

	if run and delay <= 0:

		delay = 0.3

		AudioManager.play_random_from("grass")

	elif right and delay <= 0 or left and delay <= 0 or forward and delay <= 0 or back and delay <= 0  or left && forward and delay <= 0 or left && back and delay <= 0 or right && forward and delay <= 0 or right && back and delay <= 0:

		delay = 0.5

		AudioManager.play_random_from("grass")

	else:

		delay -= delta
		
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

	if bluepowerup == true and Global.iframes == true:
		$forceshield.visible = false # hide

		print("bluegem_powerdown")
		AudioManager.play_sound("powerdown")
		bluepowerup = false
	
	move_and_slide()

#------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

func use_redgem_power_up(): # damage boost

	var powerupduration = 5.0

	print("redgem_powerup")
	AudioManager.play_sound("powerup")
	await get_tree().create_timer(powerupduration).timeout

	print("redgem_powerdown")
	AudioManager.play_sound("powerdown")

func use_bluegem_power_up(): #force shield

	bluepowerup = true

	print("bluegem_powerup")
	AudioManager.play_sound("powerup")
	$forceshield.visible = true  # show
	
func use_yellowgem_power_up(): # speed boost

	var powerupduration = 8.0

	print("yellowgem_powerup")

	normal_walk_speed = walk_speed * 1.4

	normal_run_speed = walk_speed * 1.7
	AudioManager.play_sound("powerup")
	await get_tree().create_timer(powerupduration).timeout

	print("yellowgem_powerdown")

	normal_walk_speed = 150.0

	normal_run_speed = 200.0
	AudioManager.play_sound("powerdown")

func use_greengem_power_up(): # health boost

	print("greengem_powerup")

	Global.health = 100.0
	AudioManager.play_sound("powerup")

func use_blackgem_power_up(): #invisibility men lite slowness

	var powerupduration = 10.0

	print("blackgem_powerup")

	normal_walk_speed = walk_speed * 0.75

	normal_run_speed = (walk_speed + 50) * 0.75
	Global.stop_distance = 9999999999999
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 0.4) # blir mer transparent
	AudioManager.play_sound("powerup")
	await get_tree().create_timer(powerupduration).timeout

	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1) # resetar transparency
	Global.stop_distance = 35.0
	normal_walk_speed = 150.0

	normal_run_speed = 200.0
	AudioManager.play_sound("powerdown")
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
	AudioManager.play_sound("pickupcoin")
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
	AudioManager.play_sound("powerdown")
	print("blackcoin_powerdown")

func use_redcoin_power_up(): # blindness and slowness

	var powerupduration = 18.0

	print("redcoin_powerup")

	$Blackscreenmode.modulate = Color(1, 1, 1, 1) # show

	$Blackscreenmega.modulate = Color(1, 1, 1, 1) # show

	normal_walk_speed = walk_speed * 0.6

	normal_run_speed = (walk_speed + 50) * 0.6
	AudioManager.play_sound("pickupcoin")
	await get_tree().create_timer(powerupduration).timeout

	$Blackscreenmode.modulate = Color(1, 1, 1, 0) # hide

	$Blackscreenmega.modulate = Color(1, 1, 1, 0) # hide

	normal_walk_speed = 150

	normal_run_speed = 200
	AudioManager.play_sound("powerdown")
	print("redcoin_powerdown")

func use_key():
	door.visible = false
	dooropen = true
	print("key_picked_up")

func _input(event):

	if event.is_action_pressed("inventory"):

		inventory_ui.visible = !inventory_ui.visible

		get_tree().paused = !get_tree().paused

		inventory_hotbar.visible = !inventory_hotbar.visible

func apply_item_effect(item):
	match item["effect"]:
		"Stamina":
			normal_walk_speed = 200.0
			normal_run_speed = 250.0
			print("Walk speed increased to ", normal_walk_speed," and run speed to ", normal_run_speed)
		"Slot Boost":
			Global.increase_inventory_size(5)
			print("Slots increased to ", Global.inventory.size())
		"Health boost":
			Global.maxHealth = 200
			Global.health = Global.maxHealth
		_:
			print("There is no effect for this item")
 
func use_hotbar_item(slot_index):

	if slot_index < Global.hotbar_inventory.size():

		var item = Global.hotbar_inventory[slot_index]

		if item != null:

			apply_item_effect(item)

			item["quantity"] -= 1

			if item["quantity"] <= 0:

				Global.hotbar_inventory[slot_index] = null

				Global.remove_item(item["type"], item["effect"])

			Global.inventory_updated.emit()

func _unhandled_input(event):

	if event is InputEventKey and event.pressed:

		for i in range(Global.hotbar_size):

			if Input.is_action_just_pressed("hotbar_" + str(i + 1)):

				use_hotbar_item(i)

				break

func use_door():
	if dooropen == true:
		print("newmap")
		get_tree().change_scene_to_file("res://menu.tscn") # Byter till meny scenen när man går in i dörröppningen
