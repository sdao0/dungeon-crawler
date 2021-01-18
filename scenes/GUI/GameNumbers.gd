extends Node2D

func show_damage(pos):
	$DamageNumber.start_pos = pos
	$DamageNumber.text = str(GameData.attack)
	$DamageNumber.update()

