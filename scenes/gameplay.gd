extends Node2D

var squareScene = preload("res://UI/pixel_square.tscn")
@onready var grid = $GridContainer

var selectedColor = Color.RED

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var square: ColorRect
	for i in range(15*15):
		square = squareScene.instantiate()
		square.mouse_entered.connect(draw_color.bind(square))
		grid.add_child(square)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func draw_color(square: ColorRect) -> void:
	if Input.is_mouse_button_pressed(1):
		square.color = selectedColor



func _on_red_button_pressed() -> void:
	selectedColor = Color.RED

func _on_blue_button_pressed() -> void:
	selectedColor = Color.BLUE

func _on_green_button_pressed() -> void:
	selectedColor = Color.GREEN

func _on_black_button_pressed() -> void:
	selectedColor = Color.BLACK
