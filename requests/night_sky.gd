extends RefCounted

func get_text() -> String:
	return "I want it to look more like the night sky!"

func grade(img: Image, old: Image) -> float:
	var star_count := 0
	
	var s := img.get_size()
	var count := 0
	var pixel
	var nearby_pixels := 0
	for y in s.y - 2:
		for x in s.x - 2:
			pixel = img.get_pixel(x + 1, y + 1)
			if pixel == Palette.WHITE || pixel == Palette.YELLOW:
				nearby_pixels = 0
				for i in 3:
					for j in 3:
						if img.get_pixel(x + i, y + j) == Palette.WHITE || (
							img.get_pixel(x + i, y + j) == Palette.YELLOW):
							nearby_pixels += 1
				if nearby_pixels < 2:
					star_count += 1
	return 1 if star_count > 4 else -1
