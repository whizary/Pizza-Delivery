extends CharacterBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var item_name

var player = null
var being_picked_up = false


func _ready():
	item_name = "Food"
	$AnimationPlayer.play("Float")



func _physics_process(delta):
	if being_picked_up == false:
		velocity = Vector2.ZERO  # stå helt still
	else:
		var direction = global_position.direction_to(player.global_position)
		velocity = velocity.move_toward(direction * MAX_SPEED, ACCELERATION * delta)

		if global_position.distance_to(player.global_position) < 100:
			PlayerInventory.add_item(item_name, 1)
			queue_free()

	move_and_slide()


func pick_up_item(body):
	player = body
	being_picked_up = true
