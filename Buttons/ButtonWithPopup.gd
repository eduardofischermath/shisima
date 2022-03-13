extends Button

class_name ButtonWithPopup

var popup_dialog: PopupDialog
var popup_dialog_label: Label
var popup_dialog_timer: Timer
var popup_dialog_timer_wait_time: float
var has_popup_dialog_timer_timed_out: bool

################################################
# DECLARATIONS
################################################

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

func write_text_to_popup_dialog(
		text: String) -> void:
	popup_dialog_label.set_text(text)

# Raise popup on hover, and keep it there for a specific time after mouse leaves area
func raise_popup_on_hover():
	if is_hovered():
		popup_dialog.set_visible(true)
		# Reset timer to initial position
		if not popup_dialog_timer.is_stopped():
			popup_dialog_timer.stop()
		has_popup_dialog_timer_timed_out = false
	else:
		# If visible, triggers processes to hide after some time
		if popup_dialog.is_visible():
			# If timer reached time out, we can hide the popup
			if has_popup_dialog_timer_timed_out:
				popup_dialog.set_visible(false)
			else:
				# In this case we start the timer (if not ongoing)
				if popup_dialog_timer.is_stopped():
					popup_dialog_timer.start()
					assert(not popup_dialog_timer.is_stopped(), 'Timer should be running now')
				else:
					pass

################################################
# AUTOMATIC EXECUTION
################################################

# I think it requires CollisionObject2D for ouse detection

func _enter_tree():
	# Create tree essentially
	popup_dialog = PopupDialog.new()
	add_child(popup_dialog)
	popup_dialog.set_global_position(rect_global_position + rect_size)
	#popup_dialog.anchor_left = 0.8
	#popup_dialog.anchor_right = 1
	#popup_dialog.anchor_top = 0
	#popup_dialog.anchor_bottom = 0.15
	popup_dialog_label = Label.new()
	popup_dialog.add_child(popup_dialog_label)
	popup_dialog_timer = Timer.new() # autostart is false by default
	popup_dialog_timer_wait_time = G_OTHERS.POPUP_TIMER_TIME
	popup_dialog_timer.set_wait_time(popup_dialog_timer_wait_time)
	popup_dialog_timer.set_one_shot(true)
	popup_dialog_timer.connect('timeout', self, '_on_popup_dialog_timer_timeout')
	popup_dialog.add_child(popup_dialog_timer)
	popup_dialog.set_visible(false) # Starts invisible
	# Thus popup_dialog is the old $PopupDialog and
	#popup_dialog_label is the old $PopupDialog/Label and
	#popup_dialog_timer is the old $PopupDialog/Timer

func _ready() -> void:
	# Button cannot be paused
	pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta) -> void:
	raise_popup_on_hover()

################################################
# SIGNAL PROCESSING
################################################

func _on_popup_dialog_timer_timeout():
	has_popup_dialog_timer_timed_out = true
