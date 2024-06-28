class_name Weapon

extends Node3D

@export var variations: Array[Variation] = []

var variation: Variation
var ammo: int
@export var projectile: PackedScene

@export var projectile_root: Node3D
var player: Node3D

func base_name():
	return "Weapon"

func display_name():
	if variation.name != "":
		return "%s %s" % [variation.name, base_name()]
	return base_name()

func display_ammo():
	if ammo < 0:
		return "∞/∞"
	return "%d/%d" % [ammo, variation.ammo]

func display_cooldown():
	if $Cooldown.is_stopped():
		return ""
	return "%.1f" % $Cooldown.time_left

func _ready():
	variation = variations.pick_random()
	ammo = variation.ammo

func spawn_projectile() -> Node3D:
	var instance = projectile.instantiate()
	instance.radius = variation.radius
	instance.knockback = variation.knockback
	projectile_root.add_child(instance)
	var direction = global_transform.basis.x
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

	$Cooldown.start(variation.cooldown)

func _shoot():
	pass
