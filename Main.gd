extends Node2D

const MAX_SPAWNED = 5
const BOULDER1 = preload("res://Boulder 1.tscn")
const BOULDER2 = preload("res://Boulder 2.tscn")
const BOULDER3 = preload("res://Boulder 3.tscn")
const BOULDER4 = preload("res://Boulder 4.tscn")

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
    pass

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
        var boulder = BOULDER1.instance()
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
        
        currentSpawned += 1

func _on_Boulder_boulder_removed():
    currentSpawned -= 1
  
func _on_Boulder_boulder_hit(boulder, type):
    var velocity = boulder.velocity
    var newBoulder
    for x in [-1, 0, 1]:
        match type:
            1:
                newBoulder = BOULDER2.instance()
                newBoulder.position = boulder.position
                newBoulder.velocity = boulder.velocity.rotated(x * PI/4)
                newBoulder.connect("boulder_hit", self, "_on_Boulder_boulder_hit")
                add_child(newBoulder)
            2:
                newBoulder = BOULDER3.instance()
                newBoulder.position = boulder.position
                newBoulder.velocity = boulder.velocity.rotated(x * PI/4)
                newBoulder.connect("boulder_hit", self, "_on_Boulder_boulder_hit")
                add_child(newBoulder)
            3:
                newBoulder = BOULDER4.instance()
                newBoulder.position = boulder.position
                newBoulder.velocity = boulder.velocity.rotated(x * PI/4)
                newBoulder.connect("boulder_hit", self, "_on_Boulder_boulder_hit")
                add_child(newBoulder)
            4:
                pass
             


