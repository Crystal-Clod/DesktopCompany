extends AnimationPlayer

var rng = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	#_blink()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _blink():
	await  get_tree().create_timer(rng.randf_range(0.5,3)).timeout
	play("Blink")
	await  get_tree().create_timer(current_animation_length).timeout
	play("Idle")
	_blink()
