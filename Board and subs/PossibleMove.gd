extends Node2D

class_name PossibleMove

################################################
# DECLARATIONS
################################################

var CustomShapeButtonScene: PackedScene = G_SCENES.CUSTOM_SHAPE_BUTTON_SCENE

# Message to be sent with signal the possible move makes when executed
# This is likely the easiest way to transfer information when move is made
var official_name: String

# Only assigned value after add_and_return_arrow_shaped_clickable_button
var clickable_arrow: CustomShapeButton

# All can be determined from a PiecePath parent during setup()
# (Of course, the two PossibleMoves it generates go in opposite directions)
var source_piece_place: PiecePlace
var target_piece_place: PiecePlace
var source_to_target_half_vector: Vector2

# Whether the move is possible at the moment, controlled by ShisimaGame
# [Ther word 'Active' is also used in other contexts in Godot] 
var is_possible_move_active: bool

# To be sent to ShisimaGame for processing (along with official name)
signal possible_move_performed(possible_move_official_name)

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

func set_active():
	is_possible_move_active = true
	set_visible(true)

func set_inactive():
	is_possible_move_active = false
	set_visible(false)

# This returns clickable arrow but the arrow isn't connected to anything yet
func place_and_return_arrow_shaped_clickable_button() -> CustomShapeButton:
	clickable_arrow = CustomShapeButtonScene.instance()
	var dimensions_dict = G_DIMENSIONS.POSSIBLE_MOVE_ARROW_DIMENSIONS
	var arrow_polygon = G_DRAWINGS.get_arrow_shape(
		source_to_target_half_vector,
		dimensions_dict)
	clickable_arrow.initial_setup_from_polygon(
		arrow_polygon,
		G_COLORS.COLOR_POSSIBLE_MOVE_ARROW_INACTIVE,
		G_COLORS.COLOR_POSSIBLE_MOVE_ARROW_HOVERED)
	add_child(clickable_arrow)
	return clickable_arrow

func initial_setup(
		official_name_arg: String,
		source_piece_place_arg: PiecePlace,
		target_piece_place_arg: PiecePlace) -> void:
	official_name = official_name_arg
	source_piece_place = source_piece_place_arg
	target_piece_place = target_piece_place_arg
	set_active()
	position = Vector2() # Child of PiecePath, so position should be (0, 0)
	source_to_target_half_vector = 0.5*(target_piece_place.position - source_piece_place.position)
	clickable_arrow = place_and_return_arrow_shaped_clickable_button()
	clickable_arrow.connect('mouse_clicked', self, '_on_clickable_arrow_mouse_clicked')
	# Signal below never emits, but we leave it connected here for a future implementatiom
	clickable_arrow.connect('corresponding_key_pressed', self, '_on_clickable_arrow_corresponding_key_pressed')
	# During creation PossibleMove should be impossible (and thus "invisible")
	# The controller of possibility of moves should be ShisimaGame

func execute_action_of_possible_move(
		possible_move_trigger: int) -> void:
	# Emit signal, basically, and let ShisimaGame take care of rest (p. ex. visibility)
	emit_signal('possible_move_performed', official_name, possible_move_trigger)

################################################
# AUTOMATIC EXECUTION
################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

################################################
# SIGNAL PROCESSING
################################################

func _on_clickable_arrow_mouse_clicked() -> void:
	var possible_move_trigger: int = G_OTHERS.POSSIBLE_MOVE_TRIGGERS.ARROW_CLICK
	execute_action_of_possible_move(possible_move_trigger)

# Currently signal is connected but never can trigger its emission
func _on_clickable_arrow_corresponding_key_pressed() -> void:
	var possible_move_trigger: int = G_OTHERS.POSSIBLE_MOVE_TRIGGERS.KEY_PRESS
	execute_action_of_possible_move(possible_move_trigger)
