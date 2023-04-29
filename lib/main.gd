extends Node

@export var cat_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dog_hit():
	$CatTimer.stop()

func new_game():
	$Dog.start($StartPosition.position)
	$StartTimer.start()

func _on_start_timer_timeout():
	$CatTimer.start()


func _on_cat_timer_timeout():
	# Create a new instance of the cat scene.
	var cat = cat_scene.instantiate()

	# Choose a random location on Path2D.
	var cat_spawn_location = get_node("CatPath/CatSpawnLocation")
	cat_spawn_location.progress_ratio = randf()

	# Set the cat's direction perpendicular to the path direction.
	var direction = cat_spawn_location.rotation + PI / 2

	# Set the cat's position to a random location.
	cat.position = cat_spawn_location.position

	# Set the cat's rotation opposite to the path direction
	cat.rotation = cat_spawn_location.rotation + PI

	# Choose the velocity for the cat.
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	cat.linear_velocity = velocity.rotated(direction)

	# Spawn the cat by adding it to the Main scene.
	add_child(cat)