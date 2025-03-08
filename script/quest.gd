extends Node

class_name Quest

@export var is_active : bool = false
@export var draggable_gnomes : Array[Gnome]
@export var goal_gnome : Gnome
@export var next_gnome : Gnome

func _ready() -> void:
	if is_active: $Timer.start()

func _on_timer_timeout() -> void:
	get_parent().quest_start()
