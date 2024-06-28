class_name Player
extends CharacterBody3D

const SPEED = 5.0
const PITCH_SPEED = 2
const YAW_SPEED = 2
const JUMP_VELOCITY = 4.5

const KNOCKBACK_DECAY = 0.9

signal death(player: Player)
signal player_ready(player: Player)
signal player_not_ready(player: Player)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var player_view: PlayerView

var game: Game

var team: Team
var team_index = 0

enum State {
	CHARACTER_SELECTION,
	TEAM_SELECTION,
	READY,
	PLAYING,
	DEAD,
}
var state: State

@export var character_scenes: Array[PackedScene] = []
var character: Node3D = null
var character_index = 0

@export_enum(
	"Player 1",
	"Player 2",
	"Player 3",
	"Player 4",
	"Player 5",
	"Player 6",
	"Player 7",
	"Player 8",
) var id: int = 0
@export var aim_speed: Vector2 = Vector2(0.07, 4)

#nur für default gun
@export var projectile_root: Marker3D

var knockback: Vector3 = Vector3.ZERO
var jumped = false

func _ready():
	$Mainhand/DefaultGun.projectile_root = projectile_root
	$Mainhand/DefaultGun.player = self
	switch_to_character_selection()

func is_ready():
	return state == State.READY

var selection_offset_cooldown = 0

func _process(delta):
	if selection_offset_cooldown > 0:
		selection_offset_cooldown -= delta
	update_hud()
	match state:
		State.CHARACTER_SELECTION:
			process_character_selection()
		State.TEAM_SELECTION:
			process_team_selection()
		State.READY:
			process_ready()
		State.PLAYING:
			process_playing()

func get_weapon() -> Weapon:
	if len($Mainhand.get_children()) > 0:
		return $Mainhand.get_child(0)
	return null

func update_hud():
	player_view.set_team_name(team.name if team else "")
	var weapon = get_weapon()
	player_view.set_weapon_name(weapon.display_name() if weapon else "")
	player_view.set_ammo(weapon.display_ammo() if weapon else "")

func proceed():
	return Input.is_action_just_pressed("player_%d_action" % id)

func go_back():
	return Input.is_action_just_pressed("player_%d_jump" % id)

func selection_offset():
	if selection_offset_cooldown > 0:
		return 0
	var offset = int(round(Input.get_axis(
			"player_%d_left" % id, 
			"player_%d_right" % id)))
	if offset != 0:
		selection_offset_cooldown = 0.5
	return offset

func show_keys_for(task: String):
	player_view.set_info("%s with the left stick\nConfirm with right trigger\nGo back with left trigger" % task)

func switch_to_character_selection():
	state = State.CHARACTER_SELECTION
	show_character()
	show_keys_for("Choose a character")

func process_character_selection():
	if go_back():
		game.player_left(self)
		return
	if proceed():
		switch_to_team_selection()
		return
	var offset = selection_offset()
	if offset == 0:
		return
	character_index = posmod(character_index + offset, len(character_scenes))
	show_character()

func switch_to_team_selection():
	state = State.TEAM_SELECTION
	show_keys_for("Choose a team")

func get_mesh_layer():
	return 1 << (id + 1)

func update_meshes():
	var layer = get_mesh_layer()
	for mesh in find_children("*", "VisualInstance3D", true, false):
		(mesh as VisualInstance3D).layers = layer

func show_character():
	$AnimationTree.active = false
	if character != null:
		remove_child(character)
		character.free()
	character = character_scenes[character_index].instantiate()
	add_child(character)
	character.name = "Armature"
	$AnimationTree.active = true

func process_team_selection():
	if go_back():
		switch_to_character_selection()
		return
	if proceed():
		switch_to_ready()
		return
	var offset = selection_offset()
	team_index = posmod(team_index + offset, len(game.teams))
	team = game.teams[team_index]

func switch_to_ready():
	state = State.READY
	player_ready.emit(self)
	player_view.set_info("Ready! Waiting for other players\nGo back with left trigger")

func process_ready():
	if go_back():
		player_not_ready.emit(self)
		switch_to_team_selection()
		return

func switch_to_playing():
	state = State.PLAYING
	player_view.set_info("")
	var camera = player_view.get_camera()
	camera.cull_mask = ~get_mesh_layer()
	$CameraTransform.remote_path = camera.get_path()
	update_meshes()

func process_playing():
	if Input.is_action_just_pressed("player_%d_action" % id):
		try_shoot()

	if Input.is_action_just_pressed("player_%d_switch" % id):
		switch_hands()

func try_shoot():
	var weapon = get_weapon()
	if weapon:
		weapon.try_shoot()

func switch_hands():
	var main = $Mainhand.get_child(0)
	var off = $Offhand.get_child(0)
	
	$Offhand.remove_child(off)
	$Mainhand.remove_child(main)
	
	$Offhand.add_child(main)
	$Mainhand.add_child(off)

func _physics_process(delta):
	match state:
		State.PLAYING:
			physics_process_playing(delta)

func physics_process_playing(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if is_on_floor():
		jumped = false

	# Handle jump.
	if Input.is_action_just_pressed("player_%d_jump" % id) and (is_on_floor() or not jumped):
		velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			jumped = true
		$AnimationTree.set("parameters/trigger_jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var input_dir = Input.get_vector(
		"player_%d_left" % id, 
		"player_%d_right" % id, 
		"player_%d_forward" % id, 
		"player_%d_back" % id)
	
	var aim_dir = -Input.get_vector(
		"player_%d_aim_left" % id, 
		"player_%d_aim_right" % id, 
		"player_%d_aim_forward" % id, 
		"player_%d_aim_back" % id)
	
	rotation.y += aim_dir.x * PITCH_SPEED * delta
	$Mainhand.rotation.z = clamp($Mainhand.rotation.z + aim_dir.y * YAW_SPEED * delta, -PI / 2, PI / 2)
	$Mainhand.global_position = get_bone_pos("mixamorig_RightHandIndex1")
	$Offhand.global_position = get_bone_pos("mixamorig_LeftUpLeg")
	$CameraTransform.global_position = get_bone_pos("mixamorig_Head")
	$CameraTransform.rotation.x = $Mainhand.rotation.z
	
	var input_velocity = input_dir.rotated(PI / 2 - rotation.y)
	velocity.x = input_velocity.x * SPEED
	velocity.z = input_velocity.y * SPEED
	
	velocity += knockback * Vector3(1, 0.08, 1)
	knockback *= KNOCKBACK_DECAY
	var animation_velocity = input_dir * SPEED
	animation_velocity.y *= -1
	if animation_velocity.length() > 1:
		animation_velocity = animation_velocity.normalized()
	$AnimationTree.set("parameters/running/blend_position", animation_velocity)
	$AnimationTree.set("parameters/jump/blend_position", animation_velocity)

	move_and_slide()

func die():
	state = State.DEAD
	$AnimationTree.set("parameters/trigger_death/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	death.emit(self)
	await get_tree().create_timer(3.0).timeout
	get_parent().remove_child(self)
	queue_free()

func get_bone_pos(bone_name: String, offset = Vector3.ZERO) -> Vector3:
	var skeleton: Skeleton3D = $Armature/Skeleton3D
	var bone_transform = skeleton.get_bone_global_pose(skeleton.find_bone(bone_name))
	return skeleton.global_transform * (bone_transform.origin + offset)
