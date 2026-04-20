extends Node

var current_pointer_screen = 0

func _ready() -> void:
	current_pointer_screen = DisplayServer.get_screen_from_rect(Rect2(DisplayServer.mouse_get_position(), Vector2.ONE))
	
	Events.change_game_screen.connect(
		func():
			DisplayServer.window_set_current_screen(current_pointer_screen)
			Events.game_changed_screens.emit()
			)
	
	
	
func _process(delta: float) -> void:
	var new_pointer_screen = DisplayServer.get_screen_from_rect(Rect2(DisplayServer.mouse_get_position(), Vector2.ONE))
	if new_pointer_screen != current_pointer_screen:
		current_pointer_screen = new_pointer_screen
		Events.pointer_changed_screens.emit()
	
#func _notification(what: int) -> void:
	#match what:
		#NOTIFICATION_WM_MOUSE_EXIT:
			#Events.pointer_changed_screens.emit()
		
	
