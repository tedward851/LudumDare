extends Node

@export var cat_scene: PackedScene
@export var hydrant_scene: PackedScene
@export var blind_person_scene: PackedScene
var sprinkler_scene: PackedScene = preload("res://lib/sprinkler.tscn")
var score
var world_size = Vector2()
const SAFE_ZONE = Vector2(350, 500)
const BENCH_AREA = Vector2(2700, 2700)

# Called when the node enters the scene tree for the first time.
func _ready():
	$Dog.setBoundry($ColorRect.size)
	world_size = Vector2($ColorRect.size.x, $ColorRect.size.y)
	randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$HUD/TimerLabel.text = "%.0f" % $GameTimer.time_left

func _on_dog_hit():
	pass
	#CatTimer.stop()
	#$HUD.show_game_over()

func new_game():
	get_tree().call_group("Cats", "queue_free")
	$Dog.start($StartPosition.position)
	$BlindPerson/CollisionShape2D.disabled = false
	$StartTimer.start()
	$HUD.show_message("Get Ready")
	$Person.reset()
	createObstacles(sprinkler_scene, randi_range(5, 10), 350)
	createObstacles(hydrant_scene, randi_range(5, 10), 350)

func win_game():
	$CatTimer.stop()
	$GameTimer.stop()
	get_tree().call_group("Cats", "queue_free")
	$HUD.show_game_won()
	$Dog.start($StartPosition.position)
	$Person.reset()
	
func lose_game():
	$CatTimer.stop()
	get_tree().call_group("Cats", "queue_free")
	$HUD.show_game_over()
	$Dog.start($StartPosition.position)
	$Person.reset()

func _on_start_timer_timeout():
	$CatTimer.start()
	$GameTimer.start()
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
	var velocity = Vector2(randf_range(250.0, 350.0), 0.0)
	cat.velocity = velocity.rotated(direction)

	# Spawn the cat by adding it to the Main scene.
	add_child(cat)

func createObstacles(scene: PackedScene, num, dist = 150):
	var obstacle
	var pos
	for i in num:
		var validPos = false
		obstacle = scene.instantiate()
		
		while !validPos:
			var xPos = randi_range(0, world_size.x)
			var yPos = randi_range(0, world_size.y)
			pos = Vector2(xPos, yPos)
			validPos = checkObstaclePos(pos, dist)
		
		obstacle.global_position = pos
		add_child(obstacle)
		
	
func checkObstaclePos(pos: Vector2, dist):
	var obs = get_tree().get_nodes_in_group("Obstacle")
	for item in obs:
		if pos.distance_to(item.global_position) < dist or (pos.x < SAFE_ZONE.x && pos.y < SAFE_ZONE.y) or (pos.x > BENCH_AREA.x && pos.y > BENCH_AREA.y):
			return false
	return true

func removeObstacles():
	var obs = get_tree().get_nodes_in_group("Obstacle")
	for item in obs:
		item.queue_free()

func _on_game_timer_timeout():
	lose_game()


func _on_dog_score_event(type):
	$HUD/Score.scoreEvent(type)


func _on_dog_dropped_blind_person():
	# Create a new instance of the blind person.
		var blind_person = blind_person_scene.instantiate()

		# Set the cat's position to a random location.
		var h_move = randi_range(100,200) 
		var v_move = randi_range(100,200) 
		if randf() < 0.5:
			h_move *= -1
		if randf() < 0.5:
			v_move *= -1
			
		blind_person.position.x = clamp($Dog.position.x + h_move,0,world_size.x)
		blind_person.position.y = clamp($Dog.position.y + v_move,0,world_size.y)
		
		blind_person.looking_for_dog = true
		blind_person.disable_collisions = false
		
		blind_person.scale = Vector2(1.3, 1.3)
		# Spawn the cat by adding it to the Main scene.
		call_deferred("add_child", blind_person)
		
