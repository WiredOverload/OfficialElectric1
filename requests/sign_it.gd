extends RefCounted

func get_text() -> String:
	return "can you sign it?"

func grade(img: Image, history: Array[Image]) -> float:
	var diff := ImageDiff.diff(history[-1], img)
	
	var quads = [false,false,false,false]
	
	for d in diff:
		var q := 0
		if d.x >= 12:
			q += 1
		if d.y >= 12:
			q += 2
		quads[q] = true
	
	var c := quads.count(true)
	
	return [-1.0, 1.0, 0.5, 0.0, -0.5][c]
