extends Area2D

var lookDirection = Vector2(0,0)
var ballScene: PackedScene = preload("res://lib/TennisBall.tscn")
var ball
# Called when the node enters the scene tree for the first time.
func _ready():
	setup()
	

func throwBall():
	lookDirection = Vector2.from_angle($Sprite2D.rotation - PI/4)
	ball.setVelocityV(lookDirection)
	ball.throw()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func reset():
	if ball != null:
		ball.queue_free()
	setup()
	

func setup():
	$Sprite2D.rotation_degrees = randi_range(45, 135)
	lookDirection = Vector2.from_angle($Sprite2D.rotation - PI/4)
	createBall()
	ball.setVelocityV(lookDirection)

func createBall():
	ball = ballScene.instantiate()
	ball.position = Vector2(17, 8)
	ball.scale = Vector2(.25, .25)
	add_child(ball)
	
