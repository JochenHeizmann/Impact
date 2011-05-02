Strict

Import mojo
Import gameobject
Import explosion

Class Station Extends GameObject
	Global img:Image[2]
	Global collisionRadius:Float
		
	Field destroyed:Bool
	Field type:Int = 0
	
	Function Init:Void()
		If (img[0] = Null)
			img[0] = LoadImage("gfx/station.png")
			img[1] = LoadImage("gfx/station2.png")
			collisionRadius = img[0].Width() * 0.7
		End If
	End
	
	Method OnRender:Void()
		DrawImage(img[type], x, y)
	End
	
	Method OnUpdate:Void()
	End
	
	Function Create:Void(x:Int, y:Int, type:Int)
		Local s := New Station
		s.destroyed = False
		s.x = x
		s.y = y
		s.type = type
	End	

	Method IsDestroyed:Bool()
		Return destroyed
	End	
	
	Method Destroy:Void()
		Explosion.Create(x + img[type].Width() / 2, y + 15, 1)
		destroyed = True
	End
End
