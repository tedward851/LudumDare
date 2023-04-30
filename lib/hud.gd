extends CanvasLayer

signal start_game
signal next_level

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_game_over():
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Go Fetch!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	
func show_game_won():
	show_message("Ball Delivered")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "Go Fetch!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$NextLevelButton.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	$NextLevelButton.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_message_timer_timeout():
	$Message.hide()


func _on_start_button_pressed():
	$StartButton.hide()
	$NextLevelButton.hide()
	start_game.emit()


func _on_next_level_button_pressed():
	$StartButton.hide()
	$NextLevelButton.hide()
	next_level.emit()
