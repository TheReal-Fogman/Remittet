extends StaticBody2D

signal _pegDestroyed

@onready var detection = $Area2D

var health = 1
var maxHealth = 1

func _ready():
	detection.body_entered.connect(_on_body_entered)

func set_health(amount):
	health = amount
	maxHealth = amount
	_update_appearance()

func _on_body_entered(body):
	if body.name == "player":
		health -= 1
		_update_appearance()

		if health <= 0:
			_pegDestroyed.emit()
			queue_free()

func _update_appearance():
	var toughness = float(maxHealth - 1) / 4.0
	modulate = Color(1.0, 1.0 - toughness * 2, 1.0 - toughness * 2)
