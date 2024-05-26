extends Node2D

var win_team: int
var level_scene = load("res://scenes/player_selection.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	if win_team == 1:
		$CanvasLayer/MarginContainer/PanelContainer/VBoxContainer_rows/title.text = "team 1 wins"
	if win_team == 2:
		$CanvasLayer/MarginContainer/PanelContainer/VBoxContainer_rows/title.text = "team 2 wins"
	

func _on_restart_button_pressed():
	var new_round = level_scene.instantiate()
	
	for child in get_tree().root.get_children():
		child.queue_free()
	
	get_tree().root.add_child(new_round)


func _on_quit_button_pressed():
	get_tree().quit()
