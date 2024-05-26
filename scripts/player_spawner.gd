extends Marker3D

@export var player: PackedScene
@export var projectile_root: Marker3D

func spawn(character, team, player_id: int, color: Color):
	var new_player: Node3D = player.instantiate()
	character.get_parent().remove_child(character)
	new_player.add_child(character)
	character.name = "Armature"
	new_player.player = player_id
	new_player.projectile_root = projectile_root
	new_player.death.connect($"../.."._on_player_death)
	get_parent().add_child(new_player)
	await new_player.ready
	new_player.global_position = global_position
	new_player.global_rotation = global_rotation
	new_player.add_to_group("team_%d" % team)
