extends Node2D

var score
var highScore = 0
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
				"Cat": score -= catValue * comboMult
				"Sprinkler": score -= sprinklerValue * comboMult
				"Hydrant": score -= hydrantValue * comboMult
			
			$ComboTimer.start()
			comboMult +=1
			updateUI()
		
func updateUI():
	$ScoreLabel.text = "Score: %s" % score 
	$ComboLabel.text = "Combo: x%s" % comboMult

func reset(gameWon):
	if score > highScore and gameWon:
		highScore = score
		$HighScoreLabel.text = "High Score: %s" % highScore
		$HighScoreLabel.visible = true
	score = 0
	comboMult = 1
	updateUI()
