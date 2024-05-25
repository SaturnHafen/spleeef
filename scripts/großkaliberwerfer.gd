extends Node3D
var speed = 50
var active = true

@export var shoot_item: PackedScene

var projectile_root: Node3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func shoot(): 
	if active:
		print("pew pew")
		$Cooldown.start()
		var shoot_item: RigidBody3D = shoot_item.instantiate()
		var richtung = global_rotation
		shoot_item.apply_central_force(richtung*speed)
		shoot_item.position = position
		shoot_item
		
		var vec = Vector3(5, 5, 0)
		#item.apply_central_force(richtung*speed)
		item.add_constant_central_force(vec)
		active = false
	


func _on_cooldown_timeout():
	active = true
