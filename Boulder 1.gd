extends KinematicBody2D

signal boulder_removed

export (float) var rotation_speed = 0.1
export (int) var speed = 100
var rotation_dir = 0

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    rotation_dir = sign(rand_range(-1, 1))

func _physics_process(delta):
    var velocity = Vector2(speed, 0).rotated(rotation) * delta
    rotation += rotation_dir * rotation_speed * delta
    var collision = move_and_collide(velocity)
    _remove_when_offscreen()
    if collision:
        #velocity = velocity.bounce(collision.normal)
        _boulder_collision(collision)
        
func _boulder_collision(collision):
    pass
    
func _remove_when_offscreen():
    var screensize = get_viewport_rect().size

    if global_position.y < 0 \
        or global_position.y > screensize.y \
        or global_position.x < 0 \
        or global_position.x > screensize.x:
            _remove_rock()

func _remove_rock():
    queue_free()
    emit_signal("boulder_removed")
            
func on_bullet_hit(bullet):
    _remove_rock()