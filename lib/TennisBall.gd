extends Area2D

var speed = 200
var velocity = Vector2()
var frictionCoef = 1
var timer
var isSlowing = false
var carrier: Node2D 
var isCarried = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("DeliveryItems")
	timer = createTimer(2.5)
	timer.timeout.connect(func(): isSlowing = true)
	add_child(timer)
	timer.start()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var frictionVector = velocity.rotated(PI).normalized() * frictionCoef
	if isSlowing:
		velocity += frictionVector * delta
	
	if !isCarried:
		position += velocity * delta * speed
		
	
func setVelocity(x, y):
	velocity.x = x
	velocity.y = y
	velocity = velocity.normalized()
	
func setVelocityV(vector):
	velocity = vector
	velocity = velocity.normalized()
	
func setSpeed(v):
	speed = v

func createTimer(time):
	timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	return timer

func fetched():
	queue_free()

