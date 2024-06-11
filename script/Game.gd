extends Node

var selected_node
var selected_possible_move = []
var selected_piece = ""
var turn = "white"
var promoted_pawn =""

var has_king_moved = false
var has_rook_moved = false

var attackedPieceNumBlack = 0
var attackedPieceNumWhite = 0
var attacked_piece_arr = {}
func getName(letter):
	match letter.to_lower():
		"p":
			return "Pawn"
		"b":
			return "Bishop"
		"q":
			return "Queen"
		"r":
			return "Rook"
		"z":
			return "Knight"
		"k":
			return "King"
		
