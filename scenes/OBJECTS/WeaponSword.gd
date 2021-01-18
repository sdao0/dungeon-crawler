extends KinematicBody2D

var hit = false

func attack():
	$weapon_hitbox/Sprite.texture = load("res://textures/ItemSprites/" + GameData.equipped["Weapon"]["item_name"] + ".png")
	if GameData.attack_speed > 0:
		$attack_speed.wait_time = GameData.attack_speed
		
	if $attack_speed.is_stopped():
		#$weapon_hitbox.monitoring = true
		$attack_speed.start()
		#hit = false
		var angle = get_parent().get_angle_to(get_global_mouse_position())
		angle = rad2deg(angle)
		if angle > -30 && angle <= 30: # E
			rotation_degrees = 0
			position = Vector2(5,6)
			get_parent().get_node("Sprite").flip_h = false
		elif angle > 30 && angle <= 60: # SE
			rotation_degrees = 45
			position = Vector2(5,6)
			get_parent().get_node("Sprite").flip_h = false
		elif angle > 60 && angle <= 120: # S
			rotation_degrees = 90
			position = Vector2(0,10)
		elif angle > 120 && angle <= 150: # SW
			rotation_degrees = 135
			position = Vector2(-5,6)
			get_parent().get_node("Sprite").flip_h = true
		elif (angle > 150 && angle <= 180) || (angle >= -180 && angle <= -150): # W
			rotation_degrees = 180
			position = Vector2(-5,6)
			get_parent().get_node("Sprite").flip_h = true
		elif angle > -150 && angle <= -120: # NW
			rotation_degrees = -135
			position = Vector2(-5,6)
			get_parent().get_node("Sprite").flip_h = true
		elif angle > -120 && angle <= -60: # N
			rotation_degrees = -90
			position = Vector2(0,0)
		elif angle > -60 && angle <= -30: # NE
			rotation_degrees = -45
			position = Vector2(5,6)
			get_parent().get_node("Sprite").flip_h = false
			
		$weapon_hitbox/Sprite.position = $weapon_hitbox/CollisionShape2D.position
		var size = $weapon_hitbox/Sprite.texture.get_size()
		$weapon_hitbox/Sprite.offset.x = -float(size.x)/2
		$weapon_hitbox/Sprite.offset.y = -size.y - 1
		$weapon_hitbox/CollisionShape2D.shape.b.y = -size.y - 2
		
		swing()
		#$weapon_hitbox.monitoring = true

func _on_weapon_hitbox_area_entered(area):
	#if !hit:
		#hit = true
	get_node("/root/Main/" + LevelData.current_map + "/GameNumbers").show_damage(area.get_parent().global_position)
	area.get_parent().damage(GameData.attack)
	var rotation = area.get_parent().global_position.angle_to_point(get_parent().global_position)
	area.get_parent().move_and_collide(Vector2(1, 1).rotated(rotation) * GameData.knockback)

func swing():
	if position.x >= 0:
		$Tween.interpolate_property($weapon_hitbox, "rotation_degrees", 
		15, 150, 0.3, 
		Tween.TRANS_EXPO, Tween.EASE_OUT)
	elif position.x < 0:
		$Tween.interpolate_property($weapon_hitbox, "rotation_degrees", 
		150, 15, 0.3, 
		Tween.TRANS_EXPO, Tween.EASE_OUT)
	$animation.play("attacking")
	$Tween.start()
