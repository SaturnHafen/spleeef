extends Node3D

var player: Node3D

@export var knockback: float = 5000000

func _on_body_entered(target: Node3D):
	#what happens when bullet hits other player
	if target.is_in_group("player") and not target == player:
		var collision_direction = (target.position - position) * Vector3(1, 0, 1)
		target.knockback += collision_direction * knockback + Vector3.UP * 4
		print(collision_direction)
#what happens when bullet hits ground
	if target.is_in_group("ground"): 
		pass
		#macht marius

