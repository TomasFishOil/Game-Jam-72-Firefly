extends Area2D

#speed at which the player will move in pixels/sec... @export allows us to see speed in inspector and change easily
#changing speed in the inspector will cause the speed in the script to be overriden
@export var firefly_speed = 400  
#play area
var screen_size  
#custom signal that moth player will emit upon coming into contact with a projectile
signal light_contact

#Called when the node enters the scene tree for the first time.
func _ready():
	#finds screen size 
	screen_size = get_viewport_rect().size 



#Called every frame. 'delta' is the elapsed time since the previous frame. Good for updating elements in the game
func _process(delta):
	#Player movement vector (Vector2 is just a 2d vector, ZERO is the coords (0,0)
	var velocity = Vector2.ZERO  
	#Input.is_action_pressed returns TRUE if pressed and FALSE if not
	if Input.is_action_pressed("move_right"):  
		velocity.x += 1
		$AnimatedSprite2D.play('right')
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		$AnimatedSprite2D.play('left')
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1

#normalizes veloctiy speed (sets vector length to 1) so moving diagonally doesnt make you go faster
	if velocity.length() > 0:
		velocity = velocity.normalized() * firefly_speed  
		 #$ is short for "get_node"... relative path
		$AnimatedSprite2D.play()     
	else:
		$AnimatedSprite2D.play()
	
	#using delta ensures position remains consisten regardless of FPS, this updates player position
	position += velocity * delta  
	#preventing player from leaving the screen
	position = position.clamp(Vector2.ZERO, screen_size)  
	

# Collision Function
#green icon means the function doesn't exist, only that the signal will attempt to connect to a function with this name
func _on_body_entered(body):
	light_contact.emit()
	body.queue_free()


func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
