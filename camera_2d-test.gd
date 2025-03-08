extends Camera2D

#Camera speed
@export var camera_speed : int = 1000

func _process(delta: float) -> void:
	var direction : Vector2 = Vector2(0, 0)
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= camera_speed
	if Input.is_action_pressed("ui_right"):
		direction.x += camera_speed
	if Input.is_action_pressed("ui_up"):
		direction.y -= camera_speed
	if Input.is_action_pressed("ui_down"):
		direction.y += camera_speed

	position += direction.normalized() * camera_speed * delta
