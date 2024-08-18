extends Control

@onready var lantern_select = $ButtonSelect
@onready var buttons = $VBoxContainer.get_children()
@onready var select_locs = $LanternSelectLocs.get_children()

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_start_button_pressed():
	start_game.emit()

func _on_start_button_mouse_entered():
	lantern_select.position = Vector2(select_locs[0].position[0]*5.1, select_locs[0].position[1]*5.5)


func _on_controls_button_mouse_entered():
	lantern_select.position = Vector2(select_locs[1].position[0]*5.1, select_locs[1].position[1]*5.4)


func _on_credits_button_mouse_entered():
	lantern_select.position = Vector2(select_locs[2].position[0]*5.05, select_locs[2].position[1]*5.35)
