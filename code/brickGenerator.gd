extends Node
class_name BrickGenerator

@export var brickScene : PackedScene

@export var brickStart : Marker2D
@export var brickEnd : Marker2D

@export var gridSize : Vector2i = Vector2i(14,4)

func _generate(difficulty = 1) -> Array[Brick]:
	var bricks : Array[Brick] = []
	for row in gridSize.y:
		var yLevel = lerp(brickStart.global_position.y,brickEnd.global_position.y,float(row)/gridSize.y)
		for column in gridSize.x:
			
			if randf_range(0,1) > (float(difficulty)**2.0)/3.0:
				continue
			
			
			
			var xPos = lerp(brickStart.global_position.x,brickEnd.global_position.x,float(column)/(gridSize.x-0.5) )
			var offset = sin(row * 60) * 15
			xPos -= offset
			var newBrick = brickScene.instantiate()
			get_parent().add_child(newBrick)
			newBrick.global_position = Vector2(xPos,yLevel)
			newBrick.hp = difficulty + randi_range(0,difficulty)
			bricks.append(newBrick)
	return bricks
