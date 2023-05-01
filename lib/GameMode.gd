extends Area2D

signal gamemode_selected(mode)
@export var mode: String
var isActive = true
# Called when the node enters the scene tree for the first time.
func _ready():
	area_entered.connect(func(area): onAreaEntered(area))
	match mode:
		"Fetch": initFetch()
		"Escort": initEscort()


func initFetch():
	$FetchSprite.visible = true
	$Label.text = "Fetch"

func initEscort():
	$EscortSprite.visible = true
	$Label.text = "Escort"

func _process(delta):
	pass

func onAreaEntered(area):
	if isActive:
		if area.is_in_group("Dog"):
			gamemode_selected.emit(mode)
			get_tree().call_group("GamemodeSelector", "deactivate")

func deactivate():
	hide()
	isActive = false
	
func activate():
	show()
	isActive = true
