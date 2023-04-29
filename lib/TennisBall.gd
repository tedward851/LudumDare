extends Area2D

var speed = 200
var velocity = Vector2()
var friction = Vector2(-1,1)
# Called when the node enters the scene tree for the first time.
func _ready():
	setVelocity(1,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity += friction * delta
	position += velocity * delta
	
func setVelocity(x, y):
	velocity.x = x
	velocity.y = y
	velocity = velocity.normalized() * speed
	
func setSpeed(v):
	speed = v
