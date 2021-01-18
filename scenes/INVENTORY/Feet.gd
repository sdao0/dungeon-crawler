extends TextureRect

var filled = false
var pressable = false

var id
var item_name

onready var inspector = get_owner().get_node("TextureRect/TextureRect/Inspector")

func update_slot(item_id, item):
	if id:
		get_owner().add_slot(id, item_name, 1)
		GameData.defense -= ImportData.item_data[id]["Defense"]
		GameData.attack -= ImportData.item_data[id]["Attack"]
		GameData.attack_speed -= ImportData.item_data[id]["AttackSpeed"]
		GameData.knockback -= ImportData.item_data[id]["Knockback"]
	item_name = item
	id = item_id
	GameData.equipped[name] = {"id": id, "item_name": item_name}
	GameData.defense += ImportData.item_data[id]["Defense"]
	GameData.attack += ImportData.item_data[id]["Attack"]
	GameData.attack_speed += ImportData.item_data[id]["AttackSpeed"]
	GameData.knockback += ImportData.item_data[id]["Knockback"]
	var image = "res://textures/InventorySprites/" + item_name + ".png"
	$TextureRect.texture = load(image)
	filled = true
	
func _on_TextureButton_mouse_entered():
	if filled:
		pressable = true
		inspector.inspect(id, item_name, 1, null)
		
func _on_TextureButton_mouse_exited():
	if filled:
		pressable = false
		inspector.close()

func _input(event):
	if event.is_action_pressed("use") && pressable: # unequip item
		GameData.equipped[name] = null
		inspector.close()
		get_owner().add_slot(id, item_name, 1)
		GameData.defense -= ImportData.item_data[id]["Defense"]
		GameData.attack -= ImportData.item_data[id]["Attack"]
		GameData.attack_speed -= ImportData.item_data[id]["AttackSpeed"]
		GameData.knockback -= ImportData.item_data[id]["Knockback"]
		filled = false
		pressable = false
		item_name = null
		id = null
		var image = "res://textures/InventorySprites/slot_" + name + ".png"
		$TextureRect.texture = load(image)
