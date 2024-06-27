@tool

extends Node3D

const dropper = preload("res://scenes/item_spawner/item_drop.tscn")

@export_range(2, 20) var low_timeout: float = 2
@export_range(2, 20) var high_timeout: float = 5

@export var projectile_root: Marker3D:
	set(value):
		projectile_root = value
		if Engine.is_editor_hint():
			update_configuration_warnings()

@export var items: Array[PackedScene]:
	set(value):
		items = value
		if Engine.is_editor_hint():
			update_configuration_warnings()

func _ready():
	$RespawnTimer.start(randf_range(low_timeout, high_timeout))

func _get_configuration_warnings():
	var warnings = []
	if len(items) <= 0:
		warnings.push_back("No item will be spawned because no items are selected as spawnable")
	if not projectile_root:
		warnings.push_back("Projectiles won't be attached to a node")
	return warnings

func _on_respawn_timer_timeout():
	if items:
		var drop = dropper.instantiate()
		var item = items.pick_random().instantiate()
		
		item.projectile_root = projectile_root
		
		add_child(drop)
		drop.get_node("Item").add_child(item)
		drop.drop_collected.connect(_on_drop_collected)

func _on_drop_collected():
	$RespawnTimer.start(randf_range(low_timeout, high_timeout))
