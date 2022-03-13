# Node used to run the Shisima Game
# Needs a Judge (to process the rules of the game) and two GenericPlayers
# This node connects eveything and does the calls

extends Node

#class_name ShisimaGame # Useless if single instance

################################################
# DECLARATIONS
################################################

var BoardScene: PackedScene = G_SCENES.BOARD_SCENE
var JudgeScene: PackedScene = G_SCENES.JUDGE_SCENE
# var GenericOperatorScene: PackedScene = G_SCENES.GENERIC_OPERATOR_SCENE # Unused at the moment
var EngineOperatorScene: PackedScene = G_SCENES.ENGINE_OPERATOR_SCENE
var HumanOperatorScene: PackedScene = G_SCENES.HUMAN_OPERATOR_SCENE

var board: Board # Unique board, so it is made an attribute
var judge: Judge # For Shisima rules

# The players/operators can be human or engine
var operator_1_type: int # Value in G_OTHERS.SHISIMA_OPERATOR_TYPES
var operator_2_type: int
var operator_1: GenericOperator # HumanOperator or EngineOperator
var operator_2: GenericOperator # HumanOperator or EngineOperator

# Keys are the 9 positions, having values P1, P2, EMPTY from G_RULES.PLACE_OCCUPATION
var pieces_in_each_position: Dictionary
var game_state: int # One value of GLOBAL_CONSTANTS.GAME_STATES
var number_of_past_turns: int
var repeated_positions_dict: Dictionary # Used in Judge
var is_game_ongoing setget set_is_game_ongoing, get_is_game_ongoing

# To be sent to main, in future, for sound processing
signal audio_requested(request)

################################################
# STATELESS METHODS
################################################

func set_is_game_ongoing(value):
	# Impossible to set; variable reads game_state instead. Thus this is stateless method
	pass

func get_is_game_ongoing():
	if game_state in [G_RULES.GAME_STATES.P1_TURN, G_RULES.GAME_STATES.P2_TURN]:
		return true
	else:
		return false

################################################
# STATEFUL METHODS
################################################

func activate_and_deactivate_possible_moves_on_board() -> void:
	var possible_moves_to_activate: Array = judge.get_possible_moves_to_activate(
		pieces_in_each_position,
		game_state)
	board.activate_and_deactivate_possible_moves_from_official_names_array(possible_moves_to_activate)

func perform_move(
		move_official_name: String,
		was_move_performed_by_player_1: bool) -> void:
	# All checks done inside Judge. Should raise assertion if not [debug only]
	judge.confirm_move_validity(
		move_official_name,
		pieces_in_each_position,
		was_move_performed_by_player_1,
		game_state)
	# Move the piece using the board
	board.move_piece_from_possible_move_official_name(
		move_official_name)
	# Recompute parameters in ShisimaGame
	number_of_past_turns += 1
	var source_official_name: String = G_RULES.get_source_of_ordered_pair(
			move_official_name)
	var target_official_name: String = G_RULES.get_target_of_ordered_pair(
			move_official_name)
	pieces_in_each_position[source_official_name] = G_RULES.PLACE_OCCUPATION.EMPTY
	if was_move_performed_by_player_1:
		pieces_in_each_position[target_official_name] = G_RULES.PLACE_OCCUPATION.P1
	else:
		pieces_in_each_position[target_official_name] = G_RULES.PLACE_OCCUPATION.P2
	# game_state (and thus is_game_ongoing) can be derived from situation
	# We also update the dict of past repeated positions
	var game_state_and_updated_dict: Array = judge.get_game_state_from_situation_and_updated_repeated_positions_dict(
		pieces_in_each_position,
		repeated_positions_dict,
		was_move_performed_by_player_1)
	game_state = game_state_and_updated_dict[0]
	repeated_positions_dict = game_state_and_updated_dict[1]
	print(pieces_in_each_position)
	prints(game_state, number_of_past_turns)
	# Recompute PossibleMoves, pass info to board [note info on posssible moves is not kept]
	# Note this works just as fine if the game is won by either player or drawn
	activate_and_deactivate_possible_moves_on_board()
	# Here should add code for draw/win using get_is_game_ongoing
	if get_is_game_ongoing():
		pass
	else:
		produce_game_over(game_state)

func produce_game_over(
		game_state: int):
	# Order board to act accordingly (probably an animation)
	board.trigger_actions_after_game_over(game_state)
	# Should invoke buttons for restart and quit, a menu

################################################
# AUTOMATIC EXECUTION
################################################

func _enter_tree() -> void:
	pass

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add Judge, Operators
	judge = JudgeScene.instance()
	add_child(judge)
	if G_OTHERS.FILTER_POSSIBLE_MOVES_THROUGH_OPERATORS:
		if operator_1_type == G_OTHERS.SHISIMA_OPERATOR_TYPES.HUMAN:
			operator_1 = HumanOperatorScene.instance()
		else:
			operator_1 = EngineOperatorScene.instance()
		if operator_2_type == G_OTHERS.SHISIMA_OPERATOR_TYPES.HUMAN:
			operator_2 = HumanOperatorScene.instance()
		else:
			operator_2 = EngineOperatorScene.instance()
		operator_1.judge = judge # Use same instance
		operator_2.judge = judge
		add_child(operator_1)
		add_child(operator_2)
	# Create board, add it as child
	board = BoardScene.instance()
	board.initial_setup()
	add_child(board)
	# Signals might or might not be filtered by operators
	if G_OTHERS.FILTER_POSSIBLE_MOVES_THROUGH_OPERATORS:
		# Sends signals to all [two] players
		# [They send signal to ShisimaGame only if they are the true recipients]
		pass # WRITE
	else:
		board.connect('possible_move_performed_on_board', self, '_on_possible_move_performed_on_board')
	# Set the initial state of the game (in all senses)
	pieces_in_each_position = G_RULES.INITIAL_PIECES_IN_EACH_POSITION
	game_state = G_RULES.INITIAL_GAME_STATE
	number_of_past_turns = G_RULES.INITIAL_NUMBER_OF_PAST_TURNS
	# Now create and place the pieces, sending a command to board
	board.place_record_and_return_all_pieces(pieces_in_each_position)
	# Determine possible moves to activate, sending commands to board
	activate_and_deactivate_possible_moves_on_board()

################################################
# SIGNAL PROCESSING
################################################

# Here we process the possible move! Should read self.game_state to understand command
# possible_move_trigger refers to input/keyboard/mouse
func _on_possible_move_performed_on_board(
		possible_move_official_name: String,
		possible_move_trigger: int) -> void:
	# possible_move_trigger argument ignored as we're not filtering through player
	if game_state == G_RULES.GAME_STATES.P1_TURN:
		perform_move(
			possible_move_official_name,
			true)
	elif game_state == G_RULES.GAME_STATES.P2_TURN:
		perform_move(
			possible_move_official_name,
			false)
	else:
		pass
