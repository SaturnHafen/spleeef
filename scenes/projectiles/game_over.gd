extends Node2D

var win_team: int
@export var level: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	if win_team == 1:
		$CanvasLayer/MarginContainer/PanelContainer/VBoxContainer_rows/title.text = "team 1 wins"
	if win_team == 2:
		$CanvasLayer/MarginContainer/PanelContainer/VBoxContainer_rows/title.text = "team 2 wins"
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_restart_button_pressed():
	get_tree().change_scene_to_packed(level)


func _on_quit_button_pressed():
	get_tree().quit()
