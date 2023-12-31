class_name Player extends CharacterBase

@export var idle: Sprite2D
@export var walking: AnimatedSprite2D
@export var jam_drop: PackedScene

var effects: Array[Effect] = []
var jam_shots: int = 0

var _last_pos: Vector2
var _anger_adjust_time: float
var _anger_mult: float = 1.0
var _anxiety_time: float
var _loss: bool = false

func _init():
	GameControl.player = self

func _process(delta: float):
	if _loss:
		if Input.is_action_just_pressed("Jam"):
			var menu = load("res://Menu/menu.tscn").instantiate()
			get_parent().add_sibling(menu)
			get_parent().queue_free()
		return
	var x := Input.get_axis("Left", "Right")
	var y := Input.get_axis("Up", "Down")
	var i := Vector2(x, y)
	if not i.is_zero_approx(): _input = i
	idle.visible = _last_pos == position
	walking.visible = not idle.visible
	_last_pos = position

	if Input.is_action_just_pressed("Jam") and jam_shots != 0:
		_drop_jam()

	if _anger_adjust_time > 0: _anger_adjust_time -= delta
	else: _anger_mult = 1.0
	if _anxiety_time > 0: _anxiety_time -= delta

func before_center_tile(_tile: Vector2i):
	if randf() < _manic_mod():
		_input = _motion
	for item in effects:
		if item.effect_type == Effect.EffectType.anxiety:
			if _anxiety_time <= 0:
				var dist := (global_position - item.global_position).length()
				var max_dist := item.distance
				var chance := clampf(item.custom_lerp(0, max_dist, 0.02, 0.2, dist), 0.02, 0.85)
				if randf() < chance:
					_anxiety_time = clampf(item.custom_lerp(0, 1, 0.1, 0.5, randf()), 0.1, 0.5)


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
		if item.effect_type == Effect.EffectType.anger:
			if _anger_adjust_time <= 0:
				var dist := (global_position - item.global_position).length()
				var max_dist := item.distance
				var chance := clampf(item.custom_lerp(0, max_dist, 0.02, 0.85, dist), 0.02, 0.85)
				if randf() < chance:
					_anger_mult = clampf(item.custom_lerp(0, 1, 0.25, 3.0, randf()), 0.25, 3.0)
					_anger_adjust_time = clampf(item.custom_lerp(0, 1, 0.1, 1.2, randf()), 0.1, 1.2)
	speed *= _anger_mult
	if _anxiety_time > 0:
		_input = Vector2.ZERO
		_motion = Vector2.ZERO
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
			if GameControl.enemies.size() == 0:
				var screen = load("res://Loss Screen/win.tscn").instantiate()
				add_sibling(screen)
				_loss = true
		elif !_loss:
			var screen: PackedScene
			if enemy.base_type() == Effect.EffectType.anger:
				screen = load("res://Loss Screen/anger.tscn")
			elif enemy.base_type() == Effect.EffectType.depression:
				screen = load("res://Loss Screen/depression.tscn")
			elif enemy.base_type() == Effect.EffectType.anxiety:
				screen = load("res://Loss Screen/anxiety.tscn")
			else:
				screen = load("res://Loss Screen/mania.tscn")
			var s = screen.instantiate()
			add_sibling(s)
			_loss = true
			visible = false

func _drop_jam():
	var tile := GameControl.map.current_tile(global_position)
	var pos := GameControl.map.map_to_local(tile)
	var jam := jam_drop.instantiate()
	jam.position = pos
	add_sibling.call_deferred(jam)
	jam_shots -= 1
	pass
