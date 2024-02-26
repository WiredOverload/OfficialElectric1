extends Control

var drips := []

func _process(delta: float) -> void:
	var to_remove := []
	for d in drips:
		d.alpha -= delta / 2.0
		d.speed = lerpf(d.speed, 0.0, 1.0 - exp(-delta))
		d.length += d.speed * delta
		if d.alpha <= 0.0:
			to_remove.append(d)
	for d in to_remove:
		drips.erase(d)
	queue_redraw()

func _draw() -> void:
	for d in drips:
		draw_line(d.start, d.start + Vector2.DOWN * d.length, Color(d.color, d.alpha * 2.0), 2.0, false)
		draw_circle(d.start + Vector2.DOWN * d.length, 2.0, Color(d.color, d.alpha * 2.0))

func add_drip(where: Vector2i, color: Color) -> void:
	if randi_range(0, 2) < 2:
		return
	drips.append({
		start = (Vector2(where) + Vector2(randf_range(0.1, 0.9), 1.0)) / Vector2(24, 24) * size,
		color = color,
		length = 1.0,
		speed = randf_range(1.0, 35.0),
		alpha = randf_range(1.0, 2.0),
	})
