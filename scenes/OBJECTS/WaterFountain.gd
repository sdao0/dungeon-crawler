extends StaticBody2D

var used = false
var pressable = false
var in_range = false

var seconds = 0
var minutes = 1

func save_data():
	if !LevelData.map_data.has(get_parent().name):
		LevelData.map_data[get_parent().name] = {}
	LevelData.map_data[get_parent().name][name] = {"used": used, "time_left": seconds}
	
func load_data():
	used = LevelData.map_data[str(get_parent().name)][name]["used"]
	if used:
		pressable = false
		load_timer()

func load_timer():
	minutes = floor(LevelData.map_data[get_parent().name][name]["time_left"]/60)
	seconds = int(LevelData.map_data[get_parent().name][name]["time_left"]) % 60
	$Timer.start()
	$AnimatedSprite.stop()
	$AnimatedSprite.frame = 0
	$AnimatedSprite2.stop()
	$AnimatedSprite2.frame = 0

func _on_Area2D_mouse_entered():
	if !used && in_range:
		pressable = true
		$SpriteHeart.visible = true
	elif in_range:
		$Label.visible = true
func _on_Area2D_mouse_exited():
	pressable = false
	$SpriteHeart.visible = false
	$Label.visible = false
	
func _unhandled_input(event):
	if pressable && in_range:
		$SpriteHeart.global_position = get_global_mouse_position()
		$SpriteHeart.global_position.y -= 3
		if event.is_action_pressed("use"):
				if GameData.current_health != GameData.max_health:
					$Timer.start()
					$AnimatedSprite.stop()
					$AnimatedSprite.frame = 0
					$AnimatedSprite2.stop()
					$AnimatedSprite2.frame = 0
					used = true
					pressable = false
					$SpriteHeart.visible = false
					GameData.current_health = GameData.max_health

func _on_Timer_timeout():
	if seconds == 0:
		seconds = 60
		minutes -= 1
	seconds -= 1
	if seconds < 10:
		$Label.text = str(minutes) + ":0" + str(seconds)
	else:
		$Label.text = str(minutes) + ":" + str(seconds)
	if seconds == 0 && minutes == 0:
		$Timer.stop()
		minutes = 1
		used = false
		$AnimatedSprite.playing = true
		$AnimatedSprite2.playing = true

func _on_Area2D2_area_entered(_area):
	in_range = true

func _on_Area2D2_area_exited(_area):
	in_range = false
	pressable = false
	$SpriteHeart.visible = false
	$Label.visible = false
