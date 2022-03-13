extends GenericOperator

class_name HumanOperator

################################################
# DECLARATIONS
################################################

var control_scheme: int # mouse, keyboard or both

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

func human_operator_initial_setup(
		control_scheme_arg: int) -> void:
	control_scheme = control_scheme_arg
	# Depending on control scheme some things should be changed...

################################################
# AUTOMATIC EXECUTION
################################################

################################################
# SIGNAL PROCESSING
################################################

# Note only HumanOperator (and not EngineOperator) can receive and process move from board
# The connection must be done by ShisimaGame
func _on_possible_move_performed_on_board(
		possible_move_official_name: String) -> void:
	# Official name (P1 or P2) is enough for ShisimaGame, the receptor of
	#possible_move_performed_by_operator, understand which entity sent it
	emit_signal(
		'possible_move_performed_by_operator',
		possible_move_official_name,
		official_name)
