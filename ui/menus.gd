extends CanvasLayer
class_name Menus

@onready var main_menu: PanelContainer = $MainMenu
@onready var settings_menu: PanelContainer = $SettingsMenu
@onready var credits_menu: PanelContainer = $CreditsMenu

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_tree().paused = true

func show_menu() -> void:
	get_tree().paused = true
	main_menu.show()

func _on_start_button_pressed() -> void:
	get_tree().paused = false
	main_menu.hide()

func _on_settings_button_pressed() -> void:
	main_menu.hide()
	settings_menu.show()

func _on_credits_button_pressed() -> void:
	main_menu.hide()
	credits_menu.show()

func _on_settings_return_button_pressed() -> void:
	settings_menu.hide()
	main_menu.show()
	
func _on_credits_return_button_pressed() -> void:
	credits_menu.hide()
	main_menu.show()
