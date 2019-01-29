extends KinematicBody2D

var speed = 400

func _ready():
    pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func _physics_process(delta):
    var velocity = Vector2(speed, 0).rotated(rotation) * delta
    var collision = move_and_collide(velocity)
    if collision:
        _bullet_hit()
        
func _bullet_hit():
    pass