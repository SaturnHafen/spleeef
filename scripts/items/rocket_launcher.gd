extends Weapon

const speed = 10

func base_name():
	return "Rocket Launcher"

func _shoot():
	var instance = spawn_projectile()
	var direction = global_transform.basis.x
	instance.add_constant_central_force(direction * speed)
