extends Marker3D

func add_player(player: Player):
	position.y = player.id * 20
	$PlayerRoot.add_child(player)
