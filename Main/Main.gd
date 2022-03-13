extends Node

#class_name Main # Useless if single instance

################################################
# DECLARATIONS
################################################

var ShisimaGameScene: PackedScene = G_SCENES.SHISIMA_GAME_SCENE
var GameAudioScene: PackedScene = G_SCENES.GAME_AUDIO_SCENE

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

################################################
# AUTOMATIC EXECUTION
################################################

# Called when the node enters the scene tree for the first time.
func _ready():
	$InitialMenu.connect('start_button_pressed', self, 'on_start_button_pressed')
	$InitialMenu.connect('quit_button_pressed', self, 'on_quit_button_pressed')

################################################
# SIGNAL PROCESSING
################################################

func on_start_button_pressed():
	$InitialMenu.set_visible(false)
	var shisima_game: Node = ShisimaGameScene.instance()
	var game_audio: Node = GameAudioScene.instance()
	# Maybe do some pre-tree setup?
	shisima_game.connect('audio_requested', self, '_on_audio_requested')
	add_child(shisima_game)
	add_child(game_audio)

func on_quit_button_pressed():
	get_tree().quit()
