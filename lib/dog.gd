extends Area2D

signal hit

@export var speed = 400 # How fast the player will move (pixels/sec).
var world_size # Size of the game window.

# Called when the node enters the scene tree for the first time.
func _ready():
	world_size = Vector2(5000,5000)
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var velocity = Vector2.ZERO # The player's movement vector.
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		rotation = PI / 2
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		rotation = 3 * PI / 2
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		rotation = PI
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
		rotation = 0

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		if velocity.x != 0:
			$AnimatedSprite2D.animation = "default"
			$AnimatedSprite2D.flip_v = false
			$AnimatedSprite2D.flip_h = velocity.x < 0
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()

	position += velocity * delta
	position.x = clamp(position.x, 0, world_size.x)
	position.y = clamp(position.y, 0, world_size.y)


func _on_body_entered(body):
	if body.is_in_group("cats"):
		hide() # Player disappears after being hit.
		hit.emit()
		# Must be deferred as we can't change physics properties on a physics callback.
		$CollisionShape2D.set_deferred("disabled", true)
	elif body.is_in_group("DeliveryItems"):
		body.fetched()
		

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func setBoundry(size):
	world_size = size
