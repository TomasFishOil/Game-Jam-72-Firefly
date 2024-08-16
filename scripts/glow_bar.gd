extends Node2D

@onready var glow_level = $LightBar

var count = 0
signal bar_level

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_light_bar_value_changed(value):
	bar_level.emit(value)
