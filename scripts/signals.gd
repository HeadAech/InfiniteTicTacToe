extends Node

signal AreaTouched(index: int, position: Vector2)

signal StartGame()

signal UpdateTurnText(text: String)
signal UpdateTurnCount(x: int, o: int)

signal ShowWinText(winner: String)
signal HideWinText()

signal ShowMainMenu()
