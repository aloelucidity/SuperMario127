extends State

class_name DiveState

export var divePower: Vector2 = Vector2(1350, 75)

func _startCheck(delta):
	return Input.is_action_just_pressed("dive") and !character.isGrounded() and !character.isWalled()

func _start(delta):
	var divePlayer = character.get_node("DiveSoundPlayer")
	character.velocity.x = character.velocity.x - (character.velocity.x - (divePower.x * character.facingDirection)) / 5
	character.velocity.y += divePower.y
	character.oldFriction = character.friction
	character.rotating = true
	divePlayer.play()

func _update(delta):
	var sprite = character.get_node("AnimatedSprite")
	if (!character.isGrounded()):
		character.friction = character.oldFriction
	if (character.facingDirection == 1):
		sprite.animation = "diveRight"
	else:
		sprite.animation = "diveLeft"
		
func _stop(delta):
	character.setStateByName("Slide", delta)

func _stopCheck(delta):
	return character.isGrounded()
