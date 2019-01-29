extends KinematicBody2D

signal hit

export (int) var speed = 0 # How fast the player will move (pixels/sec).
export (float) var rotation_speed = 2.5
var screensize  # Size of the game window.

func _ready():
    screensize = get_viewport_rect().size
    position.x = screensize.x / 2
    position.y = screensize.y / 2

func _physics_process(delta):
    var velocity = Vector2() # The player's movement vector.
    var rotation_dir = 0
    if Input.is_action_pressed("ui_right"):
        rotation_dir -= 1
    if Input.is_action_pressed("ui_left"):
        rotation_dir += 1
    if Input.is_action_pressed("ui_down"):
        speed -= 10
    if Input.is_action_pressed("ui_up"):
        speed += 10
    if Input.is_key_pressed(KEY_SPACE):
        _fire_bullet()

    speed = clamp(speed, 0, 600)
    velocity = Vector2(speed, 0).rotated(rotation) * delta
    rotation += rotation_dir * rotation_speed * delta
    move_and_collide(velocity)
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, 0, screensize.y)

func _fire_bullet():
    pass