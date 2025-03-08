extends Node

var gnome_array : Array[Gnome] = []

func _ready() -> void:
	for child : Gnome in $GnomeCollection.get_children():
		child.hover.connect(add_gnome)
		child.deselect.connect(remove_gnome)
	for child : Quest in $QuestCollection.get_children():
		child.quest_start.connect(quest_start)
		child.quest_completed.connect(quest_completed)
		
func _process(_delta: float) -> void:
	gnome_drag_and_drop()

func gnome_drag_and_drop() -> void:
	#On click, if there is any gnome in the gnome array
	if Input.is_action_just_pressed("mouse_click") and gnome_array.size() > 0:
		#Get the gnome with the highest y position (the lowest on the screen)
		var gnome : Gnome = gnome_array[0]
		for child in gnome_array:
			if child.position.y > gnome.position.y: gnome = child
		#Set is as being dragged
		gnome_array[gnome_array.find(gnome)].drag()

func add_gnome(gnome : Gnome) -> void:
	gnome_array.append(gnome)

func remove_gnome(gnome : Gnome) -> void:
	gnome_array.erase(gnome)

func gnome_talking(speech : String) -> void:
	$CanvasLayer/UI.display_text(speech)

func quest_start(quest : Quest, pos : Vector2) -> void:
	$Camera.move_to(pos)
	await $Camera.movement_done
	$CanvasLayer/UI.display_text(quest.speech_intro)

func quest_completed(quest : Quest) -> void:
	$CanvasLayer/UI.display_text(quest.speech_outro)
	await $CanvasLayer/UI.text_written
	$QuestEndTimer.start()
	await $QuestEndTimer.timeout
	quest.next_quest.is_active = true
	quest.next_quest.start_quest()
