extends HBoxContainer

var id
var item_name
var item_count
var pressable
var pressed = false
var stackable

var equippable = ["Head", "Chest", "Legs", "Feet", "Weapon", "Necklace", "Ring"]

onready var item_category = ImportData.item_data[id]["Category"]
onready var item_class = ImportData.item_data[id]["Class"]

onready var inspector = get_node("/root/Main/GUI/Inventory/TextureRect/TextureRect/Inspector")

func _ready():
	GameData.inventory[name] = {"id": id, "item_name": item_name, "item_count": item_count}
	stackable = bool(ImportData.item_data[id]["Stackable"])
	var image = "res://textures/InventorySprites/" + item_name + ".png"
	$TextureRect/TextureRect.texture = load(image)
	$Label.text = item_name + " "
	#if item_count > 0:
		#$Label.text = $Label.text + " x" + str(item_count)

func _on_TextureButton_mouse_entered():
	pressable = true
	inspector.inspect(id, item_name, item_count, null)
func _on_TextureButton_mouse_exited():
	pressable = false
	inspector.close()

func _input(event):
	if event.is_action_pressed("use") && pressable && !pressed:
		pressed = true
		get_node("/root/Main/GUI/Inventory").use(self, id, item_name, item_count, item_class, item_category, equippable)
		inspector.inspect(id, item_name, item_count, null)
	else:
		pressed = false

func empty():
	inspector.close()
	GameData.inventory.erase(name)
	remove_from_group("Inventory")
	queue_free()
	
func update_count():
	if item_count > 1:
		$TextureRect/TextureRect/ItemCount.text = "x" + str(item_count)
	else:
		$TextureRect/TextureRect/ItemCount.text = ""
