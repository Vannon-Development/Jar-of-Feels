extends Node2D

var _time: float = 0

func _process(delta):
	if _time < 3:
		_time += delta
		modulate.a = _time / 3.0
