extends Ghost

const SCATTER_TILE_POS = Vector2(25, 0)

func getTargetTile():
	match mode:
		0: return get_node("/root/Main/Pacman").tile_pos
		1: return SCATTER_TILE_POS
		_: return DEFAULT_POS
