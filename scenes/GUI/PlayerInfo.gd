extends Control

func _ready():
	$Health/Label.text = str(GameData.current_health) + "/" + str(GameData.max_health)
	$XP/Label.text = "Lvl." + str(GameData.current_level)
	$XP/Label2.text = str(GameData.current_xp) + "/" + str(GameData.xp_to_next)
	
	var icon = "res://textures/Classes/" + GameData.class_type + ".png"
	$PlayerWindow/HBoxContainer/VBoxContainer/PlayerClass.texture = load(icon)
	
	$Health/TextureRect/TextureProgress.value = (float(GameData.current_health)/GameData.max_health) * 100
	$XP/TextureRect/TextureProgress.value = (float(GameData.current_xp)/GameData.xp_to_next) * 100


func _on_Timer_timeout():
	if GameData.current_health >= 0:
		$Health/Label.text = str(GameData.current_health) + "/" + str(GameData.max_health)
	else:
		$Health/Label.text = "0" + "/" + str(GameData.max_health)
	$Health/TextureRect/TextureProgress.value = (float(GameData.current_health)/GameData.max_health) * 100
	
	if GameData.current_xp <= GameData.xp_to_next:
		$XP/Label2.text = str(GameData.current_xp) + "/" + str(GameData.xp_to_next)
	else:
		$XP/Label2.text = str(GameData.xp_to_next) + "/" + str(GameData.xp_to_next)
	$XP/Label.text = "Lvl." + str(GameData.current_level)
	$XP/TextureRect/TextureProgress.value = (float(GameData.current_xp)/GameData.xp_to_next) * 100
