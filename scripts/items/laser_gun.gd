extends Weapon

func base_name():
	return "Laser Gun"

func _shoot():
	spawn_projectile()
