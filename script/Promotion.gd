extends Area2D

var global = Game

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			var pawn_node = global.promoted_pawn
			var sprite_pawn = pawn_node.get_child(2)
			var piece_color = sprite_pawn.name.substr(0, 5)  # Get the piece color from the sprite name

			var new_texture_path = ""
			match self.name.substr(0, 1):
				"B":
					new_texture_path = "res://assets/" + piece_color + "/Bishop.png"
					
				"Q":
					new_texture_path = "res://assets/" + piece_color + "/Queen.png"
				"Z":
					new_texture_path = "res://assets/" + piece_color + "/Knight.png"
				"R":
					new_texture_path = "res://assets/" + piece_color + "/Rook.png"
			
			if new_texture_path != "":
				sprite_pawn.texture = load(new_texture_path)
				sprite_pawn.name = piece_color+self.name.substr(0, 1)+str(2)
				print(piece_color.capitalize(), "pawn promoted to", self.name.substr(0, 1))

			var promotion_pawn_node = get_parent() 
			if promotion_pawn_node:
				promotion_pawn_node.queue_free()
