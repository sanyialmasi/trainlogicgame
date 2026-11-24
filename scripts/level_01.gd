extends Node2D

@onready var status_label: Label = $CanvasLayer/StatusLabel
@onready var restart_button: Button = $CanvasLayer/RestartButton

func _ready() -> void:
	for path in [$EntryPath, $StraightPath, $BranchPath]:
		var line: Line2D = path.get_node("Line2D")
		line.points = path.curve.get_baked_points()
		line.width = 8.0
		line.default_color = Color.DARK_SLATE_GRAY
		line.begin_cap_mode = Line2D.LINE_CAP_ROUND
		line.end_cap_mode = Line2D.LINE_CAP_ROUND
		_draw_sleepers(path)

	$TrackSwitch.switched.connect(_on_switch_changed)
	_on_switch_changed($TrackSwitch.is_branching)

	var train: Train = $EntryPath/Train
	train.level_completed.connect(_on_level_finished.bind(true))
	train.level_failed.connect(_on_level_finished.bind(false))


	status_label.position = Vector2(200, 40)
	status_label.add_theme_font_size_override("font_size", 32)
	status_label.visible = true
	status_label.text = "zárd le a sorompót és engedd a vonatot az 1. peronra"

	restart_button.position = Vector2(850, 110)
	restart_button.text = "Újrapróbálás"
	restart_button.visible = false
	restart_button.pressed.connect(get_tree().reload_current_scene)
	

func _draw_sleepers(path: Path2D) -> void:
	var length: float = path.curve.get_baked_length()
	var distance: float = 0.0
	while distance < length:
		var pos: Vector2 = path.curve.sample_baked(distance)
		var transform_2d: Transform2D = path.curve.sample_baked_with_rotation(distance)
		var normal: Vector2 = transform_2d.y.normalized()

		var sleeper := Line2D.new()
		sleeper.width = 5.0
		sleeper.default_color = Color.SADDLE_BROWN
		sleeper.z_index = -1
		sleeper.points = PackedVector2Array([pos - normal * 12.0, pos + normal * 12.0])
		path.add_child(sleeper)

		distance += 22.0


func _on_switch_changed(is_branching: bool) -> void:
	$StraightPath/Line2D.default_color = Color.DIM_GRAY if is_branching else Color.GOLD
	$BranchPath/Line2D.default_color = Color.GOLD if is_branching else Color.DIM_GRAY

func _on_level_finished(message: String, is_win: bool) -> void:
	status_label.text = message
	status_label.modulate = Color.LIGHT_GREEN if is_win else Color.SALMON
	restart_button.visible = true
