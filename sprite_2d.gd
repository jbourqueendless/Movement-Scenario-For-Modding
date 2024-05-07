extends Sprite2D

var max_speed := 600.0
var velocity := Vector2(0, 0)
var steering_factor := 10.0
var boost_speed := 1500.0
var normal_speed = 600

func _on_timer_timeout() -> void:
	max_speed = normal_speed
	

func _process(delta: float) -> void:
	
	#This helps set and store a new vector value based on keyboard inputs
	#This value will set both direction and velocity
	var direction := Vector2(0, 0)
	direction.x = Input.get_axis("move_left", "move_right")
	direction.y = Input.get_axis("move_up", "move_down")
	
	
	#This is just a quality control condition that makes sure that the speed is
	#constant even when two directions are pressed at once like up and right
	if direction.length() > 1.0:
		direction = direction.normalized()

	#This adds a boost for a second when you press spacebar
	#acts as a kind of thruster on top of regular speed for a brief moment.
	
	#These input methods arebaked into Godot to be used whenever
	#Here I named the spacebar "boost" as a string name for godot
	if Input.is_action_just_pressed("boost"):
		max_speed = boost_speed
		#Another baked in function that is super helpful, does what it says basically
		#connects this sprite to the Timer node I used for the boost
		# ".start" is apparently a built in method as well
		get_node("Timer").start()
	
	#This is going to help smooth out the steering of the ship between two 90 deg.
	# directional inputs so that it has the look and feel of a ship trying to steer
	#rather than an instant turn
	var desired_velocity := max_speed * direction
	var steering_vector := desired_velocity - velocity
	velocity += steering_vector * steering_factor * delta
	position += velocity * delta
	
	#This just keeps the ship from resetting what direction its pointing when
	#directional inputs aren't being pressed anymore UNLESS the Vector2 length is
	#actually 0 in which case it should be left alone to point to the right
	if direction.length() > 0.0:
		rotation = velocity.angle()
