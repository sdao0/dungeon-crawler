extends Node

var current_map
var current_position_x
var current_position_y

var map_data = {}

var level_data = {
	"current_map": null,
	"current_position_x": null,
	"current_position_y": null,
}

func save_level():
	var dir = Directory.new()
	dir.open("res://scenes/LEVELS/")
	if !dir.dir_exists(GameData.current_slot):
		dir.make_dir(GameData.current_slot)
	var level = PackedScene.new()
	level.pack(get_tree().get_current_scene().get_node(LevelData.current_map))
# warning-ignore:return_value_discarded
	ResourceSaver.save("res://scenes/LEVELS/" + GameData.current_slot + "//" + current_map + ".tscn", level)
	current_position_x = get_tree().get_current_scene().get_node(current_map).get_node("Player").global_position.x
	current_position_y = get_tree().get_current_scene().get_node(current_map).get_node("Player").global_position.y
	
	var save_game = File.new()
	save_game.open("user://" + GameData.current_slot + "//" + GameData.current_slot + "_" + current_map + ".dat", File.WRITE)
	for i in level_data:
		level_data[i] = get(i)
	for i in get_tree().get_current_scene().get_node(current_map).get_children():
		for j in i.get_children():
			if j.has_method("save_data"):
				j.save_data()
				print(j.name + " saved.")
				
	save_game.store_string("{\r")
	save_game.store_string("\"level_data\": " + JSON.print(level_data) + ",\r")
	save_game.store_string("\"map_data\": {\r")
	for i in map_data:
		save_game.store_string("	\"" + i + "\":" + JSON.print(map_data[i]) + ",\r")
	save_game.store_string("	}\r}")
	print("Level Saved.\n")
	save_game.close()

func load_level():
	if current_map:
		var scene = load("res://scenes/LEVELS/" + GameData.current_slot +"//"+ current_map + ".tscn")
		if scene:
			var level = scene.instance()
			get_tree().get_current_scene().add_child(level)
			var load_game = File.new()
			if load_game.file_exists("user://" + GameData.current_slot + "//" + GameData.current_slot + "_" + current_map + ".dat"):
				load_game.open("user://" + GameData.current_slot + "//" + GameData.current_slot + "_" + current_map + ".dat", File.READ)
				var data = JSON.parse(load_game.get_as_text())
				level_data = data.result["level_data"]
				map_data = data.result["map_data"]
				for i in level_data:
					set(i, level_data[i])
				for i in map_data:
					for j in level.get_node(i).get_children():
						if j.has_method("load_data"):
							j.load_data()
			print("Loaded " + current_map + ".\r")
		else:
			print("Loading Default Map.\n")
			scene = load("res://scenes/LEVELS/LevelSpawn.tscn")
			var level = scene.instance()
			get_tree().get_current_scene().add_child(level)
	else:
		print("Can't Find current_map. Loading Default Map.\n")
		current_map = "LevelSpawn"
		var scene = load("res://scenes/LEVELS/LevelSpawn.tscn")
		var level = scene.instance()
		get_tree().get_current_scene().add_child(level)
