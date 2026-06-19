extends BaseGene
class_name PaddleFreezeGene

var desc = "When the MAIN ball hits the paddle, it will lock on, allowing it to be aimed again."
var texture = null

func onPaddleHit(_ball : Ball):
	if _ball.isMain:
		_ball.mounted = true
