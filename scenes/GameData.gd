extends Node
		
var current_slot = "slot_0"
var previous_map

var class_type = "Knight"

var max_health = 10
var current_health = 10
var defense = 0
var attack = 0
var attack_speed = 0.1
var knockback = 0

var dead = false

var current_level = 1
var current_xp = 0
var xp_to_next = 100
var gold = 100

var current_position_x
var current_position_y

var player_data = {
	"class_type": null,
	"max_health": null,
	"current_health": null,
	"current_level": null,
	"current_xp": null,
	"xp_to_next": null,
	"gold": null,
}

var equipped = {
	"Head": null,
	"Chest": null,
	"Legs": null,
	"Feet": null,
	"Weapon": null,
	"Necklace": null,
	"Ring": null,
	"Ring2": null,
}

var inventory = {}

func add_xp(level):
	current_xp += round(ImportData.level_data[str(level)]["xp_to_next"]/(10 + level))
	if current_xp >= ImportData.level_data[str(current_level)]["xp_to_next"]:
		current_xp -= xp_to_next
		max_health += int(round(3 * (pow(current_level,0.5))))
		current_health = max_health
		current_level += 1
		xp_to_next = ImportData.level_data[str(current_level)]["xp_to_next"]

func update_xp(): # force an xp check
	xp_to_next = ImportData.level_data[str(current_level)]["xp_to_next"]
	if current_xp >= ImportData.level_data[str(current_level)]["xp_to_next"]:
		current_xp -= xp_to_next
		max_health += int(round(3 * (pow(current_level,0.5))))
		current_health = max_health
		current_level += 1
		xp_to_next = ImportData.level_data[str(current_level)]["xp_to_next"]
		
func save_stats():
	# Save character stats
	for i in player_data:
		player_data[i] = get(i)
	previous_map = LevelData.current_map
		
	var save_game = File.new()
	save_game.open("user://" + current_slot + "//" + current_slot + ".dat", File.WRITE)
	var slot_data = {"previous_map": previous_map, "player_data": player_data}
	save_game.store_string("{\r")
	for i in slot_data:
		save_game.store_string("\"" + i + "\":" + JSON.print(slot_data[i]) + ",\r")
	save_game.store_string("}")
	print("Player Data Saved.\n")
	save_game.close()

func save_inventory():		
	var save_game = File.new()
	save_game.open("user://" + current_slot + "//" + current_slot + "_inventory.dat", File.WRITE)
	save_game.store_string("{\r")
	save_game.store_string("\"equipped\": " + JSON.print(equipped) + ",\r")
	save_game.store_string("\"inventory\": {\r")
	
	for i in inventory:
		save_game.store_string("	\"" + i + "\":" + JSON.print(inventory[i]) + ",\r")
		
	save_game.store_string("	}\r")
	save_game.store_string("}")
	save_game.close()
	
func load_inventory():
	pass
	
signal save_finished

func save_game():
	var dir = Directory.new()
	dir.open("user://")
	if !dir.dir_exists(current_slot):
		dir.make_dir(current_slot)
	LevelData.save_level()
	save_stats()
	save_inventory()
	emit_signal("save_finished")
	
func load_game(filename):
	var load_game = File.new()
	if load_game.file_exists("user://" + current_slot + "//" + filename + ".dat"):
		load_game.open("user://" + current_slot + "//" + filename + ".dat", File.READ)
		var slot_data = JSON.parse(load_game.get_as_text())
		for i in slot_data.result:
			set(i, slot_data.result[i])
		for i in player_data:
			set(i, player_data[i])
		LevelData.current_map = previous_map
		load_game.close()
		update_xp()
	LevelData.load_level()
	
	
	

