extends Node3D

var joined_players: Array = []
var ready_players: Array = []

@export var level: PackedScene

func _ready():
	print("Joypads" + str(Input.get_connected_joypads()))
	
	print(Input.get_joy_info(0))
	print(Input.get_joy_info(1))
	print(Input.get_joy_info(2))
	
	#sound
	$AudioStreamPlayer3D.play()

func _on_player_joined(player: Node3D):
	joined_players.push_back(player)
	$StartTimer.stop()

func _on_player_ready(player: Node3D):
	ready_players.push_back(player)
	
	if len(joined_players) == len(ready_players):
		$StartTimer.start()

func _on_starttimer_timeout():
	var arena: Node3D = level.instantiate()
	
	var spawner = arena.get_node("Player").get_children()
	
	for i in min(len(spawner), len(ready_players)):
		var p = ready_players[i]
		spawner[i].spawn(p.selected_team, p.player, p.team_colors[p.selected_team])
	
	get_tree().root.add_child(arena)
	get_tree().root.remove_child(self)
