extends CharacterBody2D


const SPEED = 130.0
const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


@onready var animated_sprite = $AnimatedSprite2D
@onready var tile_map = $"../TileMap"
@onready var player = $"."
@onready var ghoul = %Ghoul
@onready var monster = %Monster



func _onready():
	animated_sprite.play("scienceman")



func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	#Get the input direction: 1, 0, -1
	var direction = Input.get_axis("move_left", "move_right")
	
	#Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = true
	elif direction < 0:
		animated_sprite.flip_h = false
		
	#Character Switch
	if Input.is_action_just_pressed("switchchar") and animated_sprite.get_animation() == "scienceman":
		animated_sprite.play("deadman")
		tile_map.set_layer_enabled(1, false)
		tile_map.set_layer_enabled(2, true)
		player.set_collision_layer_value(1, false)
		player.set_collision_layer_value(2, true)
		ghoul.visible = false
		monster.visible = true
	elif Input.is_action_just_pressed("switchchar") and animated_sprite.get_animation() == "deadman":
		animated_sprite.play("scienceman")
		ghoul.visible = true
		monster.visible = false
		player.set_collision_layer_value(2, false)
		player.set_collision_layer_value(1, true)
		tile_map.set_layer_enabled(2, false)
		tile_map.set_layer_enabled(1, true)
	
	if Input.is_action_just_pressed("backspace"):
		get_tree().quit()
	if Input.is_action_just_pressed("r"):
		get_tree().reload_current_scene()
		
		
	#Applying Movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
