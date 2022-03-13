extends Node

#class_name GlobalMeta # Useless if single instance

################################################
# DECLARATIONS
################################################

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

func raise_error_message(
		error_message: String) -> void:
	push_error(error_message) # Sends message to STDERR or correspondent
	assert(false, error_message) # Only interrupts in debug mode

################################################
# AUTOMATIC EXECUTION
################################################

################################################
# SIGNAL PROCESSING
################################################
