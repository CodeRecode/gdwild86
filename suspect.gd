extends StaticBody2D
class_name Suspect

@onready var sprite_2d: Sprite2D = $Sprite2D

@export var tex: Texture2D
@export var key: String

func _ready() -> void:
	sprite_2d.texture = tex
