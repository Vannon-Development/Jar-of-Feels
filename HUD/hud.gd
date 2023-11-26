extends Control

@export var jam_count: Label
@export var depression_count: Label
@export var manic_count: Label

func _process(_delta):
	jam_count.text = str(GameControl.player.jam_shots)
	depression_count.text = str(GameControl.enemy_count(Effect.EffectType.depression))
	manic_count.text = str(GameControl.enemy_count(Effect.EffectType.manic))
