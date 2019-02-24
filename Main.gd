extends Node2D

const MaxSpawned = 5
const Boulder1 = preload("res://Boulder 1.tscn")
const Boulder2 = preload("res://Boulder 2.tscn")
const Boulder3 = preload("res://Boulder 3.tscn")
const Boulder4 = preload("res://Boulder 4.tscn")
const Stars = preload("res://Stars.tscn")

var score = 0
var current_spawned = 0

func _ready():
    # Create the spawn curve for the boulders.
    var boulder_curve = Curve2D.new()
    var screen_size = get_viewport_rect().size
    get_viewport().connect("size_changed", self, "_on_viewport_size_changed")
    boulder_curve.add_point(Vector2(0, 0))
    boulder_curve.add_point(Vector2(screen_size.x, 0))
    boulder_curve.add_point(Vector2(screen_size.x, screen_size.y))
    boulder_curve.add_point(Vector2(0, screen_size.y))
    boulder_curve.add_point(Vector2(0, 0))
    
    $BoulderPath.curve = boulder_curve
    generate_background()

func _on_viewport_size_changed():
    for s in get_tree().get_nodes_in_group("stars"):
        s.queue_free()
    generate_background()

func generate_background():
    var screen_size = get_viewport_rect().size
    var stars = Stars.instance()
    var texture_size = stars.get_texture().get_size()
    var star_position = Vector2(0, 0)

    # Fill the background with stars.
    while true:
        stars.position = star_position
        add_child(stars)
        star_position.x += texture_size.x
        if star_position.x >= screen_size.x:
            star_position.x = 0
            star_position.y += texture_size.y
        
        if star_position.y >= screen_size.y:
            break 
            
        stars = Stars.instance()

func new_game():
    score = 0
    current_spawned = 0

func game_over():
    pass

func _on_BoulderTimer_timeout():
    if current_spawned < MaxSpawned:
        # Choose a random location on Path2D.
        $BoulderPath/BoulderSpawnLocation.set_offset(randi())
        # Create a Boulder instance and add it to the scene.
        var boulder = Boulder1.instance()
        boulder.connect("boulder_removed", self, "_on_Boulder_boulder_removed")
        boulder.connect("boulder_hit", self, "_on_Boulder_boulder_hit")
        add_child(boulder)
        # Set the boulder's position to a random location.
        boulder.position = $BoulderPath/BoulderSpawnLocation.position
        # Set the boulders's direction perpendicular to the path direction.
        var direction = $BoulderPath/BoulderSpawnLocation.rotation + PI / 2
        # Add some randomness to the direction.
        direction += rand_range(-PI / 4, PI / 4)
        boulder.rotation = direction
        boulder.velocity = Vector2(boulder.speed, 0).rotated(direction)
        
        current_spawned += 1

func _on_Boulder_boulder_removed():
    current_spawned -= 1
  
func _on_Boulder_boulder_hit(boulder, type):
    var velocity = boulder.velocity
    var new_boulder
    for x in [-1, 0, 1]:
        match type:
            1:
                new_boulder = Boulder2.instance()
                _add_boulder(new_boulder, boulder, x)
            2:
                new_boulder = Boulder3.instance()
                _add_boulder(new_boulder, boulder, x)
            3:
                new_boulder = Boulder4.instance()
                _add_boulder(new_boulder, boulder, x)
            4:
                pass

func _add_boulder(new_boulder, boulder, x):
    new_boulder.position = boulder.position
    new_boulder.velocity = boulder.velocity.rotated(x * PI/4)
    new_boulder.connect("boulder_hit", self, "_on_Boulder_boulder_hit")
    add_child(new_boulder)
