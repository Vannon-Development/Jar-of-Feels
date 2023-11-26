class_name Map extends TileMap

@export var jam_scene: PackedScene

var _path_tiles: Array[Vector2i]
var _intersections: Array[Vector2i]

enum Direction { up, down, left, right }
var _directions: Array[Vector2i] = [Vector2i(0, -1), Vector2i(0, 1), Vector2i(-1, 0), Vector2i(1, 0)]

func _init():
	GameControl.map = self
	randomize()

func _ready():
	_path_tiles = get_used_cells_by_id(0, 0, Vector2i.ZERO, 2)
	for tile in _path_tiles:
		if _is_intersection(tile): _intersections.append(tile)
	generate_jam()

func current_tile(pos: Vector2) -> Vector2i:
	return local_to_map(pos)

func choose_path(tile: Vector2i, previous: Vector2i = Vector2i.ZERO, direction: Vector2 = Vector2.ZERO, variance: float = 0.0) -> Vector2i:
	var possible := _connected_tiles(tile)
	var prev := possible.find(previous)
	if prev != -1: possible.remove_at(prev)
	if randf() < variance or direction == Vector2.ZERO:
		return possible[randi_range(0, possible.size() - 1)] - tile

	var near: float = 0
	var near_dir: Vector2i = Vector2i.ZERO
	for item in possible:
		var dot := direction.normalized().dot(Vector2(item - tile))
		if dot > near:
			near = dot
			near_dir = item
	if near_dir != Vector2i.ZERO: return near_dir - tile
	return possible[randi_range(0, possible.size() - 1)] - tile

func next_tile_on_path(tile: Vector2i, direction: Vector2i) -> Vector2i:
	var prev_tile := tile - direction
	var tiles := _connected_tiles(tile)
	if tiles.size() != 2: return Vector2.ZERO
	for t in tiles:
		if t != prev_tile: return t
	return Vector2i.ZERO

func generate_jam():
	var pos := map_to_local(_random_tile())
	var jar := jam_scene.instantiate()
	add_sibling.call_deferred(jar)
	jar.position = pos

func _random_tile() -> Vector2i:
	return _path_tiles.pick_random()

func _connected_tiles(tile: Vector2i) -> Array[Vector2i]:
	var ret_val: Array[Vector2i] = []
	for dir in _directions:
		if get_cell_alternative_tile(0, tile + dir) == 2: ret_val.append(tile + dir)
	return ret_val

func _is_intersection(tile: Vector2i) -> bool:
	var tiles := _connected_tiles(tile)
	return tiles.size() != 2

