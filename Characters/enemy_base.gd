class_name EnemyBase extends CharacterBase

@export var effect: Effect

func _area_detected(area: Area2D):
	area.attach_effect(effect)

func _area_lost(area: Area2D):
	area.detach_effect(effect)
