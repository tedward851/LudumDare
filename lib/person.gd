extends Area2D

var lookDirection = Vector2()
var ball = load("res://lib/TennisBall.tscn")
var balls = Array()
var x
# Called when the node enters the scene tree for the first time.
func _ready():
	lookDirection = Vector2(1, -1)
	$Ball.setVelocity(lookDirection.x, lookDirection.y)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
