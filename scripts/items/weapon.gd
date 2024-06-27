class_name Weapon

extends Node3D

@export_range(0.1, 20, 0.1) var cooldown: float = 2
@export_range(-1, 100) var ammo: int = 2
@export_range(1, 100_000) var speed: int
@export var projectile: PackedScene

@export var projectile_root: Node3D
@export var player: Node3D

@export_category("Knobs for the varying strengths")
@export_range(1, 100) var low_ammo: int = 2
@export_range(1, 100) var high_ammo: int = 2
@export_range(0.1, 100) var high_strength: float = 10
@export_range(0.1, 100) var low_strength: float = 10

var starting_ammo = -1

func spawn_projectile() -> Node3D:
	var instance = projectile.instantiate()
	
	if starting_ammo != -1:
		instance.radius = remap(starting_ammo, low_ammo, high_ammo, high_strength, low_strength)
	
	var direction = global_transform.basis.x
	
	projectile_root.add_child(instance)
	
	instance.global_rotation = global_rotation
	instance.global_position = global_position + direction
	
	return instance

func try_shoot():
	if ammo == 0:
		return

	if !$Cooldown.is_stopped():
		return

	$AudioStreamPlayer3D.play()
	_shoot()

	if ammo > 0:
		ammo -= 1

	if ammo == 0:
		queue_free()

	$Cooldown.start(cooldown)

func _shoot():
	pass
