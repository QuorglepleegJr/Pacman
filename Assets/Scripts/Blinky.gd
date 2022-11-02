extends Ghost

const SCATTER_TILE_POS = Vector2(25, 0)

func getTargetTile():
	return get_node("../../Pacman").get_position()/20
