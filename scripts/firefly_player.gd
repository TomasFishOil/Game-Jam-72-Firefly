extends Area2D

#speed at which the player will move in pixels/sec... @export allows us to see speed in inspector and change easily
#changing speed in the inspector will cause the speed in the script to be overriden
@export var firefly_speed = 400  
@export var dash_orb_count = 0
@export var total_orb_count = 0
@export var paused = false

#play area
@export var screen_size_min = 0
@export var screen_size_max = 0  

#Dash variables
var dash = false
var dash_availible = true
const DASH_SPEED = 1000


#custom signal that moth player will emit upon coming into contact with a projectile
signal light_contact

#Called when the node enters the scene tree for the first time.
func _ready():
	#finds screen size 
	screen_size_min = Vector2.ZERO 
	screen_size_max = get_viewport_rect().size
	$AnimatedSprite2D.play('right') 

#Called every frame. 'delta' is the elapsed time since the previous frame. Good for updating elements in the game
func _process(delta):
	if not paused:
		#Player movement vector (Vector2 is just a 2d vector, ZERO is the coords (0,0)
		var velocity = Vector2.ZERO  
		#Input.is_action_pressed returns TRUE if pressed and FALSE if not
		if Input.is_action_pressed("move_right"):  
			velocity.x += 1
			if dash:
				$AnimatedSprite2D.play("dash_right")
			else:
				$AnimatedSprite2D.play('right')
		
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
			if dash:
				$AnimatedSprite2D.play("dash_left")
			else:
				$AnimatedSprite2D.play('left')
		
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
			if dash:
				# Okay tomas this is a match statement (i might call it switch sometimes)
				#  its literally just a fancier if else statement that is alot easier
				#  on the eyes. 
				# What this is doing is looking at the firefly's animation
				#  and changing its sprite to dash left or right depending on
				#  whether .animation returns 'right' or 'left' 
				match $AnimatedSprite2D.animation:
					'right':
						$AnimatedSprite2D.play("dash_right")
					'left':
						$AnimatedSprite2D.play("dash_left")
		
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
			if dash:
				match $AnimatedSprite2D.animation:
					'right':
						$AnimatedSprite2D.play("dash_right")
					'left':
						$AnimatedSprite2D.play("dash_left")
		
		if Input.is_action_just_pressed("dash") and dash_availible:
			dash = true
			dash_availible = false
			$DashTimer.start()
			$DashCoolDown.start()
			print("DASH")   #Debugging
			
		#normalizes veloctiy speed (sets vector length to 1) so moving diagonally doesnt make you go faster
		if velocity.length() > 0:
			velocity = velocity.normalized() * firefly_speed  
		
		#Checks for dashing, if dashing gives dash speed
		if dash:
			velocity = velocity.normalized() * DASH_SPEED
		else:
			# Added this to remove a bug where the dash animation
			#  would continue playing if you dashed and then sat still
			match $AnimatedSprite2D.animation:
				'dash_right':
					$AnimatedSprite2D.play("right")
				'dash_left':
					$AnimatedSprite2D.play("left")
		
		#using delta ensures position remains consisten regardless of FPS, this updates player position
		position += velocity * delta  
		#preventing player from leaving the screen
		position = position.clamp(screen_size_min, screen_size_max)  


# Collision Function

func _on_body_entered(body):
	if body.is_in_group("orbs"):
		light_contact.emit()
		body.queue_free()
		dash_orb_count += 1
		total_orb_count += 1
		print(dash_orb_count)  #debuggin
		#Dash cooldown refund on 10 orb collection
		if dash_orb_count == 10:
			dash_availible = true
			$DashCoolDown.start()
			dash_orb_count = 0
			print('dash refunded!')

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func _on_dash_timer_timeout():
	dash = false

func _on_dash_cool_down_timeout():
	dash_availible = true
	dash_orb_count = 0
	print("dash availible")
