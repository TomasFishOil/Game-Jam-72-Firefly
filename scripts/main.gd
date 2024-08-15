extends Node

@export var light_scene: PackedScene
var score
@onready var light_level = $CanvasLayer/ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready():
	new_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	light_level.value -= 0.1
	
	if light_level.value == 0:
		$ScoreTimer.stop()
		$LightTimer.stop()
		print('Final Score:', score)

# Game Over
func _on_firefly_player_light_contact():
	light_level.value += 10

func new_game():
	score = 0
	$FireflyPlayer.start($StartPosition.position)
	$StartTimer.start()

func _on_score_timer_timeout():
	score += 1
	print(score)

func _on_start_timer_timeout():
	$LightTimer.start()
	$ScoreTimer.start()

func _on_light_timer_timeout():
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
	light_particle.linear_velocity = velocity.rotated(direction)
	
	# Spawn the light partile
	add_child(light_particle)

