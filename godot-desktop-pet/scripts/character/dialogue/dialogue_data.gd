@tool
class_name DialogueData
extends Node

@export var dialogue_dictionary : Dictionary[String,DialogueSetArray]
@export_tool_button("Test Dictionary")
var button = refresh_dictionary
func _init() -> void:
	GameManager.character_files_setup.connect(
		func(character_folder : String):
			await get_tree().physics_frame
			_dialogue_setup(character_folder)
	)

func _dialogue_setup(current_character : String):
	var dialogue_folder = current_character + "/Dialogue"
	
	var open_directory = DirAccess.open(dialogue_folder)
	
	if open_directory:
		#print("Directory exists: ", dialogue_folder)
		pass
	else:
		print("Directory does NOT exist: ", dialogue_folder)
		DirAccess.make_dir_absolute(dialogue_folder)
	
	for key : String in dialogue_dictionary:
		print(key)
		var dialogue_set_array : DialogueSetArray = dialogue_dictionary[key]
		dialogue_set_array.save_to_json(dialogue_folder + "/" + key)

func refresh_dictionary():
	#var files = FileOperations.get_all_files_of_type_from_directory("res://Characters/Donqui/Resources/Dialogue/Intro/","json")
	#print("1) "+str(files))
	var files : Array[String]
	var directories = FileOperations.get_all_sub_directories("res://Characters/Donqui/Resources/Dialogue/")
	for directory in directories:
		var files_in_directory = FileOperations.get_all_files_of_type_from_directory(directory,"json")
		if len(files_in_directory) > 0:
			#print("2) "+str(files_in_directory))
			files.append_array(files_in_directory)
		
		
	var resources : DialogueSetArray
	for file in files:
		var json = JsonOperations.load_json(file)
		
		var dialogue_set : DialogueSet = DialogueSet.new()
		dialogue_set.load_from_json(json)
		resources.append(dialogue_set)
	pass
	
	dialogue_dictionary.get_or_add("Intro",resources)
	
