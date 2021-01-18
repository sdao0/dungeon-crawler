extends TextureProgress

func update_health():
	value = float(get_parent().current_health) / get_parent().max_health * 100
	visible = true
