extends Node2D

class_name Board

################################################
# DECLARATIONS
################################################

# To denote the scenes we need to instance
var PiecePlaceScene: PackedScene = G_SCENES.PIECE_PLACE_SCENE
# In future may reconfigure between Piece/PieceAsBody/PieceAsDrawing
var PieceAsDrawingScene: PackedScene = G_SCENES.PIECE_AS_DRAWING_SCENE
#var PossibleMoveScene: PackedScene = G_SCENES.POSSIBLE_MOVE_SCENE # Unused
var PiecePathScene: PackedScene = G_SCENES.PIECE_PATH_SCENE

# Dict of positions of the 9 piece places
# var positions_dict: Dictionary # Better not use it as attribute
# This info can be derived from piece_places_on_board, and used as variable within methods

# To control the children which are PiecePlaces or PiecePaths
# Use dictionaries to each of such node has a name (unknown to them)
# Syntax: official name is key, value is piece path or piece place
var piece_places_on_board: Dictionary
var piece_paths_on_board: Dictionary

# This one changes every move, and it should always have size 6
# Keys are official names of the current piece place the piece is at
# The value is the piece itself
var pieces_on_board: Dictionary 

# Main dimensions, on which the others depend
var board_center: Vector2 = G_DIMENSIONS.BOARD_CENTER
var board_boundary_half_length: float = G_DIMENSIONS.BOARD_BOUNDARY_HALF_LENGTH

# Secondary dimensions
var octagonal_board_radius: float = G_DIMENSIONS.OCTAGONAL_BOARD_RADIUS
var board_boundary_half_thickness: float = G_DIMENSIONS.BOARD_BOUNDARY_HALF_THICKNESS

var has_been_through_initial_setup: bool = false

# Signal to be sent to ShisimaGame
signal possible_move_performed_on_board(
	possible_move_official_name,
	possible_move_trigger)

################################################
# STATELESS METHODS
################################################

func get_positions_dict_from_parameters(
		octagonal_board_radius_arg) -> Dictionary:
	var arrow_length_radius_pointing_east = Vector2(octagonal_board_radius_arg, 0)
	# We start building the dictionary
	var positions_dict: Dictionary = {}
	var position_references: Array = G_RULES.POSITION_REFERENCES
	for position_reference in position_references:
		# We first set the multiplier
		var multiplier: float
		match position_reference:
			'CC':
				multiplier = 0
			_:
				multiplier = 1
		# Now set the angle
		var angle: float
		match position_reference:
			'CC':
				angle = 0 # This value does not matter due to multiplier being 0
			'SS':
				angle = + PI / 2
			'SW':
				angle = + 3 * PI / 4
			'SE':
				angle = + PI / 4
			'WW':
				angle = + PI
			'EE':
				angle = 0
			'NW':
				angle = - 3 * PI / 4
			'NE':
				angle = - PI / 4
			'NN':
				angle = - PI / 2
			_:
				G_META.raise_error_message('Invalid value for piece place reference')
		# Now add to dictionary, same formula for all
		var computed_position: Vector2 = multiplier * arrow_length_radius_pointing_east.rotated(angle)
		positions_dict[position_reference] = computed_position
	return positions_dict

# OBSOLETE
# Mostly obsolete as the goal is more effectively carried out by place_record_and_return_all_piece_paths()
# Produce a list/array of all 16 possible pairs of positions
#(to clarify, those which give a valid piece path in a Shisima board,
#and each allows two possible piece movements, back and fourth)
func get_all_pairs_of_positions_on_board_from_positions_dict(
		positions_dict_arg: Dictionary,
		pairs_of_position_references: Array = G_RULES.UNORDERED_PAIRS_OF_POSITION_REFERENCES
		) -> Dictionary:
	# Use away from center for the 8 paths involving center
	# For the 8 boudary paths, go counter-clockwise
	var pairs_of_positions_dict: Dictionary = {}
	for pair in pairs_of_position_references:
		var source_reference: String = G_RULES.get_source_of_unordered_pair(pair)
		var source_vector: Vector2 = positions_dict_arg[source_reference]
		var target_reference: String = G_RULES.get_target_of_unordered_pair(pair)
		var target_vector: Vector2 = positions_dict_arg[target_reference]
		pairs_of_positions_dict[pair] = [source_vector, target_vector]
	return pairs_of_positions_dict

func find_corresponding_piece_path_from_official_name(
		piece_path_official_name: String) -> PiecePath:
	var piece_path: PiecePath = piece_paths_on_board[piece_path_official_name]
	return piece_path

func find_corresponding_piece_path_from_piece_places(
		source_piece_place: PiecePlace,
		target_piece_place: PiecePlace) -> PiecePath:
	var source_official_name = source_piece_place.official_name
	var target_official_name = target_piece_place.official_name
	var piece_path_official_name: String = G_RULES.build_unordered_pair_from_source_and_target(
		source_official_name,
		target_official_name)
	var piece_path: PiecePath = find_corresponding_piece_path_from_official_name(
		piece_path_official_name)
	return piece_path

func find_corresponding_piece_path_from_possible_move_official_name(
		possible_move_official_name: String) -> PiecePath:
	var piece_path_official_name: String = G_RULES.build_unordered_pair_from_ordered_pair(
		possible_move_official_name)
	var piece_path: PiecePath = find_corresponding_piece_path_from_official_name(
		piece_path_official_name)
	return piece_path

# Useful since PossibleMove is a child of a PiecePath which is a child of Board
func find_corresponding_possible_move_from_official_name(
		possible_move_official_name: String) -> PossibleMove:
	var piece_path: PiecePath = find_corresponding_piece_path_from_possible_move_official_name(
		possible_move_official_name)
	var possible_move: PossibleMove = piece_path.possible_moves_on_path[possible_move_official_name]
	return possible_move

# Filters through strings
# Only possible after piece places, piece paths and possible moves are placed
func find_corresponding_possible_move_from_piece_places(
		source_piece_place: PiecePlace,
		target_piece_place: PiecePlace) -> PossibleMove:
	var source_official_name = source_piece_place.official_name
	var target_official_name = target_piece_place.official_name
	var possible_move_official_name: String = G_RULES.build_ordered_pair_from_source_and_target(
		source_official_name,
		target_official_name)
	var possible_move: PossibleMove = find_corresponding_possible_move_from_official_name(
		possible_move_official_name)
	return possible_move

################################################
# STATEFUL METHODS
################################################

func place_and_return_piece_place(
		official_name_arg: String,
		position_arg: Vector2) -> PiecePlace:
	var piece_place_scene: PiecePlace = PiecePlaceScene.instance()
	piece_place_scene.initial_setup(
		official_name_arg,
		position_arg)
	add_child(piece_place_scene)
	return piece_place_scene

# Returns a dict with same keys but the values are changed to the PiecePlaces
# Also puts the PiecePlaces as children of the board
# TODO: Optionally, also create groups
func place_record_and_return_all_piece_places(
		positions_dict_arg: Dictionary) -> Dictionary:
	var piece_places_dict: Dictionary = {}
	for key in positions_dict_arg:
		var official_name_arg: String = key
		var position_arg: Vector2 = positions_dict_arg[official_name_arg]
		var piece_place_scene: PiecePlace = place_and_return_piece_place(
			official_name_arg,
			position_arg)
		piece_places_dict[official_name_arg] = piece_place_scene
		# Record to variable piece_places_on_board, raising error if repetitions exist
		if official_name_arg in piece_places_on_board.keys():
			G_META.raise_error_message('Repeated creation of PiecePlace on board')
		else:
			piece_places_on_board[official_name_arg] = piece_place_scene
			#print_debug('Added piece place '+official_name_arg)
	return piece_places_dict

################################################

# Requires the two PiecePlaces to have already been set, since the PiecePath
#refers to them as source_piece_place and target_piece_place
func place_and_return_piece_path(
		official_name_arg: String,
		source_piece_place: PiecePlace,
		target_piece_place: PiecePlace) -> PiecePath:
	var piece_path_scene: PiecePath = PiecePathScene.instance()
	piece_path_scene.initial_setup(
		official_name_arg,
		source_piece_place,
		target_piece_place)
	# Need to connect signal piece_path returns to this
	piece_path_scene.connect('possible_move_performed_on_piece_path', self, '_on_possible_move_performed_on_piece_path')
	add_child(piece_path_scene)
	return piece_path_scene

# Requires all involved PiecePlaces to have already been set
func place_record_and_return_all_piece_paths(
		piece_places_dict: Dictionary,
		piece_path_references: Array = G_RULES.UNORDERED_PAIRS_OF_POSITION_REFERENCES
		) -> Dictionary:
	var piece_paths_dict: Dictionary = {}
	for key in piece_path_references:
		var official_name_arg: String = key
		#print(official_name_arg)
		var source_reference: String = G_RULES.get_source_of_unordered_pair(official_name_arg)
		var target_reference: String = G_RULES.get_target_of_unordered_pair(official_name_arg)
		var source_piece_place: PiecePlace = piece_places_dict[source_reference]
		var target_piece_place: PiecePlace = piece_places_dict[target_reference]
		var piece_path: PiecePath = place_and_return_piece_path(
			official_name_arg,
			source_piece_place,
			target_piece_place)
		piece_paths_dict[official_name_arg] = piece_path
		# Record to variable piece_paths_on_board, raising error if repetitions exist
		if official_name_arg in piece_paths_on_board:
			G_META.raise_error_message('Repeated creation of PiecePath on board')
		else:
			piece_paths_on_board[official_name_arg] = piece_path
	return piece_paths_dict

# This also deletes PossibleMoves as they are children of piece paths
func delete_all_piece_places_and_piece_paths() -> void:
	for key in piece_places_on_board:
		var piece_place: PiecePlace = piece_places_on_board[key]
		# Deleting should also remove it as child, but we do either way
		# This explicit remotion is safer for frame consistency
		remove_child(piece_place)
		piece_place.queue_free()
	piece_places_on_board = {}
	for key in piece_paths_on_board:
		var piece_path: PiecePlace = piece_paths_on_board[key]
		remove_child(piece_path)
		piece_path.queue_free()
	piece_paths_on_board = {}

################################################

# Receives order from activate_and_deactivate_possible_moves
func activate_or_deactivate_possible_move(
		possible_move_official_name: String,
		set_to_active_instead_of_inactive: bool) -> void:
	var possible_move: PossibleMove = find_corresponding_possible_move_from_official_name(
		possible_move_official_name)
	if set_to_active_instead_of_inactive:
		possible_move.set_active()
	else:
		possible_move.set_inactive()

# Receives order from ShisimaGame
# Activate all possible moves in dictionary (via official names), deactivate all others
# Official name strings are the dict keys, the values are booleans, true to activate
func activate_and_deactivate_possible_moves_from_official_names_dict(
		active_possible_moves_dict: Dictionary) -> void:
	var set_to_active_instead_of_inactive: bool
	for possible_move_reference in active_possible_moves_dict:
		set_to_active_instead_of_inactive = active_possible_moves_dict[possible_move_reference]
		activate_or_deactivate_possible_move(
			possible_move_reference,
			set_to_active_instead_of_inactive)

# The array is the subset of possible moves which should be activated
func activate_and_deactivate_possible_moves_from_official_names_array(
		possible_moves_to_activate: Array) -> void:
	var active_possible_moves_dict: Dictionary = {}
	for possible_move_reference in G_RULES.ORDERED_PAIRS_OF_POSITION_REFERENCES:
		if possible_move_reference in possible_moves_to_activate:
			active_possible_moves_dict[possible_move_reference] = true
		else:
			active_possible_moves_dict[possible_move_reference] = false
	activate_and_deactivate_possible_moves_from_official_names_dict(
		active_possible_moves_dict)

################################################

func place_and_return_piece(
		official_name_of_piece_place: String,
		is_piece_owned_by_player_1: bool) -> Piece: # Maybe PieceDrawing, maybe PieceCollision, but Piece nonetheless
	var piece: PieceAsDrawing = PieceAsDrawingScene.instance()
	var position_arg: Vector2 = piece_places_on_board[official_name_of_piece_place].position
	piece.initial_setup(
		is_piece_owned_by_player_1,
		official_name_of_piece_place,
		position_arg)
	add_child(piece)
	return piece

# This should be done only once, and ordered from ShisimaGame parent, not from Board
func place_record_and_return_all_pieces(
		pieces_in_each_position_arg: Dictionary) -> Dictionary:
	var pieces_dict: Dictionary = {}
	var piece: PieceAsDrawing
	var piece_place_official_name: String
	for key in piece_places_on_board:
		var piece_place: PiecePlace = piece_places_on_board[key]
		piece_place_official_name = piece_place.official_name
		assert(key == piece_place_official_name, 'key is the piece place official name')
		match pieces_in_each_position_arg[piece_place_official_name]:
			G_RULES.PLACE_OCCUPATION.P1:
				piece = place_and_return_piece(
					piece_place_official_name,
					true)
				pieces_dict[piece_place_official_name] = piece
			G_RULES.PLACE_OCCUPATION.P2:
				piece = place_and_return_piece(
					piece_place_official_name,
					false)
				pieces_dict[piece_place_official_name] = piece
			G_RULES.PLACE_OCCUPATION.EMPTY:
				pass
	pieces_on_board = pieces_dict
	return pieces_dict

func delete_all_pieces() -> void:
	for key in pieces_on_board:
		var piece: PiecePlace = pieces_on_board[key]
		remove_child(piece)
		piece.queue_free()
	pieces_on_board = {}

################################################

# To be ordered from ShisimaGame, maybe from a method which calls this one
func move_piece_from_piece_places(
		source_piece_place: PiecePlace,
		target_piece_place: PiecePlace) -> void:
	var source_official_name = source_piece_place.official_name
	var target_official_name = target_piece_place.official_name
	var piece_to_move: Piece = pieces_on_board[source_official_name]
	assert(piece_to_move.position == source_piece_place.position, 'Piece not at source position')
	assert(not (target_official_name in pieces_on_board), 'Target piece place not empty')
	piece_to_move.position = target_piece_place.position
	piece_to_move.update() # To ensure redrawing
	# Update the dict pieces_on_board
	pieces_on_board.erase(source_official_name)
	pieces_on_board[target_official_name] = piece_to_move

func move_piece_from_piece_places_official_names(
		source_official_name: String,
		target_official_name: String) -> void:
	var source_piece_place = piece_places_on_board[source_official_name]
	var target_piece_place = piece_places_on_board[target_official_name]
	move_piece_from_piece_places(
		source_piece_place,
		target_piece_place)

func move_piece_from_possible_move(
		possible_move: PossibleMove) -> void:
	var source_piece_place: PiecePlace = possible_move.source_piece_place
	var target_piece_place: PiecePlace = possible_move.target_piece_place
	move_piece_from_piece_places(
		source_piece_place,
		target_piece_place)

func move_piece_from_possible_move_official_name(
		possible_move_official_name: String) -> void:
	var possible_move: PossibleMove = find_corresponding_possible_move_from_official_name(
		possible_move_official_name)
	move_piece_from_possible_move(
		possible_move)

################################################

func trigger_actions_after_game_over(
		game_state: int):
	# game_state has to be one  where the game is concluded
	assert(game_state in [G_RULES.GAME_STATES.P1_WIN, G_RULES.GAME_STATES.P2_WIN, G_RULES.GAME_STATES.DRAW], 'Game over requires compatible game state')
	pass

################################################

# In future move method to GlobalDrawings, this has a lot in common with draw_thick_circle
func draw_board_visuals() -> void:
	# Boundary is Polygon2d, vertices are in a PoolVector2Array attribute named polygon
	# We want an internal and an external rectange, because boundary should be thick
	# This thickness is double as board_boundary_half_thickness
	# We focus first on creating the rectangle which is the middle of the thick rectangle
	#(the outer is exactly board_boundary_half_length)
	var mhl: float = board_boundary_half_length - board_boundary_half_thickness
	var top_left: Vector2 = Vector2(-mhl, -mhl)
	var top_right: Vector2 = Vector2(-mhl, mhl)
	var bottom_right: Vector2 = Vector2(mhl, mhl)
	var bottom_left: Vector2 = Vector2(mhl, -mhl)
	# Set the polygon for Polygon2D which is a PoolVector2Array
	var pre_polygon_open: Array = [
		top_left,
		top_right,
		bottom_right,
		bottom_left
	]
	var pre_polygon_closed: Array = pre_polygon_open + [top_left, top_right] # To round all corners
	var polygon_open: PoolVector2Array = PoolVector2Array(pre_polygon_open)
	var polygon_closed: PoolVector2Array = PoolVector2Array(pre_polygon_closed)
	var visuals: Polygon2D = $Visuals
	var boundary_thick_line: Line2D = $Visuals/BoundaryLines
	visuals.set_polygon(polygon_open)
	visuals.color = G_COLORS.COLOR_BOARD
	# Create coordinates for Line2d
	boundary_thick_line.set_points(polygon_closed)
	boundary_thick_line.set_width(2 * board_boundary_half_thickness)
	boundary_thick_line.set_joint_mode(Line2D.LINE_JOINT_ROUND)
	boundary_thick_line.default_color = G_COLORS.COLOR_BOARD_BOUNDARY
	visuals.update() # Method of all CanvasItems, passes to child Line2d

func initial_setup() -> void:
		# In the future implement real change of parameters
		#board_center_arg: Vector2,
		#board_boundary_half_length_arg: float) -> void:
	#board_center = board_center_arg
	#board_boundary_half_length = board_boundary_half_length_arg
	#pdate_dimensions_from_main_parameters()
	global_position = board_center
	draw_board_visuals()
	# Initialize
	var positions_dict_arg: Dictionary = get_positions_dict_from_parameters(
		octagonal_board_radius)
	piece_places_on_board = {}
	piece_paths_on_board = {}
	place_record_and_return_all_piece_places(positions_dict_arg) # Discard return value
	place_record_and_return_all_piece_paths(piece_places_on_board) # Discard return value
	# Pieces are not created by Board but rather by the ShisimaGame
	# Each PiecePath creates their PossibleMoves but whether they are active or
	#not depends on code on Board which is ordered from ShisimaGame
	has_been_through_initial_setup = true

################################################
# AUTOMATED EXECUTION
################################################

func _enter_tree():
	if not has_been_through_initial_setup:
		initial_setup() # Avoid doing it twice

func _ready():
	pass

################################################
# SIGNAL PROCESSING
################################################

func _on_possible_move_performed_on_piece_path(
		possible_move_official_name: String,
		possible_move_trigger: int) -> void:
	emit_signal(
		'possible_move_performed_on_board',
		possible_move_official_name,
		possible_move_trigger)
