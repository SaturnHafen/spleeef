extends RigidBody3D

var projectile_root: Node3D
var just_shot = false
var direction: Vector3

var player: Node3D

@export var force_multiplier: float = 40
@export var knockback: float = 25

func shoot():
	just_shot = true
	freeze = false
	
	var shoot_position = global_position
	direction = global_transform.basis.x
	
	get_parent().remove_child(self)
	projectile_root.add_child(self)
	global_position = shoot_position
	$Fuse.start()

func _integrate_forces(state):
	if just_shot:
		just_shot = false
		apply_central_impulse((direction + Vector3.UP * 0.1) * force_multiplier)

func _on_fuse_timeout():
	queue_free()

func _on_body_entered(body: Node3D):
	if body.is_in_group("player") and not body == player:
		var collision_direction = (body.position - position) * Vector3(1, 0, 1)
		body.knockback = collision_direction * knockback + Vector3.UP * 5
		print(collision_direction)

