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
@onready var light_spawn_locs = $Orbs.get_children() # returns all children of $Orbs as a list

# Global Variabels
var score: int
# stores attack functions as callable functions, meaning you can use .call() as if you were just using ()
var boss_attacks: Array[Callable] = [x_attack, ball_attack, vert_line_attack, hori_line_attack] 
var orb_speed: Vector2 = Vector2(200, 200)
var orb_spawn_speed: float = 0.25


# Called when the node enters the scene tree for the first time.
func _ready():
	$LightTimer.start()
	$LightTimer.wait_time = 3
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	glow_level.value -= (25*delta)
	#Matches float value of glow from bar to light energy value of firefly adequately
	if glow_level.value != 0:
		$FireflyPlayer/FireflyTailLight.energy = glow_level.value / 10

func new_game():
	score = 0
	$FireflyPlayer.start($StartPosition.position)
	$FireflyPlayer.screen_size_min = $MovementBorderStart.position
	$FireflyPlayer.screen_size_max = $MovementBorder.get_rect().size + $MovementBorderStart.position
	$StartTimer.start()

func _game_over(value):
	if value == 0:
		$ScoreTimer.stop()
		$LightTimer.stop()
		$FireflyPlayer.queue_free()
		$LightBarNode/LightBar.hide()
		print('Final Score:', score)

func _on_firefly_player_light_contact():
	glow_level.value += 10
	

# Timer Methods
func _on_score_timer_timeout():
	score += 1

func _on_start_timer_timeout():
	$ScoreTimer.start()

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
		await get_tree().create_timer(orb_spawn_speed).timeout

func ball_attack(pos):
	for x in 4:
		for direction in [UP, DOWN, LEFT, RIGHT, TOP_RIGHT, TOP_LEFT, BOTTOM_LEFT, BOTTOM_RIGHT]:
			create_light_orb(direction, pos)
		await get_tree().create_timer(orb_spawn_speed).timeout

func vert_line_attack(pos):
	for x in 7:
		for direction in [UP, DOWN]:
			create_light_orb(direction, pos)
		await get_tree().create_timer(orb_spawn_speed).timeout

func hori_line_attack(pos):
	for x in 7:
		for direction in [LEFT, RIGHT]:
			create_light_orb(direction, pos)
		await get_tree().create_timer(orb_spawn_speed).timeout


# OLD CODE THAT WE MIGHT FIND USEFUL TO LOOK BACK ON, DEPRECATED
"""
func og_rand_attack():
	# Creates new instance of the mob scene
	var light_particle = light_scene.instantiate()
	
	# Choose a random location on Path2D (LightPath)
	var particle_spawn_loc = $LightPath/LightSpawnLocation
	particle_spawn_loc.progress_ratio = randf()
	
	# Set the light particle's direction perpendicular to the path direction
	var direction = particle_spawn_loc.rotation + PI / 2
	
	# Set the light particle's position to a random location
	light_particle.position = particle_spawn_loc.position
	
	# Add randomness to direction
	direction += randf_range(-PI / 4, PI / 4)
	light_particle.rotation = direction
	
	# Choose velocity for light particle
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	light_particle.linear_velocity = velocity.rotated(UP)
	
	# Spawn the light partile
	add_child(light_particle)
"""
