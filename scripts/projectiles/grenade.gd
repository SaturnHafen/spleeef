extends RigidBody3D

var graph = preload("res://resources/sdfs/noisy_sphere.tres");

@export var knockback: float = 10

func on_timer_timeout():
	Voxels.do_graph(graph, global_position, Vector3(35, 35, 35))
	queue_free()
	
	var collisions = $KnockbackArea.get_overlapping_bodies()
	for body in collisions:
		if body.is_in_group("player"):
			var delta = body.position - position
			body.knockback += delta.normalized() / delta.length() * knockback
