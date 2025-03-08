extends Node
class_name Quest

@export var is_active : bool = false
@export var draggable_gnomes : Array[Gnome]
@export var goal_gnome : Gnome
@export var next_gnome : Gnome

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Area2D.position = goal_gnome
	$Sprite2D.hide()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
