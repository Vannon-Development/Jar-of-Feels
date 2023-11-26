class_name Effect extends Node2D

@export_color_no_alpha var color: Color
@export var distance: float
@export var high_alpha: float
@export var effect_type: EffectType

var _jammed: bool = false
var _orig_effect: EffectType

enum EffectType { none, depression, anger, anxiety, manic }

func _ready():
	_orig_effect = effect_type

func color_at(pos: Vector2) -> Color:
	if _jammed: return Color(0, 0, 0, 0)
	var col := color
	col.a = custom_lerp(0, distance, high_alpha, 0, (global_position - pos).length())
	return col

func custom_lerp(t0: float, t1: float, x0: float, x1: float, t: float) -> float:
	return (x1 - x0) * (t - t0) / (t1 - t0) + x0

func jam():
	_jammed = true
	effect_type = EffectType.none

func jam_release():
	_jammed = false
	effect_type = _orig_effect
