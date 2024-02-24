extends RefCounted

func get_text() -> String:
	return "can you make it more [color=red][shake]red[/shake][/color]?"

func grade(img: Image) -> float:
	var s := img.get_size()
	var count := 0
	for y in s.y:
		for x in s.x:
			if img.get_pixel(x, y) == Color.RED:
				count += 1
	return float(count) / float(s.x * s.y) / 0.5 # half red = 100%

