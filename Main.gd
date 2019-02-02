extends Node2D

const MAX_SPAWNED = 5
const BOULDER = preload("res://Boulder 1.tscn")
var score = 0
var currentSpawned = 0

func _ready():
    # Create the spawn curve for the boulders.
    var boulderCurve = Curve2D.new()
    var screensize = get_viewport_rect().size
    boulderCurve.add_point(Vector2(0, 0))
    boulderCurve.add_point(Vector2(screensize.x, 0))
    boulderCurve.add_point(Vector2(screensize.x, screensize.y))
    boulderCurve.add_point(Vector2(0, screensize.y))
    boulderCurve.add_point(Vector2(0, 0))
    
    $BoulderPath.curve = boulderCurve

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func new_game():
    score = 0
    currentSpawned = 0

func game_over():
    pass

func _on_BoulderTimer_timeout():
    if currentSpawned < MAX_SPAWNED:
        # Choose a random location on Path2D.
        $BoulderPath/BoulderSpawnLocation.set_offset(randi())
        # Create a Boulder instance and add it to the scene.
        var boulder = BOULDER.instance()
        boulder.connect("boulder_removed", self, "_on_Boulder_boulder_removed")
        add_child(boulder)
        # Set the boulders's direction perpendicular to the path direction.
        var direction = $BoulderPath/BoulderSpawnLocation.rotation + PI / 2
        # Set the boulder's position to a random location.
        boulder.position = $BoulderPath/BoulderSpawnLocation.position
        # Add some randomness to the direction.
        direction += rand_range(-PI / 4, PI / 4)
        boulder.rotation = direction
        
        currentSpawned += 1

func _on_Boulder_boulder_removed():
    currentSpawned -= 1
    