extends Node

class_name Quest

signal quest_start(quest : Quest, pos : Vector2)
signal quest_completed(quest : Quest)

@export_group("Text")
@export_multiline var speech_intro : String = ""
@export_multiline var speech_outro : String = ""
@export_group("Gnomes")
@export var quest_gnome : Gnome
@export var draggable_gnomes : Array[Gnome]
@export var goal_gnome : Gnome
@export_group("Quest")
@export var is_active : bool = false
@export var next_quest : Quest

func _ready() -> void:
	if is_active: $Timer.start()

func _process(_delta: float) -> void:
	var succeded : bool = true
	for gnome in draggable_gnomes:
		if gnome.global_position.distance_to(goal_gnome.global_position) > 100 or gnome.immune_to_pickup or gnome.dragging:
			succeded = false
	if succeded and is_active: 
		emit_signal("quest_completed", self)
		quest_gnome.victory()
		is_active = false

func start_quest() -> void:
	emit_signal("quest_start", self, quest_gnome.global_position)
