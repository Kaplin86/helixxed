extends CharacterBody2D
class_name Ball

@export var speed : float = 500.0
@export var mounted = true
@export var damage = 1

signal bounce
signal ballDead

func _ready():
	velocity = Vector2.RIGHT.rotated(deg_to_rad(70)) * speed

func _process(delta):
	if mounted:
		$Line2D.visible = true
		var pos = to_local(get_global_mouse_position())
		pos = pos.normalized()
		$Line2D.set_point_position(1,pos * speed * 0.5)
		
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			unmount()
		
	else:
		$Line2D.visible = false
	
	if global_position.y > 679:
		queue_free()
		ballDead.emit()

func unmount():
	var pos = to_local(get_global_mouse_position())
	var angle = pos.normalized()
	velocity = angle * speed
	mounted = false

func _physics_process(delta):
	if mounted:
		return
	
	var col = move_and_collide(velocity * delta)
	
	if col:
		velocity = velocity.bounce(col.get_normal())
		velocity = velocity.normalized() * speed
		speed *= 1.05
		bounce.emit()
		
		if col.get_collider() is Brick:
			onBrickImpact(col.get_collider())

func onBrickImpact(brick : Brick):
	brick.hp -= damage
