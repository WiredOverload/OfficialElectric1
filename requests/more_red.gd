extends RefCounted

func get_text() -> String:
	return "can you make it more [color=red][shake]red[/shake][/color]?"

func grade(img: Image, old: Image) -> float:
	var s := img.get_size()
	var count := 0
	for y in s.y:
		for x in s.x:
			if old.get_pixel(x, y) == _get_color() && img.get_pixel(x, y) != _get_color():
				count += 1
	#return 1 if (float(count) / float(s.x * s.y)) > .3 else -1
	return 1 if count > 24 else -1

func _get_color() -> Color:
	return Palette.RED
