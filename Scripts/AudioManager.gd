extends Node

var music_player: AudioStreamPlayer
var music_volume_db: float = -4.0

var sounds = {
	"grass": [
		preload("res://audio/grass1.mp3"),
		preload("res://audio/grass2.mp3"),
		preload("res://audio/grass3.mp3"),
	],
	"stone": [
		preload("res://audio/stone1.mp3"),
		preload("res://audio/stone2.mp3"),
		preload("res://audio/stone3.mp3"),
	],
	"BossWalk": [
		preload("res://audio/stomp1.mp3"),
		preload("res://audio/stomp2.mp3"),
	],
	"BossHurt": [
		preload("res://audio/BossHurt1.wav"),
		preload("res://audio/BossHurt2.wav"),
	],
	"BossAttack": [
		preload("res://audio/BossSlam1.wav"),
		preload("res://audio/BossSlam2.wav"),
	],
	"BossDeath": [
		preload("res://audio/BossDeath.wav"),
	],
	"BossMusic1": preload("res://audio/Music/BossMusic1.mp3"),
	"powerup": preload("res://audio/powerUp.wav"),
	"powerdown": preload("res://audio/powerDown.wav"),
	"pickupcoin": preload("res://audio/pickupCoin.wav"),
}

func play_music(track: String):
	if not sounds.has(track):
		return

	if music_player and music_player.playing:
		return

	if music_player == null:
		music_player = AudioStreamPlayer.new()
		add_child(music_player)
		music_player.bus = "Music"

	music_player.stream = sounds[track]
	music_player.volume_db = 0
	music_player.play()

func play_sound(sound: String):
	if not sounds.has(sound):
		return
	var p = AudioStreamPlayer.new()
	add_child(p)
	p.stream = sounds[sound]
	p.pitch_scale = randf_range(1, 1)
	p.volume_db = 0
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
	p.volume_db = -6
	p.play()
	p.finished.connect(p.queue_free)

func play_boss_sound(boss: Node2D, category: String):
	if not sounds.has(category):
		return
	var stream = sounds[category].pick_random()
	var p = AudioStreamPlayer2D.new()
	boss.add_child(p)
	p.stream = stream
	p.pitch_scale = randf_range(0.95, 1.05)
	p.volume_db = 3
	p.play()
	p.finished.connect(p.queue_free)

func play_enemy_sound(enemy: Node2D, category: String):
	if not sounds.has(category):
		return
	var stream = sounds[category].pick_random()
	var p = AudioStreamPlayer2D.new()
	enemy.add_child(p)
	p.stream = stream
	p.pitch_scale = randf_range(0.95, 1.05)
	p.play()
	p.finished.connect(p.queue_free)
