extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const KNOCKBACK_DECAY = 0.9

const aim_directions = [-45, -30, 0, 15, 30, 45]
var aim_direction_index = 2

signal death

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_enum(
	"Player 1",
	"Player 2",
	"Player 3",
	"Player 4",
	"Player 5",
	"Player 6",
	"Player 7",
	"Player 8",
) var player: int = 0
@export var aim_speed: Vector2 = Vector2(0.07, 4)

#nur für default gun
@export var projectile_root: Marker3D

var knockback: Vector3 = Vector3.ZERO
var died = false
var jumped = false

func _ready():
	$Mainhand/DefaultGun.projectile_root = projectile_root
	$Mainhand/DefaultGun.player = self

func die():
	died = true
	$AnimationTree.set("parameters/trigger_death/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	await get_tree().create_timer(3.0).timeout
	queue_free()
	remove_from_group("player")
	death.emit()

func switch_hands():
	var main = $Mainhand.get_child(0)
	var off = $Offhand.get_child(0)
	
	$Offhand.remove_child(off)
	$Mainhand.remove_child(main)
	
	$Offhand.add_child(main)
	$Mainhand.add_child(off)

func _process(delta):
	if died:
		return
	if Input.is_action_just_pressed("player_%d_action" % player):
		if len($Mainhand.get_children()) > 0:
			var item = $Mainhand.get_child(0)
			item.shoot()

	if Input.is_action_just_pressed("player_%d_switch" % player):
		switch_hands()

func _physics_process(delta):
	if died:
		return
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if is_on_floor():
		jumped = false

	# Handle jump.
	if Input.is_action_just_pressed("player_%d_jump" % player) and (is_on_floor() or not jumped):
		velocity.y = JUMP_VELOCITY
		if not is_on_floor():
			jumped = true
		$AnimationTree.set("parameters/trigger_jump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var input_dir = Input.get_vector(
		"player_%d_left" % player, 
		"player_%d_right" % player, 
		"player_%d_forward" % player, 
		"player_%d_back" % player)
	
	var aim_dir = Input.get_vector(
		"player_%d_aim_left" % player, 
		"player_%d_aim_right" % player, 
		"player_%d_aim_forward" % player, 
		"player_%d_aim_back" % player)
	
	if aim_dir:
		rotation.y = -aim_dir.angle()
	
	if Input.is_action_just_pressed("player_%d_aim_up" % player) and aim_direction_index < len(aim_directions) - 1:
		aim_direction_index += 1
	if Input.is_action_just_pressed("player_%d_aim_down" % player) and aim_direction_index > 0:
		aim_direction_index -= 1
	
	$Mainhand.rotation_degrees.z = aim_directions[aim_direction_index]
	$Mainhand.global_position = get_bon_pos("mixamorig_RightHandIndex1")
	$Offhand.global_position = get_bon_pos("mixamorig_LeftUpLeg")
	
	velocity.x = input_dir.x * SPEED
	velocity.z = input_dir.y * SPEED
	
	velocity += knockback * Vector3(1, 0.08, 1)
	knockback *= KNOCKBACK_DECAY
	var rotated_velocity = Vector2(velocity.z, velocity.x).rotated(-rotation.y)
	if rotated_velocity.length() > 1:
		rotated_velocity = rotated_velocity.normalized()
	$AnimationTree.set("parameters/running/blend_position", rotated_velocity)
	$AnimationTree.set("parameters/jump/blend_position", rotated_velocity)

	move_and_slide()

func get_bon_pos(bone_name: String) -> Vector3:
	var skeleton: Skeleton3D = $Armature/Skeleton3D
	var bone_transform = skeleton.get_bone_global_pose(skeleton.find_bone(bone_name))
	return (skeleton.global_transform * bone_transform).origin
