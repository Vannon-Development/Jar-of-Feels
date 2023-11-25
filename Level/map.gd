class_name Map extends TileMap

var _path_tiles: Array[Vector2i]
var _intersections: Array[Vector2i]
var _path: Dictionary

func _ready():
	_path_tiles = get_used_cells_by_id(0, 0, Vector2i.ZERO, 2)
	for tile in _path_tiles:
		pass

func _is_straight_path(tile: Vector2i) -> bool:
	var up = get_cell_alternative_tile(0, tile + Vector2i(0, -1))
	var down = get_cell_alternative_tile(0, tile + Vector2i(0, 1))
	var left = get_cell_alternative_tile(0, tile + Vector2i(-1, 0))
	var right = get_cell_alternative_tile(0, tile + Vector2i(1, 0))
	return up == down and left == right and up != left
