extends Area2D

class_name TouchArea

func _ready():
	Signals.PcTakeTurn.connect(on_pc_take_turn)

@export_range(0, 8) var touch_index: int = 0

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			take_turn()
	pass # Replace with function body.


func on_pc_take_turn(i):
	if i == touch_index:
		take_turn()


func take_turn():
	Signals.AreaTouched.emit(touch_index, self.position)
