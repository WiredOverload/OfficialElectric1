extends RefCounted

func get_text() -> String:
	return "we need to capture the Christian audience more."

func grade(img: Image, history: Array[Image]) -> float:
	var cross_count := 0
	
	var s := img.get_size()
	var pixel
	for y in s.y - 3:
		for x in s.x - 2:
			pixel = img.get_pixel(x + 1, y + 1)
			if (img.get_pixel(x + 1, y) == pixel &&
				img.get_pixel(x, y + 1) == pixel &&
				img.get_pixel(x + 2, y + 1) == pixel &&
				img.get_pixel(x + 1, y + 2) == pixel &&
				img.get_pixel(x + 1, y + 3) == pixel &&
				img.get_pixel(x, y) != pixel &&
				img.get_pixel(x + 2, y + 2) != pixel &&
				img.get_pixel(x, y + 2) != pixel &&
				img.get_pixel(x + 2, y) != pixel):
				cross_count += 1
	return 1 if cross_count > 2 else -1
