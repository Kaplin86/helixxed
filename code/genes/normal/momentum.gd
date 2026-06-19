extends BaseGene
class_name MomentumGene

var desc = "Changes the damage to be equal to the current velocity of the ball"

func calculateDamage(_ball : Ball):
	_ball.calculatingDamage = sqrt(_ball.velocity.distance_squared_to(Vector2.ZERO)) * 0.002
