extends Node

@onready var player = $player

signal _scoreChanged

const pegs = preload("res://peg.tscn")

var totalPegs = 0
var pegsDestroyed = 0

var score = 0

var boards = [
[
	["1","1","1","1","1","1","1","1"],
	["1","1","1","1","1","1","1","1"],
	["1","1","1","1","1","1","1","1"],
	["1","1","1","1","1","1","1","1"],
	["1","1","1","1","1","1","1","1"],
	["1","1","1","1","1","1","1","1"]
],

[
	["1","0","1","0","1","0","1","0","1"],
	["0","1","0","1","0","1","0","1","0"],
	["1","0","1","0","1","0","1","0","1"],
	["0","1","0","1","0","1","0","1","0"],
	["1","0","1","0","1","0","1","0","1"],
	["0","1","0","1","0","1","0","1","0"],
	["1","0","1","0","1","0","1","0","1"],
],

[
	["0","0","0","0","1","0","0","0","0"],
	["0","0","0","1","1","1","0","0","0"],
	["0","0","1","1","1","1","1","0","0"],
	["0","1","1","1","1","1","1","1","0"],
	["0","0","1","1","1","1","1","0","0"],
	["0","0","0","1","1","1","0","0","0"],
	["0","0","0","0","1","0","0","0","0"],
],

]

func _ready():
	_generate()
	player._resetGame.connect(_resetGame)
	

func _resetGame():
	score = 0
	pegsDestroyed = 0
	totalPegs = 0

	for child in get_children():
		if child.scene_file_path == "res://peg.tscn":
			child.queue_free()

	await get_tree().process_frame

	_generate()

	_scoreChanged.emit()

func _generate():
	totalPegs = 0
	var board = boards.pick_random()
	
	var columns = board[0].size()
	var rows = board.size()
	
	var boardX = -1023 -(columns - 1) * 175 / 2
	var boardY = -(rows - 1) * 175 / 2
	
	for y in range(rows):
		for x in range(columns):
			if board[y][x] == "1":
				_inst(Vector2(
					boardX + (x * 175),
					boardY + (y * 175)
				))
				totalPegs += 1

func _getPegHealth():
	var chance = clampf(score / 5000.0, 0.0, 0.75)

	if randf() < chance:
		var maxHealth = clampi(2 + int(score / 5000.0), 2, 5)
		return randi_range(2, maxHealth)

	return 1

func _inst(pos):
	var instance = pegs.instantiate()
	instance.position = pos

	instance.set_health(_getPegHealth())

	instance._pegDestroyed.connect(_onPegDestroyed)
	add_child(instance)
	
func _onPegDestroyed():
	pegsDestroyed += 1
	score += 10
	_scoreChanged.emit()

	if pegsDestroyed % 10 == 0:
		$player._addLife()

	if pegsDestroyed == totalPegs:
		pegsDestroyed = 0
		_generate()
		$player._addLife()
