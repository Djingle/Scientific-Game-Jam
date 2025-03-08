extends CharacterBody2D

class_name Gnome

var dragging : bool = false

signal hover(gnome : Gnome)
signal deselect(gnome : Gnome)

func _process(_delta: float) -> void:
	if Input.is_action_just_released("mouse_click"):
		dragging = false
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(1, 1), 0.05)
		z_index = 0
	if dragging:
		var tween = create_tween()
		tween.tween_property(self, "global_position", get_global_mouse_position(), 0.05)
		
func drag() -> void:
	var tween = create_tween()
	tween.set_parallel()
	tween.tween_property(self, "position", get_global_mouse_position(), 0.05)
	tween.tween_property(self, "scale", Vector2(1.75, 1.75), 0.05)
	await tween.finished
	dragging = true
	z_index = 1

func _on_mouse_entered() -> void:
	emit_signal("hover", self)

func _on_mouse_exited() -> void:
	emit_signal("deselect", self)
