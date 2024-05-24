extends CSGMesh3D

var active = false

@export var projectile: PackedScene

func shoot():
	if active:
		$Cooldown.start()
		$Laser.add_child(projectile.instantiate())
		active = false

func _on_cooldown_timeout():
	active = true
