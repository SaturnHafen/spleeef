extends RigidBody3D

var player: Node3D

var radius: float
var knockback: float

func _on_body_entered(target: Node3D):
	var hit = false
	if target.is_in_group("player") and not target == player:
		var collision_direction = (linear_velocity * Vector3(1, 0, 1)).normalized()
		target.knockback += (collision_direction + Vector3.UP) * knockback
		hit = true
	if target.is_in_group("ground"):
		Voxels.do_graph(
			preload("res://resources/sdfs/noisy_sphere.tres"),
			global_position,
			radius * Vector3.ONE)
		hit = true
	if not hit:
		return
	var explosion = preload("res://scenes/explosion.tscn").instantiate()
	explosion.set_radius(radius)
	get_parent().add_child(explosion)
	explosion.global_position = global_position
	queue_free()
