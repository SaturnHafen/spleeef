extends MeshInstance3D

var active = false

@export var projectile: PackedScene

var projectile_root: Node3D

func shoot():
	if active:
		$Cooldown.start()
		var beam = projectile.instantiate()
		$Laser.add_child(beam)
		active = false

func _on_cooldown_timeout():
	active = true
