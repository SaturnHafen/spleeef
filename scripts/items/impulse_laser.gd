extends Node3D

var active = false
@export var uses: int = 2

@export var projectile: PackedScene

var projectile_root: Node3D
var player: Node3D

func shoot():
	if active:
		uses -= 1
		$Cooldown.start()
		var beam = projectile.instantiate()
		$Laser.add_child(beam)
		active = false
		if uses <= 0:
			queue_free()

func _on_cooldown_timeout():
	active = true
