extends Node2D

@onready var in_game_node = $"In Game"
@onready var animation_player = $AnimationPlayer

var figure_names = {
	0: "O",
	1: "X"
}

var spaces = {
	0: false, 1: false, 2: false,
	3: false, 4: false, 5: false,
	6: false, 7: false, 8: false
}

const figures = [preload("res://scenes/circle.tscn"), preload("res://scenes/cross.tscn")]

var current_turn := 0

var past_turns = [
	[], []
]

var turn_counter = {
	0: 0,
	1: 0
}

var wins_counter = {
	0: 0,
	1: 0
}

var in_game: bool = false

func _ready():
	print("Game start")
	in_game_node.hide()
	Signals.AreaTouched.connect(on_area_touch)
	Signals.StartGame.connect(start_game)
	Signals.ShowMainMenu.connect(on_show_main_menu)
	#start_game()
	pass

func on_show_main_menu():
	_ready()

func start_game():
	in_game = true
	current_turn = 0
	Signals.UpdateTurnText.emit(figure_names[current_turn])
	turn_counter[0] = 0
	turn_counter[1] = 0
	
	wins_counter[0] = 0
	wins_counter[1] = 0
	for i in range(0, len(spaces)):
		spaces[i] = false
	for t in past_turns:
		for f in t:
			f.queue_free()
		t.clear()
	for t in turn_counter:
		t = 0
	in_game_node.show()
	print(spaces)
	animation_player.play("show")

func next_match():
	for i in range(0, len(spaces)):
		spaces[i] = false
	for t in past_turns:
		for f in t:
			f.queue_free()
		t.clear()
	in_game = true

func on_area_touch(index, pos):
	if not in_game:
		return
	
	printt("Clicked at: ", index, pos)
	if is_space_free(index):
		turn_counter[current_turn] += 1
		occupy_space(index)
		spawn_figure(index, pos)
		change_turn()
		check_limit()
		if check_for_win():
			win()
	
	pass

func change_turn():
	current_turn = (current_turn + 1) % 2
	Signals.UpdateTurnText.emit(figure_names[current_turn])

func is_space_free(index):
	return not spaces[index]

func occupy_space(index):
	spaces[index] = true

func free_space(index):
	spaces[index] = false

func spawn_figure(index, pos):
	var fig = figures[current_turn].instantiate()
	fig.position = pos
	fig.index = index
	past_turns[current_turn].append(fig)
	in_game_node.add_child(fig)

func check_limit():
	if len(past_turns[current_turn]) == 3:
		past_turns[current_turn][0].start_fading()
	if len(past_turns[0]) == 4:
		free_space(past_turns[0][0].index)
		past_turns[0][0].queue_free()
		past_turns[0].remove_at(0)
	if len(past_turns[1]) == 4:
		free_space(past_turns[1][0].index)
		past_turns[1][0].queue_free()
		past_turns[1].remove_at(0)

# WIN CONDITIONS
# ROWS
# 0 1 2
# 3 4 5
# 6 7 8
# DIAGONAL
# 0 4 8
# 2 4 6
# COLUMNS
# 0 3 6
# 1 4 7
# 2 5 8
func check_for_win():
	var turn = (current_turn + 1) % 2
	if len(past_turns[turn]) != 3:
		return false
	var win_conditions = [
		# ROWS
		[0, 1, 2], [3, 4, 5], [6, 7, 8],
		# DIAGONAL
		[0, 4, 8], [2, 4, 6],
		# COLUMNS
		[0, 3, 6], [1, 4, 7], [2, 5, 8]
	]
	var turns = past_turns[turn]
	var indexes = [turns[0].index, turns[1].index, turns[2].index]
	indexes.sort()
		
	for condition in win_conditions:
		condition.sort()
		if indexes == condition:
			return true
	return false

func win():
	printt(figure_names[(current_turn + 1) % 2], "wins!")
	wins_counter[(current_turn + 1) % 2] += 1
	Signals.ShowWinText.emit(figure_names[(current_turn + 1) % 2])
	Signals.UpdateTurnCount.emit(wins_counter[1], wins_counter[0])
	in_game = false
	animation_player.play("hide")
	await get_tree().create_timer(3).timeout
	Signals.HideWinText.emit()
	next_match()
	animation_player.play("show")
