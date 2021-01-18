extends Area2D

var id = "15"
var item_name = "Minor Healing Potion"
var item_count = 1

func _ready():
	var image = "res://textures/ItemSprites/" + item_name + ".png"
	$Sprite.texture = load(image)
	var size = $Sprite.texture.get_size()
	$CollisionShape2D.shape.extents.x = size.x/2
	$CollisionShape2D.shape.extents.y = size.y/2 + 1
	$Label.rect_position = Vector2(size.x/2 + 3, -size.y/2 + 3)
	# change text
	if item_count > 1:
		$Label.text = "x" + str(item_count) + "\n"
	$Label.text = $Label.text + item_name + "\n"
	if ImportData.item_data[id]["MinLevel"] != 0:
		$Label.text = $Label.text + "Min Lvl: " + str(ImportData.item_data[id]["MinLevel"]) + "\n" + "\n"
	if ImportData.item_data[id]["Attack"] != 0:
		$Label.text = $Label.text + "Atk: " + str(ImportData.item_data[id]["Attack"]) + "\n"
	if ImportData.item_data[id]["Defense"] != 0:
		$Label.text = $Label.text + "Def: " + str(ImportData.item_data[id]["Defense"]) + "\n"
	if ImportData.item_data[id]["AttackSpeed"] != 0:
		$Label.text = $Label.text + "Atk Speed: " + str(ImportData.item_data[id]["AttackSpeed"]) + "s" + "\n"
	if ImportData.item_data[id]["Knockback"] != 0:
		$Label.text = $Label.text + "Knockback: " + str(ImportData.item_data[id]["Knockback"]) + "\n"
	if ImportData.item_data[id]["Heal"] != 0:
		$Label.text = $Label.text + "Heal: " + str(ImportData.item_data[id]["Heal"]) + "\n"
	if ImportData.item_data[id]["ItemValue"] != 0:
		$Label.text = $Label.text + "Value: " + str(ImportData.item_data[id]["ItemValue"])

func _on_ItemDrop_mouse_entered():
	$Label.visible = true

func _on_ItemDrop_mouse_exited():
	$Label.visible = false

func _on_ItemDrop_area_entered(_body):
	if item_name == "Gold":
		GameData.gold += item_count
	else:
		get_node("/root/Main/GUI/Inventory").add_slot(id, item_name, item_count)
	queue_free()
