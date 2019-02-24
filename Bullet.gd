extends KinematicBody2D

var speed = 600

func _ready():
    pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func _physics_process(delta):
    var velocity = Vector2(speed, 0).rotated(rotation) * delta
    var collision = move_and_collide(velocity)
    _remove_when_offscreen()
    if collision:
        _bullet_hit(collision)
        
func _bullet_hit(collision):
    collision.collider.on_bullet_hit(self)
    queue_free()    # Bullet is consumed by impact.
        
func _remove_when_offscreen():
    var screen_size = get_viewport_rect().size

    if global_position.y < 0 \
        or global_position.y > screen_size.y \
        or global_position.x < 0 \
        or global_position.x > screen_size.x:
        queue_free()