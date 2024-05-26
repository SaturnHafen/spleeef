extends RigidBody3D

var player: Node3D

@export var knockback: float = 5
@export var radius: float = 1

func _on_body_entered(target: Node3D):
	#what happens when bullet hits other player
	if target.is_in_group("player") and not target == player:
		var collision_direction = (linear_velocity * Vector3(1, 0, 1)).normalized()
		target.knockback += (collision_direction + Vector3.UP) * knockback

	if target.is_in_group("ground"): 
		Voxels.do_graph(
			preload("res://resources/sdfs/noisy_sphere.tres"),
			global_position,
			radius * Vector3.ONE)

	queue_free()
