extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func play(track):
	for item in get_children():
		if item.name == track:
			item.play()
		else:
			item.stop()

func stop(track = "All"):
	for item in get_children():
		if item.name == track or track == "All":
			item.stop()
