extends Node2D

func _ready() -> void:
	for path in [$EntryPath, $StraightPath, $BranchPath]:
		var line: Line2D = path.get_node("Line2D")
		line.points = path.curve.get_baked_points()
		line.width = 8.0
		line.default_color = Color.DARK_SLATE_GRAY
	
	$TrackSwitch.switched.connect(_on_switch_changed)
	_on_switch_changed($TrackSwitch.is_branching)

func _on_switch_changed(is_branching: bool) -> void:
	# Az aktív vágány világosabb/vastagabb lesz, hogy a gyerek lássa az útvonalat
	$StraightPath/Line2D.default_color = Color.DIM_GRAY if is_branching else Color.GOLD
	$BranchPath/Line2D.default_color = Color.GOLD if is_branching else Color.DIM_GRAY
