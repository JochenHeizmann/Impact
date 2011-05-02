Strict

Import mojo
Import gameobject

Class Explosion Extends GameObject
	Global img:Image[2]	
	Global collisionRadius:Float
	
	Const ANIM_SPEED:Float = 1
	
	Field frame:Float
	Field typ:Int
	
	Function Init:Void()
		If (img[0] = Null Or img[1] = Null)
			img[0] = LoadImage("gfx/explosion3.png")
			img[0] = img[0].GrabImage(0, 0, 128, 128, 64, Image.MidHandle)
			img[1] = LoadImage("gfx/mushroom.png")
			img[1] = img[1].GrabImage(0, 0, 128, 128, 64, Image.MidHandle)
			collisionRadius = img[0].Width() * 0.25			
		End			
	End
	
	Function Create:Explosion(x:Int, y:Int, typ:Int = 0)
		Local e:Explosion

		For Local go := Eachin list			
			Local el:Explosion = Explosion(go)
			If (el And el.IsDestroyed())
				el.x = x
				el.y = y
				el.frame = 0
				el.typ = typ
				Return el
			End
		Next
		
		e = New Explosion
		e.x = x
		e.y = y
		e.typ = typ
		e.frame = 0
		Return e
	End
	
	Method OnUpdate:Void()
		If (IsDestroyed()) Then Return
		frame += ANIM_SPEED
	End
	
	Method IsDestroyed:Bool()
		Return (frame >= 63)
	End Method
	
	Method OnRender:Void()
		If (IsDestroyed()) Then Return
		DrawImage(img[typ], x, y, frame)
	End
	
	Method Destroy:Void()
		frame = 63
	End
End
