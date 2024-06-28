extends Weapon

const speed = 2000

func base_name():
	return "Grenade Launcher"

func _shoot():
	var instance = spawn_projectile()
	var direction = global_transform.basis.x
	instance.apply_central_force(direction * speed)
