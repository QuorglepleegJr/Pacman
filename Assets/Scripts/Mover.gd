extends KinematicBody2D

class_name Mover

var WALL_POSITIONS = [] # Contains all wall positions - var rather than const due to requiring method return
const DIRECTIONS = [Vector2(0,-1),Vector2(1,0),Vector2(0,1),Vector2(-1,0)] # All unit directions - up, right, etc
const SPEED_SCALER = 50
const DEFAULT_POS = Vector2(25,15)

var turn_ready : bool = true # Whether turns have been made
var tile_pos : Vector2 = Vector2(0,0) # Current Tile Postiion
var move_direction : Vector2 = Vector2(0,0) # Current direction

func getWalls():
	var wall_list = []
	for wall in get_node("/root/Main/Walls").get_children():
		wall_list.append(wall.get_position()/20)
	return wall_list

# Functions to override in subclasses

func classPhysicsBehaviour():
	pass

func classOnTileBehaviour():
	pass

func classTurnBehaviour():
	pass

func classGetSpeed():
	return 1

# Builtin Procedures

func _ready():
	WALL_POSITIONS = getWalls() # Initialises "constant" WALL_POSITIONS

func _physics_process(delta):
	var pos = get_position()
	
	if int(floor(pos.x)) % 20 == 0 and int(floor(pos.y)) % 20 == 0:
		if turn_ready:
			set_position(Vector2(int(floor(pos.x)), int(floor(pos.y))))
			turn_ready = false
			tile_pos = Vector2(int(floor(pos.x))/20, int(floor(pos.y))/20)
			
			classTurnBehaviour()
		
		classOnTileBehaviour()
		
	else:
		turn_ready = true
	
	classPhysicsBehaviour()
	
	var speed = classGetSpeed()
	
	var new_position : Vector2 = get_position()
	new_position += move_direction * speed * SPEED_SCALER * delta
	set_position(new_position)
