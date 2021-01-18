class_name Knight
extends KinematicBody2D

var speed = 100
var velocity = Vector2()

var collider
var collider2

func _ready():
	add_to_group("Player")

func get_input():
	velocity = Vector2()
	if Input.is_action_pressed("up"):
		velocity.y -= 1
		if !$animation.is_playing() || $animation.current_animation == "idle":
			$animation.play("run")
	elif Input.is_action_pressed("down"):
		velocity.y += 1
		if !$animation.is_playing() || $animation.current_animation == "idle":
			$animation.play("run")
			
	if Input.is_action_pressed("left"):
		velocity.x -= 1
		if !$animation.is_playing() || $animation.current_animation == "idle":
			$animation.play("run")
		$Sprite.flip_h = true
	elif Input.is_action_pressed("right"):
		velocity.x += 1
		if !$animation.is_playing() || $animation.current_animation == "idle":
			$animation.play("run")
		$Sprite.flip_h = false
	
	if velocity == Vector2.ZERO && $animation.current_animation != "hurt":
			$animation.play("idle")
			
	velocity = velocity.normalized() * speed

func _unhandled_input(event):
	if event.is_action_pressed("attack"):
		if GameData.equipped["Weapon"]:
			$weapon.attack()
		
func _physics_process(_delta):
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
		
	get_input()
	velocity = move_and_slide(velocity)

func damage(atk):
	if $invincibility_frame.is_stopped():
		$invincibility_frame.start()
		$animation.play("hurt")
		var effective_damage = atk - GameData.defense
		if effective_damage > 0:
			GameData.current_health -= effective_damage
		if GameData.current_health <= 0:
			GameData.dead = true
		
func heal(hp):
	if hp > 0:
		GameData.current_health += hp
