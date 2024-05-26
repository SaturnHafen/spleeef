@tool

extends Area3D

var disabled = true

@export var projectile_root: Marker3D:
	set(value):
		projectile_root = value
		if Engine.is_editor_hint():
			update_configuration_warnings()

@export var spawnable_item: PackedScene:
	set(value):
		spawnable_item = value
		if Engine.is_editor_hint():
			update_configuration_warnings()

func _get_configuration_warnings():
	var warnings = []
	if not spawnable_item:
		warnings.push_back("I don't have an item to spawn :(")
	if not projectile_root:
		warnings.push_back("Projectiles won't be attached to a node")
	return warnings

func _on_respawn_timer_timeout():
	if spawnable_item:
		var item = spawnable_item.instantiate()
		item.projectile_root = projectile_root
		$Item.add_child(item)
		
		$Light.visible = true
		disabled = false

func _on_body_entered(body):
	if not disabled and body.is_in_group("player"):
		# give the player the item
		
		if body.get_node("Mainhand").get_child_count() == 0:
			give_item_to(body, body.get_node("Mainhand"))
			
		elif body.get_node("Offhand").get_child_count() == 0:
			give_item_to(body, body.get_node("Offhand"))

func give_item_to(body: Node3D, target: Node3D):
	var current_item = $Item.get_children()[0]
	$Item.remove_child(current_item)
	
	target.add_child(current_item)
	current_item.player = body
	
	$RespawnTimer.start()
	$Light.visible = false
	disabled = true
	
	queue_free()
