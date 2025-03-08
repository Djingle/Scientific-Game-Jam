extends CharacterBody2D

class_name Gnome

@export var speech_intro : String = ""
@export var speech_outro : String = ""
var dragging : bool = false
var mouse_pos : Vector2 = Vector2.ZERO
var previous_pos : Vector2 = Vector2.ZERO
var immune_to_pickup : bool = false

signal hover(gnome : Gnome)
signal deselect(gnome : Gnome)
signal talk(speech : String)
signal start_quest(pos : Vector2)

func _process(_delta: float) -> void:
	#When mouse is released
	if Input.is_action_just_released("mouse_click"):
		#If gnome is being dragged, it "falls to the ground" and is immune to being picked up during the animation
		if dragging:
			dragging = false
			var tween = create_tween()
			tween.set_parallel()
			tween.tween_property(self, "scale", Vector2(1, 1), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
			print("pos :", position, previous_pos)
			tween.tween_property(self, "position", position + (position - previous_pos) * 20, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
			immune_to_pickup = true
			await tween.finished
			immune_to_pickup = false
			z_index = 0
		#If the mouse is released while not dragged, it will talk instead
		elif mouse_pos != Vector2.ZERO:
			mouse_pos = Vector2.ZERO
			$Timer.stop()
			say()
	#When being dragged, it will follow the mouse
	if dragging:
		var tween = create_tween()
		tween.tween_property(self, "global_position", get_global_mouse_position(), 0.05)
	if mouse_pos != Vector2.ZERO and mouse_pos.distance_to(get_global_mouse_position()) > 1:
		$Timer.stop()
		drag()
		mouse_pos = Vector2.ZERO
	rotation = clamp((position.x - previous_pos.x)*0.02, -1, 1)
	previous_pos = position
		
func click() -> void:
	#$Timer.start()
	#mouse_pos = get_global_mouse_position()
	drag()

func say() -> void:
	mouse_pos = Vector2.ZERO
	#emit_signal("talk", speech)

func drag() -> void:
	if !immune_to_pickup:
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(self, "position", get_global_mouse_position(), 0.05)
		tween.tween_property(self, "scale", Vector2(1.75, 1.75), 0.05)
		await tween.finished
		dragging = true
		z_index = 1

func quest_start() -> void:
	emit_signal("start_quest", global_position)

func _on_mouse_entered() -> void:
	emit_signal("hover", self)

func _on_mouse_exited() -> void:
	emit_signal("deselect", self)
