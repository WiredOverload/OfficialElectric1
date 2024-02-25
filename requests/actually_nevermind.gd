extends RefCounted

static func can_be_picked(history: Array[Image]) -> bool:
	return history.size() >= 2

func get_text() -> String:
	return "actually, I liked it better before. Could you please undo that?"

func grade(img: Image, history: Array[Image]) -> float:
	
	var diff := ImageDiff.diff(img, history[-2])
	
	return clampf(float(50 - diff.size()) / 50.0, -1.0, 1.0)
	
