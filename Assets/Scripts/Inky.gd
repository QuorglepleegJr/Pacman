extends Ghost

const SCATTER_TILE_POS = Vector2(28,30)

func getTargetTile():
	match mode:
		0:
			var pac = get_node("/root/Main/Pacman")
			var pac_pos = pac.tile_pos + 2 * pac.forwards
			var blinky_pos = get_node("/root/Main/Ghosts/Blinky").tile_pos
			var pac_blinky_vector = blinky_pos - pac_pos
			var swiveled_vector_position = pac_pos - pac_blinky_vector
			return swiveled_vector_position
		1: return SCATTER_TILE_POS
		_: return DEFAULT_POS
