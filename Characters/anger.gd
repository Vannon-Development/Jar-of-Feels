class_name Anger extends EnemyBase

var _orig_motion: float
var _tile_count: int

func _ready():
	super._ready()
	_orig_motion = step_speed
	_tile_count = 8

func base_type() -> Effect.EffectType:
	return Effect.EffectType.anger

func after_center_tile(tile: Vector2i):
	super.after_center_tile(tile)
	_tile_count -= 1
	if _tile_count <= 0:
		step_speed = effect.custom_lerp(0, 1, 0.25, 2.4, randf()) * _orig_motion
		_tile_count = randi_range(4, 12)
