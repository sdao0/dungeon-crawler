extends Node2D

const Enemy1 = preload("res://scenes/ENTITIES/Enemy1.tscn")

var enemy_one
var enemy_two

var top_left
var bottom_right
var spawn_area = Rect2(-64, -64, 64, 64)
var max_time = 40
var min_time = 20

var rand = RandomNumberGenerator.new()

onready var floor_map = get_parent().get_parent().get_node("Floor")

func _ready():
	top_left = spawn_area.position
	bottom_right = spawn_area.size
	
func select_pos():
	rand.randomize()
	var spawned = false
	var spawn_coord = Vector2()
	while !spawned:
		spawn_coord.x = rand.randi_range(bottom_right.x, top_left.x)
		spawn_coord.y = rand.randi_range(bottom_right.y, top_left.y)
		#print(spawn_coord)
		var test_pos = spawn_coord + global_position
		var cell_coord = floor_map.world_to_map(test_pos)
		var cell_id = floor_map.get_cellv(cell_coord)
		#print(cell_coord)
		#print(floor_map.tile_set.tile_get_name(cell_id))
		if floor_map.tile_set.tile_get_name(cell_id) == "floor_enemy":
			spawned = true
			spawn_enemy(spawn_coord)

func spawn_enemy(pos):
	var enemy = Enemy1.instance()
	if !is_instance_valid(enemy_one):
		enemy_one = enemy
	elif !is_instance_valid(enemy_two):
		enemy_two = enemy
	enemy.add_to_group("Enemies")
	#print(pos)
	enemy.position = pos
	add_child(enemy)
	enemy.set_owner(get_tree().get_current_scene().get_node(LevelData.current_map))

func _on_spawn_timer_timeout():
	var spawn_count = 0
	position = position # physics "movement" for get_overlapping_areas()
	for i in $spawn_area.get_overlapping_areas():
		spawn_count += 1
	#print(spawn_count)
	if spawn_count < 3:
		select_pos()
	$spawn_timer.wait_time = randi() % 40 + 20
	$spawn_timer.start()

