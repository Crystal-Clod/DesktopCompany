extends Node
var character_folder : String

func _init() -> void:
	#check if running or not
	#if !Engine.is_editor_hint():
	var game_folder := OS.get_executable_path().get_base_dir()
	character_folder = game_folder + "/Characters"
	var character_directory = DirAccess.open(character_folder)
	
	if character_directory:
		print("Directory exists: ", character_folder)
	else:
		print("Directory does NOT exist: ", character_folder)
		DirAccess.make_dir_absolute(character_folder)
		
	
	
	
