class_name Weapon

extends Node3D

@export_range(0.1, 20, 0.1) var cooldown: float = 2
@export_range(1, 100) var ammo: int = 2
@export_range(1, 100_000) var speed: int
@export var projectile: PackedScene

@export var projectile_root: Node3D
@export var player: Node3D

func spawn_projectile() -> Node3D:
	var instance = projectile.instantiate()
	var direction = global_transform.basis.x
	
	projectile_root.add_child(instance)
	
	instance.global_rotation = global_rotation
	instance.global_position = global_position + direction
	
	return instance

func try_shoot():
	if ammo <= 0:
		print("No ammo left")
		return

	if !$Cooldown.is_stopped():
		print("Cooldown on the gun")
		return

	$AudioStreamPlayer3D.play()
	_shoot()

	ammo -= 1

	if ammo <= 0:
		queue_free()

	$Cooldown.start(cooldown)

func _shoot():
	pass
