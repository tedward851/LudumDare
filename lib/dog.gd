extends Area2D

signal hit
signal win

@export var speed = 400 # How fast the player will move (pixels/sec).
var world_size # Size of the game window.
@export var tennis_ball_scence: PackedScene
var ball

# Called when the node enters the scene tree for the first time.
func _ready():
	world_size = Vector2(5000,5000)
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
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
		if velocity.x > 0:
			if velocity.y < 0:
				rotation = PI / 4
			elif velocity.y == 0:
				rotation = PI / 2
			else:
				rotation = 3 * PI / 4
		elif velocity.x < 0:
			if velocity.y < 0:
				rotation = 7 * PI / 4
			elif velocity.y == 0:
				rotation = 3 * PI /2
			else:
				rotation = 5 * PI / 4
		elif velocity.x == 0:
			if velocity.y < 0:
				rotation = 0
			else:
				rotation = PI
				
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, world_size.x)
	position.y = clamp(position.y, 0, world_size.y)


func _on_body_entered(body):
	if body.is_in_group("Cats"):
		hide() # Player disappears after being hit.
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
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
