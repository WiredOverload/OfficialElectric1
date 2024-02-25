class_name Palette
extends RefCounted

static var RED := Color(0.9074, 0, 0.1886, 1)
static var GREEN := Color(0.2999, 0.6799, 0.1018, 1)
static var BLUE := Color(0.3226, 0.4723, 1, 1)
static var BROWN := Color(0.53, 0.3357, 0, 1)
static var MAGENTA := Color(0.8547, 0.2761, 0.8821, 1)
static var YELLOW := Color(0.9904, 0.7647, 0, 1)
static var BLACK := Color(0.0808, 0.0808, 0.0808, 1)
static var WHITE := Color(0.9254, 0.9254, 0.9254, 1)

static func _static_init() -> void:
	for name: StringName in [&"RED",&"GREEN",&"BLUE",&"BROWN",&"MAGENTA",&"YELLOW",&"BLACK",&"WHITE"]:
		Palette[name] = Color.hex(Palette[name].to_rgba32())

static func color_name(c: Color) -> StringName:
	for name: StringName in [&"RED",&"GREEN",&"BLUE",&"BROWN",&"MAGENTA",&"YELLOW",&"BLACK",&"WHITE"]:
		if Palette[name] == c:
			return name
	assert(false)
	push_error("Invalid color: ", c)
	return &"MAGENTA"

func _init() -> void:
	assert(false)
	push_error("Static class should not be instantiated.")


