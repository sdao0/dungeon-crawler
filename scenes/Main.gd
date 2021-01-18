extends Node

const ItemDrop = preload("res://scenes/ENTITIES/ItemDrop.tscn")
const ClassKnight = preload("res://scenes/ENTITIES/Knight.tscn")

var loot
var pos = Vector2(156,96)

func _ready():
	GameData.load_game(GameData.current_slot)
	var player = get("Class" + GameData.class_type).instance()
	player.set_name("Player")
	if LevelData.current_position_x:
		player.global_position = Vector2(LevelData.current_position_x, LevelData.current_position_y)
	else:
		player.global_position = get_node(LevelData.current_map).default_position
	get_node(LevelData.current_map).add_child(player)
	get_loot(pos)
	
func get_loot(body_pos):
	loot = ImportData.loot_selector(get_node(LevelData.current_map).map_name)
	spawn_loot(body_pos)

func spawn_loot(body_pos):
	for i in range(1, loot.size() + 1):
		var id = loot[i][0]
		var item_name = loot[i][1]
		var item_count = loot[i][2]
		var drop = ItemDrop.instance()
		drop.id = id
		drop.item_name = item_name
		drop.item_count = item_count
		randomize()
		var inc = int(rand_range(-6, 6))
		get_node(LevelData.current_map).add_child(drop)
		drop.set_owner(get_tree().get_current_scene().get_node(LevelData.current_map))
		get_node(LevelData.current_map).move_child(drop, 0)
		drop.global_position.x = body_pos.x + inc
		drop.global_position.y = body_pos.y + inc

func _process(_delta):
	$GUI/FPS.text = "FPS: " + str(Engine.get_frames_per_second())
