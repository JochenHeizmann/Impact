
Strict

Class Fader
	Const FADE_OUT:Int = 0
	Const FADE_OFF:Int = 1
	Const FADE_IN:Int = 2

	Const DEFAULT_SPEED:Float = 0.05

	Field fadeState:Int
	Field speed:Float
	Field position:Float

	Method New()
		speed = DEFAULT_SPEED
		fadeState = FADE_IN
		position = 1
	End

	Method OnRender:Void() Abstract

	Method OnUpdate:Void()
		Select (fadeState)
			Case FADE_OUT
				position += speed
				If (position >= 1)
					position = 1
					fadeState = FADE_OFF
				End

			Case FADE_IN
				position -= speed
				If (position <= 0)
					position = 0
					fadeState = FADE_OFF
				End
		End
	End

	Method SetFadingSpeed:Void(speed:Float)
		Self.speed = speed
	End

	Method IsFading:Bool()
		Return (fadeState <> FADE_OFF)
	End

	Method FadeIn:Void()
		fadeState = FADE_IN
	End

	Method FadeOut:Void()
		fadeState = FADE_OUT
	End
End