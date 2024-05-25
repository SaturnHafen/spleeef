extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const ACCELERATION: float = 10

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_enum("Player 1", "Player 2", "Player 3", "Player 4") var player: int = 0
@export var aim_speed: Vector2 = Vector2(0.1, 5)


var knockback: Vector3 = Vector3.ZERO

var jumped = false

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
		"player_%d_up" % player, 
		"player_%d_down" % player)
		
	var aim_dir = Input.get_vector(
		"player_%d_aim_left" % player, 
		"player_%d_aim_right" % player, 
		"player_%d_aim_up" % player, 
		"player_%d_aim_down" % player)
		
	rotation.y += aim_dir.x * aim_speed.x
	var hand_rotation = $Hand.rotation_degrees.z - aim_dir.y * aim_speed.y
	
	if hand_rotation < -90:
		hand_rotation = -90
	if hand_rotation > 90:
		hand_rotation = 90
	
	$Hand.rotation_degrees.z = hand_rotation
	
	if input_dir:
		velocity.x = move_toward(velocity.x, input_dir.x * SPEED, delta * ACCELERATION)
		velocity.z = move_toward(velocity.z, input_dir.y * SPEED, delta * ACCELERATION)
		#velocity.z = input_dir.y * SPEED
		#rotation.y = -atan2(input_dir.y, input_dir.x)
	else:
		velocity.x = move_toward(velocity.x, 0, delta * ACCELERATION)
		velocity.z = move_toward(velocity.y, 0, delta * ACCELERATION)
	
	velocity += knockback
	knockback = Vector3.ZERO
	
	move_and_slide()
