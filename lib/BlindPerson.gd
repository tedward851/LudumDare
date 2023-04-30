extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	add_to_group("BlindPeople")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func holding_dog():
	queue_free()
