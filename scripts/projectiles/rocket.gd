extends RigidBody3D

var graph = preload("res://resources/sdfs/noisy_sphere.tres")

@export var knockback: float = 20
@export var radius = 10

func explode():
	Voxels.do_graph(graph, global_position, radius * Vector3.ONE)
	
	#sound
	$AudioStreamPlayer3D.play()
	
	var collisions = $KnockbackArea.get_overlapping_bodies()
	for body in collisions:
		if body.is_in_group("player"):
			var delta = body.position - position
			body.knockback += delta.normalized() / delta.length() * knockback
	
	var explosion = preload("res://scenes/explosion.tscn").instantiate()
	explosion.set_radius(radius / 3)
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()

func _on_body_entered(body):
	explode()

func _on_timer_timeout():
	explode()
