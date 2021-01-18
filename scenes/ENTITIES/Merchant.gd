extends KinematicBody2D

var speed = 10
var velocity = Vector2()
var direction = Vector2()

var collider
var collider2

var in_range
var pressable

func _physics_process(delta):
	if ($top_wall.is_colliding() || $top_wall2.is_colliding()) && \
	 ($bottom_wall.is_colliding() || $bottom_wall2.is_colliding()) :
		if $bottom_wall.is_colliding():
			collider = $bottom_wall.get_collider()
			collider.z_index = z_index + 1
		if $bottom_wall2.is_colliding():
			collider2 = $bottom_wall2.get_collider()
			collider2.z_index = z_index + 1
	elif collider || collider2:
		if collider:
			collider.z_index = z_index - 1
			collider = null
		if collider2:
			collider2.z_index = z_index - 1
			collider2 = null
	elif $bottom_wall.is_colliding() || $bottom_wall.is_colliding():
		z_index = -1
	elif $top_wall.is_colliding() || $top_wall2.is_colliding():
		z_index = 3
		
	velocity = direction * speed * delta
	if velocity.x > 0:
		$AnimatedSprite.flip_h = false
	elif velocity.x < 0:
		$AnimatedSprite.flip_h = true		
	var collision = move_and_collide(velocity)
	if collision:
		direction = Vector2.ZERO

func _on_movement_timer_timeout():
	var rand = randi() % 100 + 1
	if rand < 5:
		direction = Vector2.RIGHT
	elif rand < 10:
		direction = Vector2.LEFT
	else:
		direction = Vector2.ZERO

func _on_Area2D_mouse_entered():
	if in_range:
		pressable = true

func _on_Area2D_mouse_exited():
	pressable = false

func _on_Area2D2_area_entered(_area):
	in_range = true

func _on_Area2D2_area_exited(_area):
	in_range = false
	$CanvasLayer/ShopMenu.close()
	
func _unhandled_input(event):
	if event.is_action_pressed("use") && in_range && pressable:
		if !$CanvasLayer/ShopMenu.visible:
			$CanvasLayer/ShopMenu.populate()
			$CanvasLayer/ShopMenu.visible = true

func _on_restock_timer_timeout():
	$CanvasLayer/ShopMenu.restock()
	$restock_timer.wait_time = 600
