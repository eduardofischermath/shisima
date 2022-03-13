extends Node2D

class_name PiecePath

################################################
# DECLARATIONS
################################################

var PossibleMoveScene: PackedScene = G_SCENES.POSSIBLE_MOVE_SCENE

# We expect a PiecePath to have two associated PiecePlaces, start and end
# (or source and target, name keeps changing)
# (Always away from center and counter-clockwise)
# They should be computed on _init (by whatever note creates this)
var source_piece_place: PiecePlace
var target_piece_place: PiecePlace

# Convenient vector (difference thus independs of frame)
var source_to_target_half_vector: Vector2

# To store the two asssociated PossibleMoves
# Keys in GLOBAL_CONSTANTS.DIRECTION_OF_ORDERED_WITH_REGARD_TO_UNORDERED
var possible_moves_on_path: Dictionary

# Might be useful
var official_name: String

# Maybe useful, maybe useless
#onready var visuals: Line2D = $Visuals

signal possible_move_performed_on_piece_path(
	possible_move_official_name,
	possible_move_trigger)

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

# Cannot accomplish this with _init, _enter_tree or _ready
func initial_setup(
		official_name_arg: String,
		source_piece_place_arg: PiecePlace,
		target_piece_place_arg: PiecePlace) -> void:
	# Undecided on syntax which makes the most sense.
	# Should p. ex., use source_piece_place to mean self.source_piece_place?
	official_name = official_name_arg
	source_piece_place = source_piece_place_arg
	target_piece_place = target_piece_place_arg
	position = 0.5*(source_piece_place.position + target_piece_place.position)
	source_to_target_half_vector = 0.5*(target_piece_place.position - source_piece_place.position)
	draw_visuals()
	place_record_and_return_all_possible_moves()

func draw_visuals() -> void:
	var rectangle: Line2D = $Visuals
	var label: Label = $Visuals/Label
	rectangle.default_color = G_COLORS.COLOR_PIECE_PATH
	# Shiringking factor to not overlap with piece places
	var shrinking_factor: float = (source_to_target_half_vector.length() - G_DIMENSIONS.PIECE_PLACE_RADIUS)/source_to_target_half_vector.length()
	var source_position: Vector2 = - shrinking_factor*source_to_target_half_vector # Relative to midpoint
	var target_position: Vector2 = + shrinking_factor*source_to_target_half_vector # Relative to midpoint
	var pre_line_array: Array = [
		source_position,
		target_position
	]
	var line_array: PoolVector2Array = PoolVector2Array(pre_line_array)
	rectangle.set_points(line_array)
	rectangle.set_width(2 * G_DIMENSIONS.PIECE_PATH_HALF_THICKNESS)
	if G_OTHERS.SET_TEXT_FOR_LABELS:
		label.set_text(official_name)
	rectangle.update()

func place_and_return_possible_move(
		direction: String) -> PossibleMove:
	var source_piece_place_arg: PiecePlace
	var target_piece_place_arg: PiecePlace
	match direction:
		'DIRECT':
			# For brevity omit self in self.source_piece_place
			source_piece_place_arg = source_piece_place
			target_piece_place_arg = target_piece_place
		'INVERTED':
			source_piece_place_arg = target_piece_place
			target_piece_place_arg = source_piece_place
		_:
			G_META.raise_error_message('Invalid direction')
	var official_name_arg: String = G_RULES.build_ordered_pair_from_unordered_pair(
		official_name, # Meaning self.official_name
		direction)
	var possible_move_scene: PossibleMove = PossibleMoveScene.instance()
	possible_move_scene.initial_setup(
		official_name_arg,
		source_piece_place_arg,
		target_piece_place_arg)
	# Need to connect signal emitted by possible_move to this
	possible_move_scene.connect('possible_move_performed', self, '_on_possible_move_performed')
	add_child(possible_move_scene)
	return possible_move_scene

# Creates two PossibleMoves, add as children, return them
func place_record_and_return_all_possible_moves() -> Dictionary:
	var possible_moves_dict: Dictionary = {}
	for direction in G_RULES.DIRECTION_OF_ORDERED_WITH_REGARD_TO_UNORDERED:
		var possible_move: PossibleMove = place_and_return_possible_move(direction)
		# Record
		possible_moves_on_path[possible_move.official_name] = possible_move
		# Return
		possible_moves_dict[possible_move.official_name] = possible_move
	return possible_moves_dict

################################################
# AUTOMATIC EXECUTION
################################################

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

################################################
# SIGNAL PROCESSING
################################################

func _on_possible_move_performed(
		possible_move_official_name: String,
		possible_move_trigger: int) -> void:
	emit_signal(
		'possible_move_performed_on_piece_path',
		possible_move_official_name,
		possible_move_trigger)
