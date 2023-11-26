extends Control

@export var jam_count: Label

func _process(_delta):
	jam_count.text = str(GameControl.player.jam_shots)
