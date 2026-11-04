extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -300.0
const COYOTE_TIME_FRAMES = 5
const MAX_JUMP_TIME = 12
const REG_MAX_Y_VELOCITY = 400
const DIVE_VELOCITY = 400

var jump_timer = 0
var max_y_velocity = REG_MAX_Y_VELOCITY
var glide_y_velocity = 150
var coyote_timer = 0

func _physics_process(delta: float) -> void:
	
	if is_on_floor() or Input.is_action_just_released("up"):
		jump_timer = 0
	if is_on_floor(): coyote_timer = COYOTE_TIME_FRAMES

	# Add the gravity.
	if not is_on_floor():
		if coyote_timer > 0: coyote_timer -= 1

		velocity += get_gravity() * delta
		if velocity.y > max_y_velocity: velocity.y = max_y_velocity

	# Handle jump.
	max_y_velocity = REG_MAX_Y_VELOCITY
	if Input.is_action_pressed("up"): 
		if is_on_floor() or coyote_timer > 0:
			velocity.y = JUMP_VELOCITY
			jump_timer = MAX_JUMP_TIME
			coyote_timer = 0
		elif Input.is_action_pressed("up") and jump_timer > 0:
		
			velocity.y = JUMP_VELOCITY
			jump_timer -= 1
		else: 
			max_y_velocity = glide_y_velocity
	
	if Input.is_action_pressed("down"):
		velocity.y = DIVE_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	#print(direction)
	if direction:	
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	print(velocity)

	move_and_slide()
