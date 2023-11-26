extends Control

@export var jam_count: Label
@export var depression_count: Label
@export var manic_count: Label
@export var anger_count: Label
@export var anxiety_count: Label

func _process(_delta):
	jam_count.text = str(GameControl.player.jam_shots)
	depression_count.text = str(GameControl.enemy_count(Effect.EffectType.depression))
	manic_count.text = str(GameControl.enemy_count(Effect.EffectType.manic))
	anger_count.text = str(GameControl.enemy_count(Effect.EffectType.anger))
	anxiety_count.text = str(GameControl.enemy_count(Effect.EffectType.anxiety))
