extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@export_enum("Player 1", "Player 2", "Player 3", "Player 4") var player: int = 0

var knockback: Vector3 = Vector3.ZERO

func _process(delta):
	if Input.is_action_just_pressed("player_%d_action" % player):
		if len($Hand.get_children()) > 0:
			var item = $Hand.get_child(0)
			item.shoot()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("player_%d_jump" % player) and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	
	var input_dir = Input.get_vector(	\
		"player_%d_left" % player, 		\
		"player_%d_right" % player, 	\
		"player_%d_up" % player, 		\
		"player_%d_down" % player)
	
	if input_dir:
		velocity.x = input_dir.x * SPEED
		velocity.z = input_dir.y * SPEED
		rotation.y = -atan2(input_dir.y, input_dir.x)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.y, 0, SPEED)
	
	velocity += knockback
	
	move_and_slide()
