extends Weapon

func _shoot():
	var instance = projectile.instantiate()
	var direction = global_transform.basis.x
	
	projectile_root.add_child(instance)
	
	instance.global_rotation = global_rotation
	instance.global_position = global_position + direction
