extends Node

@export var use_external = false
@export var overwrite_files = false

@export var states: Dictionary[String,AnimationState]
@export var internal_states : Dictionary[String,AnimationState]
@export var external_states : Dictionary[String,AnimationState]

var character_folder : String
var state_folder : String

func _init():
	GameManager.character_files_setup.connect(
		func(_character_folder : String):
			await get_tree().physics_frame
			character_folder = _character_folder
			state_folder = character_folder + "/States"
			
			_save_internal_to_files()
			
			_load_external_from_files()
			
			if use_external:
				states = external_states.duplicate_deep()
			else:
				states = internal_states.duplicate_deep()
	)

func initialize_states(current_character: String):
		var state_directory = ResourceLoader.list_directory("res://Characters/" + current_character + "/States/")

func _save_internal_to_files():
	print("saving states not implemented")
	return
	FileOperations.check_if_directory_exists(state_folder)
	
	var files = FileOperations.get_all_files_of_type_from_directory(state_folder, "json")
	for key : String in internal_states:
		var animation_state : AnimationState = internal_states[key]
		if overwrite_files:
			animation_state.save_to_json(state_folder + "/" + key)
		else:
			if !files.has(state_folder + "/" + key + ".json"):
				animation_state.save_to_json(state_folder + "/" + key)

func _load_external_from_files():
	pass
