class_name RailSignal
extends Area2D

signal state_changed(is_green: bool)

@export var is_green: bool = false

func _ready() -> void:
	update_visuals()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_green = not is_green
		state_changed.emit(is_green)
		update_visuals()

func update_visuals() -> void:
	modulate = Color.GREEN if is_green else Color.RED
