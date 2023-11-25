class_name Player extends CharacterBase

var effects: Array[Effect] = []

func _process(_delta: float):
	var x := Input.get_axis("Left", "Right")
	var y := Input.get_axis("Up", "Down")
	_input = Vector2(x, y)

func attach_effect(e: Effect):
	if effects.find(e) == -1:
		effects.append(e)

func detach_effect(e: Effect):
	var index := effects.find(e)
	if index != -1: effects.remove_at(index)
