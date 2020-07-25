extends GameObject

var steely_objects = []
var spawn_timer = 0.0
var cleanout_timer = 0.0

var spawn_interval = 7.5

func _set_properties():
	savable_properties = ["spawn_interval"]
	editable_properties = ["spawn_interval"]
	
func _set_property_values():
	set_property("spawn_interval", spawn_interval, 1)

func _ready():
	cleanout_timer = 10.0
	
func _physics_process(delta):
	if mode != 1:
		spawn_timer -= delta
		if spawn_timer <= 0:
			spawn_timer = spawn_interval
			
			#use the collision shape to query the space state to check for collisions with steelies, if there's any steelies in the way don't spawn a new one
			var shape_query_parameters = Physics2DShapeQueryParameters.new()
			shape_query_parameters.set_shape($CollisionShape2D.shape)
			shape_query_parameters.transform = transform
			shape_query_parameters.collision_layer = 32
			var no_steelies_in_front = get_world_2d().direct_space_state.intersect_shape(shape_query_parameters).empty()
			if no_steelies_in_front: #steely_objects.size() <= 16: this is some old code, was commented out before adding the no_steelies_in_front stuff
				var object = LevelObject.new()
				object.type_id = 37
				object.properties = []
				object.properties.append(global_position)
				object.properties.append(scale)
				object.properties.append(0)
				object.properties.append(true)
				object.properties.append(true)
				get_parent().create_object(object, false)
				steely_objects.append(object)
