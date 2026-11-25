class_name Train
extends PathFollow2D

@export var train_texture: Texture2D

signal level_completed(message: String)
signal level_failed(reason: String)

@export var speed: float = 120.0
var is_stopped: bool = false
var current_signal: RailSignal = null

func _ready() -> void:
	if train_texture != null:
		$Sprite2D.texture = train_texture
	$SensorArea.area_entered.connect(_on_area_entered)
	$SensorArea.area_exited.connect(_on_area_exited)


func _process(delta: float) -> void:
	if current_signal != null:
		is_stopped = not current_signal.is_green

	if is_stopped:
		return

	progress += speed * delta

func _on_area_entered(area: Area2D) -> void:
	if area is RailSignal:
		current_signal = area
		if not area.is_green:
			is_stopped = true
	elif area is TrackSwitch:
		var next_path: Path2D = area.get_active_path()
		if next_path != null:
			call_deferred("_switch_to_path", next_path)
	elif area is RailBarrier:
		if not area.is_closed:
			is_stopped = true
			level_failed.emit("sorompó nyitva az átjáróban")
	elif area is StationGoal:
		is_stopped = true
		if area.is_correct_destination:
			level_completed.emit("vonat megérkezett: " + area.station_name)
		else:
			level_failed.emit("rossz vágány")

func _on_area_exited(area: Area2D) -> void:
	if area == current_signal:
		current_signal = null
		
func _switch_to_path(next_path: Path2D) -> void:
	var current_global_pos: Vector2 = global_position
	reparent(next_path, false)
	var local_pos: Vector2 = next_path.to_local(current_global_pos)
	progress = next_path.curve.get_closest_offset(local_pos)
