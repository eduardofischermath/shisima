extends GenericOperator

class_name EngineOperator

################################################
# DECLARATIONS
################################################

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

func engine_operator_initial_setup():
	pass # Can't think of anything

################################################
# AUTOMATIC EXECUTION
################################################

################################################
# SIGNAL PROCESSING
################################################

# For now we have no engines nor the corresponding signal, thus EngineOperator does nothing
func _on_possible_move_returned_by_engine(
		possible_move_official_name) -> void:
	emit_signal(
		'possible_move_performed_by_operator',
		possible_move_official_name,
		official_name)
