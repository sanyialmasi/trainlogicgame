extends CanvasLayer

@export var level_number_text: String = "1. Pálya"
@export var start_popup_title: String = "1. Pálya: Gyakorló"
@export_multiline var start_popup_description: String = "1. Pálya leírása"
@export_multiline var bullet_tasks: String = "• Zárd le a sorompót\n• Állítsd a váltót egyenesbe\n• Engedd be a vonatot az 1-es peronra"


@onready var dimmer: ColorRect = $Control/DarkOverlay

@onready var level_title_label: Label = $Control/TopCenterBar/PanelContainer/LevelTitleLabel


@onready var start_popup: CenterContainer = $Control/StartPopup

@onready var encyclopedia_popup: CenterContainer = $Control/EncyclopediaPopup
@onready var end_popup: CenterContainer = $Control/EndPopup
@onready var result_title: Label = $Control/EndPopup/PanelContainer/MarginContainer/VBoxContainer/ResultTitle
@onready var result_message: Label = $Control/EndPopup/PanelContainer/MarginContainer/VBoxContainer/ResultMessage

@onready var game_hud: CanvasLayer = $"."
@onready var task_list_label: Label = $Control/TaskCheckList/PanelContainer/MarginContainer/VBoxContainer/HeaderBox/TaskListLabel
@onready var start_title: Label = $Control/StartPopup/PanelContainer2/PanelContainer/VBoxContainer/StartTitle
@onready var start_description: Label = $Control/StartPopup/PanelContainer2/PanelContainer/VBoxContainer/StartDescription

func _ready() -> void:
	level_title_label.text = level_number_text
	task_list_label.text = bullet_tasks
	start_title.text = start_popup_title
	start_description.text = start_popup_description
	
	start_popup.visible = true
	_update_dimmer()
	encyclopedia_popup.visible = false
	end_popup.visible = false
	get_tree().paused = true

func _on_start_level_button_pressed() -> void:
	start_popup.visible = false
	get_tree().paused = false
	_update_dimmer()

func _on_encyclopedia_button_pressed() -> void:
	encyclopedia_popup.visible = true
	get_tree().paused = true
	_update_dimmer()

func _on_close_encyclopedia_button_pressed() -> void:
	encyclopedia_popup.visible = false
	if not start_popup.visible and not end_popup.visible:
		get_tree().paused = false
		_update_dimmer()

func show_end_popup(success: bool, message: String) -> void:
	result_title.text = "Sikerült!" if success else "Próbáld újra!"
	result_title.modulate = Color.LIGHT_GREEN if success else Color.SALMON
	result_message.text = message
	end_popup.visible = true
	get_tree().paused = true
	_update_dimmer()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://ui/main_menu.tscn")


func _on_popup_restart_button_pressed() -> void:
	_on_restart_button_pressed()


func _on_popup_menu_button_pressed() -> void:
	_on_menu_button_pressed()
	
func _update_dimmer() -> void:
	var should_show: bool = start_popup.visible or encyclopedia_popup.visible or end_popup.visible
	var tween := create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	
	if should_show:
		if not dimmer.visible:
			dimmer.modulate.a = 0.0
			dimmer.visible = true
		tween.tween_property(dimmer, "modulate:a", 1.0, 0.2)
	else:
		tween.tween_property(dimmer, "modulate:a", 0.0, 0.15)
		tween.tween_callback(func(): dimmer.visible = false)
