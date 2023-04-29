extends Area2D

var lookDirection = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	$Ball
	$Sprite2D.rotation_degrees = randi_range(45, 135)
	lookDirection = Vector2.from_angle($Sprite2D.rotation - PI/4)
	$Ball.setVelocityV(lookDirection)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
