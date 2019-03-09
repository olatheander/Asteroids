extends CanvasLayer

signal start_game

func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass

func show_message(text):
    $MessageLabel.text = text
    $MessageLabel.show()
    $MessageTimer.start()
    
func show_game_over():
    $MessageLabel.text = "Game Over!"
    $MessageLabel.show()
    $GameOverTimer.start()
    yield($GameOverTimer, "timeout")
    $StartButton.show()
    
func update_score(score):
    $ScoreLabel.text = str(score)

func _on_StartButton_pressed():
    $StartButton.hide()
    $MessageLabel.hide()
    emit_signal("start_game")

func _on_MessageTimer_timeout():
    $MessageLabel.hide()
    $MessageTimer.stop()

func _on_GameOverTimer_timeout():
    $MessageLabel.text = "Asteroids"
    $GameOverTimer.stop()
