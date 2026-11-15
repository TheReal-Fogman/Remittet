extends CharacterBody2D

signal _healthChanged
signal _resetGame

#set variables
var speed = 1500.0
var lives = 2
var dead = true
var launched = false

var health: int = 15:
	set(value):
		health = value
		_healthChanged.emit()

func _ready():
	velocity = Vector2.ZERO

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if health > 0 and dead:
				launched = true
				velocity = (get_global_mouse_position() - global_position).normalized() * speed
			dead = false

func _physics_process(delta):
	if health <= 0:
		dead = true
		velocity = velocity.lerp(Vector2.ZERO,10 * delta)
		
		if velocity.length() < 5:
			velocity = Vector2.ZERO
		
			if lives > 0:
				lives -= 1
				health = 15
				launched = false
			else:
				_resetGame.emit()
				global_position = Vector2(-1023,-900)
				speed = 1500.0
				lives = 2
				dead = true
				launched = false
				return
		
		move_and_collide(velocity * delta)
		return
	
	#handle collisions
	var collision = move_and_collide(velocity * delta)
	
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		health -= 1

func _addLife():
	lives += 1
