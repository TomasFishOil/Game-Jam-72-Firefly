extends Control

@onready var lantern_select = $ButtonSelect
@onready var buttons = $VBoxContainer.get_children()
@onready var select_locs = $LanternSelectLocs.get_children()

signal start_game

# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/StartButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")
	
func _on_start_button_mouse_entered():
	$VBoxContainer/StartButton.grab_focus()

func _on_controls_button_mouse_entered():
	$VBoxContainer/ControlsButton.grab_focus()

func _on_credits_button_mouse_entered():
	$VBoxContainer/CreditsButton.grab_focus()

func _on_start_button_focus_entered():
	lantern_select.position = Vector2(select_locs[0].position[0]*5, select_locs[0].position[1]*5.5)

func _on_controls_button_focus_entered():
	lantern_select.position = Vector2(select_locs[1].position[0]*4.98, select_locs[1].position[1]*5.45)

func _on_credits_button_focus_entered():
	lantern_select.position = Vector2(select_locs[2].position[0]*4.96, select_locs[2].position[1]*5.35)
