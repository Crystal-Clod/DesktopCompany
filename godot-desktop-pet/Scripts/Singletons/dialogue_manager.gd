extends Node

signal finished_dialogue
signal finished_displaying

signal talking_starts

@onready var text_box_scene = preload("res://Scenes/TextBox.tscn")

var dialogue_lines: Array[String] = []
var current_line_index = 0

var text_box : TextBox
var text_box_position: Vector2

var is_dialogue_active = false
var can_advance_line = false

var current_parent : Node2D


	
func _dialogue(position : Vector2, lines: Array[String], parent_node : Node2D):
	if !is_dialogue_active:
		talking_starts.emit()
		_start_dialogue(position,lines,parent_node)
	else:
		_continue_dialogue()
	

func _start_dialogue(position : Vector2, lines: Array[String], parent_node : Node2D):
	if is_dialogue_active:
		return
	
	talking_starts.emit()
	dialogue_lines = lines
	text_box_position = position
	
	current_parent = parent_node
	_show_text_box()
	
	is_dialogue_active = true

func  _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finish_displaying)
	
	current_parent.add_child(text_box)
	text_box.global_position = current_parent.global_position
	
	text_box._display_text(dialogue_lines[current_line_index])
	can_advance_line = false
	
func _on_text_box_finish_displaying():
	finished_displaying.emit()
	can_advance_line = true
	
func  _continue_dialogue():
	if(
		#event.is_action_pressed("click") &&
		is_dialogue_active &&
		can_advance_line
	):
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialogue_lines.size():
			is_dialogue_active = false
			current_line_index = 0
			finished_dialogue.emit()
			return
			
		talking_starts.emit()
		_show_text_box()
