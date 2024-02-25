extends Node2D

const TEXT_SPEED = 1.0
const IMAGE_SIZE = 24

var requests: Array[Script] = [
	preload("res://requests/more_red.gd"),
	preload("res://requests/more_green.gd"),
	preload("res://requests/more_blue.gd"),
	preload("res://requests/frame_it.gd"),
]

var squareScene = preload("res://UI/pixel_square.tscn")
@onready var grid = %PixelGrid
@onready var request_label: RichTextLabel = %RequestLabel

@onready var palette_rects := {
	RED = %PaletteRed,
	GREEN = %PaletteGreen,
	BLUE = %PaletteBlue,
	WHITE = %PaletteWhite,
	CYAN = %PaletteCyan,
	MAGENTA = %PaletteMagenta,
	YELLOW = %PaletteYellow,
	BLACK = %PaletteBlack,
}

var selected_color := Palette.RED: set = set_selected_color
var old_color = null

var current_subject := ""
var current_request
var request_num := 0
var request_target_num := 10 + 1
var satisfaction := 0

var available_subjects := [
	"a man with a hat",
	"a fluffy cat",
	"the Mona Lisa",
	"a cool tech giant logo",
	"your fursona",
]

var starting_phrases := [
	"That looks great, but ",
	"Fantastic work, but ",
	"Great! Now ",
	"Alright, now ",
	"Hmmmm, ",
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	selected_color = selected_color
	
	for c in palette_rects:
		palette_rects[c].color = Palette[c]
		palette_rects[c].gui_input.connect(_on_palette_gui_input.bind(palette_rects[c]))
	
	grid.columns = IMAGE_SIZE
	for i in range(IMAGE_SIZE*IMAGE_SIZE):
		var square: ColorRect = squareScene.instantiate()
		square.mouse_entered.connect(draw_color.bind(null, square))
		square.gui_input.connect(draw_color.bind(square))
		square.mouse_exited.connect(exit_square.bind(square))
		grid.add_child(square)
	
	#start_request()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


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
	var image := Image.create(IMAGE_SIZE, IMAGE_SIZE, false, Image.FORMAT_RGB8)
	for i in range(IMAGE_SIZE*IMAGE_SIZE):
		image.set_pixel(i % IMAGE_SIZE, i / IMAGE_SIZE, grid.get_child(i).color)
	return image

func start_request() -> void:
	var script: Script = requests.pick_random()
	current_request = script.new()
	request_label.text = starting_phrases.pick_random() + current_request.get_text()
	request_label.visible_ratio = 0.0
	create_tween().tween_property(request_label, "visible_ratio", 1.0, 1.0 / TEXT_SPEED)

func grade_submission() -> void:
	assert(current_request)
	satisfaction += current_request.grade(get_image())
	#var score = current_request.grade(get_image())
	#$PlaceholderScoreLabel.text = str(roundi(score * 100))

func final_submission():
	request_label.text = "Yep, that sure is " + current_subject + ".\n" + (
		"You were terrible to work with though" if satisfaction < 0 else "I'm glad you liked all my ideas!")
	request_label.visible_ratio = 0.0
	create_tween().tween_property(request_label, "visible_ratio", 1.0, 1.0 / TEXT_SPEED)
	$VBoxContainer/SubmitButton.text = "Restart"

func next_request() -> void:
	if request_num == 0:
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

func set_selected_color(c: Color) -> void:
	palette_rects[Palette.color_name(selected_color)].get_parent().theme_type_variation = &"PanelBorderOff"
	selected_color = c
	palette_rects[Palette.color_name(selected_color)].get_parent().theme_type_variation = &"PanelBorderOn"

func _on_palette_gui_input(event: InputEvent, palette_rect: ColorRect) -> void:
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			selected_color = palette_rect.color

func _on_submit_button_pressed() -> void:
	if request_num == request_target_num:
		get_tree().reload_current_scene()
	else:
		next_request()
