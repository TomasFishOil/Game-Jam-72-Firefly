extends Node

# Directions
const UP = 5*PI/4
const DOWN = PI/4
const RIGHT = 7*PI/4
const LEFT = 3*PI/4
const TOP_RIGHT = 3*PI/2
const TOP_LEFT = PI
const BOTTOM_RIGHT = 0
const BOTTOM_LEFT = PI/2

# Godot Elements
@export var light_scene: PackedScene
@onready var glow_level = $LightBarNode/LightBar
@onready var dash_bar = $GameUI/DashNodes/DashBar
@onready var game_timer = $GameUI/GameTimer
@onready var light_spawn_locs = $Orbs.get_children() # returns all children of $Orbs as a list
@onready var timer_list = [$LightTimer, $ScoreTimer, $StartTimer, $FireflyPlayer/DashTimer, $FireflyPlayer/DashCoolDown]

# Global Variabels
var score: int
# stores attack functions as callable functions, meaning you can use .call() as if you were just using ()
var boss_attacks: Array[Callable] = [x_attack, plus_attack, ball_attack, vert_line_attack, hori_line_attack] 
var orb_speed: Vector2 = Vector2(200, 200)
var orb_spawn_speed: float = 0.25

# Pause Variables
var game_paused = true


# Called when the node enters the scene tree for the first time.
func _ready():
	#node_visibility(false)
	process_mode = Node.PROCESS_MODE_ALWAYS
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_PAUSABLE
	new_game()
#func node_visibility(status):
	#for node in get_children().slice(1):
		#if node is CanvasItem:
			#node.set_visible(status)

func _start_button_clicked():
	#$MainMenu.queue_free()
	#node_visibility(true)
	new_game()

func _input(event):
	if event.is_action_pressed("ui_cancel") and $GameUI.visible:
		get_tree().paused = not get_tree().paused


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Removes orbs off of player screen
	for child in get_children():
		var orb_animated_sprite = child.find_child('AnimatedSprite2D')
		if child is RigidBody2D and orb_animated_sprite.animation == 'pulse':
			var orb_pos = child.position
			if orb_pos < $FireflyPlayer.screen_size_min or orb_pos > $FireflyPlayer.screen_size_max:
				child.queue_free()

	if not get_tree().paused and glow_level.is_visible_in_tree():
		glow_level.value -= (25*delta)
	
	$GameUI/OrbCount.text = str($FireflyPlayer.total_orb_count)
	$GameUI/DashNodes/ResetOrbText.text = str(10 - $FireflyPlayer.dash_orb_count)
	
	if $FireflyPlayer and not $FireflyPlayer.dash_availible:
		dash_bar.value = $FireflyPlayer/DashCoolDown.time_left * 20
	else:
		dash_bar.value = 100
		
	#Matches float value of glow from bar to light energy value of firefly adequately
	if glow_level.value != 0:
		$FireflyPlayer/FireflyTailLight.energy = glow_level.value / 50
		for light in $GameUI/BackgroundSprite.get_children().slice(0, 3):
			light.energy = glow_level.value / 125


func new_game():
	game_paused = false
	$StartTimer.start()
	$ScoreTimer.start()
	
	score = 0
	$FireflyPlayer.start($StartPosition.position)
	$FireflyPlayer.screen_size_min = $MovementBorderStart.position
	$FireflyPlayer.screen_size_max = $GameUI/MovementBorder.get_rect().size + $MovementBorderStart.position
	
	$LightTimer.start()
	$LightTimer.wait_time = 3

func _game_over(value):
	if value == 0:
		$ScoreTimer.stop()
		$LightTimer.stop()
		$FireflyPlayer.hide()
		$FireflyPlayer.position = Vector2.ZERO
		$GameUI/DashNodes/DashBar.hide()
		$LightBarNode/LightBar.hide()
		print('Final Score:', score)

# Firefly Related Signals
func _on_firefly_player_light_contact():
	glow_level.value += 10

# Timer Methods
func _on_score_timer_timeout():
	score += 1
	
	var timer = game_timer.text.split(':')
	var minutes: int = int(timer[0])
	var seconds: int = int(timer[1])
	
	if seconds < 59:
		seconds += 1
	else:
		seconds = 0
		minutes += 1
	
	var seconds_str: String = '0'
	var minutes_str: String = '0'
	if seconds >= 10:
		seconds_str = ''
	if minutes >= 10:
		minutes_str = ''

	game_timer.text = minutes_str + str(minutes) + ':' + seconds_str + str(seconds)

func _on_light_timer_timeout():
	# Choses a random index from all light spawns, then calls .position on them to get (x, y) coord
	var spawn_loc = light_spawn_locs[randi_range(0, len(light_spawn_locs)-1)].position
	var attack_pattern: Callable = boss_attacks[randi_range(0, len(boss_attacks)-1)]
	
	# Chooses a random attack from boss_attacks and calls .call on it
	#   .call is the same as using () to call a function,
	#   we just have to use .call() cuz im doing fancy stuff that
	#   saves space, complexity, and makes things more readable!
	# Feel free to remove this comment if u get it, its big and ugly
	attack_pattern.call(spawn_loc)
	

# Boss Attacks!
# Creates a singular light orb, method created to reduce reptitive code
func create_light_orb(direction, pos):
	# Create light particle from global variable packed scene (look above)
	var light_particle = light_scene.instantiate()
	light_particle.position = pos # Sets position to pos, a randomized marker
	
	var velocity = orb_speed # Set the speed of the balls through vector
	# Rotates balls by direction chosen in the for-each loop
	light_particle.linear_velocity = velocity.rotated(direction)

	# Spawns light orb
	add_child(light_particle)

func x_attack(pos):
	for x in 5:
		# Basically a for-each loop but in gdscript (python) syntax
		for direction in [TOP_RIGHT, TOP_LEFT, BOTTOM_LEFT, BOTTOM_RIGHT]:
			create_light_orb(direction, pos)
		
		# Creates a temporary timer in the current session
		#  that pauses this method for 0.5 seconds
		await get_tree().create_timer(orb_spawn_speed, false).timeout

func plus_attack(pos):
	for x in 5:
		# Basically a for-each loop but in gdscript (python) syntax
		for direction in [UP, DOWN, LEFT, RIGHT]:
			create_light_orb(direction, pos)
		
		# Creates a temporary timer in the current session
		#  that pauses this method for 0.5 seconds
		await get_tree().create_timer(orb_spawn_speed, false).timeout

func ball_attack(pos):
	for x in 4:
		for direction in [UP, DOWN, LEFT, RIGHT, TOP_RIGHT, TOP_LEFT, BOTTOM_LEFT, BOTTOM_RIGHT]:
			create_light_orb(direction, pos)
		await get_tree().create_timer(orb_spawn_speed, false).timeout

func vert_line_attack(pos):
	for x in 7:
		for direction in [UP, DOWN]:
			create_light_orb(direction, pos)
		await get_tree().create_timer(orb_spawn_speed, false).timeout

func hori_line_attack(pos):
	for x in 7:
		for direction in [LEFT, RIGHT]:
			create_light_orb(direction, pos)
		await get_tree().create_timer(orb_spawn_speed, false).timeout
