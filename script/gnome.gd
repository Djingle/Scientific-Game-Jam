@tool
extends CharacterBody2D

class_name Gnome

@export var gnome_size : float = 1.0
@export var cant_be_caught : bool = false
@export_subgroup("Sprites")
@export var sprite : CompressedTexture2D
@export var sprite_victory : CompressedTexture2D
@export_subgroup("Sounds")
@export var grab_sounds : Array[AudioStreamWAV]
@export var drop_sounds : Array[AudioStreamWAV]
@export var throw_sounds : Array[AudioStreamWAV]
var dragging : bool = false
var mouse_pos : Vector2 = Vector2.ZERO
var previous_pos : Vector2 = Vector2.ZERO
var immune_to_pickup : bool = false
#top, bottom, right, left
var map_limit : Array[int] = [-2970, 2680,4040, -2930]

signal hover(gnome : Gnome)
signal deselect(gnome : Gnome)

func _ready() -> void:
	scale = Vector2(gnome_size, gnome_size)
	$Sprite2D.texture = sprite
	var animation_offset : float = randf_range(0, 3)
	$AnimationPlayer.play("idle")
	$AnimationPlayer.seek(animation_offset)

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
				$AnimationPlayer.stop()
				$AnimationPlayer.play("idle")
				var tween = create_tween()
				tween.set_parallel()
				tween.tween_property(self, "scale", Vector2(gnome_size, gnome_size), 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
				tween.tween_property(self, "position", position + (position - previous_pos) * 20, 1).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
				immune_to_pickup = true
				await tween.finished
				immune_to_pickup = false
				z_index = 0
				position = position.clamp(Vector2(map_limit[0], map_limit[3]), Vector2(map_limit[2], map_limit[1]))
					
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
		$AnimationPlayer.stop()
		$AnimationPlayer.play("Drag")
	else :
		var tween = create_tween()
		tween.tween_property(self, "scale", Vector2(gnome_size, gnome_size * .8), .05)
		tween.tween_property(self, "scale", Vector2(gnome_size, gnome_size), .5).set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		

func _on_mouse_entered() -> void:
	emit_signal("hover", self)

func _on_mouse_exited() -> void:
	emit_signal("deselect", self)
	
func victory():
	$Sprite2D.texture = sprite_victory
	var tween = create_tween()
	tween.tween_property(self, "scale:y", gnome_size * .8, .5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	$AudioPlayer.stream = throw_sounds[randi_range(0, throw_sounds.size()-1)]
	$AudioPlayer.play()
	tween.tween_property(self, "scale:y", gnome_size * 1, 1.5).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_ELASTIC)
