extends Node2D

const TEXT_SPEED = 1.0
const IMAGE_SIZE = 24

enum Tool {
	PENCIL,
	BRUSH,
	BUCKET,
}

var requests: Array[Script] = [
	preload("res://requests/more_red.gd"),
	preload("res://requests/more_green.gd"),
	preload("res://requests/more_blue.gd"),
	preload("res://requests/frame_it.gd"),
	preload("res://requests/rainbow.gd"),
	preload("res://requests/night_sky.gd"),
	preload("res://requests/more_rats.gd"),
]

var request_sfx := [
	preload("res://sfx/animalSounds1.wav"),
	preload("res://sfx/animalSounds2.wav"),
	preload("res://sfx/animalSounds3.wav"),
]
@onready var audio_player := $AudioStreamPlayer

var squareScene = preload("res://UI/pixel_square.tscn")
@onready var request_label: RichTextLabel = %RequestLabel
@onready var canvas: TextureRect = %Canvas

@onready var palette_rects := {
	RED = %PaletteRed,
	GREEN = %PaletteGreen,
	BLUE = %PaletteBlue,
	WHITE = %PaletteWhite,
	BROWN = %PaletteCyan,
	MAGENTA = %PaletteMagenta,
	YELLOW = %PaletteYellow,
	BLACK = %PaletteBlack,
}

@onready var tool_buttons := {
	PENCIL = %PencilToolButton,
	BRUSH = %BrushToolButton,
	BUCKET = %BucketToolButton,
	UNDO = %UndoButton,
}

var selected_color := Palette.RED: set = set_selected_color
var old_color = null

var current_tool: Tool = Tool.PENCIL: set = set_current_tool

var current_image: Image

var undo_history: Array[Image]
var request_history: Array[Image]

var current_subject := ""
var current_request
var request_num := 0
var request_target_num := 10 + 1
var satisfaction := 0
var last_satisfaction := 1

var freeze_input := false

var available_subjects := [
	"a man with a hat",
	"a fluffy cat",
	"the Mona Lisa",
	"a cool tech giant logo",
	"your fursona",
]

var positive_starting_phrases := [
	"That looks great, but ",
	"Fantastic work, but ",
	"Great! Now ",
	"Alright cool, now ",
	"I like it, but ",
]

var negative_starting_phrases := [
	"Well, okay, but ",
	"Well, I guess that works, but ",
	"That wasn't what I had in mind, but ",
	"Not sure you captured my vision, but ",
	"I guess that's not [wave]horrible[/wave], ",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected_color = selected_color
	current_tool = current_tool
	
	for c in palette_rects:
		palette_rects[c].color = Palette[c]
		palette_rects[c].gui_input.connect(_on_palette_gui_input.bind(palette_rects[c]))
	
	current_image = Image.create(IMAGE_SIZE, IMAGE_SIZE, false, Image.FORMAT_RGBA8)
	(canvas.texture as ImageTexture).set_image(current_image)
	canvas.gui_input.connect(_on_canvas_gui_input)
	
	#start_request()


func _unhandled_key_input(event: InputEvent) -> void:
	if event is InputEventKey:
		if event.pressed and event.ctrl_pressed and event.keycode == KEY_Z:
			_undo()

func draw_color(event: InputEvent, square: ColorRect) -> void:
	if event != null && !event.is_action("mouse_click"):
		return
	if Input.is_mouse_button_pressed(1):
		square.color = selected_color
		old_color = null
	else:
		old_color = square.color
		square.color = selected_color

func exit_square(square: ColorRect) -> void:
	if old_color != null:
		square.color = old_color
		old_color = null

func get_image() -> Image:
	return current_image

func start_request() -> void:
	request_history.append(current_image.duplicate())
	var script: Script = requests.pick_random()
	current_request = script.new()
	if last_satisfaction > 0:
		request_label.text = positive_starting_phrases.pick_random() + current_request.get_text()
	else:
		request_label.text = negative_starting_phrases.pick_random() + current_request.get_text()
	request_label.visible_ratio = 0.0
	create_tween().tween_property(request_label, "visible_ratio", 1.0, 1.0 / TEXT_SPEED)

func grade_submission() -> void:
	assert(current_request)
	last_satisfaction = current_request.grade(get_image(), request_history.back())
	satisfaction += last_satisfaction
	#var score = current_request.grade(get_image())
	#$PlaceholderScoreLabel.text = str(roundi(score * 100))

func final_submission():
	request_label.text = ("Well, not sure that still looks like " + current_subject + (
		", but that's probably because you kept ignoring my suggestions." if satisfaction < 0 else 
		", but I'm glad you liked all my ideas!")
		+ "\nSatisfaction: " + str((((satisfaction / 2.0) + ((request_target_num - 1.0) / 2.0)) / (request_target_num - 1.0)) * 100.0) + "%!")
	request_label.visible_ratio = 0.0
	create_tween().tween_property(request_label, "visible_ratio", 1.0, 1.0 / TEXT_SPEED)
	$VBoxContainer/SubmitButton.text = "Restart"

func next_request() -> void:
	audio_player.stream = request_sfx.pick_random()
	audio_player.play()
	if request_num == 0:
		request_history.clear()
		current_subject = available_subjects.pick_random()
		request_label.text = "I want you to draw me " + current_subject
		request_label.visible_ratio = 0.0
		create_tween().tween_property(request_label, "visible_ratio", 1.0, 1.0 / TEXT_SPEED)
	elif request_num == 1:
		start_request()
	elif request_num == request_target_num:
		grade_submission()
		final_submission()
	else:
		grade_submission()
		start_request()
	request_num += 1
	undo_history.clear()

func set_selected_color(c: Color) -> void:
	palette_rects[Palette.color_name(selected_color)].get_parent().theme_type_variation = &"PanelBorderOff"
	selected_color = c
	palette_rects[Palette.color_name(selected_color)].get_parent().theme_type_variation = &"PanelBorderOn"
	for k in tool_buttons:
		tool_buttons[k].get_node("Color").modulate = selected_color

func set_current_tool(t: Tool) -> void:
	tool_buttons[Tool.find_key(current_tool)].get_parent().theme_type_variation = &"PanelBorderOff"
	current_tool = t
	tool_buttons[Tool.find_key(current_tool)].get_parent().theme_type_variation = &"PanelBorderOn"

func _on_palette_gui_input(event: InputEvent, palette_rect: ColorRect) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			selected_color = palette_rect.color

func _on_submit_button_pressed() -> void:
	if request_num == request_target_num + 1:
		get_tree().reload_current_scene()
	else:
		next_request()

func _canvas_to_pixel(canvas_coord: Vector2) -> Vector2i:
	return Vector2i(canvas_coord / canvas.size * Vector2(IMAGE_SIZE, IMAGE_SIZE))

func _on_canvas_gui_input(event: InputEvent) -> void:
	if freeze_input:
		return
	
	match current_tool:
		Tool.PENCIL, Tool.BRUSH:
			if event is InputEventMouseButton:
				if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					_push_history()
					var where := _canvas_to_pixel(event.position)
					current_image.set_pixelv(where, selected_color)
					if current_tool == Tool.BRUSH:
						for d: Vector2i in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
							var p := where + d
							if Rect2i(0, 0, IMAGE_SIZE, IMAGE_SIZE).has_point(p):
								current_image.set_pixelv(p, selected_color)
					_update_canvas_image()
			
			if event is InputEventMouseMotion:
				if event.button_mask & MOUSE_BUTTON_MASK_LEFT:
					var from := Vector2(_canvas_to_pixel(event.position - event.relative))
					var to := Vector2(_canvas_to_pixel(event.position))
					var n := maxi(absi(to.x - from.x), absi(to.y - from.y))
					for i: int in n + 1:
						var where := Vector2i(from.lerp(to, float(i) / float(n)).round())
						if Rect2i(0, 0, IMAGE_SIZE, IMAGE_SIZE).has_point(where):
							current_image.set_pixelv(where, selected_color)
						if current_tool == Tool.BRUSH:
							for d: Vector2i in [Vector2i.UP, Vector2i.DOWN, Vector2i.LEFT, Vector2i.RIGHT]:
								var p := where + d
								if Rect2i(0, 0, IMAGE_SIZE, IMAGE_SIZE).has_point(p):
									current_image.set_pixelv(p, selected_color)
					_update_canvas_image()
		
		Tool.BUCKET:
			if event is InputEventMouseButton:
				if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
					var where := _canvas_to_pixel(event.position)
					var inside := current_image.get_pixelv(where)
					if inside == selected_color:
						return
					_push_history()
					freeze_input = true
					var stack := [where]
					await get_tree().physics_frame
					while not stack.is_empty():
						var tmp := stack
						stack = []
						for p: Vector2i in tmp:
							if current_image.get_pixelv(p) != inside:
								continue
							current_image.set_pixelv(p, selected_color)
							for d: Vector2i in [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]:
								var pp := p + d
								if Rect2i(0, 0, IMAGE_SIZE, IMAGE_SIZE).has_point(pp):
									stack.append(pp)
						_update_canvas_image()
						await get_tree().physics_frame
					freeze_input = false

func _push_history():
	undo_history.append(current_image.duplicate())

func _undo():
	if undo_history.is_empty():
		return
	current_image = undo_history.pop_back()
	_update_canvas_image()

func _update_canvas_image() -> void:
	(canvas.texture as ImageTexture).update(current_image)


func _on_pencil_tool_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			current_tool = Tool.PENCIL


func _on_brush_tool_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			current_tool = Tool.BRUSH


func _on_bucket_tool_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			current_tool = Tool.BUCKET


func _on_undo_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_undo()
