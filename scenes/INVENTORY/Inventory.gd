extends Control

var slot = preload("res://scenes/INVENTORY/InventorySlot.tscn")

func _ready():
	# load inventory from save file
	var load_game = File.new()
	if load_game.file_exists("user://" + GameData.current_slot + "//" + GameData.current_slot + "_inventory.dat"):
		load_game.open("user://" + GameData.current_slot + "//" + GameData.current_slot + "_inventory.dat", File.READ)
		var slot_data = JSON.parse(load_game.get_as_text())
		# Load Equipped Items
		for i in slot_data.result["equipped"]:
			if slot_data.result["equipped"][i]:
				for j in get_tree().get_nodes_in_group("Equipment"):
					if i == j.name:
						if i == "Ring":
							if j.name == "Ring" && j.filled: # check second ring slot
								for k in get_tree().get_nodes_in_group("Equipment"):
									if k.name == "Ring2":
										k.update_slot(slot_data.result["equipped"][i]["id"], slot_data.result["equipped"][i]["item_name"])
							else:
								j.update_slot(slot_data.result["equipped"][i]["id"], slot_data.result["equipped"][i]["item_name"])	
						else:
							j.update_slot(slot_data.result["equipped"][i]["id"], slot_data.result["equipped"][i]["item_name"])
							
		for i in slot_data.result["inventory"]:
			add_slot(slot_data.result["inventory"][i]["id"],slot_data.result["inventory"][i]["item_name"], slot_data.result["inventory"][i]["item_count"])
		load_game.close()

func add_slot(id, item_name, item_count):
	var stacked = false
	if ImportData.item_data[id]["Stackable"]:
		for i in get_tree().get_nodes_in_group("Inventory"):
			if i.item_name == item_name:
				stacked = true
				i.item_count += item_count
				for j in GameData.inventory:
					if GameData.inventory[j]["item_name"] == item_name:
						GameData.inventory[j]["item_count"] += 1
				return i
	if !stacked:
		var slot_id
		for i in range(0, GameData.inventory.size() + 1): # assign slot number to first free int
			if !GameData.inventory.has(str(i)):
				slot_id = i
				break
		var s
		s = slot.instance()
		s.name = str(slot_id)
		s.id = id
		s.item_name = item_name
		s.item_count = item_count
		get_node("TextureRect/TextureRect/VBoxContainer/MainElements/Right/ScrollContainer/VBoxContainer").add_child(s)
		s.add_to_group("Inventory")
		return s
	
func remove_slot(slot_name):
	get_node("TextureRect/TextureRect/VBoxContainer/MainElements/Right/ScrollContainer/VBoxContainer/" + slot_name).empty()

func use(node, id, item_name, _item_count, item_class, item_category, equippable):
	if (item_class == GameData.class_type || item_class == "All") && \
		GameData.current_level >= ImportData.item_data[id]["MinLevel"]:
			for n in equippable:
				if item_category == n:
					var equipment = get_tree().get_nodes_in_group("Equipment")
					for i in equipment:
						if item_category == i.name:
							if item_category == "Ring":
								if i.name == "Ring" && i.filled: # check second ring slot
									for j in equipment:
										if j.name == "Ring2":
											j.update_slot(id, item_name)
								else:
									i.update_slot(id, item_name)	
							else:
								i.update_slot(id, item_name)
					node.empty()
			if item_category == "Consumable": # use item instead of equipping if possible
				if GameData.current_health < GameData.max_health:
					GameData.current_health += ImportData.item_data[id]["Heal"]
					if GameData.current_health > GameData.max_health:
						GameData.current_health = GameData.max_health
					node.item_count -= 1
					node.update_count()
					GameData.inventory[node.name]["item_count"] -= 1
					if node.item_count == 0:
						node.empty()
						
func _on_exit_pressed():
	$TextureRect/TextureRect/Inspector.close()
	visible = false

func _unhandled_input(event):
	if event.is_action_pressed("inventory"):
		if !visible:
			if get_node("/root/Main/GUI/Menu").visible:
				get_node("/root/Main/GUI/Menu").visible = false
			for i in get_tree().get_nodes_in_group("Inventory"):
				i.update_count()
			visible = true
			
		else:
			$TextureRect/TextureRect/Inspector.close()
			visible = false
			
	if event.is_action_pressed("Pause"):
		if visible:
			$TextureRect/TextureRect/Inspector.close()
			visible = false
