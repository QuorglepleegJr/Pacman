extends Mover

var new_direction : Vector2 = Vector2(0,0)
var forwards : Vector2 = Vector2(0,0)

func classPhysicsBehaviour():
	if Input.is_action_just_pressed("ui_left"):
		new_direction = Vector2(-1,0)
	if Input.is_action_just_pressed("ui_down"):
		new_direction = Vector2(0,1)
	if Input.is_action_just_pressed("ui_right"):
		new_direction = Vector2(1,0)
	if Input.is_action_just_pressed("ui_up"):
		new_direction = Vector2(0,-1)

func classOnTileBehaviour():
	move_direction = new_direction
	forwards = new_direction
	if tile_pos + move_direction in WALL_POSITIONS:
		move_direction = Vector2(0,0)
		turn_ready = true
