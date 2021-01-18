extends VBoxContainer

func _process(_delta):
	if GameData.current_health >= 0:
		$HP.text = "HP: " + str(GameData.current_health) + "/" + str(GameData.max_health)
	else:
		$HP.text = "HP: " + "0" + "/" + str(GameData.max_health)
	$DEF.text = "DEF: " + str(GameData.defense)
	$ATK.text = "ATK: " + str(GameData.attack)
	$LVL.text = "LVL: " + str(GameData.current_level)
	$XP.text = "XP: " + str(GameData.current_xp) + "/" + str(GameData.xp_to_next)
	$Gold/Amount.text =	str(GameData.gold)
