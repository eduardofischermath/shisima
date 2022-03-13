extends Node

class_name GameAudio

################################################
# DECLARATIONS
################################################

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

# Create AudioPlayerStream (relevant attribute: stream) for each need, when needed

################################################
# AUTOMATIC EXECUTION
################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

################################################
# SIGNAL PROCESSING
################################################

# Responsible to receive audio requests and then figure out
func on_audio_requested(
		request: String) -> void:
	pass
