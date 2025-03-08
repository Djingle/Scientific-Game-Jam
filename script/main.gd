extends Node

var gnome_array : Array[Gnome] = []

func _ready() -> void:
	for child : Gnome in $GnomeCollection.get_children():
		child.hover.connect(add_gnome)
		child.deselect.connect(remove_gnome)
		child.talk.connect(gnome_talking)

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
		gnome_array[gnome_array.find(gnome)].click()

func add_gnome(gnome : Gnome) -> void:
	gnome_array.append(gnome)

func remove_gnome(gnome : Gnome) -> void:
	gnome_array.erase(gnome)

func gnome_talking(speech : String):
	$CanvasLayer/UI.display_text(speech)
