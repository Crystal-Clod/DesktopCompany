extends Node

@onready var main_window : Window = get_window()
@onready var sub_window : Window = $Window
#@onready var sub_window_2 : Window = $Window2

func _ready() -> void:
	
	sub_window.world_2d = main_window.world_2d
	sub_window.world_3d = main_window.world_3d
	
	return
	main_window.transparent = true
	
	main_window.borderless = true
	
	main_window.always_on_top = true
	
	main_window.unresizable = true
	
	return

	
	#sub_window_2.world_2d = main_window.world_2d
	
	
