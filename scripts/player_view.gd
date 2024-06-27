class_name PlayerView extends Control

func get_camera() -> Camera3D:
	var camera = Camera3D.new()
	$SubViewportContainer/SubViewport.add_child(camera)
	return camera

func _ready():
	update_font_size()

func update_font_size():
	set_font_size(size.x / 20)

var player_selector: Node3D

func add_player(player: Player):
	player_selector = preload("res://scenes/player_selector.tscn").instantiate()
	$SubViewportContainer/SubViewport.add_child(player_selector)
	player_selector.add_player(player)

func remove_player():
	$SubViewportContainer/SubViewport.remove_child(player_selector)

func set_font_size(font_size: float):
	for label in [$Team, $Weapon, $Ammo, $Info]:
		(label as Label).add_theme_font_size_override(&"font_size", font_size)

func set_info(info: String):
	$Info.text = info

func set_team_name(team: String):
	$Team.text = team

func set_weapon_name(weapon: String):
	$Weapon.text = weapon

func set_ammo(ammo: String):
	$Ammo.text = ammo
