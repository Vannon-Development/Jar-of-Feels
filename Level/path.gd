class_name Path extends Area2D

@export var shape: Polygon2D

var effects: Array[Effect] = []

func _process(_delta):
	var color: Color = Color.BLACK
	var a: float = 0
	var r: float = 0
	var g: float = 0
	var b: float = 0
	for effect in effects:
		var add_color := effect.color_at(global_position)
		if add_color.r > r: r = add_color.r
		if add_color.g > g: g = add_color.g
		if add_color.b > b: b = add_color.b
		if add_color.a > a: a = add_color.a
	shape.color = Color(r, g, b, a)

func attach_effect(e: Effect):
	if effects.find(e) == -1:
		effects.append(e)

func detach_effect(e: Effect):
	var index := effects.find(e)
	if index != -1: effects.remove_at(index)
