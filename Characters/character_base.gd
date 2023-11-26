class_name CharacterBase extends Area2D

@export var step_speed: float

const _block_size: float = 64.0

var _input: Vector2
var _motion: Vector2 = Vector2.ZERO

func _physics_process(delta: float):
	var next_pos := position + _motion * _calc_speed() * delta

	if _will_cross_boundary(position, next_pos) or _motion.is_zero_approx():
		before_center_tile(GameControl.map.current_tile(position))
		if _motion.is_zero_approx() and _input.is_zero_approx(): return
		if _input.is_zero_approx(): _motion = Vector2.ZERO
		var paths: Array[Vector2] = [Vector2.UP, Vector2.DOWN, Vector2.LEFT, Vector2.RIGHT]
		var m := _motion.normalized()
		if not m.is_zero_approx():
			paths = [m, m * -1, m.rotated(deg_to_rad(90)), m.rotated(deg_to_rad(-90))]
		var next_move := Vector2.ZERO
		for path in paths:
			if _can_move(path) and _similar_direction(_input, path):
				next_move = path
				break
		if not m.is_zero_approx() and next_move.is_zero_approx() and _can_move(_motion):
			next_move = m

		if not (m - next_move).is_zero_approx():
			var bound := Vector2(_boundary(position.x), _boundary(position.y))
			if next_move.is_zero_approx():
				next_pos = bound
				_motion = Vector2.ZERO
			else:
				var dist = _calc_speed() * delta
				dist -= (bound - position).length()
				next_pos = bound + next_move * dist
				_motion = next_move
		after_center_tile(GameControl.map.current_tile(position))
	position = next_pos

func before_center_tile(_tile: Vector2i):
	pass

func after_center_tile(_tile: Vector2i):
	pass

func _will_cross_boundary(pos1: Vector2, pos2: Vector2) -> bool:
	var x_zero := _near_zero(pos1.x - pos2.x)
	var y_zero := _near_zero(pos1.y - pos2.y)
	if x_zero and y_zero: return false

	var x_boundry := false
	var y_boundry := false
	var xb := _boundary(pos1.x)
	x_boundry = (pos1.x <= xb and pos2.x >= xb) or (pos1.x >= xb and pos2.x <= xb)
	var yb := _boundary(pos1.y)
	y_boundry = (pos1.y <= yb and pos2.y >= yb) or (pos1.y >= yb and pos2.y <= yb)
	return (x_boundry and y_zero) or (y_boundry and x_zero) or (x_boundry and y_boundry)

func _calc_speed() -> float:
	return step_speed * _block_size

func _near_zero(val: float) -> bool:
	return absf(val) < 0.000001

func _boundary(val: float) -> float:
	return int(val / _block_size) * _block_size + _block_size / 2.0

func _can_move(dir: Vector2) -> bool:
	var mask: int = 2
	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, global_position + dir.normalized() * _block_size * 3 / 4.0, mask)
	var result := space_state.intersect_ray(query)
	return result.size() == 0

func _similar_direction(dir: Vector2, input: Vector2) -> bool:
	return (not _near_zero(dir.x) and not _near_zero(input.x) and sign(dir.x) == sign(input.x)) or (not _near_zero(dir.y) and not _near_zero(input.y) and sign(dir.y) == sign(input.y))
