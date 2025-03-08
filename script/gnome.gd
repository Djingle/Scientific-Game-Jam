extends CharacterBody2D

class_name Gnome

@export var speech : String = ""
var dragging : bool = false
var mouse_pos : Vector2 = Vector2.ZERO

signal hover(gnome : Gnome)
signal deselect(gnome : Gnome)
signal talk(speech : String)

func _process(_delta: float) -> void:
	if Input.is_action_just_released("mouse_click"):
		if dragging:
			dragging = false
			var tween = create_tween()
			tween.tween_property(self, "scale", Vector2(1, 1), 0.05)
			z_index = 0
		elif mouse_pos != Vector2.ZERO:
			mouse_pos = Vector2.ZERO
			$Timer.stop()
			say()
	if dragging:
		var tween = create_tween()
		tween.tween_property(self, "global_position", get_global_mouse_position(), 0.05)
	if mouse_pos != Vector2.ZERO and mouse_pos.distance_to(get_global_mouse_position()) > 1:
		$Timer.stop()
		drag()
		mouse_pos = Vector2.ZERO
		
func click() -> void:
	$Timer.start()
	mouse_pos = get_global_mouse_position()

func say() -> void:
	mouse_pos = Vector2.ZERO
	emit_signal("talk", speech)

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
