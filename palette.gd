class_name Palette
extends RefCounted

static var RED := Color(0.8936, 0.2295, 0.267, 1)
static var GREEN := Color(0.3561, 0.6718, 0.2291, 1)
static var BLUE := Color(0.4, 0.5389, 0.9633, 1)
static var CYAN := Color(0.125, 0.7021, 0.7082, 1)
static var MAGENTA := Color(0.8547, 0.2761, 0.8821, 1)
static var YELLOW := Color(0.949, 0.6706, 0.2157, 1)
static var BLACK := Color(0.0808, 0.0808, 0.0808, 1)
static var WHITE := Color(0.9254, 0.9254, 0.9254, 1)

static func _static_init() -> void:
	for name: StringName in [&"RED",&"GREEN",&"BLUE",&"CYAN",&"MAGENTA",&"YELLOW",&"BLACK",&"WHITE"]:
		Palette[name] = Color.hex(Palette[name].to_rgba32())

static func color_name(c: Color) -> StringName:
	for name: StringName in [&"RED",&"GREEN",&"BLUE",&"CYAN",&"MAGENTA",&"YELLOW",&"BLACK",&"WHITE"]:
		if Palette[name] == c:
			return name
	assert(false)
	push_error("Invalid color: ", c)
	return &"MAGENTA"

func _init() -> void:
	assert(false)
	push_error("Static class should not be instantiated.")


