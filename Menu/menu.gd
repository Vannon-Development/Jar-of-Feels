extends Node2D

var _frame_count

func _ready():
	_frame_count = 20

func _process(_delta):
	if _frame_count > 0: _frame_count -= 1
	if _frame_count == 0:
		GameControl.clear()
		_frame_count -= 1
	if _frame_count < 0:
		if Input.is_action_just_pressed("Jam"):
			var game_scene = load("res://Game Scene/game_scene.tscn").instantiate()
			add_sibling(game_scene)
			queue_free()
