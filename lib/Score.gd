extends Node2D

var score
var escortHighScore = 0
var fetchHighScore = 0
const sprinklerValue = 20
const catValue = 10
const hydrantValue = 15
const ballValue = 100
var gameMode = "Escort"
var comboMult = 1
# Called when the node enters the scene tree for the first time.
func _ready():
	$ComboTimer.timeout.connect(func(): 
		comboMult = 1
		updateUI())
	match gameMode:
		"Fetch":
			score = 0
		"Escort":
			score = 500
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func scoreEvent(type):
	match gameMode:
		"Fetch":
			match type:
				"Cat": score += catValue * comboMult
				"Sprinkler": score += sprinklerValue * comboMult
				"Hydrant": score += hydrantValue * comboMult
				"DeliveryItem": score += 100 * comboMult
		
			$ComboTimer.start()
			comboMult +=1
			updateUI()
		"Escort":
			match type:
				"Cat": score -= catValue
				"Sprinkler": score -= sprinklerValue
				"Hydrant": score -= hydrantValue
			updateUI()
		
func updateUI():
	$ScoreLabel.text = "Score: %s" % score 
	$ComboLabel.text = "Combo: x%s" % comboMult

func reset(gameWon):
	match gameMode:
		"Fetch":
			if score > fetchHighScore and gameWon:
				fetchHighScore = score
				$HighScoreLabel.text = "High Score: %s" % fetchHighScore
				$HighScoreLabel.visible = true
			score = 0
		"Escort":
			if score > escortHighScore and gameWon:
				escortHighScore = score
				$HighScoreLabel.text = "High Score: %s" % escortHighScore
				$HighScoreLabel.visible = true
			score = 500
	comboMult = 1
	updateUI()

func displayGameModeHighScore(currentGameMode):
	match gameMode:
		"Fetch":
			$HighScoreLabel.text = "High Score: %s" % fetchHighScore
			score = 0
			updateUI()
		"Escort":
			$HighScoreLabel.text = "High Score: %s" % escortHighScore
			score = 500
			updateUI()
	
