extends Node

var seen_diags: Dictionary
var evidence: Array

var character_data: Dictionary
var dialog_data: Dictionary
var evidence_data: Dictionary

func _ready() -> void:
	dialog_data = _load_JSON("res://dialogue.json")
	character_data = _load_JSON("res://characters.json")
	evidence_data = _load_JSON("res://evidence.json")
		
func _load_JSON(file_name: String) -> Dictionary:
	var file = FileAccess.open(file_name, FileAccess.READ)
	var json = JSON.new()
	var error = json.parse(file.get_as_text())
	if error == OK:
		return json.data
	else:
		print("JSON Parse Error")
		return {}
