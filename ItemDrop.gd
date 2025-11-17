extends CharacterBody2D

const ACCELERATION = 460
const MAX_SPEED = 225
var item_name

func _ready():
	item_name = "Food"
	$AnimationPlayer.play("Float")



func _physics_process(_delta):
	move_and_slide()
