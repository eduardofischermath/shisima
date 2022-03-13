extends Node

#class_name GlobalDrawings # Useless if single instance

################################################
# DECLARATIONS
################################################

################################################
# STATELESS METHODS
################################################

# The coordinates will be given based at a center (0,0), which is in the "median" of the arrow
# Parameter vector_giving_direction_of_arrow gives the direction of the arrow
# Dict of dimensions should have: BASE_LENGTH, HALF_BASE_WIDTH, TIP_LENGTH, HALF_TIP_WIDTH
# To facilitate, we have one default in GLOBAL_DIMENSIONS
func get_arrow_shape(
		vector_giving_direction_of_arrow: Vector2,
		dimensions_dict: Dictionary = G_DIMENSIONS.POSSIBLE_MOVE_ARROW_DIMENSIONS) -> PoolVector2Array:
	# To shorten:
	var d_d: Dictionary = dimensions_dict
	# For convenience, let u be the unit parallel vector point to the tip of the arrow
	#and let v be that vector rotated 90 degrees (so it's orthogonal)
	var u: Vector2 = vector_giving_direction_of_arrow.normalized()
	var v: Vector2 = u.rotated(PI / 2)
	var pre_vertices: Array = []
	# We will draw the polygon, going counterclockwise (in mind)
	# Should think parallel points up and orthogonal points right
	# Two points in the base, away from tip
	var half_total_arrow_length: float = 0.5*(d_d.BASE_LENGTH + d_d.TIP_LENGTH)
	# We first draw the four points in the base, starting by one touching the tip
	# Then two in the other side, then another touching the tip
	pre_vertices.append((-half_total_arrow_length+d_d.BASE_LENGTH)*u - d_d.HALF_BASE_WIDTH*v)
	pre_vertices.append(-half_total_arrow_length*u - d_d.HALF_BASE_WIDTH*v)
	pre_vertices.append(-half_total_arrow_length*u + d_d.HALF_BASE_WIDTH*v)
	pre_vertices.append((-half_total_arrow_length + d_d.BASE_LENGTH)*u + d_d.HALF_BASE_WIDTH*v)
	# Now one of the points of the base of the triangle/tip
	pre_vertices.append((-half_total_arrow_length+d_d.BASE_LENGTH)*u + d_d.HALF_TIP_WIDTH*v)
	# Now the tip itself
	pre_vertices.append(half_total_arrow_length*u)
	# Now the other point of the base of the triangle/tip
	pre_vertices.append((-half_total_arrow_length+d_d.BASE_LENGTH)*u - d_d.HALF_TIP_WIDTH*v)
	# Finished. Collect the points into the Polygon2D
	var vertices: PoolVector2Array = PoolVector2Array(pre_vertices)
	return vertices

# dimensions_dict should have CIRCLE_CENTER, OUTER_CIRCLE_RADIUS, THICKNESS, NUMBER_OF_POLYGON_VERTICES
# NUMBER_OF_POLYGON_VERTICES is about approximating the circles for a polygon with that number of sides
# If THICKNESS == OUTER_CIRCLE_RADIUS then we get a solid disk
# If THICKNESS < OUTER_CIRCLE_RADIUS we get a ring with inner radius being
#OUTER_CIRCLE_RADIUS - HALF_THICKNESS
func get_thick_circle_shape(
		dimensions_dict: Dictionary) -> PoolVector2Array:
	var d_d: Dictionary = dimensions_dict # For short
	# Adapt for absence of THICKNESS, also for parameter HALF_THICKNESS
	if not ('THICKNESS' in d_d):
		if 'HALF_THICKNESS' in d_d:
			d_d.THICKNESS = 2 * d_d.HALF_THICKNESS
			d_d.erase('HALF_THICKNESS')
		else:
			d_d.THICKNESS = d_d.OUTER_CIRCLE_RADIUS # Make solid disk
	# Adapt for absence of CIRCLE_CENTER
	if not ('CIRCLE_CENTER' in d_d):
		d_d.CIRCLE_CENTER = Vector2()
	# Default of 64-polygon for approximation
	if not ('NUMBER_OF_POLYGON_VERTICES' in d_d):
		d_d.NUMBER_OF_POLYGON_VERTICES = G_DIMENSIONS.BEST_NUMBER_OF_POLYGONS_FOR_CIRCLE_APPROXIMATION
	var angle_single_step: float = 2 * PI / d_d.NUMBER_OF_POLYGON_VERTICES
	var polygon_vertices: PoolVector2Array
	# Subdivide for cases of solid disk and ring
	if d_d.THICKNESS == d_d.OUTER_CIRCLE_RADIUS:
		# Draw regular polygon with d_d.NUMBER_OF_POLYGON_VERTICES vertices, simulating circle
		var outer_radius_right_vector: Vector2 = Vector2(d_d.OUTER_CIRCLE_RADIUS, 0)
		var pre_outer_points: Array = []
		var temp_outer_vector: Vector2
		var temp_angle: float
		# Need number_of_polygon_vertices points and not 2 * number_of_polygon_vertices + 2
		for idx in range(d_d.NUMBER_OF_POLYGON_VERTICES):
			temp_angle = idx * angle_single_step
			temp_outer_vector = outer_radius_right_vector.rotated(temp_angle)
			pre_outer_points.append(d_d.CIRCLE_CENTER + temp_outer_vector)
		polygon_vertices = PoolVector2Array(pre_outer_points)
	elif (0 < d_d.THICKNESS) and (d_d.THICKNESS < d_d.OUTER_CIRCLE_RADIUS): # Ring
		var inner_circle_radius: float = d_d.OUTER_CIRCLE_RADIUS - d_d.THICKNESS
		var inner_radius_right_vector: Vector2 = Vector2(inner_circle_radius, 0)
		var outer_radius_right_vector: Vector2 = Vector2(d_d.OUTER_CIRCLE_RADIUS, 0)
		# Goal: Generate a polygon with (2 * number_of_polygon_vertices + 2) vertices, then color its inside
		# First complete a circle outside,
		#then head inside going left along positive x-axis,
		#then complete a circle inside in the opposite direction,
		#then close with a last edge going right in positive x-axis from inner to outer circle
		var pre_outer_points: Array = []
		var pre_inner_points: Array = []
		var temp_outer_vector: Vector2
		var temp_inner_vector: Vector2
		var temp_angle: float
		for idx in range(d_d.NUMBER_OF_POLYGON_VERTICES + 1):
			# Without this single pixel nudge the shape doesn't form a closed polygon
			var minimal_nudge: Vector2
			if idx == 0:
				minimal_nudge = Vector2(0,1)
			else:
				minimal_nudge = Vector2(0,0)
			temp_angle = idx * angle_single_step
			temp_outer_vector = outer_radius_right_vector.rotated(temp_angle)
			temp_inner_vector = inner_radius_right_vector.rotated(temp_angle)
			pre_inner_points.append(d_d.CIRCLE_CENTER + temp_inner_vector + minimal_nudge)
			pre_outer_points.append(d_d.CIRCLE_CENTER + temp_outer_vector + minimal_nudge)
		# Need to reverse inner circle to polygon to work
		pre_inner_points.invert()
		var pre_polygon_vertices: Array = pre_inner_points + pre_outer_points
		polygon_vertices = PoolVector2Array(pre_polygon_vertices)
	else:
		G_META.raise_error_message('Cannot have thickness negative, or larger than outer circle radius')
	return polygon_vertices

################################################
# STATEFUL METHODS
################################################

# Builds circle with specified bundary thickness
# (If thickness equals the outer radius, then it draws a filled-in circle)
# Has parameter number_of_polygon_vertices for number of vertices approximating the circle
# Default: use polygon with 64 sides to approximate circle
func draw_thick_circle(
		relevant_node: Node,
		draw_to_new_child_node: bool,
		dimensions_dict: Dictionary,
		color: Color) -> void:
	var polygon_node: Polygon2D # To be drawn on it (the way we want) it needs to be Polygon2D
	if draw_to_new_child_node:
		var new_polygon: Polygon2D = Polygon2D.instance()
		relevant_node.add_child(new_polygon)
		polygon_node = new_polygon
	else:
		polygon_node = relevant_node
	var polygon_vertices: PoolVector2Array = get_thick_circle_shape(dimensions_dict)
	polygon_node.set_polygon(polygon_vertices)
	polygon_node.set_color(color)
	polygon_node.set_antialiased(true)
	polygon_node.update()

################################################
# AUTOMATIC EXECUTION
################################################

################################################
# SIGNAL PROCESSING
################################################
