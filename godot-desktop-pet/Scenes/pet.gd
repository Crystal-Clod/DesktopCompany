extends Node2D

class_name Pet

signal change_scale(current_scale: Vector2)
@warning_ignore("unused_signal")
signal dragging_state(is_dragging : bool)

@export_custom(PROPERTY_HINT_LINK,"") var current_scale_step : Vector2 = Vector2(1.0,1.0)
@export var step_size : float = 2

func _ready() -> void:
	emit_signal("change_scale",current_scale_step)

func _increase_scale():
	if(current_scale_step.x < 4):
		current_scale_step = current_scale_step*step_size
		emit_signal("change_scale",current_scale_step)
			
func _decrease_scale():
	if(current_scale_step.x > 0.25):
		current_scale_step = current_scale_step/step_size
		emit_signal("change_scale",current_scale_step)
