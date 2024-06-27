extends Node3D

var spawn_height = 0

func _ready():
	$AudioStreamPlayer3D_1.play()

func spawn(players: Array[Player]):
	var increment = TAU / len(players)
	var angle = 0
	for player in players:
		add_child(player)
		player.look_at(Vector3(0, spawn_height, 0))
		var horizontal = Vector2.from_angle(angle)
		player.position = Vector3(horizontal.x, spawn_height, horizontal.y)
		angle += increment

func _on_item_spawner_timer_timeout():
	var Spawner = preload("res://scenes/item_spawner.tscn")
	var InstSpawner = Spawner.instantiate()
	var SpawnerPosition = Vector3(randf_range(-15, 15), 0.5, randf_range(-15, 15))
	var ItemArray = [preload("res://scenes/items/rocket_launcher.tscn"),
	 preload("res://scenes/items/laser_gun.tscn"), preload("res://scenes/items/impulse_laser_gun.tscn"),
	 preload("res://scenes/items/grenade_launcher.tscn")]

	add_child(InstSpawner)
	InstSpawner.global_position = SpawnerPosition
	InstSpawner.projectile_root = $ProjectileRoot
	InstSpawner.spawnable_item = ItemArray.pick_random()

func _on_soundtimer_2_timeout():
	$AudioStreamPlayer3D_2.stop()
	$AudioStreamPlayer3D_3.play()

func _on_audio_stream_player_3d_1_finished():
	$AudioStreamPlayer3D_2.play()

func _on_audio_stream_player_3d_3_finished():
	$AudioStreamPlayer3D_4.play()
