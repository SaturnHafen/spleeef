extends RigidBody3D

var graph = preload("res://resources/sdfs/noisy_sphere.tres");

func on_timer_timeout():
	Voxels.do_graph(graph, global_position, Vector3(100, 100, 100))
	queue_free()
