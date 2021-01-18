extends Node2D

var map_name = "LevelSpawn"	
var default_position = Vector2(150, 150)

func _ready():
	LevelData.current_map = map_name
