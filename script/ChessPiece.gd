extends Area2D

func _ready():
	var black_texture = preload("res://assets/gridsquare/black.png")
	var white_texture = preload("res://assets/gridsquare/white.png")
	
	var board_size = min(get_viewport_rect().size.x, get_viewport_rect().size.y)

	var square_size = board_size / 8

	for i in range(0, 64):
		var row = i / 8 
		var col = i % 8  

		var square = self.get_child(i)
		var sprite = square.get_child(1)  # Assumes second child is the Sprite2D
		var collision_shape = square.get_child(0)  # Assumes first child is the CollisionShape2D

		# Set the texture based on the chessboard pattern 
		if (row + col) % 2 == 0:
			sprite.texture = black_texture
		else:
			sprite.texture = white_texture
		
		# Scale the sprite
		sprite.scale = Vector2(1.4, 1.4)

		# Adjust the size of the collision shape using sprite's scale
		var shape = collision_shape.shape
		shape.extents = Vector2(sprite.texture.get_size().x * sprite.scale.x / 2, sprite.texture.get_size().y * sprite.scale.y / 2)
		collision_shape.shape = shape


func _on__mouse_entered():
	pass # Replace with function body.



func _on_options_2d_input_event(viewport, event, shape_idx):
	pass # Replace with function body.


func _on__input_event(viewport, event, shape_idx):
	pass # Replace with function body.
