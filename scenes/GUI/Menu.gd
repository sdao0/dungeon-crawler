extends Control

func _on_Save_pressed():
	GameData.save_game()
	
func _unhandled_input(event):
	if event.is_action_pressed("Pause"):
		if !visible:
			visible = true
		else:
			visible = false

func _on_Button_pressed():
	GameData.save_game()
	get_tree().quit()
