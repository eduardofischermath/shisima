# Class inherited by PieceAsBody and PieceAsDrawing
# Should not be instanced

extends Node2D

class_name Piece

################################################
# DECLARATIONS
################################################

var is_owned_by_player_1: bool # Determines color
var current_piece_place_official_name: String # Only name, not the PiecePlace

################################################
# STATELESS METHODS
################################################

# Virtual, different for PieceAsDrawing and PieceAsBody
# Should be executed on those subclasses
func draw_visuals() -> void:
	G_META.raise_error_message('Virtual method, implement on PieceAsBody and PieceAsDrawing')

################################################
# STATEFUL METHODS
################################################

func initial_setup(
		is_owned_by_player_1_arg: bool,
		current_piece_place_official_name_arg: String,
		position_arg: Vector2) -> void:
	is_owned_by_player_1 = is_owned_by_player_1_arg
	current_piece_place_official_name = current_piece_place_official_name_arg
	position = position_arg
	draw_visuals() # Different for PieceAsDrawing and PieceAsBody

################################################
# AUTOMATIC EXECUTION
################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

################################################
# SIGNAL PROCESSING
################################################
