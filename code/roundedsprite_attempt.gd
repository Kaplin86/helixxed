extends Sprite2D

enum triangles {DOWN_UP,UP_DOWN}

func _ready():
	var sprite : Texture2D = texture
	var results = upscale(sprite.get_image(),9,9)
	var results2 = [texture,scale]
	
	while true:
		texture = results[0]
		scale = results[1]
		await get_tree().create_timer(0.5).timeout
		texture = results2[0]
		scale = results2[1]
		
		await get_tree().create_timer(0.5).timeout


func upscale(sprite : Image, amountX : int, amountY : int):
	var previousTriangles = {}
	var newImgSize = Vector2(sprite.get_size().x * amountX,sprite.get_size().y * amountY)
	var newImage = Image.create(newImgSize.x,newImgSize.y,false, Image.FORMAT_RGBA8)
	
	var size = sprite.get_size()
	# FIRST PASS -------------------------------------------
	for X in range(size.x - 1):
		for Y in range(size.y - 1):
			var color = sprite.get_pixel(X,Y)
			var lowerColor = sprite.get_pixel(X,Y + 1)
			var lowerRightColor = sprite.get_pixel(X + 1 ,Y+ 1)
			var rightColor = sprite.get_pixel(X + 1,Y )
			if color != rightColor and rightColor == lowerColor and lowerColor == lowerRightColor:
				# 01
				# 11
				if previousTriangles.has(Vector2i(X,Y)):
					previousTriangles[Vector2i(X,Y)] = -1
				else:
					previousTriangles[Vector2i(X,Y)] = triangles.DOWN_UP
			
			elif  color != rightColor and color == lowerColor and color == lowerRightColor:
				# 10
				# 11
				if previousTriangles.has(Vector2i(X + 1,Y)):
					previousTriangles[Vector2i(X + 1,Y)] = -1
				else:
					previousTriangles[Vector2i(X + 1,Y)] = triangles.UP_DOWN
			
			elif  color == rightColor and color == lowerColor and color != lowerRightColor:
				# 11
				# 10
				if previousTriangles.has(Vector2i(X + 1,Y + 1)):
					previousTriangles[Vector2i(X + 1,Y + 1)] = -1
				else:
					previousTriangles[Vector2i(X + 1,Y + 1)] = triangles.DOWN_UP
			
			elif  color == rightColor and color != lowerColor and color == lowerRightColor:
				# 11
				# 01
				if previousTriangles.has(Vector2i(X,Y + 1)):
					previousTriangles[Vector2i(X,Y + 1)] = -1
				else:
					previousTriangles[Vector2i(X,Y + 1)] = triangles.UP_DOWN

			
	
	# SECOND PASS -------------------------------------------
	for X in sprite.get_size().x:
		for Y in sprite.get_size().y:
			var triangleStyle = 0
			var pixelColor = sprite.get_pixel(X,Y)
			var upperColor = sprite.get_pixel(X,Y -1)
			var lowerColor = sprite.get_pixel(X,Y + 1)
			
			if Vector2i(X,Y) in previousTriangles:
				for xOffset in amountX:
					for yOffset in amountY:
						var finalPos = Vector2i((X * amountX) + xOffset, (Y * amountY) + yOffset)
						newImage.set_pixelv(finalPos,Color.RED)
				continue
			
			#triangle style is just for the shape of the triangles (aka if it cuts one way vs the other)
			
			if triangleStyle == 1:
				for xOffset in amountX:
					for yOffset in amountY:
						var finalPos = Vector2i((X * amountX) + xOffset, (Y * amountY) + yOffset)
						
						var u := (float(xOffset) + 0.5) / amountX
						var v := (float(yOffset) + 0.5) / amountY
						if u + v < 1.0:
							newImage.set_pixelv(finalPos, upperColor)
						elif u + v > 1.0:
							newImage.set_pixelv(finalPos, lowerColor)
						else:
							newImage.set_pixelv(finalPos, upperColor)
			elif triangleStyle == 2:
				for xOffset in amountX:
					for yOffset in amountY:
						var finalPos = Vector2i((X * amountX) + xOffset, (Y * amountY) + yOffset)
						
						var u := (float(xOffset) + 0.5) / amountX
						var v := (float(yOffset) + 0.5) / amountY
						if u > v:
							newImage.set_pixelv(finalPos, upperColor)
						elif u < v:
							newImage.set_pixelv(finalPos, lowerColor)
						else:
							newImage.set_pixelv(finalPos, upperColor)
			else:
				for xOffset in amountX:
					for yOffset in amountY:
						var finalPos = Vector2i((X * amountX) + xOffset, (Y * amountY) + yOffset)
						newImage.set_pixelv(finalPos,pixelColor)
	

	return [ImageTexture.create_from_image(newImage), scale * (Vector2.ONE/Vector2(amountX,amountY))]
