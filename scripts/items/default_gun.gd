extends Node3D
const speed = 2000
const offset = 1

var projectile_root: Node3D

var active = false
@export var projectiles: PackedScene

func shoot():
	if active:
		active = false
		$Cooldown.start()
		
		var projectile = projectiles.instantiate()
		$default_proj.add_child(projectile)
		
		
		var direction = global_transform.basis.x
		projectile.apply_central_force(direction * speed)
		projectile_root.add_child(projectile)
		projectile.global_position = global_position + direction * offset

	
	
func _on_cooldown_timeout():
	active = true
