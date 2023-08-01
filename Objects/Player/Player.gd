extends CharacterBody2D

@export var limit_top = 0
@export var limit_bottom = 0
@export var limit_right = 0
@export var limit_left = 0

const JUMP_VELOCITY = -500.0
const ACCELERATION = 20
const MAX_SPEED = 250.0

var speed = 0.0
var jumps = 1
var gravity = 0
var runes = 0
var coins = 0
var current_color = "none"
var mid_air = false
var falling = false
var jumping = false
var jump_buff = false
var coyote_time = true
var level_finished = false

var rune_active = load("res://Objects/UI/rune_active.tscn")
var rune_unactive = load("res://Objects/UI/rune_unactive.tscn")

@onready var sprite = $Sprite
@onready var coyote_timer = $CoyoteTimer
@onready var mid_air_timer = $MidAirTimer
@onready var jump_buffer_timer = $JumpBufferTimer
@onready var tile_map = $"../TileMap"
@onready var runes_ui = $"../CanvasLayer/UI/Runes"
@onready var camera_2d = $Camera2D
@onready var coin_num = $"../CanvasLayer/UI/CoinNum"
@onready var level_finished_ui = $"../CanvasLayer/LevelFinished"
@onready var pause_menu = $"../CanvasLayer/PauseMenu"

func _ready():
	camera_2d.limit_bottom = limit_bottom
	camera_2d.limit_left = limit_left
	camera_2d.limit_top = limit_top
	camera_2d.limit_right = limit_right

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

	if Input.is_action_just_pressed("jump") and level_finished == false:
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
	
	if level_finished:
		direction = 0
	
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

func _input(event):
	if event.is_action_pressed("Blue") and runes > 0 and current_color != "blue" and level_finished == false:
		tile_map.set_layer_enabled(2, true)
		tile_map.set_layer_enabled(3, false)
		current_color = "blue"
		RunesChanged(-1)
	if event.is_action_pressed("Red") and runes > 0 and current_color != "red" and level_finished == false:
		tile_map.set_layer_enabled(2, false)
		tile_map.set_layer_enabled(3, true)
		current_color = "red"
		RunesChanged(-1)
	if event.is_action_pressed("restart"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("pause"):
		pause_menu.Pause()

func RunesChanged(num):
	runes += num
	if num > 0:
		var new_rune = rune_active.instantiate()
		runes_ui.add_child(new_rune)
		runes_ui.move_child(runes_ui.get_child(runes_ui.get_child_count()-1), 0)
	else:
		var new_rune = rune_unactive.instantiate()
		runes_ui.add_child(new_rune)
		runes_ui.get_child(runes).queue_free()
	
	if runes == 0:
		tile_map.set_layer_enabled(5, false)

func _on_coyote_timer_timeout():
	coyote_time = false
	jumps = 0

func _on_jump_buffer_timer_timeout():
	jump_buff = false

func _on_mid_air_timer_timeout():
	mid_air = false
	falling = true

func _on_area_2d_area_entered(area):
	if area.is_in_group("Rune"):
		RunesChanged(1)
		area.queue_free()
		tile_map.set_layer_enabled(5, true)
	if area.is_in_group("Coin"):
		coins += 1
		area.queue_free()
		coin_num.text = str(coins)
	if area.is_in_group("Flag"):
		level_finished = true
		level_finished_ui.FinishLevel(coins)
	if area.is_in_group("Spike"):
		get_tree().reload_current_scene()
