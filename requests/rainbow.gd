extends RefCounted

func get_text() -> String:
	return "can you make it more [rainbow]colorful[/rainbow]?"

func grade(img: Image) -> float:
	var color_counts := {
		Palette.RED: 0,
		Palette.BLUE: 0,
		Palette.BROWN: 0,
		Palette.GREEN: 0,
		Palette.MAGENTA: 0,
		#Palette.BLACK: 0,
		#Palette.WHITE: 0,
		Palette.YELLOW: 0,
	}
	
	var s := img.get_size()
	var count := 0
	var pixel
	for y in s.y:
		for x in s.x:
			pixel = img.get_pixel(x, y)
			if pixel != Color(0, 0, 0, 0) && pixel != Palette.BLACK && pixel != Palette.WHITE:
				color_counts[img.get_pixel(x, y)] += 1
	return 1 if color_counts.values().all(func(x): x > 24) else -1

func _get_color() -> Color:
	return Palette.RED
