class_name ImageDiff
extends RefCounted


static func diff(old: Image, new: Image) -> Array:
	var result = []
	for x in old.get_size().x:
		for y in old.get_size().y:
			var o := old.get_pixel(x, y)
			var n := new.get_pixel(x, y)
			if o != n:
				result.append({
					where = Vector2i(x, y),
					old_color = o,
					new_color = n,
				})
	return result
