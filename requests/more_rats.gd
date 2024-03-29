extends RefCounted

func get_text() -> String:
	return "can you make it more rat-like?"

func grade(img: Image, history: Array[Image]) -> float:
	
	var s := img.get_size()
	var diff_count := 0
	var pixel
	var old_pixel
	for y in s.y:
		for x in s.x:
			pixel = img.get_pixel(x, y)
			old_pixel = history.back().get_pixel(x, y)
			if pixel != old_pixel:
				diff_count += 1
	return 1 if diff_count > 24 else -1
