extends Node

#class_name GlobalDimensions # Useless if single instance

################################################
# DECLARATIONS
################################################

# Initially they will all be constants
const BOARD_BOUNDARY_HALF_LENGTH: float = 320.0
const BOARD_CENTER: Vector2 = Vector2(BOARD_BOUNDARY_HALF_LENGTH, BOARD_BOUNDARY_HALF_LENGTH)
const BOARD_BOUNDARY_HALF_THICKNESS: float = 5.0
const OCTAGONAL_BOARD_RADIUS: float = 0.8 * BOARD_BOUNDARY_HALF_LENGTH
const PIECE_PLACE_RADIUS: float = 50.0
const PIECE_PLACE_THICKNESS: float = 10.0
const PIECE_PATH_HALF_THICKNESS: float = 5.0
const PIECE_RADIUS: float = 40.0
const BEST_NUMBER_OF_POLYGONS_FOR_CIRCLE_APPROXIMATION: int = 64

# To draw the arrow, which is a base (a rectangle) and a tip (a triangle)
const POSSIBLE_MOVE_ARROW_DIMENSIONS: Dictionary = {
	'BASE_LENGTH': 50.0,
	'HALF_BASE_WIDTH': 12.5,
	'TIP_LENGTH': 25.0,
	'HALF_TIP_WIDTH': 20.0
}

const PIECE_PLACE_DIMENSIONS: Dictionary = {
	'CIRCLE_CENTER': Vector2(),
	'OUTER_CIRCLE_RADIUS': PIECE_PLACE_RADIUS,
	'THICKNESS': PIECE_PLACE_THICKNESS
}

# Solid, so thickness is omitted
const PIECE_DIMENSIONS: Dictionary = {
	'CIRCLE_CENTER': Vector2(),
	'OUTER_CIRCLE_RADIUS': PIECE_RADIUS
}

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

func update_main_element_dimensions_from_screen_size():
	# Compute (or update) certain lengths depending on screen
	# Idea: 4 panels. One board, one top panel, one left and right for each player
	var screen_size = OS.get_screen_size()
	if screen_size.x > 1.0 * screen_size.y:
		# This is for the "horizontal displays"
		# Game info to the sides of the board
		# Top row the top panel, then the left panel, board, right panel
		#BOARD_CENTER = Vector2(0.5 * screen_size.x, 0.525 * screen_size.y)
		#BOARD_BOUNDARY_HALF_LENGTH = (1 - BOARD_CENTER.y) * screen_size.y
		pass
	else:
		# This is for the "vertical displays"
		# Top row is top panel
		# Then row with only the board
		# Then row with left and right panels
		#BOARD_CENTER = Vector2(0.5 * screen_size.x, screen_size.y - 0.5 * screen_size.x)
		#BOARD_BOUNDARY_HALF_LENGTH = 0.45 * screen_size.x
		pass
	# emit_signal("board_dimensions_updated") UNCOMMENT AT THE RIGHT TIME

func update_secondary_dimensions_from_main_ones() -> void:
	# In the future implement real change of parameters
	#octagonal_board_radius = (0.86) * board_boundary_half_length
	#piece_place_radius = (0.05) * board_boundary_half_length
	#piece_radius = (0.04) * board_boundary_half_length
	#positions_dict = get_positions_dict_from_parameters(board_center, octagonal_board_radius)
	pass
	#board_center = G_DIMENSIONS.BOARD_CENTER
	#position = board_center # This is important for children nodes
	#board_boundary_half_length = G_DIMENSIONS.BOARD_BOUNDARY_HALF_LENGTH
	#board_boundary_half_thickness = G_DIMENSIONS.BOARD_BOUNDARY_HALF_THICKNESS
	#octagonal_board_radius = G_DIMENSIONS.OCTAGONAL_BOARD_RADIUS
	#piece_place_radius = G_DIMENSIONS.PIECE_PLACE_RADIUS
	#piece_radius = G_DIMENSIONS.PIECE_RADIUS
	#positions_dict = get_positions_dict_from_parameters(octagonal_board_radius)

################################################
# AUTOMATIC EXECUTION
################################################

################################################
# SIGNAL PROCESSING
################################################
