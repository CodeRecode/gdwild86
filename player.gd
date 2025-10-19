extends CharacterBody2D


@export var SPEED = 500.0 * 60.0

var suspect: Node
var evidence: Node

signal on_suspect_interact(body: Node2D)
signal on_suspect_leave(body: Node2D)
signal on_evidence_interact(body: Node2D)


func _physics_process(delta: float) -> void:
	var delta_speed = SPEED * delta
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	if direction:
		velocity = direction * delta_speed
	else:
		velocity.x = move_toward(velocity.x, 0, delta_speed)
		velocity.y = move_toward(velocity.y, 0, delta_speed)

	move_and_slide()

func _input(event):
	if event.is_action_pressed("interact"):
		_interact()

func _interact() -> void:
	if evidence:
		on_evidence_interact.emit(evidence)
	elif suspect:
		on_suspect_interact.emit(suspect)

func _on_interact_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("suspect"):
		suspect = body


func _on_interact_area_body_exited(body: Node2D) -> void:
	if body.is_in_group("suspect"):
		suspect = null
		on_suspect_leave.emit(body)


func _on_interact_area_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("evidence"):
		evidence = parent


func _on_interact_area_area_exited(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent.is_in_group("evidence"):
		evidence = null
