extends CharacterBody3D

signal drop_collected

@export_range(0.1, 20) var gravity: float = 1.5

var landed = false

func check_collision(body):
	if body.is_in_group("player"):
		# give the player the item
		
		if body.get_node("Mainhand").get_child_count() == 0:
			give_item_to(body, body.get_node("Mainhand"))
			
		elif body.get_node("Offhand").get_child_count() == 0:
			give_item_to(body, body.get_node("Offhand"))

func _on_body_entered(body):
	check_collision(body)

func give_item_to(body: Node3D, target: Node3D):
	var current_item = $Item.get_children()[0]
	$Item.remove_child(current_item)
	
	target.add_child(current_item)
	current_item.player = body
	
	drop_collected.emit()
	queue_free()

func _physics_process(delta):
	if not landed:
		if move_and_collide(Vector3(0, -gravity * delta, 0)):
			$AnimationPlayer.play("idle")
			landed = true
			
