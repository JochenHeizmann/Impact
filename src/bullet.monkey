
Strict

Import mojo
Import explosion
Import gameobject
Import soundmanager
Import application

Class Bullet Extends GameObject
	Global img:Image
	Global bullets:Int 
	Global bulletsInUse:Int

	Const MAX_BULLETS:Int = 8

	Const LAUNCHED:Int = 0
	Const DESTROYED:Int = 1
	
	Field state:Int
	Field dx:Float
	Field dy:Float
	Field steps:Int

	Global LAUNCH_X:Int = 166
	Global LAUNCH_Y:Int = 255
	Global SPEED:Int = 2
	
	Global collisionRadius:Int
	
	Function Init:Void()
		If (img = Null)
			img = LoadImage("gfx/bullet.png", 1, Image.MidHandle)
			collisionRadius = img.Width() / 2
		End
		bullets = 1
		bulletsInUse = 0
	End
	
	Method IsDestroyed:Bool()
		Return (state = DESTROYED)
	End
	
	Method Destroy:Void()
		bulletsInUse -= 1
		If (bulletsInUse < 0) Then bulletsInUse = 0
		state = DESTROYED		
	End
	
	Function PowerUp:Void()
		bullets += 1
		If (bullets >= MAX_BULLETS) Then bullets = MAX_BULLETS
	End
	
	Function Create:Bullet(dx:Int, dy:Int)
		If (bulletsInUse >= bullets) Then Return Null
		
		bulletsInUse += 1
		Local b:Bullet
		For Local go:GameObject = Eachin list
			If Bullet(go)
				b = Bullet(go)
				If (b.state = DESTROYED) Then Exit
				b = Null
			End
		Next
		If (Not b) Then b = New Bullet 	
		b.x = LAUNCH_X
		b.y = LAUNCH_Y
		b.steps = (Sqrt(Pow(dx - b.x, 2) + Pow(dy - b.y, 2))) / SPEED
		b.dx = (dx - b.x) / b.steps
		b.dy = (dy - b.y) / b.steps
		b.state = LAUNCHED

		SoundManager.Play(SoundManager.ROCKET)

		Return b
	End

	Method OnUpdate:Void()
		If (state = DESTROYED) Then Return
		If (state = LAUNCHED)
			x += dx
			y += dy
			steps -= 1
			If (steps < 0)
				Destroy()
				Explosion.Create(x, y)
				SoundManager.Play(SoundManager.EXPLODE)
			End
		End
		If (x < -32 Or y < -32 Or x > Application.WIDTH + 32 Or y > Application.HEIGHT + 32) Then Destroy()
	End
	
	Method OnRender:Void()
		If (state = DESTROYED) Then Return
		SetColor(0,255,255)
		DrawLine LAUNCH_X, LAUNCH_Y, x, y
		SetColor(255,255,255)
		DrawImage(img, x, y)
	End	
End
