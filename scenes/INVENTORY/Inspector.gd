extends RichTextLabel

func adjust_size(width):
	rect_size.x = width + 20 # set label width to greatest line width + 6px margin
	rect_size.y = (get_line_count()+1)*get_font("normal_font").get_height()

func inspect(id, item_name, item_count, slot_type):
	var max_width = 0
	visible = true
	bbcode_text = "[center]"
	if item_count > 1:
		# warning-ignore:return_value_discarded
		append_bbcode("x" + str(item_count) + "\n") 
	# warning-ignore:return_value_discarded
	append_bbcode(item_name + "\n")
	if get_font("normal_font").get_string_size(item_name + "\n").x > max_width:
			max_width = get_font("normal_font").get_string_size(item_name + "\n").x
	if ImportData.item_data[id]["MinLevel"] != 0:
		if ImportData.item_data[id]["MinLevel"] > GameData.current_level:
			# warning-ignore:return_value_discarded
			append_bbcode("[color=#f51d1d]Min Lvl: " + str(ImportData.item_data[id]["MinLevel"]) + "[/color]" + "\n" + "\n")
		else:
			# warning-ignore:return_value_discarded
			append_bbcode("[color=#23eb10]Min Lvl: " + str(ImportData.item_data[id]["MinLevel"]) + "[/color]" + "\n" + "\n")
		if get_font("normal_font").get_string_size("Min Lvl: " + str(ImportData.item_data[id]["MinLevel"]) + "\n" + "\n").x > max_width:
			max_width = get_font("normal_font").get_string_size("Min Lvl: " + str(ImportData.item_data[id]["MinLevel"]) + "\n" + "\n").x
	if ImportData.item_data[id]["Attack"] != 0:
		# warning-ignore:return_value_discarded
		append_bbcode("Atk: " + str(ImportData.item_data[id]["Attack"]) + "\n")
		if  get_font("normal_font").get_string_size("Atk: " + str(ImportData.item_data[id]["Attack"]) + "\n").x > max_width:
			max_width =  get_font("normal_font").get_string_size("Atk: " + str(ImportData.item_data[id]["Attack"]) + "\n").x
	if ImportData.item_data[id]["Defense"] != 0:
		# warning-ignore:return_value_discarded
		append_bbcode("Def: " + str(ImportData.item_data[id]["Defense"]) + "\n")
		if  get_font("normal_font").get_string_size("Def: " + str(ImportData.item_data[id]["Defense"])).x > max_width:
			max_width =  get_font("normal_font").get_string_size("Def: " + str(ImportData.item_data[id]["Defense"])).x
	if ImportData.item_data[id]["AttackSpeed"] != 0:
		# warning-ignore:return_value_discarded
		append_bbcode("Atk Speed: " + str(ImportData.item_data[id]["AttackSpeed"]) + "s" + "\n")
		if  get_font("normal_font").get_string_size("Atk Speed: " + str(ImportData.item_data[id]["AttackSpeed"]) + "s" + "\n").x > max_width:
			max_width =  get_font("normal_font").get_string_size("Atk Speed: " + str(ImportData.item_data[id]["AttackSpeed"]) + "s" + "\n").x
	if ImportData.item_data[id]["Knockback"] != 0:
		# warning-ignore:return_value_discarded
		append_bbcode("Knockback: " + str(ImportData.item_data[id]["Knockback"]) + "\n")
		if  get_font("normal_font").get_string_size("Knockback: " + str(ImportData.item_data[id]["Knockback"]) + "\n").x > max_width:
			max_width =  get_font("normal_font").get_string_size("Knockback: " + str(ImportData.item_data[id]["Knockback"]) + "\n").x
	if ImportData.item_data[id]["Heal"] != 0:
		# warning-ignore:return_value_discarded
		append_bbcode("Heal: " + str(ImportData.item_data[id]["Heal"]) + "\n")
		if  get_font("normal_font").get_string_size("Heal: " + str(ImportData.item_data[id]["Heal"]) + "\n").x > max_width:
			max_width =  get_font("normal_font").get_string_size("Heal: " + str(ImportData.item_data[id]["Heal"]) + "\n").x
	if ImportData.item_data[id]["ItemValue"] != 0:
		if slot_type == "Buy":
			# warning-ignore:return_value_discarded
			append_bbcode("Buy: " + str(2*ImportData.item_data[id]["ItemValue"]))
			if  get_font("normal_font").get_string_size("Buy: " + str(2*ImportData.item_data[id]["ItemValue"])).x > max_width:
				max_width =  get_font("normal_font").get_string_size("Buy: " + str(2*ImportData.item_data[id]["ItemValue"])).x
		elif slot_type == "Sell":
			# warning-ignore:return_value_discarded
			append_bbcode("Sell: " + str(ImportData.item_data[id]["ItemValue"]))
			if  get_font("normal_font").get_string_size("Sell: " + str(ImportData.item_data[id]["ItemValue"])).x > max_width:
				max_width =  get_font("normal_font").get_string_size("Sell: " + str(ImportData.item_data[id]["ItemValue"])).x
		else:
			# warning-ignore:return_value_discarded
			append_bbcode("Value: " + str(ImportData.item_data[id]["ItemValue"]))
			if  get_font("normal_font").get_string_size("Value: " + str(ImportData.item_data[id]["ItemValue"])).x > max_width:
				max_width =  get_font("normal_font").get_string_size("Value: " + str(ImportData.item_data[id]["ItemValue"])).x
	adjust_size(max_width)
func close():
	visible = false
