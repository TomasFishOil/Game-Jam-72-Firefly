extends Control

signal dash_bar

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_dash_bar_value_changed(value):
	dash_bar.emit(value)
