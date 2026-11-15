extends Panel

@onready var player = $"../player"
@onready var main = $".."

func _ready():
	player._healthChanged.connect(_process)
	main._scoreChanged.connect(_process)
	
func _process(delta):
	$hp_label.text = "HP: " + str(player.health) + "\n" + "Lives: " + str(player.lives)
	$score_label.text = "Score: " + str(main.score)
