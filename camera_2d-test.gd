extends Camera2D

#Camera speed
@export var camera_speed : int = 1000

func _process(delta: float) -> void:
	var direction : Vector2 = Vector2(0, 0)
	
	if Input.is_action_pressed("left"):
		direction.x -= camera_speed
	if Input.is_action_pressed("right"):
		direction.x += camera_speed
	if Input.is_action_pressed("up"):
		direction.y -= camera_speed
	if Input.is_action_pressed("down"):
		direction.y += camera_speed

	position += direction.normalized() * camera_speed * delta
	
	if Input.is_action_just_pressed("escape"):
		get_tree().quit()
