extends Area3D

const graph = preload("res://resources/sdfs/laser.tres")
const length = 20.0

var radius: float
var knockback: float

func _ready():
	# fix random rotation toggling at spawn
	$Mesh.rotation_degrees.z = 90

func _do_destruction():
	var direction = global_transform.basis.x.normalized()
	Voxels.do_graph(
		graph,
		global_position + direction * length / 2.0,
		Vector3(length, radius * 2, radius * 2),
		global_rotation.z,
		global_rotation.y)

	var collisions = get_overlapping_bodies()
	for body in collisions:
		if body.is_in_group("player"):
			var delta = body.global_position - global_position
			delta -= direction * delta.dot(direction)
			body.knockback += delta.normalized() / delta.length() * knockback
