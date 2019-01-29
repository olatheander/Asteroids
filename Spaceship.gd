extends KinematicBody2D

signal hit

const BULLET = preload("res://Bullet.tscn")
const RELOAD_TIME = 0.1

export (int) var speed = 0 # How fast the player will move (pixels/sec).
export (float) var rotation_speed = 2.5
var screensize  # Size of the game window.
var reloading = 0.0

func _ready():
    screensize = get_viewport_rect().size
    position.x = screensize.x / 2
    position.y = screensize.y / 2

func _physics_process(delta):
    reloading -= delta
    
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
    var collision = move_and_collide(velocity)
    if collision:
        _ship_collision()
        
    # Keep ship within screen boundaries.
    position.x = clamp(position.x, 0, screensize.x)
    position.y = clamp(position.y, 0, screensize.y)

func _ship_collision():
    pass

func _fire_bullet():
    if reloading <= 0.0:
        reloading = RELOAD_TIME
        var bullet = BULLET.instance()
        bullet.show()
        bullet.global_position = global_position
        bullet.rotation = rotation
        get_parent().add_child(bullet)
