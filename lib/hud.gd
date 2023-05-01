extends CanvasLayer

signal start_game
signal next_level
var game_mode

func onStart(mode):
	game_mode = mode
	match game_mode:
		"Fetch":
			show_message("Fetch the Ball!", 40)
			show_subtext("Hit obstacles to increase your score")
		"Escort":
			show_message("Guide Your Person to the Bench!", 40)
			show_subtext("Avoid obstacles for a higher score")

func show_message(text, size = 64):
	$Message.add_theme_font_size_override("font_size", size)
	$Message.text = text
	$Message.show()
	$MessageTimer.start()
	
func show_subtext(text, size = 30):
	$Subtext.add_theme_font_size_override("font_size", size)
	$Subtext.text = text
	$Subtext.show()
	$MessageTimer2.start()
	
func show_game_over():
	match game_mode:
		"Fetch":
			show_message("Game Over!")
			show_subtext("Your Person Got Bored!", 40)
			await $MessageTimer.timeout
			$Score.reset(false)
			$Message.text = "Play Again?"
			$Message.add_theme_font_size_override("font_size", 64)
			$Message.show()
			await get_tree().create_timer(1.0).timeout
			$StartButton.show()
			$NextLevelButton.show()
		"Escort":
			show_message("Game Over!")
			show_subtext("Your Person Got too Frustrated!")
			await $MessageTimer.timeout
			$Score.reset(false)
			$Message.text = "Play Again?"
			$Message.add_theme_font_size_override("font_size", 64)
			$Message.show()
			await get_tree().create_timer(1.0).timeout
			$StartButton.show()
			$NextLevelButton.show()
			
	
func show_game_won():
	match game_mode:
		"Fetch":
			show_message("Ball Delivered!")
			await $MessageTimer.timeout
			$Score.reset(true)
			$Message.text = "Play Again?"
			$Message.show()
			await get_tree().create_timer(1.0).timeout
			$StartButton.show()
			$NextLevelButton.show()
		"Escort":
			show_message("Person Delivered!")
			await $MessageTimer.timeout
			$Score.reset(true)
			$Message.text = "Play Again?"
			$Message.show()
			await get_tree().create_timer(1.0).timeout
			$StartButton.show()
			$NextLevelButton.show()

# Called when the node enters the scene tree for the first time.
func _ready():
	$NextLevelButton.hide()
	$StartButton.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_message_timer_timeout():
	$Message.hide()

func _on_message_timer_timeout2():
	$Subtext.hide()

func _on_start_button_pressed():
	$StartButton.hide()
	$NextLevelButton.hide()
	start_game.emit()

func _on_next_level_button_pressed():
	$StartButton.hide()
	$NextLevelButton.hide()
	$Message.hide()
	next_level.emit()
