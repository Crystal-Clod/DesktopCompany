extends PopupMenu

func _on_index_pressed(index):
	if index == 0:
		get_tree().quit()
