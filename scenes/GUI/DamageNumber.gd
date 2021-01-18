extends Label

var start_pos
var end_pos
var rand = RandomNumberGenerator.new()

func update():
	randomize()
	end_pos = start_pos + Vector2(rand.randi_range(-24, 24) , rand.randi_range(-32, 16))
	move_up()

func move_up(): # tween damage number
	$Tween.interpolate_property(self, "rect_position", 
	start_pos, end_pos, 1, 
	Tween.TRANS_EXPO, Tween.EASE_OUT)
#	$Tween.interpolate_property(self, "modulate:a", 
#	255, 0, 0.75, 
#	Tween.TRANS_EXPO, Tween.EASE_OUT)
	$Tween.interpolate_property(self, "modulate", 
	Color(1, 1, 1, 1), Color(1, 1, 1, 0), 1, 
	Tween.TRANS_LINEAR, Tween.EASE_IN)
	visible = true
	$Tween.start()


func _on_Tween_tween_all_completed():
	#print("tween done")
	visible = false
