extends Node3D

@export var game_over: PackedScene

func _on_player_death():
	if len(get_tree().get_nodes_in_group("player")) <= 1:
		get_tree().change_scene_to_packed(game_over)
