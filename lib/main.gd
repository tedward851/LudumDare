extends Node

@export var cat_scene: PackedScene
var score

# Called when the node enters the scene tree for the first time.
func _ready():
	$Dog.setBoundry($ColorRect.size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_dog_hit():
	$CatTimer.stop()
	$HUD.show_game_over()

func new_game():
	get_tree().call_group("Cats", "queue_free")
	$Dog.start($StartPosition.position)
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	$Person.reset()

func win_game():
	$CatTimer.stop()
	get_tree().call_group("Cats", "queue_free")
	$HUD.show_game_won()
	$Dog.start($StartPosition.position)
	$Person.reset()

func _on_start_timer_timeout():
	$CatTimer.start()
	$Person.throwBall()


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

