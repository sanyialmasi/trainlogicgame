class_name TrackSwitch
extends Area2D

signal switched(is_branching: bool)

@export var is_branching: bool = false
@export var straight_path: Path2D
@export var branch_path: Path2D


func _ready() -> void:
	update_visuals()

func _input_event(_viewport: Viewport, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		var local_pos: Vector2 = $Sprite2D.get_local_mouse_position()
		if $Sprite2D.get_rect().has_point(local_pos):
			toggle_switch()
			get_viewport().set_input_as_handled()

func toggle_switch() -> void:
	is_branching = not is_branching
	switched.emit(is_branching)
	update_visuals()
	
	
func update_visuals() -> void:
	$Sprite2D.flip_h = not is_branching
	$Sprite2D.modulate = Color.WHITE

func get_active_path() -> Path2D:
	return branch_path if is_branching else straight_path
