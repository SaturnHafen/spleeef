extends RigidBody3D

@export var explosion: PackedScene
var graph = preload("res://resources/sdfs/noisy_sphere.tres")

@export var knockback: float = 10
@export var radius = 10

func explode():
	Voxels.do_graph(graph, global_position, radius * Vector3.ONE)
	
	var collisions = $KnockbackArea.get_overlapping_bodies()
	for body in collisions:
		if body.is_in_group("player"):
			var delta = body.position - position
			body.knockback += delta.normalized() / delta.length() * knockback
	
	var exp = explosion.instantiate()
	get_parent().add_child(exp)
	exp.global_position = global_position
	queue_free()

func _on_body_entered(body):
	explode()

func _on_timer_timeout():
	explode()
