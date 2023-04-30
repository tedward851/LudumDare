extends Area2D

var velocity
var world_size = Vector2(3000,3000)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if velocity != null:
		position += velocity * delta
		position.x = clamp(position.x, -50, world_size.x + 50)
		position.y = clamp(position.y, -50, world_size.y + 50)
		if position.x < 0 or position.x > world_size.x:
			queue_free()
		elif position.y < 0 or position.y > world_size.y:
			queue_free()
