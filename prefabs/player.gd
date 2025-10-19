extends CharacterBody2D

@export var speed = 50
var screen_size

enum Direction { LEFT, RIGHT, UP, DOWN }
var current_direction: Direction = Direction.DOWN
var interacting: bool = false

var direction_map = { Direction.LEFT: "left", Direction.RIGHT: "right", Direction.UP: "up", Direction.DOWN: "down" }
var rotation_map = { Direction.LEFT: deg_to_rad(90), Direction.RIGHT: deg_to_rad(270), Direction.UP: deg_to_rad(180), Direction.DOWN: deg_to_rad(0) } 

func dialogue_started(_resource: DialogueResource):
	interacting = true
	$InteractingComponent.can_interact = false

func dialogue_ended(_resource: DialogueResource):
	interacting = false
	$InteractingComponent.can_interact = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	DialogueManager.connect("dialogue_started", dialogue_started)
	DialogueManager.connect("dialogue_ended", dialogue_ended)
	$AnimatedSprite2D.animation = "down"
	screen_size = get_viewport_rect().size
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func handle_input() -> void:
	velocity = Vector2.ZERO
	
	if not interacting:
		if Input.is_action_pressed("move_right"):
			velocity.x += 1
		if Input.is_action_pressed("move_left"):
			velocity.x -= 1
		if Input.is_action_pressed("move_up"):
			velocity.y -= 1
		if Input.is_action_pressed("move_down"):
			velocity.y += 1
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		
		if velocity.x != 0 and velocity.y == 0:
			if velocity.x > 0:
				current_direction = Direction.RIGHT
			elif velocity.x < 0:
				current_direction = Direction.LEFT
				
		if velocity.y != 0 and velocity.x == 0:
			if velocity.y > 0:
				current_direction = Direction.DOWN
			elif velocity.y < 0:
				current_direction = Direction.UP
		
		$InteractingComponent.rotation = rotation_map[current_direction]
		$AnimatedSprite2D.animation = direction_map[current_direction]
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		$AnimatedSprite2D.frame = 1

func _physics_process(_delta: float) -> void:
	handle_input()
	move_and_slide()

func start(pos: Vector2) -> void:
	position = pos
	show()
