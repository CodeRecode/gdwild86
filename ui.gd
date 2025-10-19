extends CanvasLayer
class_name UI


@onready var dialogue_box: PanelContainer = $DialogueBox
@onready var question_box: PanelContainer = $QuestionBox
@onready var dialogue: Label = $DialogueBox/MarginContainer/HBox/MarginContainer/Dialogue
@onready var texture_rect: TextureRect = $DialogueBox/MarginContainer/HBox/TextureRect

@onready var persons_box: PanelContainer = $PersonsBox
@onready var evidence_box: PanelContainer = $EvidenceBox
@onready var accuse_box: PanelContainer = $AccuseBox

@onready var alias_value: Label = $PersonsBox/MarginContainer/VBoxContainer/GridContainer/AliasValue
@onready var occupation_value: Label = $PersonsBox/MarginContainer/VBoxContainer/GridContainer/OccupationValue
@onready var alibi_value: Label = $PersonsBox/MarginContainer/VBoxContainer/GridContainer/AlibiValue
@onready var statements_value: Label = $PersonsBox/MarginContainer/VBoxContainer/GridContainer/StatementsValue

@onready var blackmail_button: TextureButton = $EvidenceBox/MarginContainer/VBoxContainer/HBoxContainer/BlackmailButton
@onready var invitation_button: TextureButton = $EvidenceBox/MarginContainer/VBoxContainer/HBoxContainer/InvitationButton
@onready var report_button: TextureButton = $EvidenceBox/MarginContainer/VBoxContainer/HBoxContainer/ReportButton
@onready var evidence_label: Label = $EvidenceBox/MarginContainer/VBoxContainer/MarginContainer/EvidenceLabel

@onready var white_button: TextureButton = $PersonsBox/MarginContainer/VBoxContainer/HBoxContainer/WhiteButton
@onready var green_button: TextureButton = $PersonsBox/MarginContainer/VBoxContainer/HBoxContainer/GreenButton
@onready var black_button: TextureButton = $PersonsBox/MarginContainer/VBoxContainer/HBoxContainer/BlackButton
@onready var red_button: TextureButton = $PersonsBox/MarginContainer/VBoxContainer/HBoxContainer/RedButton
@onready var yellow_button: TextureButton = $PersonsBox/MarginContainer/VBoxContainer/HBoxContainer/YellowButton
@onready var blue_button: TextureButton = $PersonsBox/MarginContainer/VBoxContainer/HBoxContainer/BlueButton

@onready var present_box: PanelContainer = $PresentBox
@onready var blackmail_present_button: TextureButton = $PresentBox/MarginContainer/VBoxContainer/HBoxContainer/BlackmailPresentButton
@onready var invitation_present_button: TextureButton = $PresentBox/MarginContainer/VBoxContainer/HBoxContainer/InvitationPresentButton
@onready var report_present_button: TextureButton = $PresentBox/MarginContainer/VBoxContainer/HBoxContainer/ReportPresentButton

@onready var perpetrator: OptionButton = $AccuseBox/MarginContainer/VBoxContainer/GridContainer/Perpetrator
@onready var motive: OptionButton = $AccuseBox/MarginContainer/VBoxContainer/GridContainer/Motive
@onready var accomplice: OptionButton = $AccuseBox/MarginContainer/VBoxContainer/GridContainer/Accomplice
@onready var accomplice_motive: OptionButton = $AccuseBox/MarginContainer/VBoxContainer/GridContainer/AccompliceMotive

@onready var victory_box: PanelContainer = $VictoryBox
@onready var victory_label: Label = $VictoryBox/MarginContainer/VBoxContainer/VictoryLabel
@onready var incorrect_label: Label = $AccuseBox/MarginContainer/VBoxContainer/IncorrectLabel
var incorrect_count = 0

signal dialog_button_pressed(key: String)
signal menu_button_pressed()

func _ready() -> void:
	white_button.button_group.pressed.connect(_calc_suspects_callback)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and evidence_box.visible:
		evidence_box.hide()
	if event is InputEventMouseButton and accuse_box.visible:
		accuse_box.hide()
	if event is InputEventMouseButton and persons_box.visible:
		persons_box.hide()

func set_texture(tex: Texture2D) -> void:
	texture_rect.texture = tex
	
var tween: Tween
func set_dialog(text: String) -> void:
	dialogue.text = text
	dialogue.visible_ratio = 0
	tween = create_tween()
	tween.tween_property(dialogue, "visible_ratio", 1., dialogue.text.length() / 120.);
	tween.play()
	
func is_tweening() -> bool:
	return tween and tween.is_running()

func showing_dialog() -> bool:
	return dialogue_box.visible

func show_dialog() -> void:
	accuse_box.hide()
	evidence_box.hide()
	persons_box.hide()
	dialogue_box.show()
	
func show_questions() -> void:
	question_box.show()
	if Global.evidence.size() > 0:
		_calc_present()
		present_box.show()

func hide_dialog() -> void:
	dialogue_box.hide()
	question_box.hide()
	present_box.hide()

func _on_happened_button_pressed() -> void:
	dialog_button_pressed.emit("happened")

func _on_who_button_pressed() -> void:
	dialog_button_pressed.emit("occupation")

func _on_where_button_pressed() -> void:
	dialog_button_pressed.emit("alibi")

func _on_suspect_button_pressed() -> void:
	dialog_button_pressed.emit("suspicions")

func _on_close_button_pressed() -> void:
	hide_dialog()

func _on_suspects_button_pressed() -> void:
	accuse_box.hide()
	evidence_box.hide()
	persons_box.visible = !persons_box.visible
	_calc_suspects()

func _calc_suspects_callback(_button) -> void:
	_calc_suspects()
	
func _calc_present() -> void:
	blackmail_present_button.visible = Global.evidence.find("blackmail") != -1
	invitation_present_button.visible = Global.evidence.find("invitation") != -1
	report_present_button.visible = Global.evidence.find("report") != -1
	
func _calc_suspects() -> void:
	var key = "white"
	if red_button.button_pressed:
		key = "red"
	elif black_button.button_pressed:
		key = "black"
	elif green_button.button_pressed:
		key = "green"
	elif blue_button.button_pressed:
		key = "blue"
	elif yellow_button.button_pressed:
		key = "yellow"
		
	alias_value.text = Global.character_data[key]["alias"]
	if key == "white" or Global.seen_diags.get(key + "_occupation"):
		occupation_value.text = Global.character_data[key]["occupation"]
	else:
		occupation_value.text = "???"
		
	if key == "white" or Global.seen_diags.get(key + "_alibi"):
		alibi_value.text = Global.character_data[key]["alibi"]
	else:
		alibi_value.text = "???"
		
	statements_value.text = ""
	var had_statements = false
	if Global.character_data[key].get("statement_happened") and Global.seen_diags.get(key + "_happened"):
		statements_value.text += "- " + Global.character_data[key].get("statement_happened") + "\n"
		had_statements = true
	if Global.character_data[key].get("statement_suspicion") and Global.seen_diags.get(key + "_suspicions"):
		statements_value.text += "- " + Global.character_data[key].get("statement_suspicion") + "\n"
		had_statements = true
		
	if not had_statements:
		statements_value.text = "None"
	

func _on_evidence_button_pressed() -> void:
	accuse_box.hide()
	persons_box.hide()
	evidence_box.visible = !evidence_box.visible
	_calc_evidence()

func _calc_evidence() -> void:
	blackmail_button.visible = Global.evidence.find("blackmail") != -1
	invitation_button.visible = Global.evidence.find("invitation") != -1
	report_button.visible = Global.evidence.find("report") != -1
	
	if blackmail_button.visible:
		evidence_label.text = Global.evidence_data["blackmail"]
	elif invitation_button.visible:
		evidence_label.text = Global.evidence_data["invitation"]
	elif report_button.visible:
		evidence_label.text = Global.evidence_data["report"]

func _on_accuse_button_pressed() -> void:
	persons_box.hide()
	evidence_box.hide()
	accuse_box.visible = !accuse_box.visible

func _on_blackmail_button_pressed() -> void:
	evidence_label.text = Global.evidence_data["blackmail"]

func _on_invitation_button_pressed() -> void:
	evidence_label.text = Global.evidence_data["invitation"]

func _on_report_button_pressed() -> void:
	evidence_label.text = Global.evidence_data["report"]

func _on_evidence_close_button_pressed() -> void:
	evidence_box.hide()

func _on_blackmail_present_button_pressed() -> void:
	dialog_button_pressed.emit("blackmail")

func _on_invitation_present_button_pressed() -> void:
	dialog_button_pressed.emit("invitation")

func _on_report_present_button_pressed() -> void:
	dialog_button_pressed.emit("report")

func _on_accuse_commit_button_button_up() -> void:
	if perpetrator.get_selected_id() != 3:
		_incorrect()
		return
	if motive.get_selected_id() != 2:
		_incorrect()
		return
	if accomplice.get_selected_id() != 4:
		_incorrect()
		return
	if accomplice_motive.get_selected_id() != 4:
		_incorrect()
		return
	
	accuse_box.hide()
	victory_label.text = "You solved the case in " + str(incorrect_count + 1) + " attempts!"
	victory_box.show()
	get_tree().paused = true
		
func _incorrect() -> void:
	incorrect_count += 1
	incorrect_label.text = "Incorrect! " + str(incorrect_count) + " incorrect accusations."
	incorrect_label.show()

func _on_replay_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_menu_button_pressed() -> void:
	menu_button_pressed.emit()
