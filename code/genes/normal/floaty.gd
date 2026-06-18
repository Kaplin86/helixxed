extends BaseGene
class_name FloatyGene

var desc = "If the ball is moving down, it looses 20% of its vertical speed"

func preCalc(_ball : Ball):
	if _ball.calculatingVelocity.y >= 0:
		_ball.calculatingVelocity *= Vector2(1,0.8)
