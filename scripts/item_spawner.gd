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
	if body.is_in_group("player") and not disabled:
		# give the player the item
		var current_item = $Item.get_children()[0]
		$Item.remove_child(current_item)
		
		var hand: Node3D = body.get_node("Hand")
		
		for child in hand.get_children():
			child.queue_free()
		
		hand.add_child(current_item)
		
		current_item.player = body
		
		$RespawnTimer.start()
		$Light.visible = false
		disabled = true
