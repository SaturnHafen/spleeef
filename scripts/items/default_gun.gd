extends Node3D
const speed = 20
const offset = 1
var active = true

var projectile_root: Node3D
var player: Node3D

@export var projectiles: PackedScene

func shoot():
	if active:
		active = false
		$Cooldown.start()
		
		var projectile = projectiles.instantiate()
		var direction = global_transform.basis.x
		projectile.player = player 
		projectile_root.add_child(projectile)
		projectile.global_rotation = global_rotation
		
		projectile.add_constant_central_force(direction * speed)
		
		projectile.global_position = global_position + direction * offset
		
		#sound
		$AudioStreamPlayer3D.play()
	
	
func _on_cooldown_timeout():
	active = true
