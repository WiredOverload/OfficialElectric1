extends Node2D

var squareScene = preload("res://UI/pixel_square.tscn")
@onready var grid = $GridContainer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var square: ColorRect
	for i in range(15*15):
		square = squareScene.instantiate()
		square.mouse_entered.connect(change_color.bind(square))
		grid.add_child(square)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func change_color(square: ColorRect) -> void:
	if Input.is_mouse_button_pressed(1):
		square.color = Color.RED

