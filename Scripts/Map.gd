extends Node2D

var current_wave: int
@export var orc_scene: PackedScene

var starting_nodes: int
var current_nodes: int
var wave_spawn_ended
@onready var door: TileMapLayer = $door

@onready var spawn_point = $SpawnPoint
var player_scene = preload("res://Scenes/player.tscn")

func _ready():
	var player = player_scene.instantiate()
	player.global_position = spawn_point.global_position
	add_child(player)
	player.connect("open_door", _door_opened)
	#current_wave = 0
	#Global.current_wave = current_wave
	#starting_nodes = get_child_count()
	#current_nodes = get_child_count()
	#position_to_next_wave()
#
#func position_to_next_wave():
	#if current_nodes == starting_nodes:
		#if current_wave != 0:
			#Global.moving_to_next_wave = true
		#current_wave += 1
		#Global.current_wave = current_wave
		#await get_tree().create_timer(0.5).timeout
		#prepare_spawn("orcs", 4.0, 4.0) #type, multiplier, spawns
		#print(current_wave)
#
#func prepare_spawn(type, multiplier, mob_spawns):
	#var mob_amount = float(current_wave) * multiplier
	#var mob_wait_time: float = 2.0
	#print("mob_amount: ", mob_amount)
	#var mob_spawn_rounds = mob_amount/mob_spawns
	#spawn_type(type, mob_spawn_rounds, mob_wait_time)
#
#func spawn_type(type, mob_spawn_rounds, mob_wait_time):
	#if type == "orcs":
		#var orc_spawn1 = $Player/Camera2D/OrcSpawn1
		#var orc_spawn2 = $Player/Camera2D/OrcSpawn2
		#var orc_spawn3 = $Player/Camera2D/OrcSpawn3
		#var orc_spawn4 = $Player/Camera2D/OrcSpawn4
		#if mob_spawn_rounds >= 1:
			#for i in mob_spawn_rounds:
				#var orc1 = orc_scene.instantiate()
				#orc1.global_position = orc_spawn1.global_position
				#var orc2 = orc_scene.instantiate()
				#orc2.global_position = orc_spawn2.global_position
				#var orc3 = orc_scene.instantiate()
				#orc3.global_position = orc_spawn3.global_position
				#var orc4= orc_scene.instantiate()
				#orc4.global_position = orc_spawn4.global_position
				#add_child(orc1)
				#add_child(orc2)
				#add_child(orc3)
				#add_child(orc4)
				#mob_spawn_rounds -= 1
				#await get_tree().create_timer(mob_wait_time).timeout
		#wave_spawn_ended = true

func _door_opened():
	print("signal open door")
	door.visible = false
