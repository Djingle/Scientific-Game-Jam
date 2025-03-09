@tool
extends CharacterBody2D

class_name Gnome

@export var gnome_size : float = 1.0
@export var cant_be_caught : bool = false
@export var sprite : CompressedTexture2D
@export_subgroup("Sounds")
@export var grab_sounds : Array[AudioStreamWAV]
@export var drop_sounds : Array[AudioStreamWAV]
@export var throw_sounds : Array[AudioStreamWAV]
var dragging : bool = false
var mouse_pos : Vector2 = Vector2.ZERO
var previous_pos : Vector2 = Vector2.ZERO
var immune_to_pickup : bool = false

signal hover(gnome : Gnome)
signal deselect(gnome : Gnome)

func _ready() -> void:
	scale = Vector2(gnome_size, gnome_size)
	$Sprite2D.texture = sprite

func _process(_delta: float) -> void:
	if !Engine.is_editor_hint():
		#When mouse is released
		if Input.is_action_just_released("mouse_click"):
			#If gnome is being dragged, it "falls to the ground" and is immune to being picked up during the animation
			if dragging:
				dragging = false
				if position.distance_to(previous_pos) < 50:
					$AudioPlayer.stream = drop_sounds[randi_range(0, drop_sounds.size()-1)]
				else:
					$AudioPlayer.stream = throw_sounds[randi_range(0, throw_sounds.size()-1)]
				$AudioPlayer.play()
				var tween = create_tween()
				tween.set_parallel()
				tween.tween_property(self, "scale", Vector2(gnome_size, gnome_size), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
				tween.tween_property(self, "position", position + (position - previous_pos) * 20, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
				immune_to_pickup = true
				await tween.finished
				immune_to_pickup = false
				z_index = 1
					
		#When being dragged, it will follow the mouse
		if dragging:
			var tween = create_tween()
			tween.tween_property(self, "global_position", get_global_mouse_position(), 0.05)
		rotation = clamp((position.x - previous_pos.x)*0.0125, -1, 1)
		previous_pos = position
		
func drag() -> void:
	if !immune_to_pickup and !cant_be_caught:
		var tween = create_tween()
		tween.set_parallel()
		tween.tween_property(self, "position", get_global_mouse_position(), 0.05)
		tween.tween_property(self, "scale", Vector2(gnome_size * 1.5, gnome_size * 1.5), 0.05)
		await tween.finished
		dragging = true
		z_index = 10
		$AudioPlayer.stream = grab_sounds[randi_range(0, grab_sounds.size()-1)]
		$AudioPlayer.play()

func _on_mouse_entered() -> void:
	emit_signal("hover", self)

func _on_mouse_exited() -> void:
	emit_signal("deselect", self)
