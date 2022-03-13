# This represents one of the two operators/players in a Shisima game
# Inherited by HumanOperator and EngineOperator

extends Node

class_name GenericOperator

################################################
# DECLARATIONS
################################################

var judge: Judge

var official_name: String # P1 or P2, Shisima should keep a record
var embellished_name: String # Deciding...
var display_name: String  # Deciding...

signal possible_move_performed_by_operator(
		possible_move_official_name,
		generic_operator_official_name)

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

# Initial setup for procedures/attributes common to HumanOperator and EngineOperator
func generic_operator_initial_setup(
		official_name_arg: String,
		judge_arg: Node) -> void:
	official_name = official_name_arg
	judge = judge_arg

# Since tehre
# Virtual method
#func initial_setup():
	#G_META.raise_error_message('Virtual method, implement on EngineOperator and HumanOperator')

################################################
# AUTOMATIC EXECUTION
################################################

################################################
# SIGNAL PROCESSING
################################################
