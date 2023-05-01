extends Area2D

@export var blind_person_scence: PackedScene
var blind_person

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("Bench")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_area_entered(area):
	if area.is_in_group("Dog") and area.blind_person != null:
		$CollisionShape2D.set_deferred("disabled", true)
		# Create a new instance of the blind person.
		blind_person = blind_person_scence.instantiate()
		
		blind_person.find_child("CollisionShape2D").set_deferred("disabled", true)

		# Set the cat's position to a random location.
		blind_person.position = Vector2(0, 0)
		blind_person.rotation = PI
		blind_person.scale = Vector2(1, 1)
		# Spawn the cat by adding it to the Main scene.
		call_deferred("add_child", blind_person)
		area.drop_blind_person()
