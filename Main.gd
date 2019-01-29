extends Node2D

var score = 0


func _ready():
    screensize = get_viewport_rect().size
    $StartPosition.position.x = screensize.x / 2
    $StartPosition.position.y = screensize.y / 2

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass

func game_over():
    $ScoreTimer.stop()
    $MobTimer.stop()

func new_game():
    score = 0
    $Spaceship.start
    #$Player.start($StartPosition.position)
    #$StartTimer.start()