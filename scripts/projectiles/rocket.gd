extends RigidBody3D

@export var explosion: PackedScene

func explode():
	var exp = explosion.instantiate()
	get_parent().add_child(exp)
	exp.global_position = global_position
	queue_free()

func _on_body_entered(body):
	print("pew")
	explode()

func _on_timer_timeout():
	explode()
