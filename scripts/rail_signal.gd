class_name RailSignal
extends Area2D

signal state_changed(is_green: bool)

@export var is_green: bool = false
@export var red_texture: Texture2D
@export var green_texture: Texture2D

func _ready() -> void:
	update_visuals()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos: Vector2 = $Sprite2D.get_local_mouse_position()
		if $Sprite2D.get_rect().has_point(local_pos):
			is_green = not is_green
			state_changed.emit(is_green)
			update_visuals()
			get_viewport().set_input_as_handled()

func update_visuals() -> void:
	if red_texture != null and green_texture != null:
		$Sprite2D.texture = green_texture if is_green else red_texture
		modulate = Color.WHITE
