extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -350.0
const COYOTE_TIME_FRAMES = 5
const MAX_JUMP_TIME = 12
const REG_MAX_Y_VELOCITY = 400
const DIVE_VELOCITY = 400

var jump_timer = 0
var max_y_velocity = REG_MAX_Y_VELOCITY
var glide_y_velocity = 150
var coyote_timer = 0

const shift_speed_mult = 0.6
var speed_mult = 1.0
const shift_jump_mult = 0.6
var jump_mult = 1.0

var a = 1.0

@onready var Sprite = $Sprite2D
@onready var BulletCollider = $BulletCollider

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	BulletCollider.modulate.a = 0.0

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
		if (is_on_floor() or coyote_timer > 0) and Input.is_action_just_pressed("up"):
			velocity.y = JUMP_VELOCITY * jump_mult
			jump_timer = MAX_JUMP_TIME
			coyote_timer = 0
		elif Input.is_action_pressed("up") and jump_timer > 0:
		
			velocity.y = JUMP_VELOCITY * jump_mult
			jump_timer -= 1
		else: 
			max_y_velocity = glide_y_velocity
	
	if Input.is_action_pressed("down"):
		velocity.y = DIVE_VELOCITY
	
	
	if Input.is_action_pressed("shift"):
		#a nice smooth transition to 0.2 opacity (MAKE CODE GOODER????)
		a = lerp(a, 0.2, 0.2)
		Sprite.modulate.a = snapped(a, 0.05)
		
		BulletCollider.modulate.a = 1.0
		
		speed_mult = shift_speed_mult
		jump_mult = shift_jump_mult
	else:
		#the above script but reversed
		a = lerp(a, 1.0, 0.2)
		Sprite.modulate.a = snapped(a, 0.05)
		
		BulletCollider.modulate.a = 0.0
		
		speed_mult = 1.0
		jump_mult = 1.0
	
	
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("left", "right")
	#print(direction)
	if direction:	
		velocity.x = direction * (SPEED * speed_mult)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	#print(velocity)
	
	if direction == 1.0:
		Sprite.scale.x = 1.0
	elif direction == -1.0: 
		Sprite.scale.x = -1.0

	move_and_slide()
