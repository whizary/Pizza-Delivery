extends Node
 
var sounds = {
	"grass": [
		preload("res://Audio/grass1.mp3"),
		preload("res://Audio/grass2.mp3"),
		preload("res://Audio/grass3.mp3"),
	],
	"stone": [
		preload("res://Audio/stone1.mp3"),
		preload("res://Audio/stone2.mp3"),
		preload("res://Audio/stone3.mp3"),
	],
	"powerup": preload("res://Audio/powerUp.wav"),
	"powerdown": preload("res://Audio/powerDown.wav"),
	"pickupcoin": preload("res://Audio/pickupCoin.wav"),

}
 
var player: AudioStreamPlayer
 
func _ready():
	player = AudioStreamPlayer.new()
	add_child(player)
 
func play_sound(sound: String):
	if not sounds.has(sound):
		push_warning("Sound '%s' not found" % sound)
		return

	var p = AudioStreamPlayer.new()
	add_child(p)

	p.stream = sounds[sound]
	p.pitch_scale = randf_range(0.95, 1.05)
	p.play()

	p.finished.connect(p.queue_free)
 
 
func play_random_from(category: String):
	if not sounds.has(category):
		return

	var stream = sounds[category].pick_random()

	var p = AudioStreamPlayer.new()
	add_child(p)

	p.stream = stream
	p.pitch_scale = randf_range(0.95, 1.05)
	p.play()

	p.finished.connect(p.queue_free)
