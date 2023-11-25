class_name EnemyBase extends CharacterBase

@export var effect: Effect

func _init():
	GameControl.enemies.append(self)

func _ready():
	var temp: Map = GameControl.map
	var tile := temp.current_tile(position)
	_input = temp.choose_path(tile)

func center_tile(tile: Vector2i):
	super.center_tile(tile)
	var moving := tile + Vector2i(_input)
	var next_tile = GameControl.map.next_tile_on_path(moving, _input)
	if next_tile == Vector2i.ZERO:
		var dir = GameControl.player.position - position
		next_tile = moving + GameControl.map.choose_path(moving, tile, dir)
	_input = next_tile - moving

func _area_detected(area: Area2D):
	area.attach_effect(effect)

func _area_lost(area: Area2D):
	area.detach_effect(effect)
