extends Node3D

var joined_players = []
var ready_players = []

@export var level: PackedScene

func _on_player_joined(player: Node3D):
	joined_players.push_back(player)
	$StartTimer.stop()

func _on_player_ready(player: Node3D):
	ready_players.push_back(player)
	
	if len(joined_players) == len(ready_players):
		$StartTimer.start()

func _on_starttimer_timeout():
	get_tree().change_scene_to_packed(level)
