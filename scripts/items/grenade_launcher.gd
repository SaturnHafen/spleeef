extends Weapon

const speed = 2000

func _shoot():
	var instance = projectile.instantiate()
	var direction = global_transform.basis.x
	
#	instance.player = player 
	projectile_root.add_child(instance)
	
	instance.global_rotation = global_rotation
	instance.global_position = global_position + direction
	
	instance.apply_central_force(direction * speed)
