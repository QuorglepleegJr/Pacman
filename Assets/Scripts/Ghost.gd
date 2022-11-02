# With exception of _physics_process(), all functions here are \
# abstracted from KinematicBody2D

extends KinematicBody2D
class_name Ghost

# CONTAINS AI FEATURES OF ALL GHOSTS, SUCH AS PATHFINDING

# Tile grid: 28 horizontal by 31 vertical 20x20 pixel squares

# CONSTANTS

# SCATTER_TILE_POS defined in child scripts
var WALL_POSITIONS = [] # Contains all wall positions - var rather than const due to requiring method return
const DIRECTIONS = [Vector2(0,-1),Vector2(1,0),Vector2(0,1),Vector2(-1,0)] # All unit directions - up, right, etc
const SPEED_SCALER = 50

# VARIABLES

var tile_pos : Vector2 = Vector2(0,0) # Current Tile Postiion
var target_tile_pos : Vector2 = Vector2(0,0) # Position of target time
var move_direction : Vector2 = Vector2(0,0) # Current direction
var mode : int = 0 # 0 = chase, 1 = scatter, 2 = frightened, 3 = eaten
var previous_mode : int = 0 # mode last frame, holds rotating on phase transition
var turn_ready : bool = true # Whether turns have been made

# Detailed AI for all 4 ghosts + a general explanation:
# https://www.youtube.com/watch?v=ataGotQ7ir8
# Above video used to create this AI

var rng = RandomNumberGenerator.new() # Used in frightened state ONLY

# FUNCTIONS

func getWalls():
	var wall_list = []
	for wall in get_node("../../Walls").get_children():
		wall_list.append(wall.get_position()/20)
	return wall_list

func getDirection():
	if mode == 2: return rng.randi_range(0,3) # Frightened mode, with random directions
	
	# Picks the appropriate direction to turn
	# Based on shortest distance between 1 tile forwards and the target
	# Final distances are squared as this doesn't affect comparisons,
	# but removes need for square rooting and floats
	# Ties settled by up, then right, etc.
	# Authentic failure to turn up in certain corridors,
	# Along with overflow of up direction with tiles forward, 
	# UNIMPLEMENTED but planned, along with setting to enable - default is off
	
	var shortest_distance_squared : int = 10000
	var shortest_direction = Vector2(0, -1)
	for direction in DIRECTIONS:
		if not direction == move_direction * -1:
			var new_pos = Vector2(tile_pos.x+direction.x, tile_pos.y+direction.y)
			if not (new_pos in WALL_POSITIONS):
				var current_x_squared_distance = (target_tile_pos.x-new_pos.x)*(target_tile_pos.x-new_pos.x)
				var current_y_squared_distance = (target_tile_pos.y-new_pos.y)*(target_tile_pos.y-new_pos.y)
				var current_distance_squared = current_x_squared_distance + current_y_squared_distance
				if current_distance_squared < shortest_distance_squared:
					shortest_distance_squared = current_distance_squared
					shortest_direction = direction
	return shortest_direction

func getTargetTile():
	print("Caution: getTargetTile function called on base class Ghost instead of inheritants")
	return Vector2(25,15) # Return center of screen

# PROCEDURES

func _ready():
	rng.randomize()
	WALL_POSITIONS = getWalls()

func _physics_process(delta):
	var pos = get_position()
	
	# Calculate speed
	var speed : float = 1.0
	match mode:
		2: speed = 0.5
		3: speed = 2.0
	
	# Update tile position and target tile position
	if int(floor(pos.x)) % 20 == 0 and int(floor(pos.y)) % 20 == 0:
		if turn_ready:
			set_position(Vector2(int(floor(pos.x)), int(floor(pos.y))))
			turn_ready = false
			tile_pos = Vector2(int(floor(pos.x))/20, int(floor(pos.y))/20)
			target_tile_pos = getTargetTile()
			move_direction = getDirection()
			
	else:
		turn_ready = true
	
	if previous_mode != mode:
		move_direction *= -1
	previous_mode = mode
	
	var new_position : Vector2 = get_position()
	new_position += move_direction * speed * SPEED_SCALER * delta
	set_position(new_position)
