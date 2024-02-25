extends RefCounted

func get_text() -> String:
	return "could you actually flip it horizontally?"

func grade(img: Image, history: Array[Image]) -> float:
	var errors := 0
	
	var s := img.get_size()
	var pixel
	var old_mirrored_pixel
	for y in s.y:
		for x in s.x:
			pixel = img.get_pixel(x, y)
			old_mirrored_pixel = history.back().get_pixel((s.x - 1) - x, y)
			if pixel != old_mirrored_pixel:
				errors += 1
	return 1 if errors < 48 else -1
