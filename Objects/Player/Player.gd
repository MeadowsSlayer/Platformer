extends CharacterBody2D

const JUMP_VELOCITY = -500.0
const ACCELERATION = 5
const MAX_SPEED = 250.0

var speed = 0.0
var jumps = 1
var gravity = 0
var mid_air = false
var falling = false
var jumping = false
var jump_buff = false
var coyote_time = true

@onready var sprite = $Sprite
@onready var coyote_timer = $CoyoteTimer
@onready var mid_air_timer = $MidAirTimer
@onready var jump_buffer_timer = $JumpBufferTimer

func _physics_process(delta):
	if not is_on_floor():
		if jumping == false:
			falling = true
		
		if mid_air == false:
			gravity = move_toward(gravity, 1000, 50)
		else:
			gravity = 500
		
		if falling == true:
			gravity = move_toward(gravity, 2000, 100)
		
		if jumps > 0 and coyote_time == true:
			coyote_timer.start()
		
		velocity.y += gravity * delta
	else:
		jumps = 1
		gravity = 0
		jumping = false
		falling = false
		coyote_time = true
		if jump_buff == true:
			Jump()

	if Input.is_action_just_pressed("jump"):
		if (is_on_floor() or coyote_time == true) and jumps > 0:
			Jump()
		if not is_on_floor():
			jump_buff = true
			jump_buffer_timer.start()
	if Input.is_action_just_released("jump") and velocity.y < -100:
		velocity.y = -100
		mid_air = true
		mid_air_timer.start()
	
	if velocity.y == JUMP_VELOCITY:
		mid_air = true
		mid_air_timer.start()

	var direction = Input.get_axis("left", "right")
	if direction:
		speed = move_toward(speed, MAX_SPEED, ACCELERATION)
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if direction == 0:
		if falling == false and jumping == false:
			sprite.play("idle")
	else:
		if falling == false and jumping == false:
			sprite.play("run")
		sprite.scale.x = direction * 2

	move_and_slide()

func Jump():
	jumps -= 1
	jumping = true
	sprite.play("jump")
	velocity.y = JUMP_VELOCITY

func _on_coyote_timer_timeout():
	coyote_time = false
	jumps = 0

func _on_jump_buffer_timer_timeout():
	jump_buff = false

func _on_mid_air_timer_timeout():
	mid_air = false
	falling = true
