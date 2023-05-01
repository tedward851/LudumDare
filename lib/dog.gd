extends Area2D

signal win
signal scoreEvent(type)
signal dropped_blind_person
@export var speed = 400 # How fast the player will move (pixels/sec).
var world_size # Size of the game window.
@export var tennis_ball_scence: PackedScene
@export var blind_person_scence: PackedScene
var ball
var blind_person
var velocity
var entity_in_control = "Player"
var out_of_control_timer
var target
var lastObstacle = self
# Called when the node enters the scene tree for the first time.
func _ready():
	world_size = Vector2(5000,5000)
	add_to_group("Dog")
	hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if entity_in_control == "Player":
		if blind_person != null:
			$AnimatedSprite2D.play("guide_dog")
		else:
			$AnimatedSprite2D.play("default")
		velocity = Vector2.ZERO # The player's movement vector.
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1		
		
		$AudioHandler.stop()
	elif entity_in_control == "Sprinkler":
		if blind_person != null:
			$AnimatedSprite2D.play("guide_dog")
		else:
			$AnimatedSprite2D.play("default")
		velocity = global_position.direction_to(target).orthogonal()
		velocity = velocity + global_position.direction_to(target) * (global_position.distance_to(target) / 1000)
	elif entity_in_control == "Hydrant":
		rotation = global_position.direction_to(target).orthogonal().angle() + (PI / 2)
		velocity = Vector2.ZERO
		if blind_person != null:
			$AnimatedSprite2D.play("guide_dog_peeing")
		else:
			$AnimatedSprite2D.play("peeing")
		

	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		rotation = velocity.angle() + (PI / 2)

	position += velocity * delta
	position.x = clamp(position.x, 0, world_size.x)
	position.y = clamp(position.y, 0, world_size.y)

func createTimer(time):
	out_of_control_timer = Timer.new()
	out_of_control_timer.wait_time = time
	out_of_control_timer.one_shot = true
	return out_of_control_timer

func _on_body_entered(body):
	if lastObstacle == null:
		lastObstacle = self
	if body.is_in_group("Cats"):
		if body.name != lastObstacle.name:
			scoreEvent.emit("Cat")
			# Must be deferred as we can't change physics properties on a physics callback.
			entity_in_control = "Cat"
			# The cat runs away from the dog
			body.velocity = body.global_position.direction_to(global_position).normalized() * -600
			# Set the dog off in pursuit of the cat
			velocity = body.velocity.normalized() * speed
			rotation = velocity.angle() + (PI / 2)
			# Update the cat model
			body.rotation = rotation
			out_of_control_timer = createTimer(1.0)
			out_of_control_timer.timeout.connect(func(): entity_in_control = "Player")
			add_child(out_of_control_timer)
			out_of_control_timer.start()
			lastObstacle = body
			$AudioHandler.play("BarkC")
		
	elif body.is_in_group("DeliveryItems"):
		ball = tennis_ball_scence.instantiate()
		ball.position = Vector2(0, -75)
		ball.scale = Vector2(.25, .25)
		call_deferred("add_child", ball)
		body.fetched()
		
	elif body.is_in_group("People"):
		if ball != null:
			win.emit()
	
	elif body.is_in_group("Sprinkler"):
		if body.name != lastObstacle.name:
			if blind_person != null:
				dropped_blind_person.emit()
				blind_person.queue_free()
			scoreEvent.emit("Sprinkler")
			entity_in_control = "Sprinkler"
			target = body.global_position
			out_of_control_timer = createTimer(2.0)
			out_of_control_timer.timeout.connect(func(): entity_in_control = "Player")
			add_child(out_of_control_timer)
			out_of_control_timer.start()
			lastObstacle = body
			$AudioHandler.play("BarkS")
	elif body.is_in_group("Hydrant"):
		if body.name != lastObstacle.name:
			scoreEvent.emit("Hydrant")
			entity_in_control = "Hydrant"
			target = body.global_position
			out_of_control_timer = createTimer(2.0)
			out_of_control_timer.timeout.connect(func(): entity_in_control = "Player")
			add_child(out_of_control_timer)
			out_of_control_timer.start()
			lastObstacle = body
			$AudioHandler.play("Pee")
			
	elif body.is_in_group("BlindPeople"):
		# Create a new instance of the blind person.
		blind_person = blind_person_scence.instantiate()

		# Set the cat's position to a random location.
		blind_person.position = Vector2(-55, 15)
		blind_person.scale = Vector2(1.3, 1.3)
		# Spawn the cat by adding it to the Main scene.
		call_deferred("add_child", blind_person)
		body.holding_dog()

func start(pos):
	if ball != null:
		ball.queue_free()
	position = pos
	show()

func setBoundry(size):
	world_size = size
	$Camera2D.limit_right = size.x
	$Camera2D.limit_bottom = size.y

func drop_blind_person():
	if blind_person != null:
		blind_person.queue_free()
