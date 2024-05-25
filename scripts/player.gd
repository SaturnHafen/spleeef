extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const ACCELERATION: float = 20

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


var knockback: Vector3 = Vector3.ZERO

var jumped = false

func die():
	queue_free()
	remove_from_group("player")
	death.emit()

func _process(delta):
	if Input.is_action_just_pressed("player_%d_action" % player):
		if len($Hand.get_children()) > 0:
			var item = $Hand.get_child(0)
			item.shoot()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	if is_on_floor():
		jumped = false

	# Handle jump.
	if Input.is_action_just_pressed("player_%d_jump" % player) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	elif Input.is_action_just_pressed("player_%d_jump" % player) and not jumped:
		velocity.y = JUMP_VELOCITY
		jumped = true

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
	
	$Hand.rotation_degrees.z = aim_directions[aim_direction_index]
	
	if input_dir:
		velocity.x = move_toward(velocity.x, input_dir.x * SPEED, delta * ACCELERATION)
		velocity.z = move_toward(velocity.z, input_dir.y * SPEED, delta * ACCELERATION)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * ACCELERATION)
		velocity.z = move_toward(velocity.y, 0, delta * ACCELERATION)
	
	velocity += knockback
	knockback = Vector3.ZERO
	
	move_and_slide()
