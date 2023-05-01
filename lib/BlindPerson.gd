extends Area2D

var looking_for_dog = false
var disable_collisions = true


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")
	add_to_group("BlindPeople")
	if disable_collisions:
		$CollisionShape2D.set_deferred("disabled", true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if looking_for_dog:
			$AnimatedSprite2D.play("searching")
	else:
		$AnimatedSprite2D.play("default")

func holding_dog():
	queue_free()
