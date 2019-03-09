extends KinematicBody2D

signal spaceship_crashed

const Bullet = preload("res://Bullet.tscn")
const reload_time = 0.1

export (int) var speed = 0 # How fast the player will move (pixels/sec).
export (float) var rotation_speed = 2.5
var screen_size  # Size of the game window.
var reloading = 0.0

func _ready():
    screen_size = get_viewport_rect().size
    position.x = screen_size.x / 2
    position.y = screen_size.y / 2
    hide()

func _physics_process(delta):
    reloading -= delta
    
    var velocity = Vector2() # The player's movement vector.
    var rotation_dir = 0
    $Sprite.frame = 0
    if Input.is_action_pressed("ui_right"):
        rotation_dir += 1
    if Input.is_action_pressed("ui_left"):
        rotation_dir -= 1
    if Input.is_action_pressed("ui_down"):
        speed -= 10
    if Input.is_action_pressed("ui_up"):
        $Sprite.frame = 1
        speed += 10
    if Input.is_key_pressed(KEY_SPACE):
        _fire_bullet()

    speed = clamp(speed, 0, 400)
    velocity = Vector2(speed, 0).rotated(rotation) * delta
    rotation += rotation_dir * rotation_speed * delta
    move_and_collide(velocity)
        
    # Keep ship within screen boundaries.
    position.x = clamp(position.x, 0, screen_size.x)
    position.y = clamp(position.y, 0, screen_size.y)

func on_boulder_collision(boulder):
    print("Spaceship crashed with boulder: " + str(boulder.get_instance_id()))
    emit_signal("spaceship_crashed")
    queue_free()

func _fire_bullet():
    if reloading <= 0.0 && visible:
        reloading = reload_time
        var bullet = Bullet.instance()
        bullet.show()
        bullet.global_position = global_position
        bullet.rotation = rotation
        get_parent().add_child(bullet)
