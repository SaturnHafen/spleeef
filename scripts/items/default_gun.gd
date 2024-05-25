extends Node3D

var active = false
@export var projectiles: PackedScene

func shoot():
	if active:
		active = false
		$Cooldown.start()
		
		var projectile = projectiles.instantiate()
		$default_proj.add_child(projectile)
		active = false

	
	
func _on_cooldown_timeout():
	active = true
