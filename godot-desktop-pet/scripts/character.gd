extends Node

class_name Character

signal change_scale(current_scale: Vector2)
signal set_scale_instantly(scale_relative_to_initial_scale : Vector2)
signal dragging_state(is_dragging : bool)

@onready var dialogue_data : DialogueData = %DialogueData


@export_custom(PROPERTY_HINT_LINK,"") var current_scale_step : Vector2 = Vector2(1.0,1.0)
@export var step_size : float = 2

@export var character_name : String


func _init() -> void:
	#print(OS.get_data_dir())
	#name = character_name
	#print(FileOperations.get_all_sub_directories("res://Characters/Donqui/Resources/Dialogue/"))
	#refresh_dictionary()
	pass

func get_random_dialogue_from_rarity_set(_set_name : String):
	var dialogue_sets : DialogueSetArray = dialogue_data.dialogues.get("Intro")
	if dialogue_sets == null:
		push_error("EMPTY DIALOGUE SET - RARITY")
	
	var rarity_roll = randf_range(0,100)
	var rolled_sets : Array[DialogueSet]
	
	
	for d_set in dialogue_sets.dialogue_set_array:
		if d_set.rarity >= rarity_roll:
			rolled_sets.append(d_set)
	if len(rolled_sets) == 0:
		return get_random_dialogue_from_set(_set_name)
		
	
	var dialogue_set = rolled_sets[randi_range(0,len(rolled_sets) -1)] 
	var dialogue = dialogue_set.dialogues[randi_range(0,len(dialogue_set.dialogues) -1)]
	return dialogue 

func get_random_dialogue_from_set(_set_name : String):
	var dialogue_sets : DialogueSetArray = dialogue_data.dialogues.get("Intro")
	
	if dialogue_sets == null:
		push_error("EMPTY DIALOGUE SET - RANDOM")
	
	var dialogue_set = dialogue_sets.dialogue_array[randi_range(0,len(dialogue_sets.dialogue_array) -1)] 
	var dialogue = dialogue_set.dialogues[randi_range(0,len(dialogue_set.dialogues) -1)]
	return dialogue 


func _ready() -> void:
	GameManager._character_folder_setup(character_name)
	pass
	#emit_signal("change_scale",current_scale_step)
	#global_position = get_viewport_rect().get_center()

func increase_scale():
	if(current_scale_step.x < 4):
		current_scale_step = current_scale_step*step_size
		emit_signal("change_scale",current_scale_step)
			
func decrease_scale():
	if(current_scale_step.x > 0.25):
		current_scale_step = current_scale_step/step_size
		emit_signal("change_scale",current_scale_step)

func _set_scale_instantly(scale_relative_to_initial_scale : Vector2):
	
	if scale_relative_to_initial_scale.x > 0:
		if current_scale_step.x > 4:
			current_scale_step = Vector2.ONE * 4
		else:
			current_scale_step = Vector2.ONE * (step_size * scale_relative_to_initial_scale)
	else:
		if current_scale_step.x < 0.25:
			current_scale_step = Vector2.ONE * 0.25
		else:
			current_scale_step = Vector2.ONE/(step_size*scale_relative_to_initial_scale)
	
	emit_signal("set_scale_instantly", current_scale_step)
