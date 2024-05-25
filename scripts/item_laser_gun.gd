extends MeshInstance3D

var active = false
@export var uses: int = 5

@export var projectile: PackedScene

var projectile_root: Node3D
var player: Node3D

func shoot():
	if active:
		uses -= 1
		if uses <= 0:
			queue_free()
		
		$Cooldown.start()
		var beam = projectile.instantiate()
		$Laser.add_child(beam)
		active = false

func _on_cooldown_timeout():
	active = true
