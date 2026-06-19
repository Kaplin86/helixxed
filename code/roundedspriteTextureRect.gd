extends TextureRect

func _ready():
	var sprite : Texture2D = texture
	var results = upscale(sprite.get_image(),5,5)
	texture = results[0]
	#scale = results[1]


var previousTriangles = []
func upscale(sprite : Image, amountX : int, amountY : int):
	previousTriangles = []
	var newImgSize = Vector2(sprite.get_size().x * amountX,sprite.get_size().y * amountY)
	var newImage = Image.create(newImgSize.x,newImgSize.y,false, Image.FORMAT_RGBA8)
	
	# FIRST PASS -------------------------------------------
	for X in range(1,sprite.get_size().x - 1):
		for Y in range(1,sprite.get_size().y - 1):
			var upperColor = sprite.get_pixel(X,Y -1)
			var lowerColor = sprite.get_pixel(X,Y + 1)
			var leftColor = sprite.get_pixel(X - 1 ,Y)
			var rightColor = sprite.get_pixel(X + 1,Y )
			var add = true
			for I in [Vector2i(X + 1,Y),Vector2i(X,Y -1),Vector2i(X,Y + 1),Vector2i(X - 1 ,Y)]:
				if previousTriangles.has(I):
					add = false
			
			if upperColor == leftColor and rightColor == lowerColor:
				if add: previousTriangles.append(Vector2i(X,Y))
				
			elif upperColor == rightColor and lowerColor == leftColor:
				if add: previousTriangles.append(Vector2i(X,Y))
			
	
	# SECOND PASS -------------------------------------------
	for X in range(1,sprite.get_size().x - 1):
		for Y in range(1,sprite.get_size().y - 1):
			
			
			
			var triangleStyle = 0
			var pixelColor = sprite.get_pixel(X,Y)
			var upperColor = sprite.get_pixel(X,Y -1)
			var lowerColor = sprite.get_pixel(X,Y + 1)
			var leftColor = sprite.get_pixel(X - 1 ,Y)
			var rightColor = sprite.get_pixel(X + 1,Y )
			
			if null in [pixelColor,upperColor,lowerColor,leftColor,rightColor]:
				continue
			
			if upperColor == leftColor and rightColor == lowerColor:
				triangleStyle = 1
			elif upperColor == rightColor and lowerColor == leftColor:
				triangleStyle = 2
			
			for I in [Vector2i(X + 1,Y),Vector2i(X,Y -1),Vector2i(X,Y + 1),Vector2i(X - 1 ,Y)]:
				if previousTriangles.has(I):
					triangleStyle = 0
			
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
