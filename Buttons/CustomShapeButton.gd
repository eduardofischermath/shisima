# Created to model clickable arrows, but serves more purposes
# They are expected to have any shape (Concave, for example), a detection
#for hovering (optionally changing colors/textures) and for clicking inside

extends Area2D

class_name CustomShapeButton

################################################
# DECLARATIONS
################################################

var polygon_visual: Polygon2D # Does color, provides the appearance
var polygon_clickable: CollisionPolygon2D # Shape which detects mouse actions

# Other object should connect this to target devices
# Maybe we could merge these two to a single signal: "button activated" or something
signal mouse_clicked
signal corresponding_key_pressed

var corresponding_keyboard_key: String
var color_when_hovered: Color
var color_when_inactive: Color
# var color_when_clicked: Color # For now unused

################################################
# STATELESS METHODS
################################################

################################################
# STATEFUL METHODS
################################################

# Arrow will be centered on CustomShapeButton
func initial_setup_from_polygon(
		polygon_vertices: PoolVector2Array,
		color_when_inactive_arg: Color = G_COLORS.COLOR_POSSIBLE_MOVE_ARROW_INACTIVE,
		color_when_hovered_arg: Color = G_COLORS.COLOR_POSSIBLE_MOVE_ARROW_HOVERED) -> void:
	# Record colors in attributes
	color_when_inactive = color_when_inactive_arg
	color_when_hovered = color_when_hovered_arg
	# If it were a ConcavePolygonShape2D it would be set_segments
	polygon_visual = $Polygon2D
	polygon_clickable = $CollisionPolygon2D
	polygon_visual.set_polygon(polygon_vertices) # This should have mouse detection
	polygon_clickable.set_polygon(polygon_vertices) # This is the visual representation
	set_pickable(true) # Should be true either way
	set_collision_layer(1) # Should be 1 either way
	polygon_visual.set_color(color_when_inactive)
	update() # To make the visual part
	# Connect signals
	# mouse_entered and mouse_exited detect entering/exiting of any child subshapes
	connect('mouse_entered', self, '_on_CustomShapeButton_mouse_entered')
	connect('mouse_exited', self, '_on_CustomShapeButton_mouse_exited')
	# To collect all events from the shape (one shape only so we don't need to specify shape_idx)
	connect('input_event', self, '_on_CustomShapeButton_input_event')

func add_label_and_keyboard_input(
		keyboard_key: String) -> void:
	# Relatively complicated, implement later
	pass

func on_being_clicked():
	emit_signal('mouse_clicked')

func on_being_hovered_or_not(
		is_being_hovered: bool) -> void:
	if is_being_hovered:
		polygon_visual.set_color(color_when_hovered)
	else:
		polygon_visual.set_color(color_when_inactive)
	polygon_visual.update()

func test_initial_setup() -> void:
	position = Vector2(300, 300)
	var pre_test_polygon: Array = [Vector2(-100,-100), Vector2(-100,100), Vector2(100,100), Vector2(100,-100)]
	var test_polygon: PoolVector2Array = PoolVector2Array(pre_test_polygon)
	initial_setup_from_polygon(test_polygon)

################################################
# AUTOMATIC EXECUTION
################################################

func _enter_tree():
	#test_initial_setup() For testing
	pass

################################################
# SIGNAL PROCESSING
################################################

func _on_CustomShapeButton_mouse_entered():
	on_being_hovered_or_not(true)

func _on_CustomShapeButton_mouse_exited():
	on_being_hovered_or_not(false)

func _on_CustomShapeButton_input_event(
		viewport: Node,
		event: InputEvent,
		shape_idx: int) -> void:
	if (event is InputEventMouseButton):
		if (event.button_index == BUTTON_LEFT):
			if (event.pressed):
				on_being_clicked()
