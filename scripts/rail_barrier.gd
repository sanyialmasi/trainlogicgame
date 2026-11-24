class_name RailBarrier
extends Area2D

signal state_changed(is_closed: bool)

@export var is_closed: bool = false

func _ready() -> void:
	update_visuals()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		is_closed = not is_closed
		state_changed.emit(is_closed)
		update_visuals()

func update_visuals() -> void:
	modulate = Color.CRIMSON if is_closed else Color.WHITE
	rotation_degrees = 0.0 if is_closed else -75.0
