extends Control

var slot = preload("res://scenes/INVENTORY/ShopSlot.tscn")

signal cleared
# add dictionary for shop slots instead of using group

var sell = {} # player inventory
var buy = {} # shop inventory

func _process(_delta):
	get_node("TextureRect/TextureRect/HBoxContainer/gold_count").text = str(GameData.gold)

func populate():
	for i in get_tree().get_nodes_in_group("Inventory"):
		add_slot(i.id, i.item_name, i.item_count, "Sell", i.name)
	# update ItemCount labels
	for i in get_node("TextureRect/TextureRect/VBoxContainer/HBoxContainer/Buy/Buy").get_children(): 
		i.update_count()
	for i in get_node("TextureRect/TextureRect/VBoxContainer/HBoxContainer/Sell/Sell").get_children():
		i.update_count()
func remove(type):
	for i in get_node("TextureRect/TextureRect/VBoxContainer/HBoxContainer/" + type + "/" + type).get_children():
		i.queue_free()
	if type == "Buy":
		buy = {}
	emit_signal("cleared")
		
func add_slot(id, item_name, item_count, type, slot_name):
	var stacked
	if ImportData.item_data[id]["Stackable"]:
		var slot_node = get_node("TextureRect/TextureRect/VBoxContainer/HBoxContainer/" + type + "/" + type + "/" + id)
		if slot_node:
			if type == "Buy":
				for i in buy:
					if buy[i]["item_name"] == item_name:
						buy[i]["item_count"] += 1
						slot_node.item_count += 1
						slot_node.update_count()
						stacked = true
			if type == "Sell":
				for i in sell:
					if sell[i]["item_name"] == item_name:
						sell[i]["item_count"] += 1
						slot_node.item_count += 1
						slot_node.update_count()
						stacked = true
	if !stacked:
		var s
		s = slot.instance()
		s.name = id
		s.id = id
		s.item_name = item_name
		s.item_count = item_count
		s.type = type
		if type == "Sell":
			s.slot_name = slot_name
			sell[slot_name] = {"id": id, "item_name": item_name, "item_count": item_count}
		else:
			var count = 1
			slot_name = item_name
			while buy.has(slot_name):
				slot_name = slot_name + str(count)
				count += 1
			buy[slot_name] = {"id": id, "item_name": item_name, "item_count": item_count}
			s.slot_name = slot_name
		get_node("TextureRect/TextureRect/VBoxContainer/HBoxContainer/" + type + "/" + type + "/").add_child(s)
		s.set_owner(get_parent())
		
func _on_exit_pressed():
	close()
	
func _input(event):
	if event.is_action_pressed("inventory") && visible:
		close()
	if event.is_action_pressed("Pause") && visible:
		close()
		
func close():
	$TextureRect/TextureRect/Inspector.close()
	remove("Sell")
	visible = false

func restock():
	remove("Buy")
	yield(self, "cleared")
	while buy.size() < 5:
		var loot = ImportData.loot_selector(LevelData.current_map) # returns a dictionary of selected items
		for j in loot.values():
			if j:
				if j[0] != "1": # if item id is not == gold
					add_slot(j[0], j[1], j[2], "Buy", null) # add_slot(id, item_name, item_count...)
		
