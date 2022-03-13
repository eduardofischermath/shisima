extends GenericHUD

################################################
# DECLARATIONS
################################################

signal start_button_pressed
signal quit_button_pressed

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

func create_popup_messages():
	var rules_button: ButtonWithPopup = $MainMenuContainer/RulesButton
	var options_button: ButtonWithPopup = $MainMenuContainer/OptionsButton
	rules_button.write_text_to_popup_dialog(
		'(No rules!)'
	)
	options_button.write_text_to_popup_dialog(
		'(No options!)'
	)

################################################
# AUTOMATIC EXECUTION
################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	create_popup_messages()

################################################
# SIGNAL PROCESSING
################################################

func _on_StartButton_pressed():
	# Send it up to InitialMenu
	emit_signal('start_button_pressed')

func _on_QuitButton_pressed():
	emit_signal('quit_button_pressed')




func _on_OptionstButton_pressed():
	pass # Replace with function body.


func _on_RulesButton_pressed():
	pass # Replace with function body.
