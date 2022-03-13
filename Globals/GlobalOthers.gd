extends Node

#class_name GlobalOthers # Useless if single instance

################################################
# DECLARATIONS
################################################

# Use this to deermine whether ShisimaGame filters moves (coming from board) by the operators/players
#or if they are directly connected Board-ShisimaGame
const FILTER_POSSIBLE_MOVES_THROUGH_OPERATORS: bool = false

enum SHISIMA_OPERATOR_TYPES {HUMAN, ENGINE}

enum HUMAN_OPERATOR_CONTROL_SCHEMES {MOUSE_ONLY, KEYBOARD_ONLY, MOUSE_AND_KEYBOARD}

enum POSSIBLE_MOVE_TRIGGERS {ARROW_CLICK, KEY_PRESS} # In future maybe others, say PIECE_DRAG

# This creates labels for PiecePaths and PiecePlaces.
# Good only to display more information for debugging
const SET_TEXT_FOR_LABELS: bool = false

# Used in ButtonWithPopup within InitialMenu
# This is the time required of the mouse being outside the button for the popup to hide
const POPUP_TIMER_TIME: float = 0.5 # Seconds, I presume

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

################################################
# AUTOMATIC EXECUTION
################################################

################################################
# SIGNAL PROCESSING
################################################
