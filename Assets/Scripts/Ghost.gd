# All functions here are abstracted from KinematicBody2D

extends Mover
class_name Ghost

# CONTAINS AI FEATURES OF ALL GHOSTS, SUCH AS PATHFINDING

# Tile grid: 28 horizontal by 31 vertical 20x20 pixel squares

# VARIABLES

var target_tile_pos : Vector2 = Vector2(0,0) # Position of target time
var mode : int = 0 # 0 = chase, 1 = scatter, 2 = frightened, 3 = eaten
var previous_mode : int = 0 # mode last frame, holds rotating on phase transition


# Detailed AI for all 4 ghosts + a general explanation:
# https://www.youtube.com/watch?v=ataGotQ7ir8
# Above video used to create this AI

var rng = RandomNumberGenerator.new() # Used in frightened state ONLY

# FUNCTIONS

func getDirection():
	# Returns the correct direction according to wall of text below
	
	# Frightened mode, with random directions
	if mode == 2: return DIRECTIONS[rng.randi_range(0,3)]
	
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
	# Designed to be overridden in individual ghost classes
	print("Caution: getTargetTile function called on base class Ghost instead of inheritants")
	return Vector2(25,15) # Return center of screen

# Mover method overrides

func classTurnBehaviour():
	# Update target_tile_pos and move_direction
	target_tile_pos = getTargetTile()
	move_direction = getDirection()

func classPhysicsBehaviour():
	# Turn around on mode switch (except to and from eaten)
	if previous_mode != mode and mode != 3 and previous_mode != 3:
		move_direction *= -1
	previous_mode = mode
	
func classGetSpeed():
	# Return relative speeds of each mode
	match mode:
		2:
			return 0.5
		3:
			return 2
		_:
			return 1

func _ready():
	._ready()
	rng.randomize()
