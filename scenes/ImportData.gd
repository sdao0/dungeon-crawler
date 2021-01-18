extends Node

var item_data
var loot_data
var level_data

func _ready():
	var itemdata_file = File.new()
	itemdata_file.open("res://data/LootList - Sheet1.json", File.READ)
	var itemdata_json = JSON.parse(itemdata_file.get_as_text())
	itemdata_file.close()
	item_data = itemdata_json.result
	#print(item_data)
	
	var lootdata_file = File.new()
	lootdata_file.open("res://data/LootTable - Sheet1.json", File.READ)
	var lootdata_json = JSON.parse(lootdata_file.get_as_text())
	lootdata_file.close()
	loot_data = lootdata_json.result
	#print(loot_data)
	
	var leveldata_file = File.new()
	leveldata_file.open("res://data/LevelTable - Sheet1.json", File.READ)
	var leveldata_json = JSON.parse(leveldata_file.get_as_text())
	level_data = leveldata_json.result
	#print(level_data)
var loot_count
var loot_dic = {}	

func loot_selector(map_name):
	loot_dic = {}
	var counter = 0
	var items_dropped = 0
	var item_counter = rand_range(float(loot_data[map_name]["ItemCountMin"]), float(loot_data[map_name]["ItemCountMax"]))
	while counter <= item_counter && items_dropped < 1:
		randomize()
		var i = randi() % int(loot_data[map_name]["UniqueItems"]) + 1
		var chance = randf() * 100
		var actual_chance = loot_data[map_name]["Item" + str(i) + "Chance"] * pow(1.05,loot_data[map_name]["UniqueItems"]) * (pow(0.5, items_dropped))
		
		if chance <= actual_chance:
			var loot = []
			loot.append(str(loot_data[map_name]["Item" + str(i) + "id"]))
			loot.append(item_data[str(loot_data[map_name]["Item" + str(i) + "id"])]["ItemName"])
			randomize()
			loot.append((int(rand_range(float(loot_data[map_name]["Item" + str(i) + "MinQ"]), float(loot_data[map_name]["Item" + str(i) + "MaxQ"])))))
			loot_dic[loot_dic.size() + 1] = loot
			items_dropped += 1
		counter += 1
		
	var counter_common = 0
	for n in range(1, loot_data[map_name + "_Common"]["UniqueItems"] + 1):
		randomize()
		var chance = randi() % 100
		if chance <= loot_data[map_name + "_Common"]["Item" + str(n) + "Chance"] && counter_common < loot_data[map_name + "_Common"]["UniqueItems"]:
			var loot = []
			loot.append(str(loot_data[map_name + "_Common"]["Item" + str(n) + "id"]))
			loot.append(item_data[str(loot_data[map_name + "_Common"]["Item" + str(n) + "id"])]["ItemName"])
			randomize()
			loot.append((int(rand_range(float(loot_data[map_name + "_Common"]["Item" + str(n) + "MinQ"]), float(loot_data[map_name + "_Common"]["Item" + str(n) + "MaxQ"])))))
			loot_dic[loot_dic.size() + 1] = loot
			counter_common += 1
	#print(loot_dic)
	return loot_dic
