extends Node

#from https://www.youtube.com/watch?v=1DRy5An_6DU

signal finished_dialogue
signal finished_displaying

signal talking_starts (animation_name : String)

@onready var text_box_scene = preload("res://Scenes/TextBox.tscn")

var current_dialogue : DialogueResource
var current_line_index = 0
var text_box : TextBox

var is_dialogue_active = false
var can_advance_line = false

var current_parent : Node2D


	
func _dialogue(dialogue: DialogueResource, parent_node : Node2D):
	if !is_dialogue_active:
		_start_dialogue(dialogue,parent_node)
	else:
		_continue_dialogue()
	

func _start_dialogue(dialogue: DialogueResource, parent_node : Node2D):
	if is_dialogue_active:
		return
	current_dialogue = dialogue
	talking_starts.emit(current_dialogue.dialogue_text[current_line_index].talking_animation)
	
	current_parent = parent_node
	_show_text_box()
	
	is_dialogue_active = true

func  _show_text_box():
	text_box = text_box_scene.instantiate()
	text_box.finished_displaying.connect(_on_text_box_finish_displaying)
	
	current_parent.add_child(text_box)
	
	text_box.position = Vector2.ZERO
	
	text_box._display_text(
		current_dialogue.dialogue_text[current_line_index])
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
		if current_line_index >= current_dialogue.dialogue_text.size():
			is_dialogue_active = false
			current_line_index = 0
			finished_dialogue.emit()
			return
			
		talking_starts.emit(current_dialogue.dialogue_text[current_line_index].talking_animation)
		_show_text_box()
