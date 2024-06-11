extends Area2D
@onready var chess_board = $"../.."
@onready var label = $"../../Label"
@onready var label_2 = $"../../Label2"
@onready var white_piece = $"../../AttackedPiece/WhitePiece"
@onready var black_piece = $"../../AttackedPiece/BlackPiece"


var removed_black_pieces = []
var removed_white_pieces = []
var global = Game

var attacked_piece_box = preload("res://scene/attacked_piece.tscn") as PackedScene
var attacked_box = attacked_piece_box.instantiate().get_child(0)
@onready var black_attacked_piece = $"../../BlackAttackedPiece"
@onready var white_attacked_piece = $"../../WhiteAttackedPiece"

func _ready():
	global.turn = "white"
	update_turn_label("White's Turn")

func _on_input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if self.get_child_count() != 2:
				if check_possible(self):
					remove_possible_move()
					var to_remove_highlight = get_node('./' + "possible_move")
					var to_remove_piece = global.selected_node.get_child(2)
					self.remove_child(to_remove_highlight)
					if self.get_child_count() == 3:
						var opponent_piece = self.get_child(2)
						#
						var new_sprite = Sprite2D.new()
						print(global.attacked_piece_arr)
						var path = "res://assets/" + opponent_piece.name.substr(0,5) + "/" + global.getName(opponent_piece.name.substr(5,1)) + ".png"
						var new_image = load(path)
						new_sprite.texture = new_image
						new_sprite.name = opponent_piece.name
						if opponent_piece.name.substr(0, 5) == "White":
							new_sprite.position = Vector2(-15,-300 + global.attackedPieceNumWhite)
							white_attacked_piece.scale = Vector2(0.7,0.7)
							white_attacked_piece.add_child(new_sprite)
							global.attackedPieceNumWhite += 70
						else:
							new_sprite.position = Vector2(50,-300 + global.attackedPieceNumBlack)
							black_attacked_piece.scale = Vector2(0.7,0.7)
							black_attacked_piece.add_child(new_sprite)
							global.attackedPieceNumBlack += 70
						self.remove_child(opponent_piece)
					create_sprite(self, global.selected_node)
					global.selected_node.remove_child(to_remove_piece)
					
					# Check for pawn promotion
					var row = int(str(self.name)[0])  # Extract row number from node name
					var piece_type = to_remove_piece.name.substr(5, 1)  # Get the piece type
					if piece_type == "P" and ((global.turn == "black" and row == 1) or (global.turn == "white" and row == 8)):
						const Pawn_promotion = preload("res://scene/promotion_pawn.tscn")
						var Pawn_promotion_instance = Pawn_promotion.instantiate()
						chess_board.add_child(Pawn_promotion_instance)
						global.promoted_pawn = self
					if global.turn == "white":
						global.turn = "black"
						update_turn_label("Black's Turn")

					else:
						global.turn = "white"
						update_turn_label("White's Turn")
				else:
					remove_possible_move()
					possible_move(self, self.get_child(2).name.substr(5, 1))
			else:
				remove_possible_move()
func update_turn_label(text):
	if global.turn == "white":
		if label_2 != null:
			label_2.text = text
			label_2.visible = true  # Show label_2
		if label != null:
			label.visible = false  # Hide label
	else:  # Black's turn
		if label != null:
			label.text = text
			label.visible = true  # Show label
		if label_2 != null:
			label_2.visible = false  # Hide label_2

func render_removed_pieces():
	# Render removed white pieces
	for removed_piece in removed_white_pieces:
		removed_piece.position = Vector2(0, 0)  # Adjust position as needed
		white_piece.add_child(removed_piece)  # Add removed white piece to WhitePiece node

	# Render removed black pieces
	for removed_piece in removed_black_pieces:
		removed_piece.position = Vector2(0, 0)  # Adjust position as needed
		black_piece.add_child(removed_piece)  # Add removed black piece to BlackPiece node


func _on_mouse_entered():
	pass

func remove_possible_move():
	for i in global.selected_possible_move:
		var node = get_node("../" + str(i))
		if node:
			for child in node.get_children():
				if child.name == "possible_move":
					node.remove_child(child)
					child.queue_free()  # Make sure to free the node from memory

func create_sprite(area, piece):
	var full_name = ""
	var color = ""
	
	match piece.get_child(2).name.substr(5, 1):
		"P":
			full_name = "Pawn"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
		"Z":
			full_name = "Knight"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
		"K":
			full_name = "King"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
			var piece_name = piece.name
			if int(str(piece_name))+2 == int(str(area.name)) && global.has_king_moved:
				var change_node_sprite = get_node("../"+str(int(str(area.name))-1))
				var new_sprite = Sprite2D.new()
				var path = "res://assets/" + color + "/" + "Rook" + ".png"
				var new_image = load(path)
				new_sprite.texture = new_image
				new_sprite.position = Vector2(0, 0)
				new_sprite.name = global.selected_piece.substr(0,5)+"R"+"1"
				change_node_sprite.add_child(new_sprite)
				var old_rook_square = get_node("../"+str(int(str(area.name))+1))
				global.has_king_moved=false
				
				if old_rook_square and old_rook_square.get_child_count() == 3:
					var old_rook = old_rook_square.get_child(2)
					old_rook_square.remove_child(old_rook)
			elif int(str(piece_name))-2 == int(str(area.name)) && global.has_king_moved:
				var change_node_sprite = get_node("../"+str(int(str(area.name))+1))
				var new_sprite = Sprite2D.new()
				var path = "res://assets/" + color + "/" + "Rook" + ".png"
				var new_image = load(path)
				new_sprite.texture = new_image
				new_sprite.position = Vector2(0, 0)
				new_sprite.name = global.selected_piece.substr(0,5)+"R"+"1"
				change_node_sprite.add_child(new_sprite)
				var old_rook_square = get_node("../"+str(int(str(area.name))-1))
				global.has_king_moved=false
				
				if old_rook_square and old_rook_square.get_child_count() == 3:
					var old_rook = old_rook_square.get_child(2)
					old_rook_square.remove_child(old_rook)
				
		"B":
			full_name = "Bishop"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
		"R":
			full_name = "Rook"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
		"Q":
			full_name = "Queen"
			color = "White" if piece.get_child(2).name.substr(0, 5) == "White" else "Black"
	var new_sprite = Sprite2D.new()
	var path = "res://assets/" + color + "/" + full_name + ".png"
	var new_image = load(path)
	new_sprite.texture = new_image
	new_sprite.position = Vector2(0, 0)
	new_sprite.name = global.selected_piece
	area.add_child(new_sprite)

func check_possible(area):
	for i in area.get_child_count():
		if area.get_child(i).name == "possible_move":
			return true
	return false

func possible_move(area, piece):
	if global.turn != self.get_child(2).name.substr(0, 5).to_lower():
		return
	remove_possible_move()
	global.selected_node = area
	global.selected_piece = area.get_child(2).name
	var piece_color = area.get_child(2).name.substr(0, 5)
	match piece.to_upper():
		"P":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var initial_row = 2 if piece_color == "White" else 7
			var is_first_move = false
			if piece_color == "White":
				is_first_move = area_index >= initial_row * 10 and area_index < (initial_row + 1) * 10
			else:
				is_first_move = area_index >= initial_row * 10 and area_index < (initial_row + 1) * 10

			var new_area_indices = []
			if piece_color == "White":
				if is_first_move:
					new_area_indices.append(area_index + 20)
				new_area_indices.append(area_index + 10)
				# Add possible attack positions
				if area_index % 10 != 9:  # Ensure it's not on the right edge
					new_area_indices.append(area_index + 11)
				if area_index % 10 != 0:  # Ensure it's not on the left edge
					new_area_indices.append(area_index + 9)
			else:
				if is_first_move:
					new_area_indices.append(area_index - 20)
				new_area_indices.append(area_index - 10)
				# Add possible attack positions
				if area_index % 10 != 9:  # Ensure it's not on the right edge
					new_area_indices.append(area_index - 9)
				if area_index % 10 != 0:  # Ensure it's not on the left edge
					new_area_indices.append(area_index - 11)

			global.selected_possible_move = new_area_indices
			for new_area_index in new_area_indices:
				var new_area_name = str(new_area_index)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node:
					if new_area_index in [area_index + 10, area_index + 20, area_index - 10, area_index - 20]:  # Check for forward moves
						if new_area_node.get_child_count() == 2:  # Ensure the square is empty
							var possible_move = Sprite2D.new()
							var new_image = preload("res://assets/gridsquare/predict.png")
							possible_move.texture = new_image
							possible_move.position = Vector2(0, 0)
							possible_move.name = "possible_move"
							possible_move.z_index = 10
							new_area_node.add_child(possible_move)
					else:  # Check for diagonal attack moves
						if new_area_node.get_child_count() == 3:  # Ensure there's an opponent piece
							if new_area_node.get_child(2).name.substr(0, 5) != piece_color:
								var possible_move = Sprite2D.new()
								var new_image = preload("res://assets/gridsquare/attack.png")
								possible_move.texture = new_image
								possible_move.position = Vector2(0, 0)
								possible_move.name = "possible_move"
								possible_move.z_index = 10
								new_area_node.add_child(possible_move)
					
		"Z":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var knight_moves = [
				area_index - 12, area_index - 21,
				area_index - 8, area_index - 19,
				area_index + 12, area_index + 21,
				area_index + 8, area_index + 19
			]
			global.selected_possible_move = knight_moves
			for new_area_index in knight_moves:
				var new_area_name = str(new_area_index)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node:
					if new_area_node.get_child_count() == 2:  # The square is empty
						var possible_move = Sprite2D.new()
						var new_image = preload("res://assets/gridsquare/predict.png")
						possible_move.texture = new_image
						possible_move.position = Vector2(0, 0)
						possible_move.name = "possible_move"
						new_area_node.add_child(possible_move)
					elif new_area_node.get_child_count() == 3 and new_area_node.get_child(2).name.substr(0, 5) != piece_color:  # Opponent piece is present
						var possible_attack = Sprite2D.new()
						var attack_image = preload("res://assets/gridsquare/attack.png")
						possible_attack.texture = attack_image
						possible_attack.position = Vector2(0, 0)
						possible_attack.name = "possible_move"
						possible_attack.z_index = 10
						new_area_node.add_child(possible_attack)
		"K":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var king_moves = []
			if global.has_king_moved:
				king_moves = [
					area_index - 11, area_index - 10, area_index - 9,
					area_index - 1, area_index + 1,
					area_index + 9, area_index + 10, area_index + 11
				]
			else:
				king_moves = [
					area_index - 11, area_index - 10, area_index - 9,
					area_index - 1, area_index + 1,area_index - 2, area_index + 2,
					area_index + 9, area_index + 10, area_index + 11
				]
			global.selected_possible_move = king_moves
			for new_area_index in king_moves:
				var new_area_name = str(new_area_index)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node and (new_area_node.get_child_count() == 2 or new_area_node.get_child(2).name.substr(0, 5) != piece_color):
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					if new_area_node.get_child_count() == 3 and new_area_node.get_child(2).name.substr(0, 5) != piece_color:
						possible_move.texture = preload("res://assets/gridsquare/attack.png")
					new_area_node.add_child(possible_move)

		"B":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var directions = [-11, -9, 9, 11]
			var possible_moves = []
			for direction in directions:
				var new_area_index = area_index + direction
				while new_area_index >= 0 and new_area_index <= 88:
					var new_area_name = str(new_area_index)
					var new_area_node = get_node("../" + new_area_name)
					if new_area_node:
						if new_area_node.get_child_count() == 2:
							possible_moves.append(new_area_index)
							new_area_index += direction
						elif new_area_node.get_child_count() == 3 and new_area_node.get_child(2).name.substr(0, 5) != piece_color:
							possible_moves.append(new_area_index)
							break
						else:
							break
					else:
						break
			global.selected_possible_move = possible_moves
			for move in possible_moves:
				var new_area_name = str(move)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node:
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					if new_area_node.get_child_count() == 3 and new_area_node.get_child(2).name.substr(0, 5) != piece_color:
						possible_move.texture = preload("res://assets/gridsquare/attack.png")
					new_area_node.add_child(possible_move)
		"Q":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var directions = [-1, 1, -10, 10, -11, -9, 9, 11]
			var possible_moves = []
			for direction in directions:
				var new_area_index = area_index + direction
				while new_area_index >= 0 and new_area_index <= 88:
					var new_area_name = str(new_area_index)
					var new_area_node = get_node("../" + new_area_name)
					if new_area_node:
						if new_area_node.get_child_count() == 2:
							possible_moves.append(new_area_index)
							new_area_index += direction
						elif new_area_node.get_child_count() == 3 and new_area_node.get_child(2).name.substr(0, 5) != piece_color:
							possible_moves.append(new_area_index)
							break
						else:
							break
					else:
						break
			global.selected_possible_move = possible_moves
			for move in possible_moves:
				var new_area_name = str(move)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node:
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					if new_area_node.get_child_count() == 3 and new_area_node.get_child(2).name.substr(0, 5) != piece_color:
						possible_move.texture = preload("res://assets/gridsquare/attack.png")
					new_area_node.add_child(possible_move)

		"R":
			var area_name = str(area.name)
			var area_index = int(area_name)
			var directions = [-1, 1, -10, 10]
			var possible_moves = []
			for direction in directions:
				var new_area_index = area_index + direction
				while new_area_index >= 0 and new_area_index <= 88:
					var new_area_name = str(new_area_index)
					var new_area_node = get_node("../" + new_area_name)
					if new_area_node:
						if new_area_node.get_child_count() == 2:
							possible_moves.append(new_area_index)
							new_area_index += direction
						elif new_area_node.get_child_count() == 3 and new_area_node.get_child(2).name.substr(0, 5) != piece_color:
							possible_moves.append(new_area_index)
							break
						else:
							break
					else:
						break
			global.selected_possible_move = possible_moves
			for move in possible_moves:
				var new_area_name = str(move)
				var new_area_node = get_node("../" + new_area_name)
				if new_area_node:
					var possible_move = Sprite2D.new()
					var new_image = preload("res://assets/gridsquare/predict.png")
					possible_move.texture = new_image
					possible_move.position = Vector2(0, 0)
					possible_move.name = "possible_move"
					if new_area_node.get_child_count() == 3 and new_area_node.get_child(2).name.substr(0, 5) != piece_color:
						possible_move.texture = preload("res://assets/gridsquare/attack.png")
					new_area_node.add_child(possible_move)
