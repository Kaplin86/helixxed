extends Node2D

func toScene(path):
	var newtween = create_tween()
	newtween.tween_property($Sprite2D,"modulate",Color.WHITE,0.3)
	await get_tree().create_timer(0.3).timeout
	get_tree().change_scene_to_file(path)
	newtween = create_tween()
	newtween.tween_property($Sprite2D,"modulate",Color.TRANSPARENT,0.3)
