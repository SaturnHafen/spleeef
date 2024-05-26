extends Node3D

@export var game_over: PackedScene

#win scenen muss im level noch im inspector reingezogen werden!!!!!!!!!!!!!!!!!!!!!

func _on_player_death(player):
	if len(get_tree().get_nodes_in_group("player")) <= 1:
		get_tree().change_scene_to_packed(game_over)
		
		
#team 2 wins
	if len(get_tree().get_nodes_in_group("team_0")) <= 0:
		get_tree().change_scene_to_packed(game_over)
		
#team 1 wins
	if len(get_tree().get_nodes_in_group("team_1")) <= 0:
		get_tree().change_scene_to_packed(game_over)
		


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
