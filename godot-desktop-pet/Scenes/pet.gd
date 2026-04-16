@tool
extends Node2D

class_name Pet

signal change_scale(current_scale: Vector2)
@warning_ignore("unused_signal")
signal dragging_state(is_dragging : bool)

@export_custom(PROPERTY_HINT_LINK,"") var current_scale_step : Vector2 = Vector2(1.0,1.0)
@export var step_size : float = 2

@export var character_name : String
@export_tool_button("Test Dictionary")
var button = refresh_dictionary
@export var dialogue_dictionary : Dictionary

func _init() -> void:
	print(OS.get_data_dir())
	#name = character_name
	#print(FileOperations.get_all_sub_directories("res://Characters/Donqui/Resources/Dialogue/"))
	refresh_dictionary()
	pass

func get_random_dialogue_from_set(_set_name : String):
	var dialogue_sets : Array[DialogueSet] = dialogue_dictionary.get("Intro")
	var dialogue_set = dialogue_sets[randi_range(0,len(dialogue_sets) -1)] 
	var dialogue = dialogue_set.dialogues[randi_range(0,len(dialogue_set.dialogues) -1)]
	return dialogue 

func refresh_dictionary():
	#var files = FileOperations.get_all_files_of_type_from_directory("res://Characters/Donqui/Resources/Dialogue/Intro/","json")
	#print("1) "+str(files))
	var files : Array[String]
	var directories = FileOperations.get_all_sub_directories("res://Characters/Donqui/Resources/Dialogue/")
	for directory in directories:
		var files_in_directory = FileOperations.get_all_files_of_type_from_directory(directory,"json")
		if len(files_in_directory) > 0:
			print("2) "+str(files_in_directory))
			files.append_array(files_in_directory)
		
		
	var resources : Array[DialogueSet]
	for file in files:
		var json = JsonOperations.load_json(file)
		
		var dialogue_set : DialogueSet = DialogueSet.new()
		dialogue_set.load_from_json(json)
		print(dialogue_set)
		resources.append(dialogue_set)
	pass
	
	dialogue_dictionary.get_or_add("Intro",resources)
	
func _ready() -> void:
	emit_signal("change_scale",current_scale_step)
	#global_position = get_viewport_rect().get_center()

func _increase_scale():
	if(current_scale_step.x < 4):
		current_scale_step = current_scale_step*step_size
		emit_signal("change_scale",current_scale_step)
			
func _decrease_scale():
	if(current_scale_step.x > 0.25):
		current_scale_step = current_scale_step/step_size
		emit_signal("change_scale",current_scale_step)
	
