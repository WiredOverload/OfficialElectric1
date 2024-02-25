extends RefCounted

func get_text() -> String:
	return "I want a nice clean frame!"

func grade(img: Image, old: Image) -> float:
	var s := img.get_size()
	var streaks := []
	var colors := {}
	var current_color := [Color.TRANSPARENT]
	var add := func add(x: int, y: int):
		var c := img.get_pixel(0, y)
		if c != current_color[0]:
			streaks.append(0)
			current_color[0] = c
		streaks[-1] += 1
		colors[c] = colors.get(c, 0) + 1
	for y in range(0, s.y):
		add.call(0, y)
	for x in range(1, s.x-1):
		add.call(x, s.y-1)
	for y in range(s.y-1, -1, -1):
		add.call(s.x-1, y)
	for x in range(s.x-2, 0, -1):
		add.call(x, 0)
	if streaks.size() > 2 and img.get_pixel(0, 0) == img.get_pixel(1, 0):
		streaks[0] += streaks[-1]
		streaks.pop_back()
	
	var score := 0.0
	score += 0.5 if streaks.min() > 10 else 0.0
	score += 0.5 if streaks.size() < 5 else 0.0
	return score
