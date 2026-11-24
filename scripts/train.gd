class_name Train
extends PathFollow2D

signal reached_destination(train: Train)
signal crashed(reason: String)

@export var speed: float = 120.0
var is_stopped: bool = false
var current_signal: RailSignal = null

func _ready() -> void:
	$SensorArea.area_entered.connect(_on_area_entered)
	$SensorArea.area_exited.connect(_on_area_exited)

func _process(delta: float) -> void:
	# Ha piros jelzőnél állunk, figyeljük, mikor vált zöldre
	if current_signal != null:
		is_stopped = not current_signal.is_green

	if is_stopped:
		return

	progress += speed * delta
	if progress_ratio >= 1.0:
		reached_destination.emit(self)

func _on_area_entered(area: Area2D) -> void:
	if area is RailSignal:
		current_signal = area
		if not area.is_green:
			is_stopped = true
	elif area is TrackSwitch:
		var next_path: Path2D = area.get_active_path()
		if next_path != null:
			# Átlépés a váltó által kijelölt következő sínszakaszra
			reparent(next_path)
			progress = 0.0

func _on_area_exited(area: Area2D) -> void:
	if area == current_signal:
		current_signal = null
