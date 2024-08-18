extends Control

@onready var lantern_select = $ButtonSelect
@onready var select_locs = $LanternSelectLocs.get_children()

signal resume_game
signal exit_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$ButtonContainer/ResumeButton.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_resume_button_pressed():
	resume_game.emit()

func _on_controls_button_pressed():
	pass # Replace with function body.

func _on_return_button_pressed():
	exit_game.emit()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_resume_button_mouse_entered():
	$ButtonContainer/ResumeButton.grab_focus()

func _on_controls_button_mouse_entered():
	$ButtonContainer/ControlsButton.grab_focus()

func _on_return_button_mouse_entered():
	$ButtonContainer/ReturnButton.grab_focus()

func _on_resume_button_focus_entered():
	lantern_select.position = select_locs[0].position

func _on_controls_button_focus_entered():
	lantern_select.position = select_locs[1].position

func _on_return_button_focus_entered():
	lantern_select.position = select_locs[2].position


