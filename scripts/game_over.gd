extends Control

@onready var lantern_select = $ButtonSelect
@onready var select_locs = [$RetryLoc, $MainMenuLoc]

# Called when the node enters the scene tree for the first time.
func _ready():
	$ButtonContainer/RetryButton.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_retry_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_main_menu_button_pressed():
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _on_retry_button_mouse_entered():
	$ButtonContainer/RetryButton.grab_focus()

func _on_main_menu_button_mouse_entered():
	$ButtonContainer/MainMenuButton.grab_focus()

func _on_retry_button_focus_entered():
	lantern_select.position = select_locs[0].position

func _on_main_menu_button_focus_entered():
	lantern_select.position = select_locs[1].position
