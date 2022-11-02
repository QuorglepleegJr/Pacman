extends KinematicBody2D

const SPEED_SCALER = 50

var tile_pos : Vector2 = Vector2(0,0)
var direction : Vector2 = Vector2(0,0)
var new_direction : Vector2 = Vector2(0,0)
var turn_ready : bool = true

func _physics_process(delta):
	var pos = get_position()
	
	if Input.is_action_just_pressed("ui_left"):
		new_direction = Vector2(-1,0)
	if Input.is_action_just_pressed("ui_down"):
		new_direction = Vector2(0,1)
	if Input.is_action_just_pressed("ui_right"):
		new_direction = Vector2(1,0)
	if Input.is_action_just_pressed("ui_up"):
		new_direction = Vector2(0,-1)
	
	if int(floor(pos.x)) % 20 == 0 and int(floor(pos.y)) % 20 == 0:
		if turn_ready:
			set_position(Vector2(int(floor(pos.x)), int(floor(pos.y))))
			turn_ready = false
			tile_pos = Vector2(int(floor(pos.x))/20, int(floor(pos.y))/20)
			direction = new_direction
	else:
		turn_ready = true
	
	var new_position : Vector2 = get_position()
	new_position += direction * SPEED_SCALER * delta
	set_position(new_position)
