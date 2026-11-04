extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -300.0
const MAX_JUMP_TIME = 12

var jump_timer = 0


func _physics_process(delta: float) -> void:
	
	if is_on_floor() or Input.is_action_just_released("up"):
		jump_timer = 0
	# Add the gravity.
	if not is_on_floor():
		#print("not on ground!")
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("up"): 
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jump_timer = MAX_JUMP_TIME
		elif Input.is_action_pressed("up") and jump_timer > 0:
		
			velocity.y = JUMP_VELOCITY
			jump_timer -= 1

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	#print(direction)
	if direction:
		velocity.x = direction * SPEED 
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
