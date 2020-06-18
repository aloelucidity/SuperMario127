extends GameObject

onready var animated_sprite = $AnimatedSprite
onready var sound = $AudioStreamPlayer
onready var area = $Area2D
onready var visibility_enabler = $VisibilityEnabler2D
onready var ground_detector = $GroundDetector
onready var ceiling_detector = $CeilingDetector
onready var wall_detector = $WallDetector

var collected = false
var physics = false
var destroy_timer = 0.0
var despawn_timer = 0.0
var gravity : float
var velocity : Vector2

export var anim_damp = 80

func _set_properties():
	savable_properties = ["physics", "velocity"]
	editable_properties = ["physics", "velocity"]
	
func _set_property_values():
	set_property("physics", physics, true)
	set_property("velocity", velocity, true)

func collect(body):
	if enabled and !collected and body.name.begins_with("Character") and !body.dead:
		CurrentLevelData.level_data.vars.coins_collected += 1
		body.heal()
		var player_id = 1
		if body.name == "Character":
			player_id = 0
		if PlayerSettings.other_player_id == -1 or PlayerSettings.my_player_index == player_id:
			sound.play()
		collected = true
		animated_sprite.animation = "collect"
		animated_sprite.frame = 0
		destroy_timer = 2
		
func _ready():
	if physics:
		despawn_timer = 10.0
		gravity = CurrentLevelData.level_data.areas[CurrentLevelData.area].settings.gravity
		ground_detector.enabled = true
		wall_detector.enabled = true
		ceiling_detector.enabled = true
	var _connect = area.connect("body_entered", self, "collect")

func _process(delta):
	if destroy_timer > 0:
		destroy_timer -= delta
		if destroy_timer <= 0:
			destroy_timer = 0
			queue_free()
	if despawn_timer > 0:
		despawn_timer -= delta
		if despawn_timer <= 1:
			visible = !visible
		if despawn_timer <= 0:
			if !sound.playing:
				despawn_timer = 0
				queue_free()
			else:
				despawn_timer = 0.3
	if !collected:
		animated_sprite.frame = (OS.get_ticks_msec() / anim_damp) % 4

func _physics_process(delta):
	if physics and mode != 1:
		velocity.y += gravity
		position += velocity * delta
		var x_cast = 1
		if velocity.x <= 0:
			x_cast = -1
		wall_detector.cast_to = Vector2(x_cast, 0)
		if ground_detector.is_colliding() and velocity.y > 0:
			velocity.x = lerp(velocity.x, 0, delta)
			velocity.y = 0
			position.y = ground_detector.get_collision_point().y - 10
			
		if ceiling_detector.is_colliding():
			velocity.y = 30
			position.y += 2
			
		if wall_detector.is_colliding():
			velocity.x = 0
			position.x = wall_detector.get_collision_point().x - (5*x_cast)
