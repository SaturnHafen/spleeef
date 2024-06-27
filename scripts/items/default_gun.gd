extends Weapon

func _shoot():
	var instance = spawn_projectile()
	var direction = global_transform.basis.x
	
	instance.player = player 
	instance.add_constant_central_force(direction * speed)
