extends Node3D
var speed = 5
var active = false

@export var shoot_item: PackedScene

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	pass


func shoot(): 
	if active:
		$Cooldown.start()
		var shoot_item:RigidBody3D = shoot_item.instantiate()
		var richtung = global_rotation
		shoot_item.apply_central_force(richtung*speed)
		
		
	


func _on_Cooldown_timeout():
	active = true
