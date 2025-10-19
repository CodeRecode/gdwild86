extends Node2D

@onready var menus: Menus = $Menus
@onready var ui: UI = $UI

var suspect: Suspect
var dialogue
var curr_line = 0

func _on_player_on_suspect_interact(body: Node2D) -> void:
	if ui.showing_dialog():
		return
		
	curr_line = 0
	suspect = body as Suspect
	if not suspect:
		return
	ui.set_texture(suspect.tex)
	var key = suspect.key + "_intro"
	if suspect.key == "white" and not Global.seen_diags.find_key("white_intro1"):
		key = "white_intro1"
		Global.seen_diags[key] = true
	dialogue = Global.dialog_data[key]
	ui.set_dialog(dialogue[0])
	ui.show_dialog()
	if suspect.key != "body":
		ui.show_questions()
	else:
		Global.evidence.append("blackmail")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		_advance_dialogue()
	if event is InputEventMouseButton:
		_advance_dialogue()

func _advance_dialogue() -> void:
	if ui.is_tweening():
		return
	curr_line += 1
	if dialogue and curr_line < dialogue.size():
		ui.set_dialog(dialogue[curr_line])

func _on_ui_dialog_button_pressed(key: String) -> void:
	if curr_line < dialogue.size():
		_advance_dialogue()
		return
	if not suspect:
		return
	var full_key = suspect.key + "_" + key
	var result = Global.dialog_data.get(full_key)
	dialogue = result
	curr_line = 0
	if not result:
		dialogue = []
		ui.set_dialog("I'm not sure how to answer that.")
		return
	ui.set_dialog(result[0])
	Global.seen_diags[full_key] = true


func _on_player_on_evidence_interact(body: Node2D) -> void:
	var evidence = body as Evidence
	Global.evidence.append(evidence.evidence_type)
	body.queue_free()


func _on_player_on_suspect_leave(_body: Node2D) -> void:
	ui.hide_dialog()


func _on_ui_menu_button_pressed() -> void:
	menus.show_menu()
