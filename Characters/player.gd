class_name Player extends CharacterBase

@export var idle: Sprite2D
@export var walking: AnimatedSprite2D
@export var jam_drop: PackedScene

var effects: Array[Effect] = []
var jam_shots: int = 0

var _last_pos: Vector2

func _init():
	GameControl.player = self

func _process(_delta: float):
	var x := Input.get_axis("Left", "Right")
	var y := Input.get_axis("Up", "Down")
	var i := Vector2(x, y)
	if not i.is_zero_approx(): _input = i
	idle.visible = _last_pos == position
	walking.visible = not idle.visible
	_last_pos = position

	if Input.is_action_just_pressed("Jam") and jam_shots != 0:
		_drop_jam()

func before_center_tile(_tile: Vector2i):
	if randf() < _manic_mod():
		_input = _motion

func _manic_mod() -> float:
	var manic_mod: float = 0
	for item in effects:
		if item.effect_type == Effect.EffectType.manic:
			var dist := (global_position - item.global_position).length()
			var max_dist := item.distance
			manic_mod += clampf(item.custom_lerp(0, max_dist, 1, .4, dist), .4, 1)
	return manic_mod

func attach_effect(e: Effect):
	if effects.find(e) == -1:
		effects.append(e)

func detach_effect(e: Effect):
	var index := effects.find(e)
	if index != -1: effects.remove_at(index)

func _calc_speed() -> float:
	var speed := super._calc_speed()
	for item in effects:
		if item.effect_type == Effect.EffectType.manic:
			var dist := (global_position - item.global_position).length()
			var max_dist := item.distance
			var accel := clampf(item.custom_lerp(0, max_dist, 3, 1, dist), 1, 3)
			speed *= accel
		if item.effect_type == Effect.EffectType.depression:
			var dist := (global_position - item.global_position).length()
			var max_dist := item.distance
			var reduction := clampf(item.custom_lerp(0, max_dist, 0.5, 1, dist), 0, 1)
			speed *= reduction
	return speed

func _on_hit_area(area: Area2D):
	if area is Jar:
		jam_shots += (area as Jar).charges
		GameControl.map.generate_jam()
		area.queue_free()
	elif area is EnemyBase:
		var enemy := area as EnemyBase
		if enemy.jammed:
			GameControl.enemies.remove_at(GameControl.enemies.find(enemy))
			enemy.queue_free()

func _drop_jam():
	var tile := GameControl.map.current_tile(global_position)
	var pos := GameControl.map.map_to_local(tile)
	var jam := jam_drop.instantiate()
	jam.position = pos
	add_sibling.call_deferred(jam)
	jam_shots -= 1
	pass
