extends KinematicBody2D

signal boulder_removed
signal boulder_hit

export (int) var speed = 100
export (Vector2) var velocity = Vector2()

func _ready():
    pass

func _physics_process(delta):
    move_and_collide(velocity * delta)
    _remove_when_offscreen()
        
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
    emit_signal("boulder_hit", self, 1)
    _remove_rock()
