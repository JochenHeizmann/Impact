
Strict

Import mojo
Import fader
Import application

Class FaderBrightness Extends Fader
	Method OnRender:Void()
		Local alpha:Float = GetAlpha()
		Local c:Float[] = GetColor()
		
		Scale(1,1)
		SetAlpha(position)
		SetColor(0,0,0)
		Rotate(0)
		
		DrawRect(0,0, Application.WIDTH, Application.HEIGHT)
		
		SetColor(c[0], c[1], c[2])
		SetAlpha(alpha)
	End
End

