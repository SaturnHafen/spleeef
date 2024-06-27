extends Weapon

var speed = 20

func _shoot():
	var instance = projectile.instantiate()
	var direction = global_transform.basis.x
	
	instance.player = player 
	projectile_root.add_child(instance)
	instance.global_rotation = global_rotation
	
	instance.add_constant_central_force(direction * speed)
	
	instance.global_position = global_position + direction
