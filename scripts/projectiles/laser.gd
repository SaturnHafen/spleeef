extends Area3D

const graph = preload("res://resources/sdfs/laser.tres")
const length = 20.0
const radius = 0.5

func _do_destruction():
	Voxels.do_graph(
		graph,
		global_position + global_transform.basis.x.normalized() * length / 2.0,
		Vector3(length * 5, radius * 10, radius * 10),
		global_rotation.z,
		global_rotation.y)
