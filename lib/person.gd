extends Area2D

var lookDirection = Vector2(0,0)
var ballScene: PackedScene = preload("res://lib/TennisBall.tscn")
var ball
# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("People")
	setup()
	

func throwBall():
	ball.setVelocityV(Vector2.from_angle(rotation + PI/2))
	ball.throw()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset():
	if ball != null:
		ball.queue_free()
	setup()
	

func setup():
	createBall()
	rotation_degrees = randi_range(-90, 0)

func createBall():
	ball = ballScene.instantiate()
	ball.position = $Hand.position
	ball.scale = Vector2(.25, .25)
	call_deferred("add_child", ball)
	
