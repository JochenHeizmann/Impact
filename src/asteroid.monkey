Strict

Import mojo
Import gameobject
Import explosion
Import application

Class Asteroid Extends GameObject
	Const ANIM_SPEED:Float = 0.5
	Const FRAMES:Int = 32
	
	Const MOVING:Int = 0
	Const DESTROYED:Int = 1	
		
	Global img:Image
	Global collisionRadius:Float
	Global count:Int = 0
	
	Field sx:Float, sy:Float
	Field dx:Float, dy:Float
	Field frame:Float	
	Field state:Int	
	
	Function Init:Void()
		If (img = Null)
			img = LoadImage("gfx/asteroids.png")
			img = img.GrabImage(0, 0, 32, 32, FRAMES, Image.MidHandle)
			collisionRadius = img.Width() / 2 * 0.7
		End
	End
	
	Method OnUpdate:Void()
		frame += ANIM_SPEED
		If (frame >= FRAMES) Then frame -= FRAMES
		x += dx
		y += dy
		If (x < -32 Or x > Application.WIDTH + 32 Or y > Application.HEIGHT + 32) Then Destroy()
	End
	
	Method OnRender:Void()
		SetColor(192,0,0)
		SetAlpha(0.5)
		DrawLine sx, sy, x, y
		SetAlpha(1)
		SetColor(255,255,255)
		DrawImage img, x, y, frame
	End
	
	Function Create:Asteroid(x:Int, y:Int, dx:Float, dy:Float)
		Local a:Asteroid
		For Local go:GameObject = Eachin list
			If (Asteroid(go))
				a = Asteroid(go)
				If (a.IsDestroyed()) Then Exit
				a = Null
			End
		Next
		If (Not a) Then a = New Asteroid
		a.x = x
		a.y = y
		a.sx = x
		a.sy = y
		a.dx = dx
		a.dy = dy
		a.state = MOVING
		count += 1
		Return a	
	End
	
	Method Destroy:Void()
		state = DESTROYED
		count -= 1
		If (count <= 0) Then count = 0
	End
	
	Method Explode:Void()
		Destroy()
		Explosion.Create(x, y)
	End
	
	Method IsDestroyed:Bool()
		Return (state = DESTROYED)
	End
	
	Private
		
	Method New()
	End	
End


