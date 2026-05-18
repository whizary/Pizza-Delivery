extends Area2D

var player_inside = false
var player = null

func _ready():
	visible = true
	monitoring = true

func _process(_delta):
	if player_inside and Input.is_action_just_pressed("take_quest"):
		collect_pizza()

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_inside = true
		player = body

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_inside = false
		player = null

func collect_pizza():
	# Bara collecta pizzan om Henry-questen är aktiv
	if Global.keyquest_index != 1:
		return

	Global.HenryquestComplete = true

	# Om du vill öppna boss-dörren direkt:
	Global.bossdooropen = true

	queue_free()
