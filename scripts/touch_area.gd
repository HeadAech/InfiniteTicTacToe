extends Area2D

class_name TouchArea

@export_range(0, 8) var touch_index: int = 0

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton or event is InputEventScreenTouch:
		if event.pressed:
			Signals.AreaTouched.emit(touch_index, self.position)
	pass # Replace with function body.
