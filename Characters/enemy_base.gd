class_name EnemyBase extends CharacterBase

@export var effect: Effect
@export var idle: Sprite2D
@export var walking: AnimatedSprite2D
@export var jam_visual: Sprite2D
@export var jam_timer: float
@export_range(0, 1) var follow_variance: float

var jammed: bool = false

var _last_pos: Vector2
var _jam_time: float

func _init():
	GameControl.enemies.append(self)

func _ready():
	var temp: Map = GameControl.map
	var tile := temp.current_tile(position)
	_input = temp.choose_path(tile)

func _process(delta: float):
	jam_visual.visible = jammed
	walking.visible = not jammed and _last_pos != position
	idle.visible = not jammed and not walking.visible
	_last_pos = position
	if jammed:
		_jam_time -= delta
		if _jam_time < 0:
			effect.jam_release()
			jammed = false
			after_center_tile(GameControl.map.current_tile(position))

func before_center_tile(tile: Vector2i):
	if jammed:
		_input = Vector2.ZERO
		_motion = Vector2.ZERO
		position = GameControl.map.map_to_local(tile)

func after_center_tile(tile: Vector2i):
	var moving := tile + Vector2i(_input)
	var next_tile := GameControl.map.next_tile_on_path(moving, _input)
	if next_tile == Vector2i.ZERO:
		var dir := GameControl.player.position - position
		next_tile = moving + GameControl.map.choose_path(moving, tile, dir, follow_variance)
	_input = next_tile - moving

func base_type() -> Effect.EffectType:
	return Effect.EffectType.none

func _area_detected(area: Area2D):
	area.attach_effect(effect)

func _area_lost(area: Area2D):
	area.detach_effect(effect)

func _jam_enter(area: Area2D):
	jammed = true
	_jam_time = jam_timer
	effect.jam()
	area.queue_free()
