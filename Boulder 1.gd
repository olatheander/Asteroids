extends KinematicBody2D

const BOULDER = preload("res://Boulder 1.tscn")

signal boulder_removed

# export (float) var rotation_speed = 0.1
export (int) var speed = 100
export (Vector2) var velocity = Vector2()
export (int) var spriteIndex = 0

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    print(spriteIndex)
    $Sprite.frame = spriteIndex

func _physics_process(delta):
    # velocity = Vector2(speed, 0).rotated(0) * delta
    var collision = move_and_collide(velocity * delta)
    _remove_when_offscreen()
    if collision:
        velocity = velocity.bounce(collision.normal)
        
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
    print(str("Hit: ", spriteIndex))
    if spriteIndex < 3:
        # Spawn small blocks
        var boulder = BOULDER.instance()
        get_parent().add_child(boulder)
        # Set the boulder's position to a random location.
        boulder.position = position
        # Add some randomness to the direction.
        # direction += rand_range(-PI / 4, PI / 4)
        # boulder.rotation = direction
        # boulder.velocity = Vector2(boulder.speed, 0).rotated(direction)
        boulder.spriteIndex = spriteIndex + 1
        #boulder.velocity = velocity.rotated(rand_range(-PI / 4, PI / 4))
        boulder.velocity = velocity
