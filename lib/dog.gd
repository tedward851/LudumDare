extends Area2D

signal hit
signal win

@export var speed = 400 # How fast the player will move (pixels/sec).
var world_size # Size of the game window.
@export var tennis_ball_scence: PackedScene
var ball
var velocity
var entity_in_control = "Player"
var out_of_control_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	world_size = Vector2(5000,5000)
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if entity_in_control == "Player":
		velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play("default")
		rotation = velocity.angle() + (PI / 2)
				
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, world_size.x)
	position.y = clamp(position.y, 0, world_size.y)

func createTimer(time):
	out_of_control_timer = Timer.new()
	out_of_control_timer.wait_time = time
	out_of_control_timer.one_shot = true
	return out_of_control_timer

func _on_body_entered(body):
	if body.is_in_group("Cats"):
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
		entity_in_control = "Cat"
		velocity = body.linear_velocity.normalized() * speed
		body.linear_velocity = body.linear_velocity.normalized() * 1000
		out_of_control_timer = createTimer(1.0)
		out_of_control_timer.timeout.connect(func(): 
			entity_in_control = "Player"
			$CollisionShape2D.set_deferred("disabled", false))
		add_child(out_of_control_timer)
		out_of_control_timer.start()
		
	elif body.is_in_group("DeliveryItems"):
		# Create a new instance of the cat scene.
		ball = tennis_ball_scence.instantiate()

		# Set the cat's position to a random location.
		ball.position = Vector2(0, -75)
		ball.scale = Vector2(.25, .25)
		# Spawn the cat by adding it to the Main scene.
		add_child(ball)
		body.fetched()
	elif body.is_in_group("People"):
		if ball != null:
			win.emit()
		

func start(pos):
	if ball != null:
		ball.queue_free()
	position = pos
	show()
	$CollisionShape2D.disabled = false

func setBoundry(size):
	world_size = size
