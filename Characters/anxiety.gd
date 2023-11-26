class_name Anxiety extends EnemyBase

@export_range(0, 1) var freeze_chance: float

var _freeze_time: float
var _frozen: bool

func base_type() -> Effect.EffectType:
	return Effect.EffectType.anxiety

func _physics_process(delta: float):
	if _frozen:
		_freeze_time -= delta
		if _freeze_time <= 0:
			_frozen = false
			super.after_center_tile(GameControl.map.current_tile(global_position))
	super._physics_process(delta)

func before_center_tile(tile: Vector2i):
	super.before_center_tile(tile)
	if _frozen: _input = Vector2.ZERO
	else:
		var player := GameControl.player
		var dist := (player.global_position - global_position).length()
		freeze_chance = clampf(effect.custom_lerp(0, 64 * 15, .8, .05, dist), .05, .8)
		if randf() < freeze_chance:
			_frozen = true
			_freeze_time = clampf(effect.custom_lerp(0, 1, 0.25, 3, randf()), 0.25, 3)
			_input = Vector2i.ZERO
