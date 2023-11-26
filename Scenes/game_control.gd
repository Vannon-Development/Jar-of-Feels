extends Node2D

var map: Map
var player: Player
var enemies: Array[EnemyBase]

func enemy_count(type: Effect.EffectType) -> int:
	var count: int = 0
	for enemy in enemies:
		if enemy.base_type() == type: count += 1
	return count
