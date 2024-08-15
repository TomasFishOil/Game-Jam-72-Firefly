extends CanvasLayer

@onready var light_level = $ProgressBar
var count = 0
signal bar_level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_progress_bar_value_changed(value):
	# You can pass an infinite amount of parameters into emit
	bar_level.emit(value)
