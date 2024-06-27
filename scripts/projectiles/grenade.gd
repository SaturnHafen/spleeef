extends RigidBody3D

var graph = preload("res://resources/sdfs/noisy_sphere.tres")

@export var knockback: float = 20
@export var radius = 5

func on_timer_timeout():
	Voxels.do_graph(graph, global_position, radius * Vector3.ONE)
	
	#sound  
	$AudioStreamPlayer3D.play()
	
	var explosion = preload("res://scenes/explosion.tscn").instantiate()
	explosion.set_radius(radius / 3)
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	
	var collisions = $KnockbackArea.get_overlapping_bodies()
	for body in collisions:
		if body.is_in_group("player"):
			var delta = body.position - position
			body.knockback += delta.normalized() / delta.length() * knockback
	
	queue_free()
