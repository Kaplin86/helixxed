extends Sprite2D

func _ready():
	var sprite : Texture2D = texture
	upscale(sprite.get_image(),4,4)

func upscale(sprite : Image, amountX : int, amountY : int):
	var newImage := Image.new()
	
	var newImgSize = Vector2(sprite.get_size().x * amountX,sprite.get_size().y * amountY)
	newImage.set_data(1,1,true,Image.FORMAT_RGB8,PackedByteArray([Color(0,0,0,0),Color(0,0,0,0),Color(0,0,0,0)]))
	newImage.resize(newImgSize.x,newImgSize.y)
	print("original size:",sprite.get_size(), " when multiplied by amount gives", newImage.get_size())
	for X in sprite.get_size().x:
		for Y in sprite.get_size().y:
			print(X,",",Y)
			var triangleStyle = 0
			var pixelColor = sprite.get_pixel(X,Y)
			var upperColor = sprite.get_pixel(X,Y -1)
			var lowerColor = sprite.get_pixel(X,Y + 1)
			var leftColor = sprite.get_pixel(X - 1 ,Y)
			var rightColor = sprite.get_pixel(X + 1,Y )
			if upperColor == leftColor and rightColor == lowerColor:
				triangleStyle = 1
			if upperColor == rightColor and lowerColor == leftColor:
				triangleStyle = 2
			
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
	
	texture = ImageTexture.create_from_image(newImage)
	scale = scale * (Vector2.ONE/Vector2(amountX,amountY))
