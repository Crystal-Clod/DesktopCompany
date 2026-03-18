class_name JsonOperations

static func save_json(_object : Resource):
	if _object is DialogueLine:
		_save_dialogue_line(_object)
		
	

static func _save_dialogue_line(_dialogue : DialogueLine):
	print("It's dialogue with this funny line: " + _dialogue.line)
	pass
