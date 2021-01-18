extends KinematicBody2D

var max_health = 9999
var current_health = 9999

func damage(atk):
	$animation.play("hurt")
	current_health -= atk
	$Healthbar.update_health()


