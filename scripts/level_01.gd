extends Node2D

@onready var status_label: Label = $CanvasLayer/StatusLabel
@onready var restart_button: Button = $CanvasLayer/RestartButton

func _ready() -> void:
	for path in [$EntryPath, $StraightPath, $BranchPath]:
		_build_realistic_track(path)

	$TrackSwitch.switched.connect(_on_switch_changed)
	_on_switch_changed($TrackSwitch.is_branching)

	var train: Train = $EntryPath/Train
	train.level_completed.connect(_on_level_finished.bind(true))
	train.level_failed.connect(_on_level_finished.bind(false))

	status_label.position = Vector2(200, 40)
	status_label.add_theme_font_size_override("font_size", 32)
	status_label.visible = true
	status_label.text = "zárd le a sorompót és engedd a vonatot az 1-es peronra"

	restart_button.position = Vector2(850, 110)
	restart_button.text = "Újrapróbálás"
	restart_button.visible = false
	restart_button.pressed.connect(get_tree().reload_current_scene)

func _build_realistic_track(path: Path2D) -> void:
	var highlight_line: Line2D = path.get_node("Line2D")
	highlight_line.points = path.curve.get_baked_points()
	highlight_line.width = 26.0
	highlight_line.z_index = 0
	highlight_line.default_color = Color(1.0, 0.85, 0.2, 0.0) 


	var left_rail := Line2D.new()
	var right_rail := Line2D.new()
	for rail in [left_rail, right_rail]:
		rail.width = 3.5
		rail.default_color = Color(0.82, 0.85, 0.88)
		rail.z_index = 2
		rail.begin_cap_mode = Line2D.LINE_CAP_ROUND
		rail.end_cap_mode = Line2D.LINE_CAP_ROUND
		path.add_child(rail)

	var left_points := PackedVector2Array()
	var right_points := PackedVector2Array()
	var rail_half_gauge: float = 6.5

	var length: float = path.curve.get_baked_length()
	var distance: float = 0.0


	while distance <= length:
		var pos: Vector2 = path.curve.sample_baked(distance)
		var xform: Transform2D = path.curve.sample_baked_with_rotation(distance)
		var normal: Vector2 = xform.y.normalized()


		left_points.append(pos - normal * rail_half_gauge)
		right_points.append(pos + normal * rail_half_gauge)


		if int(distance) % 20 < 5:
			var sleeper := Line2D.new()
			sleeper.width = 5.0
			sleeper.default_color = Color(0.36, 0.22, 0.11) 
			sleeper.z_index = 1
			sleeper.points = PackedVector2Array([pos - normal * 12.0, pos + normal * 12.0])
			path.add_child(sleeper)

		distance += 5.0

	left_rail.points = left_points
	right_rail.points = right_points

func _on_switch_changed(is_branching: bool) -> void:
	$StraightPath/Line2D.default_color = Color(1.0, 0.85, 0.2, 0.0) if is_branching else Color(1.0, 0.85, 0.2, 0.45)
	$BranchPath/Line2D.default_color = Color(1.0, 0.85, 0.2, 0.45) if is_branching else Color(1.0, 0.85, 0.2, 0.0)

func _on_level_finished(message: String, is_win: bool) -> void:
	status_label.text = message
	status_label.modulate = Color.LIGHT_GREEN if is_win else Color.SALMON
	restart_button.visible = true
