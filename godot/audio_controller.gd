extends Node2D

@export var mute: bool = false


func play_mudhit():
	if not mute:
		$MudHit.play()

func play_bubbleup():
	if not mute:
		$BubbbleUp.play()

func play_bubblehit():
	if not mute:
		$BubbleHit.play()
