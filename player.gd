extends Area2D
signal pickup
signal hurt
@export var speed = 350
var velocity = Vector2.ZERO
var screensize = Vector2(480,720)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func start():
	#this function resets player for a new game
	set_process(true)
	position = screensize / 2
	$AnimatedSprite2D.animation = "idle"

func die():
	# We call this function when the player dies
	$AnimatedSprite2D.animation = "hurt"
	set_process(false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Get a vector representing the player's input
	# Then move and clamp the position inside the screen
	velocity = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	position += velocity * speed * delta
	position.x = clamp(position.x, 0, screensize.x)
	position.y = clamp(position.y, 0, screensize.y)
	
	#choose which animation to play
	if velocity.length() > 0:
		$AnimatedSprite2D.animation = "run"
	else:
		$AnimatedSprite2D.animation = "idle"
	if velocity.x != 0:
		$AnimatedSprite2D.flip_h = velocity.x < 0

func _on_area_entered(area):
	# When we hit an object, decide what to do
	if area.is_in_group("coins"):
		area.pickup()
		pickup.emit("coin")
	if area.is_in_group("powerups"):
		area.pickup()
		pickup.emit("powerup")
	if area.is_in_group("obstacles"):
		hurt.emit()
		die()
