extends Weapon

const speed = 20

func base_name():
	return "Pistol"

func _shoot():
	var instance = spawn_projectile()
	var direction = global_transform.basis.x
	instance.player = player 
	instance.add_constant_central_force(direction * speed)
