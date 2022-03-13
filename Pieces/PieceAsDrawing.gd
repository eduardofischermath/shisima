extends Piece

class_name PieceAsDrawing

################################################
# DECLARATIONS
################################################

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

func draw_visuals() -> void:
	# Draws a disc
	var visuals: Polygon2D = $Visuals
	var color: Color
	if is_owned_by_player_1:
		color = G_COLORS.COLOR_PIECE_P1
	else:
		color = G_COLORS.COLOR_PIECE_P2
	var piece_dimensions_dict: Dictionary = G_DIMENSIONS.PIECE_DIMENSIONS
	G_DRAWINGS.draw_thick_circle(
		visuals,
		false,
		piece_dimensions_dict,
		color)

################################################
# AUTOMATIC EXECUTION
################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

################################################
# SIGNAL PROCESSING
################################################
