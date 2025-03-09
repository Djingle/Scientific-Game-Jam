extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TextureRect/ButtonBack.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_button_jouer_pressed() -> void:
	get_tree().change_scene_to_file("res://test_quest.tscn")


func _on_button_credits_pressed() -> void:
	$TextureRect/ButtonBack.show()
	$TextureRect/ButtonCredits.hide()
	$TextureRect/ButtonJouer.hide()


func _on_button_back_pressed() -> void:
	$TextureRect/ButtonBack.hide()
	$TextureRect/ButtonCredits.show()
	$TextureRect/ButtonJouer.show()
