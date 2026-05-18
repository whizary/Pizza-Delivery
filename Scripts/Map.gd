extends Node2D

var current_wave: int
var starting_nodes: int
var current_nodes: int
var wave_spawn_ended
@onready var door: TileMapLayer = $door
@onready var spawn_point = $SpawnPoint
@onready var BossSpawnPoint = $BossSpawnPoint
@onready var demon_slime_boss = preload("res://scenes/player-enemy_scenes/demon_slime_boss.tscn")
@onready var player_scene = preload("res://scenes/player-enemy_scenes/player.tscn")
@onready var orc_enemy = preload("res://scenes/player-enemy_scenes/orc_enemy.tscn")

func _ready():
	var player = player_scene.instantiate()
	if Global.bossroomactive == false and Global.bossalive == false and Global.normalspawn == false:
		spawn_point = $SpawnPoint2
	elif Global.normalspawn == true:
		spawn_point = $SpawnPoint
	player.global_position = spawn_point.global_position
	player.connect("open_door", _door_opened)
	add_child(player)
	Global.set_player_reference(player)
	if get_tree().current_scene.scene_file_path == "res://scenes/map_scenes/Dungeon.tscn":
		var orc = orc_enemy.instantiate()
		orc.global_position = $EnemySpawnPoint.global_position
		add_child(orc)
	if get_tree().current_scene.scene_file_path == "res://scenes/map_scenes/Dungeon.tscn":
		var orc2 = orc_enemy.instantiate()
		orc2.global_position = $EnemySpawnPoint2.global_position
		add_child(orc2)
	if get_tree().current_scene.scene_file_path == "res://scenes/map_scenes/Dungeon.tscn":
		var orc3 = orc_enemy.instantiate()
		orc3.global_position = $EnemySpawnPoint3.global_position
		add_child(orc3)
	if get_tree().current_scene.scene_file_path == "res://scenes/map_scenes/Dungeon.tscn":
		var orc4 = orc_enemy.instantiate()
		orc4.global_position = $EnemySpawnPoint4.global_position
		add_child(orc4)
	if get_tree().current_scene.scene_file_path == "res://scenes/map_scenes/Dungeon.tscn":
		var orc5 = orc_enemy.instantiate()
		orc5.global_position = $EnemySpawnPoint5.global_position
		add_child(orc5)
	if get_tree().current_scene.scene_file_path == "res://scenes/map_scenes/Dungeon.tscn":
		var orc6 = orc_enemy.instantiate()
		orc6.global_position = $EnemySpawnPoint6.global_position
		add_child(orc6)
	if get_tree().current_scene.scene_file_path == "res://scenes/map_scenes/dungeon_boss_room.tscn":
		print("boss")
		var demon_slime = demon_slime_boss.instantiate()
		demon_slime.global_position = $BossSpawnPoint.global_position
		add_child(demon_slime)
		Global.set_player_reference(demon_slime)
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
