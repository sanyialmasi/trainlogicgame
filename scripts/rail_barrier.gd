class_name RailBarrier
extends Area2D

signal state_changed(is_closed: bool)

@export var is_closed: bool = false
@export var open_texture: Texture2D
@export var closed_texture: Texture2D

func _ready() -> void:
	update_visuals()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos: Vector2 = $Sprite2D.get_local_mouse_position()
		if $Sprite2D.get_rect().has_point(local_pos):
			is_closed = not is_closed
			state_changed.emit(is_closed)
			update_visuals()
			get_viewport().set_input_as_handled()

func update_visuals() -> void:
	if open_texture != null and closed_texture != null:
		$Sprite2D.texture = closed_texture if is_closed else open_texture
		$Sprite2D.modulate = Color.WHITE
		$Sprite2D.rotation_degrees = 0.0
