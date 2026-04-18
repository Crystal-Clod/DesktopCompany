extends Node

signal character_files_setup(character_folder : String)

var character_folder : String
var current_character: String

var game_folder := OS.get_executable_path().get_base_dir()

var rng = RandomNumberGenerator.new()

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
		
	character_files_setup.emit(character_folder)
		

	
