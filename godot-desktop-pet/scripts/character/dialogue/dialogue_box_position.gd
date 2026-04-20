extends Node2D

@onready var visuals: Sprite2D = %Visuals
var offset : Vector2

func _init() -> void:
	offset = position
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position = visuals.position + offset
