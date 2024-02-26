extends RefCounted

func get_text() -> String:
	return "I'm afraid of rats. Please make sure there are no rats."

func grade(img: Image, history: Array[Image]) -> float:
	return randf_range(0.0, 1.0)
