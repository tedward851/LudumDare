extends Area2D

var speed = 100
var velocity = Vector2()
var frictionCoef = 1
var timer
var isSlowing = false
var carrier = Node2D
var isCarried = false


# Called when the node enters the scene tree for the first time.
func _ready():
	timer = createTimer(1)
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
	else:
		position = carrier.position
		
	
func setVelocity(x, y):
	velocity.x = x
	velocity.y = y
	velocity = velocity.normalized()
	
func setSpeed(v):
	speed = v

func createTimer(time):
	timer = Timer.new()
	timer.wait_time = time
	timer.one_shot = true
	return timer

func attachToNode(node):
	carrier = node
	isSlowing = false
	isCarried = true
