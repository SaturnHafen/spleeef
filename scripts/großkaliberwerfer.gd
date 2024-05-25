extends Node3D
var speed = 50
var active = true

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
		var item = shoot_item.instantiate()
		$shoot_item.add_child(item)
		var richtung = global_rotation
		
		var vec = Vector3(5, 5, 0)
		#item.apply_central_force(richtung*speed)
		item.add_constant_central_force(vec)
		active = false
	


func _on_Cooldown_timeout():
	active = true
