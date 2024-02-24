extends Node2D

const TEXT_SPEED = 1.0

var requests: Array[Script] = [
	preload("res://requests/more_red.gd")
]

var squareScene = preload("res://UI/pixel_square.tscn")
@onready var grid = $GridContainer
@onready var request_label: RichTextLabel = %RequestLabel

var selectedColor = Color.RED

var current_request

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var square: ColorRect
	for i in range(15*15):
		square = squareScene.instantiate()
		square.mouse_entered.connect(draw_color.bind(square))
		grid.add_child(square)
	
	start_request()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func draw_color(square: ColorRect) -> void:
	if Input.is_mouse_button_pressed(1):
		square.color = selectedColor

func get_image() -> Image:
	var image := Image.create(15, 15, false, Image.FORMAT_RGB8)
	for i in range(15*15):
		image.set_pixel(i % 15, i / 15, grid.get_child(i).color)
	return image

func start_request() -> void:
	var script: Script = requests.pick_random()
	current_request = script.new()
	request_label.text = current_request.get_text()
	request_label.visible_ratio = 0.0
	create_tween().tween_property(request_label, "visible_ratio", 1.0, 1.0 / TEXT_SPEED)

func grade_submission() -> void:
	assert(current_request)
	var score = current_request.grade(get_image())
	$PlaceholderScoreLabel.text = str(roundi(score * 100))

func next_request() -> void:
	grade_submission()
	start_request()

func _on_red_button_pressed() -> void:
	selectedColor = Color.RED

func _on_blue_button_pressed() -> void:
	selectedColor = Color.BLUE

func _on_green_button_pressed() -> void:
	selectedColor = Color.GREEN

func _on_black_button_pressed() -> void:
	selectedColor = Color.BLACK

func _on_submit_button_pressed() -> void:
	next_request()
