# Records names for each possible scene for easier calling
# If this becomes too heavyu on initialization. change preload() to load()

extends Node

#class_name GlobalScenes # Useless if single instance

################################################
# DECLARATIONS
################################################

# In each paragraph block, the classes must be called in order (top-bottom),
#and only from a scene below them

const BUTTON_WITH_POPUP_SCENE: PackedScene = preload('res://Buttons/ButtonWithPopup.tscn')
const CUSTOM_SHAPE_BUTTON_SCENE: PackedScene = preload('res://Buttons/CustomShapeButton.tscn')

const PIECE_PLACE_SCENE: PackedScene = preload('res://Board and subs/PiecePlace.tscn')
const PIECE_SCENE: PackedScene = preload('res://Pieces/Piece.tscn')
const PIECE_AS_BODY_SCENE: PackedScene = preload('res://Pieces/PieceAsBody.tscn')
const PIECE_AS_DRAWING_SCENE: PackedScene = preload('res://Pieces/PieceAsDrawing.tscn')
const POSSIBLE_MOVE_SCENE: PackedScene = preload('res://Board and subs/PossibleMove.tscn')
const PIECE_PATH_SCENE: PackedScene = preload('res://Board and subs/PiecePath.tscn')
const BOARD_SCENE: PackedScene = preload('res://Board and subs/Board.tscn')

const GAME_AUDIO_SCENE: PackedScene = preload('res://Audio/GameAudio.tscn')

const JUDGE_SCENE: PackedScene = preload('res://Game logic/Judge.tscn')
# Operators have access to Judge (which has rules)
# Judge only sees the moves and other information 
# I might see at most the official name [a string] of the operator, not the Operator itself
const GENERIC_OPERATOR_SCENE: PackedScene = preload('res://Operators/GenericOperator.tscn')
const ENGINE_OPERATOR_SCENE: PackedScene = preload('res://Operators/EngineOperator.tscn')
const HUMAN_OPERATOR_SCENE: PackedScene = preload('res://Operators/HumanOperator.tscn')

const SHISIMA_GAME_SCENE: PackedScene = preload('res://Game logic/ShisimaGame.tscn')


################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

################################################
# AUTOMATIC EXECUTION
################################################

################################################
# SIGNAL PROCESSING
################################################
