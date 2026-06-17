extends Node2D

@export var brickGenerator : BrickGenerator

var bricks : Array[Brick]

signal allBricksBroken
var difficulty = 0
func _doRound():
	difficulty += 1
	bricks = brickGenerator._generate(difficulty)
	
	for I in bricks:
		I.die.connect(onBrickDie)
	
	await allBricksBroken
	_doRound()

func onBrickDie():
	while bricks.has(null):
		bricks.erase(null)
	
	if bricks.size() == 0:
		allBricksBroken.emit()

func _ready():
	_doRound()
