extends Node

class_name Judge

################################################
# DECLARATIONS
################################################

################################################
# STATELESS METHODS
################################################

# Given position and player to move, give possible moves
func get_possible_moves_to_activate(
		pieces_in_each_position: Dictionary,
		game_state: int) -> Array:
	var array_of_moves_to_activate: Array = []
	var desired_place_occupation: int
	var game_state_allows_possible_moves: bool
	if game_state == G_RULES.GAME_STATES.P1_TURN:
		desired_place_occupation = G_RULES.PLACE_OCCUPATION.P1
		game_state_allows_possible_moves = true
	elif game_state == G_RULES.GAME_STATES.P2_TURN:
		desired_place_occupation = G_RULES.PLACE_OCCUPATION.P2
		game_state_allows_possible_moves = true
	else:
		game_state_allows_possible_moves = false # Will, at the end, return empty array
	if game_state_allows_possible_moves:
		var source_reference: String
		var target_reference: String
		for possible_move_reference in G_RULES.ORDERED_PAIRS_OF_POSITION_REFERENCES:
			source_reference = G_RULES.get_source_of_ordered_pair(possible_move_reference)
			target_reference = G_RULES.get_target_of_ordered_pair(possible_move_reference)
			if pieces_in_each_position[source_reference] == desired_place_occupation:
				if pieces_in_each_position[target_reference] == G_RULES.PLACE_OCCUPATION.EMPTY:
					array_of_moves_to_activate.append(possible_move_reference)
	return array_of_moves_to_activate

# Determines whether move is valid or not (given move as string and the position before move)
# In debug mode, raises assertions with the errors
func confirm_move_validity(
		move_official_name: String,
		position_right_before_move: Dictionary,
		was_move_performed_by_player_1: bool,
		game_state_before_move: int) -> void:
	var source_official_name: String = G_RULES.get_source_of_ordered_pair(
			move_official_name)
	var target_official_name: String = G_RULES.get_target_of_ordered_pair(
			move_official_name)
	if was_move_performed_by_player_1:
		assert(game_state_before_move == G_RULES.GAME_STATES.P1_TURN,
			'Only Player 1 can act on its turn')
		assert(position_right_before_move[source_official_name] == G_RULES.PLACE_OCCUPATION.P1,
			'Source must have have piece')
		assert(position_right_before_move[target_official_name] == G_RULES.PLACE_OCCUPATION.EMPTY,
			'Target piece place must be empty')
	else:
		assert(game_state_before_move == G_RULES.GAME_STATES.P2_TURN,
			'Only Player 2 can act on its turn')
		assert(position_right_before_move[source_official_name] == G_RULES.PLACE_OCCUPATION.P2,
			'Source piece placer must have have piece')
		assert(position_right_before_move[target_official_name] == G_RULES.PLACE_OCCUPATION.EMPTY,
			'Target piece place must be empty')

# To determine repetition of positions. Simplifies the dictionary into a 9-char string
func codify_dict_of_positions_into_string(
		pieces_in_each_position: Dictionary) -> String:
	var hash_string: String = ''
	for position_reference in G_RULES.POSITION_REFERENCES:
		match pieces_in_each_position[position_reference]:
			G_RULES.PLACE_OCCUPATION.P1:
				hash_string = hash_string + '1'
			G_RULES.PLACE_OCCUPATION.P2:
				hash_string = hash_string + '2'
			G_RULES.PLACE_OCCUPATION.EMPTY:
				hash_string = hash_string + 'E'
	return hash_string

# Receives a new position, determines if repeats enough for draw.
# Also updates dict_of_all_past_hash_strings with the new position
# dict_of_all_past_hash_strings keeps as keys the possible hash strings
# The value associated to them is the number of times they have been repeated
func get_draw_determination_and_updated_repeated_positions_dict(
		pieces_in_each_position: Dictionary,
		dict_of_all_past_hash_strings: Dictionary,
		number_of_repetitions_to_trigger_draw: int) -> Array: # Array of dict, bool
	# Start by updating the dict
	var hash_string_of_position: String = codify_dict_of_positions_into_string(
			pieces_in_each_position)
	if hash_string_of_position in dict_of_all_past_hash_strings:
		dict_of_all_past_hash_strings[pieces_in_each_position] += 1
	else:
		dict_of_all_past_hash_strings[pieces_in_each_position] = 1
	# If the threshold for a draw is 0, there are no draws
	# If the threshold for a draw is 1, any move is drawn [if it does not win]
	# The following code takes care of these two special situations just as well
	var was_draw_threshold_just_met: bool
	if dict_of_all_past_hash_strings[pieces_in_each_position] == number_of_repetitions_to_trigger_draw:
		was_draw_threshold_just_met = true
	else:
		was_draw_threshold_just_met = false
	# Put everything together and return dict and bool
	var whether_draw_threshold_just_met_and_updated_dict: Array = [
		was_draw_threshold_just_met,
		dict_of_all_past_hash_strings]
	return whether_draw_threshold_just_met_and_updated_dict

# Determines whether selected player has won (to be run after its move)
# [Returns false if the opposite player has won]
func detect_victory_of_player(
		pieces_in_each_position: Dictionary,
		does_it_concern_victor_of_player_1: bool) -> bool:
	var winning_positions_array: Array = G_RULES.WINNING_POSITIONS
	var player_guaranteed_to_not_win_with_current_winning_position: bool
	var player_victory_for_at_least_one_winning_position: bool = false
	var desired_place_occupation: int
	if does_it_concern_victor_of_player_1:
		desired_place_occupation = G_RULES.PLACE_OCCUPATION.P1
	else:
		desired_place_occupation = G_RULES.PLACE_OCCUPATION.P2
	for winning_position in winning_positions_array:
		# If vicory found, does not need to keep checking
		if player_victory_for_at_least_one_winning_position:
			break
		player_guaranteed_to_not_win_with_current_winning_position = false
		# Each position_reference is another Array, with 3 position references
		for position_reference in winning_position:
			if pieces_in_each_position[position_reference] == desired_place_occupation:
				pass
			else:
				player_guaranteed_to_not_win_with_current_winning_position = true
			if player_guaranteed_to_not_win_with_current_winning_position:
				break
		# Now, for possible winning position, if there was a break, then it is not victory
		# Otherwise, if this was reached without a break, then there is
		if player_guaranteed_to_not_win_with_current_winning_position:
			player_victory_for_at_least_one_winning_position = false
		else:
			player_victory_for_at_least_one_winning_position = true
	return player_victory_for_at_least_one_winning_position

# Return array with game state and uptated dict (in this order)
func get_game_state_from_situation_and_updated_repeated_positions_dict(
		pieces_in_each_position: Dictionary,
		repeated_positions_dict: Dictionary,
		was_move_performed_by_player_1: bool,
		number_of_repetitions_to_trigger_draw: int = G_OPTIONS.THRESHOLD_OF_REPETITIONS_TO_TRIGGER_DRAW) -> Array:
	# Collect information on position related to the rules and the past positions
	var was_the_move_victorius: bool = detect_victory_of_player(
		pieces_in_each_position,
		was_move_performed_by_player_1)
	var whether_draw_threshold_just_met_and_updated_dict: Array = get_draw_determination_and_updated_repeated_positions_dict(
		pieces_in_each_position,
		repeated_positions_dict,
		number_of_repetitions_to_trigger_draw)
	var was_draw_threshold_just_met = whether_draw_threshold_just_met_and_updated_dict[0]
	var updated_repeated_positions_dict = whether_draw_threshold_just_met_and_updated_dict[1]
	# Determine game state after move [move not directly specified, only the position it generated]
	# First detects victory, then detects draw. If nothing detected, it's the other player's turn
	var new_game_state: int
	if was_the_move_victorius:
		if was_move_performed_by_player_1:
			new_game_state = G_RULES.GAME_STATES.P1_WIN
		else:
			new_game_state = G_RULES.GAME_STATES.P2_WIN
	elif was_draw_threshold_just_met:
		new_game_state = G_RULES.GAME_STATES.DRAW
	else:
		if was_move_performed_by_player_1:
			new_game_state = G_RULES.GAME_STATES.P2_TURN
		else:
			new_game_state = G_RULES.GAME_STATES.P1_TURN
	var game_state_and_updated_dict: Array = [
		new_game_state,
		updated_repeated_positions_dict]
	return game_state_and_updated_dict

################################################
# STATEFUL METHODS
################################################

################################################
# AUTOMATIC EXECUTION
################################################

################################################
# SIGNAL PROCESSING
################################################
