extends Node2D

class_name PiecePlace

################################################
# DECLARATIONS
################################################

# Might be useful
var official_name: String

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

func draw_visuals() -> void:
	# Draw circle to Polygon2D Visuals
	var visuals: Polygon2D = $Visuals
	var color: Color = G_COLORS.COLOR_PIECE_PLACE
	var piece_place_dimensions_dict: Dictionary = G_DIMENSIONS.PIECE_PLACE_DIMENSIONS
	G_DRAWINGS.draw_thick_circle(
		visuals,
		false,
		piece_place_dimensions_dict,
		color)

func initial_setup(
		official_name_arg: String,
		position_arg: Vector2) -> void:
	# Position of Node2D is relative to parent [Board]
	official_name = official_name_arg
	position = position_arg
	var label: Label = $Visuals/Label
	if G_OTHERS.SET_TEXT_FOR_LABELS:
		label.set_text(official_name)
	draw_visuals()

################################################
# AUTOMATIC EXECUTION
################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

################################################
# SIGNAL PROCESSING
################################################
