extends KinematicBody2D

var max_health = 5
var current_health = 5
var attack = 1
var knockback = 10
var level = 1

var hostile = false

var speed = 25
var velocity = Vector2()

var direction : Vector2

var current_target
var player 
var bounce = 0
var random = RandomNumberGenerator.new()

var collider
var collider2

func _ready():
	randomize()
	
func _physics_process(delta):
	# determine draw order
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
		z_index = 5
		
	velocity = direction * speed * delta
	if $animation.current_animation != "hurt" && !$animation.is_playing():	
		if velocity != Vector2.ZERO:
			$animation.play("run")
		else:
			$animation.play("idle")
	if velocity.x > 0:
		$Sprite.flip_h = false
	elif velocity.x < 0:
		$Sprite.flip_h = true
	
	var collision = move_and_collide(velocity)
	if collision && collision.collider.name != "Player":
		direction = direction.rotated(random.randf_range(PI/4, PI/2))
		bounce = random.randi_range(2, 5)


func _on_aggro_timer_timeout():
	# determine next movement
	if !player:
		player = get_node("/root/Main").get_node(LevelData.current_map).get_node("Player")
	else:
		var player_pos = player.global_position - global_position
		if player_pos.length() <= 12:
			direction = Vector2.ZERO
		elif player_pos.length() <= 100 and bounce == 0:
			speed = 50
			direction = player_pos.normalized()
		elif bounce == 0:
			speed = 25
			var random_number = randi() % 100 + 1
			if random_number < 10:
				direction = Vector2.ZERO
			elif random_number < 15:
				direction = Vector2.DOWN.rotated(random.randf() * 2 * PI)		

	if bounce > 0:
		bounce -= 1

func damage(atk):
	$animation.play("hurt")
	current_health -= atk
	$Healthbar.update_health()
	if current_health <= 0:
		get_node("/root/Main").get_loot(global_position)
		GameData.add_xp(level)
		queue_free()

func _on_hitbox_area_entered(area):
	if area.name == "hitbox":
		hostile = true
		current_target = area.get_parent()
		hit(current_target)

func _on_hitbox_area_exited(area):
	if area.name == "hitbox":
		hostile = false
		current_target = null
	
func hit(target):
	if $attack_cooldown.is_stopped():
		$attack_cooldown.start()
		if target.get_node("invincibility_frame").is_stopped():
			target.damage(attack)
			var rotation = target.global_position.angle_to_point(global_position)
			target.move_and_collide(Vector2(1, 1).rotated(rotation) * knockback)

func _on_attack_cooldown_timeout():
	if hostile:
		hit(current_target)
