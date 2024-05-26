extends Node3D

@export var game_over: PackedScene

#win scenen muss im level noch im inspector reingezogen werden!!!!!!!!!!!!!!!!!!!!!

func _ready():
	#sound
	$AudioStreamPlayer3D_1.play()

func _on_player_death(player):
	var team_won = -1
	for i in range(len(GameOverData.team_colors)):
		if len(get_tree().get_nodes_in_group("team_%d" % i)) >= 1:
			if team_won >= 0:
				team_won = -1
				break
			else:
				team_won = i
	
	if team_won >= 0:
		GameOverData.team_won = team_won
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		return
	
	if len(get_tree().get_nodes_in_group("player")) <= 0:
		GameOverData.team_won = -1
		get_tree().change_scene_to_file("res://scenes/game_over.tscn")
		return


func _on_item_spawner_timer_timeout():
	var Spawner = preload("res://scenes/item_spawner.tscn")
	var InstSpawner = Spawner.instantiate()
	var SpawnerPosition = Vector3(randf_range(-15, 15), 0.5, randf_range(-15, 15))
	var ItemArray = [preload("res://scenes/items/snowball.tscn"), preload("res://scenes/items/rocket_launcher.tscn"),
	 preload("res://scenes/items/laser_gun.tscn"), preload("res://scenes/items/impulse_laser_gun.tscn"),
	 preload("res://scenes/items/grenade_launcher.tscn")]
	
	add_child(InstSpawner)
	InstSpawner.global_position = SpawnerPosition
	InstSpawner.projectile_root = $ProjectileRoot
	InstSpawner.spawnable_item = ItemArray.pick_random()




#wenn sectionuberg1 fertig wird section 2 gestartet
func _on_audio_stream_player_3d_1_finished():
	$AudioStreamPlayer3D_2.play()


func _on_audio_stream_player_3d_3_finished():
	$AudioStreamPlayer3D_4.play()
	
