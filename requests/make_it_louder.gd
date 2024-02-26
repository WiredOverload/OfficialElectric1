extends RefCounted

func get_text() -> String:
	return "it needs to be louder."

func grade(img: Image, history: Array[Image]) -> float:
	return randf_range(0.0, 1.0)
