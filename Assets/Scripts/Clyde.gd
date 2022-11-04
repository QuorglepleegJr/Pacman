extends Ghost

const SCATTER_TILE_POS = Vector2(1,30)

func getTargetTile():
	match mode:
		0:
			var pac_pos = get_node("/root/Main/Pacman").tile_pos
			var vector_to_pac = pac_pos - tile_pos
			if vector_to_pac.x * vector_to_pac.x + vector_to_pac.y * vector_to_pac.y < 64:
				return SCATTER_TILE_POS
			else:
				return pac_pos
		1: return SCATTER_TILE_POS
		_: return DEFAULT_POS
