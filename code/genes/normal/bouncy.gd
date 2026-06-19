extends BaseGene
class_name BouncyGene

var desc = "Every bounce, the ball has its speed multiplied by 1.1x"
var texture = "res://assets/sprites/genes/BouncyGene.png"

func onGeneralBounce(_ball : Ball):
	_ball.speed *= 1.1
