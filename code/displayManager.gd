extends Control
class_name DisplayManager

@export var roundCount : Label
@export var shotsRemaining : Label
@export var geneSlots : Array[TextureRect]
@export var geneSegment : Control
@export var moneyLabel : Label

func showRound(roundNum : int):
	roundCount.text = "ROUND " + str(roundNum)

func showShots(shotNum : int):
	shotsRemaining.text = "Shots remaining: " + str(shotNum)

func _ready():
	showRound(1)

func showGenes(genes : Array[BaseGene]):
	var I = 0
	for g in geneSlots:
		if I in range(genes.size()):
			if genes[I].texture:
				g.texture = load(genes[I].texture)
			else:
				g.texture = load("res://assets/sprites/genes/FloatyGene.png")
			g._ready()
			g.tooltip_text = str(genes[I])+"\n"+genes[I].desc
		else:
			g.texture = null
		I += 1

func showMoney(money ):
	moneyLabel.text = "$" + str(money)

var dt = 0.0
func _process(delta):
	dt += delta
	geneSegment.modulate = lerp(Color(1.0, 0.959, 0.952, 1.0),Color(0.877, 1.0, 0.985, 1.0),sin(dt))
