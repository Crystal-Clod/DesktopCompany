extends Node

signal character_folders_setup
signal dialogue_setup
signal sprites_setup
signal states_setup

var character_folder : String
var current_character: String

var game_folder := OS.get_executable_path().get_base_dir()

func _init() -> void:
	#check if running or not
	#if !Engine.is_editor_hint():
	character_folder = game_folder + "/Characters"
	var character_directory = DirAccess.open(character_folder)
	
	if character_directory:
		#print("Directory exists: ", character_folder)
		pass
	else:
		print("Directory does NOT exist: ", character_folder)
		DirAccess.make_dir_absolute(character_folder)

func _character_folder_setup(character_name: String):
	current_character = character_folder + "/" + character_name
	var open_directory = DirAccess.open(current_character)
	
	if open_directory:
		#print("Directory exists: ", current_character)
		pass
	else:
		print("Directory does NOT exist: ", current_character)
		DirAccess.make_dir_absolute(current_character)
		
	character_folders_setup.emit()
		
func _dialogue_setup(dialogue : Dictionary):
	var dialogue_folder = current_character + "/Dialogue"
	
	var open_directory = DirAccess.open(dialogue_folder)
	
	if open_directory:
		#print("Directory exists: ", dialogue_folder)
		pass
	else:
		print("Directory does NOT exist: ", dialogue_folder)
		DirAccess.make_dir_absolute(dialogue_folder)
	

	
	for key in dialogue:
		var set_number = 1
		var value = dialogue[key]
		print(value)
		for dialogue_set : DialogueSet in value:
			dialogue_set.save_to_json(dialogue_folder + "Idle_" + str(set_number))
			set_number += 1
	
