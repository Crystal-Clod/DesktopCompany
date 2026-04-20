extends MarginContainer

class_name TextBox

@onready var label = $MarginContainer/RichTextLabel
@onready var timer = $LetterDisplayTimer

@onready var base_typewriter_sound: AudioStreamPlayer = %BaseTypewriterSound
@onready var punctuation_typewriter_sound: AudioStreamPlayer = %PunctuationTypewriterSound

const MAX_WIDTH = 256

var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2


signal  finished_displaying()

		
#func _process(delta):
	#if Input.is_action_just_released("click"):
		#DialogueManager._continue_dialogue()

func  _display_text(dialogue_line : DialogueLine):
	text = dialogue_line.line
	label.text = dialogue_line.line
	
	await  resized
	#await get_tree().process_frame
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		#await get_tree().process_frame
		await  resized
		await  resized
		custom_minimum_size.y = size.y
	#global_position.x -= size.x / 2
	#global_position.y -= size.y
	
	label.text = text
	label.visible_characters = 0
	_display_letter()

func  _display_letter():
	#label.text += text[letter_index]
	
	
	label.visible_characters += 1
	
	letter_index = label.visible_characters - 1
	
	if(label.visible_characters >= text.length()):
		finished_displaying.emit()
		return
	
	match  text[letter_index]:
		"!", ".", ",", "?":
			punctuation_typewriter_sound.play()
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			base_typewriter_sound.play()
			timer.start(letter_time)
		

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.is_released():
			DialogueManager._continue_dialogue()


func _on_letter_display_timer_timeout():
	_display_letter()
