extends StaticBody2D
class_name Brick

signal die

@export var hp = 3:
	set(value):
		hp = value
		updateHpDisplay()
		if hp <= 0:
			queue_free()
			die.emit()

func updateHpDisplay():
	find_child("hp").text = str(hp)

func _ready():
	updateHpDisplay()
