class_name Effect extends Node2D

@export_color_no_alpha var color: Color
@export var distance: float
@export var high_alpha: float
@export var effect_type: EffectType

enum EffectType { depression, anger, anxiety }

func color_at(pos: Vector2) -> Color:
	var col := color
	col.a = custom_lerp(0, distance, high_alpha, 0, (global_position - pos).length())
	return col

func custom_lerp(t0: float, t1: float, x0: float, x1: float, t: float) -> float:
	return (x1 - x0) * (t - t0) / (t1 - t0) + x0
