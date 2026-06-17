extends Control
class_name DisplayManager

@export var roundCount : Label
@export var shotsRemaining : Label

func showRound(roundNum : int):
	roundCount.text = "ROUND " + str(roundNum)

func showShots(shotNum : int):
	shotsRemaining.text = "Shots remaining: " + str(shotNum)

func _ready():
	showRound(1)
