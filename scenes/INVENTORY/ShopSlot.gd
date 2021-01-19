extends HBoxContainer

var id
var item_name
var item_count
var type
var pressable
var slot_name

onready var inspector = get_node("../../../../../").get_node("Inspector")
onready var shop_menu = get_node("../../../../../../../")

func _ready():
	var image = "res://textures/InventorySprites/" + item_name + ".png"
	$TextureRect/TextureRect.texture = load(image)
	$Label.text = item_name + " "
	#if item_count > 0:
		#$Label.text = $Label.text + " x" + str(item_count)

func _on_TextureButton_mouse_entered():
	pressable = true
	inspector.inspect(id, item_name, item_count, type)
func _on_TextureButton_mouse_exited():
	pressable = false
	inspector.close()
	
func _input(event):
	if event.is_action_pressed("use") && pressable:
		if type == "Buy":
			buy()
		elif type == "Sell":
			sell()

func buy():
	var price = 2 * ImportData.item_data[id]["ItemValue"]
	if GameData.gold >= price:
		item_count -= 1
		shop_menu.buy[slot_name]["item_count"] -= 1
		update_count()
		GameData.gold -= price
		var s = get_node("/root/Main/GUI/Inventory").add_slot(id, item_name, 1)
		shop_menu.add_slot(id, item_name, 1, "Sell", s.name)
		inspector.inspect(id, item_name, item_count, type)
		if item_count == 0:
			shop_menu.buy.erase(slot_name)
			inspector.close()
			queue_free()
			
func sell():
	GameData.gold += ImportData.item_data[id]["ItemValue"]
	for i in get_tree().get_nodes_in_group("Inventory"):
		if i.name == slot_name:
			i.item_count -= 1
			item_count -= 1
			update_count()
			shop_menu.add_slot(id, item_name, 1, "Buy", slot_name)
			inspector.inspect(id, item_name, item_count, type)
			if i.item_count == 0:
				inspector.close()
				get_node("/root/Main/GUI/Inventory").remove_slot(slot_name)
				queue_free()

func update_count():
	if item_count > 1:
		$TextureRect/TextureRect/ItemCount.text = "x" + str(item_count)
	else:
		$TextureRect/TextureRect/ItemCount.text = ""
