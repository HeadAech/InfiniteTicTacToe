extends CanvasLayer

@onready var main_menu = $Control/MainMenu
@onready var in_game_ui = $"Control/In Game UI"
@onready var x_turns = $"Control/In Game UI/Top Bar/X turns"
@onready var o_turns = $"Control/In Game UI/Top Bar/O turns"
@onready var turn = $"Control/In Game UI/Top Bar/Turn Label/Turn"

@onready var win_label = $"Control/In Game UI/Bottom Bar/Win Label"
@onready var winner = $"Control/In Game UI/Bottom Bar/Win Label/Winner"

@onready var animation_player_points = $AnimationPlayerPoints
@onready var animation_player_win = $AnimationPlayerWin



func _ready():
	main_menu.show()
	in_game_ui.hide()
	x_turns.text = "0"
	o_turns.text = "0"
	Signals.UpdateTurnCount.connect(on_update_turn_count)
	Signals.UpdateTurnText.connect(on_update_turn_text)
	Signals.ShowWinText.connect(on_show_win_text)
	Signals.HideWinText.connect(on_hide_win_text)
	win_label.hide()

func _on_start_button_pressed():
	main_menu.hide()
	Globals.vs_pc_mode = false
	Signals.StartGame.emit()
	in_game_ui.show()


func _on_restart_pressed():
	Signals.StartGame.emit()
	x_turns.text = "0"
	o_turns.text = "0"
	pass # Replace with function body.

func on_update_turn_count(x, o):
	if x_turns.text != str(x):
		animation_player_points.play("x_score")
	if o_turns.text != str(o):
		animation_player_points.play("o_score")
	x_turns.text = str(x)
	o_turns.text = str(o)

func on_update_turn_text(turn):
	self.turn.text = turn

func on_show_win_text(winner):
	self.winner.text = winner
	win_label.show()
	animation_player_win.play("win")

func on_hide_win_text():
	win_label.hide()


func _on_menu_button_pressed():
	Signals.ShowMainMenu.emit()
	_ready()
	pass # Replace with function body.


func _on_1_player_start_pressed():
	main_menu.hide()
	Globals.vs_pc_mode = true
	Signals.StartGame.emit()
	in_game_ui.show()
