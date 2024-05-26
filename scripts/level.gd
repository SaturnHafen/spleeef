extends Node3D

@export var game_over: PackedScene

#win scenen muss im level noch im inspector reingezogen werden!!!!!!!!!!!!!!!!!!!!!

func _on_player_death(player):
	if len(get_tree().get_nodes_in_group("player")) <= 1:
		get_tree().change_scene_to_packed(game_over)
		
		
#team 2 wins
	if len(get_tree().get_nodes_in_group("team_0"))<=0:
		get_tree().change_scene_to_packed(game_over)
		game_over.win_team = 2
		#luke macht grad farbe die die leute wählen für ihr team
		#hier muss dann farbe geholt und dan game_over scene übertragen werden
		
#team 1 wins
	if len(get_tree().get_nodes_in_group("team_1"))<=0:
		get_tree().change_scene_to_packed(game_over)
		game_over.win_team = 1
		
