extends Node3D
const speed = 1000
const offset = 1
var active = true

@export var shoot_item: PackedScene

var projectile_root: Node3D
var player: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot(): 
	if active:
		$Cooldown.start()
		var item: RigidBody3D = shoot_item.instantiate()
		var direction = global_transform.basis.x
		item.apply_central_force(direction * speed)
		projectile_root.add_child(item)
		item.global_position = global_position + direction * offset
		active = false

func _on_cooldown_timeout():
	active = true
