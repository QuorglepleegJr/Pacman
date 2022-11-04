extends Ghost

const SCATTER_TILE_POS = Vector2(3,-1)

func getTargetTile():
	match mode:
		0:
			var pac = get_node("/root/Main/Pacman")
			return pac.tile_pos + 4 * pac.forwards
		1: return SCATTER_TILE_POS
		_: return DEFAULT_POS
