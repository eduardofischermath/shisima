# There should be an instance of this autoloaded as child of every scene
# (Accomplish this using AutoLoad settings)
# In this script we store global constants (which should never change) about the Shisima game
#as well as methods we expect to be useful in many situations

extends Node

#class_name GlobalRules # Useless if single instance

################################################
# DECLARATIONS
################################################

enum PLACE_OCCUPATION {P1, P2, EMPTY}

enum GAME_STATES {P1_TURN, P2_TURN, P1_WIN, P2_WIN, DRAW, OTHER}

const INITIAL_GAME_STATE: int = GAME_STATES.P1_TURN

const INITIAL_NUMBER_OF_PAST_TURNS: int = 0

const THRESHOLD_OF_REPETITIONS_TO_TRIGGER_DRAW: int = 3

const POSITION_REFERENCES: Array = [
	'CC',
	'SS',
	'SW',
	'SE',
	'WW',
	'EE',
	'NW',
	'NE',
	'NN'
]

const INITIAL_PIECES_IN_EACH_POSITION: Dictionary = {
	'CC': PLACE_OCCUPATION.EMPTY,
	'SS': PLACE_OCCUPATION.P1,
	'SW': PLACE_OCCUPATION.P1,
	'SE': PLACE_OCCUPATION.P1,
	'WW': PLACE_OCCUPATION.EMPTY,
	'EE': PLACE_OCCUPATION.EMPTY,
	'NW': PLACE_OCCUPATION.P2,
	'NE': PLACE_OCCUPATION.P2,
	'NN': PLACE_OCCUPATION.P2
}

# There are two PossibleMoves (ordered pair) for each PiecePath (unordered pair)
# It might be a good idea to have canonical names for those relationships
const DIRECTION_OF_ORDERED_WITH_REGARD_TO_UNORDERED: Array = [
	'DIRECT',
	'INVERTED'
]

# By default, pointing away from center
const UNORDERED_PAIRS_OF_POSITION_REFERENCES_INVOLVING_CENTER: Array = [
	'CC_SS',
	'CC_SW',
	'CC_SE',
	'CC_WW',
	'CC_EE',
	'CC_NW',
	'CC_NE',
	'CC_NN'
]

# By default, counter-clockwise
const UNORDERED_PAIRS_OF_POSITION_REFERENCES_NOT_INVOLVING_CENTER: Array = [
	'SW_SS',
	'WW_SW',
	'SS_SE',
	'NW_WW',
	'SE_EE',
	'NN_NW',
	'EE_NE',
	'NE_NN'
]

# By default, pointing away from center or counter-clockwise
const UNORDERED_PAIRS_OF_POSITION_REFERENCES: Array = (
	UNORDERED_PAIRS_OF_POSITION_REFERENCES_NOT_INVOLVING_CENTER +
	UNORDERED_PAIRS_OF_POSITION_REFERENCES_INVOLVING_CENTER
)

const ORDERED_PAIRS_OF_POSITION_REFERENCES_AWAY_FROM_CENTER: Array = [
	'CC->SS',
	'CC->SW',
	'CC->SE',
	'CC->WW',
	'CC->EE',
	'CC->NW',
	'CC->NE',
	'CC->NN'
]

const ORDERED_PAIRS_OF_POSITION_REFERENCES_TOWARD_CENTER: Array = [
	'SS->CC',
	'SW->CC',
	'SE->CC',
	'WW->CC',
	'EE->CC',
	'NW->CC',
	'NE->CC',
	'NN->CC'
]

const ORDERED_PAIRS_OF_POSITION_REFERENCES_COUNTER_CLOCKWISE: Array = [
	'SW->SS',
	'WW->SW',
	'SS->SE',
	'NW->WW',
	'SE->EE',
	'NN->NW',
	'EE->NE',
	'NE->NN'
]

const ORDERED_PAIRS_OF_POSITION_REFERENCES_CLOCKWISE: Array = [
	'SS->SW',
	'SW->WW',
	'SE->SS',
	'WW->NW',
	'EE->SE',
	'NW->NN',
	'NE->EE',
	'NN->NE'
]

const ORDERED_PAIRS_OF_POSITION_REFERENCES: Array = (
	ORDERED_PAIRS_OF_POSITION_REFERENCES_AWAY_FROM_CENTER +
	ORDERED_PAIRS_OF_POSITION_REFERENCES_TOWARD_CENTER +
	ORDERED_PAIRS_OF_POSITION_REFERENCES_COUNTER_CLOCKWISE +
	ORDERED_PAIRS_OF_POSITION_REFERENCES_CLOCKWISE
)

const WINNING_POSITION_WW_EE: Array = ['WW', 'CC', 'EE']
const WINNING_POSITION_SW_NE: Array = ['SW', 'CC', 'NE']
const WINNING_POSITION_SS_NN: Array = ['SS', 'CC', 'NN']
const WINNING_POSITION_SE_NW: Array = ['SE', 'CC', 'NW']

const WINNING_POSITIONS: Array = [
	WINNING_POSITION_WW_EE,
	WINNING_POSITION_SW_NE,
	WINNING_POSITION_SS_NN,
	WINNING_POSITION_SE_NW
]

################################################
# STATELESS METHODS
################################################

func get_source_of_ordered_pair(
		ordered_pair: String) -> String:
	var source: String = ordered_pair.substr(0, 2)
	assert(source in POSITION_REFERENCES, 'Cannot get source of ordered pair')
	return source

func get_target_of_ordered_pair(
		ordered_pair: String) -> String:
	var target: String = ordered_pair.substr(4, 2)
	assert(target in POSITION_REFERENCES, 'Cannot get target of ordered pair')
	return target

# Note below might switch source and target to conform to ordering conventions
func build_unordered_pair_from_source_and_target(
		source: String,
		target: String) -> String:
	var direct_possibility: String = source + '_' + target
	var inverted_possibility: String = target + '_' + source
	if direct_possibility in UNORDERED_PAIRS_OF_POSITION_REFERENCES:
		return direct_possibility
	elif inverted_possibility in UNORDERED_PAIRS_OF_POSITION_REFERENCES:
		return inverted_possibility
	else:
		G_META.raise_error_message('Cannot convert to unordered pair')
		return String() # To avoid complaints

# Uses build_unordered_pair_from_source_and_target, may switch source and target
func build_unordered_pair_from_ordered_pair(
		ordered_pair: String) -> String:
	var current_source: String = get_source_of_ordered_pair(ordered_pair)
	var current_target: String = get_target_of_ordered_pair(ordered_pair)
	return build_unordered_pair_from_source_and_target(
		current_source,
		current_target)

################################################

# Technically no source so return first
func get_source_of_unordered_pair(
		unordered_pair: String) -> String:
	var source: String = unordered_pair.substr(0, 2)
	assert(source in POSITION_REFERENCES, 'Cannot get source of unordered pair')
	return source

# Technically no target so return second
func get_target_of_unordered_pair(
		unordered_pair: String) -> String:
	var target: String = unordered_pair.substr(3, 2)
	assert(target in POSITION_REFERENCES, 'Cannot get target of unordered pair')
	return target

# Build ordered pair from source and target
func build_ordered_pair_from_source_and_target(
		source: String,
		target: String) -> String:
	var ordered_pair: String = source + '->' + target
	assert(ordered_pair in ORDERED_PAIRS_OF_POSITION_REFERENCES, 'Not valid ordered pair')
	return ordered_pair

# Build one ordered pair [direct or inverted] associated to unordered pair
func build_ordered_pair_from_unordered_pair(
		unordered_pair: String,
		direction: String) -> String:
	var current_source: String = get_source_of_unordered_pair(unordered_pair)
	var current_target: String = get_target_of_unordered_pair(unordered_pair)
	var future_source: String
	var future_target: String
	match direction:
		'DIRECT':
			future_source = current_source
			future_target = current_target
		'INVERTED':
			future_source = current_target
			future_target = current_source
		_:
			G_META.raise_error_message('Invalid direction')
	var ordered_pair: String = build_ordered_pair_from_source_and_target(
		future_source,
		future_target)
	return ordered_pair

# Note first is "same" direction as unordered pair, second reverses it
func build_two_ordered_pairs_from_unordered_pair(
		unordered_pair: String) -> Array:
	var direct_ordered: String = build_ordered_pair_from_unordered_pair(
		unordered_pair,
		'DIRECT')
	var inverted_ordered: String = build_ordered_pair_from_unordered_pair(
		unordered_pair,
		'INVERTED')
	return [direct_ordered, inverted_ordered]

################################################
# STATEFUL METHODS
################################################

################################################
# AUTOMATIC EXECUTION
################################################

################################################
# SIGNAL PROCESSING
################################################
