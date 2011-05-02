
Strict

Import mojo
Import scene

Import application
Import base
Import bullet
Import explosion
Import station
Import collision
Import asteroid
Import gamefonts
Import angelfont
Import powerup

Class SceneGame Extends Scene
	Const GAME_RUNNING:Int = 0
	Const GET_READY:Int = 1
	Const LEVEL_COMPLETE:Int = 2
	Const GAME_OVER:Int = 3
			
	Field state:Int
	Field level:Int
	Field score:Int
	Field stations:Station[STATION_COUNT]
	
	Field background:Image[2]
	
	Field timer:Int
	Field launchAmount:Int
	Field launchDx:Float
	Field launchDy:Float
	Field launchDelay:Int
	Field launchCount:Int

	Method OnUpdate:Void()
		timer += 1
		Select state
			Case GAME_RUNNING
				If (timer > launchDelay)
					If (launchCount > 0)
						For Local i:Int = 1 To launchAmount
							Asteroid.Create(Rnd(50, Application.WIDTH - 100), Rnd(-92, -32), Rnd(-launchDx, launchDx), Rnd(0.1, launchDy))
						Next
						launchCount -= 1
					Else If (Asteroid.count <= 0)
						state = LEVEL_COMPLETE
						ClearLevel()		
					End
					timer = 0
				End If
				CheckCollision()
				GameObject.UpdateAll()		
				
			Case LEVEL_COMPLETE			
				If (timer > 30 And MouseHit(MOUSE_LEFT)) 
					state = GAME_RUNNING	
					level += 1
					InitLevel(level)
				End If
				
			Case GET_READY
				If MouseHit() Then state = GAME_RUNNING
			
			Case GAME_OVER
				If (timer > 30 And MouseHit(MOUSE_LEFT)) 
					Application.GetInstance().SetNextScene("title")
				End								
		End		
	End
	
	Method OnRender:Void()
		DrawImage(background[level Mod 2], 0, 0)
		
		GameObject.RenderAll()
		Select state
			Case LEVEL_COMPLETE
				RenderStateMessage("GET READY", True)
				Local t:String = "Stage cleared!"
				GameFonts.normal.DrawText(t, Application.WIDTH / 2 - GameFonts.normal.TextWidth(t) / 2, 135)

			Case GET_READY
				RenderStateMessage("GET READY", True)
				
			Case GAME_OVER
				RenderStateMessage("Your Score: " + GetScore(), True)
				Local t:String = "G A M E     O V E R"
				GameFonts.normal.DrawText(t, Application.WIDTH / 2 - GameFonts.normal.TextWidth(t) / 2, 135)
		End
		
		RenderScore()
	End
	
	Method RenderStateMessage:Void(t:String, blink:Bool)
		SetColor(0,0,0)
		SetAlpha(0.6)
		DrawRect(0, 0, Application.WIDTH, Application.HEIGHT)
		SetAlpha(1)
		SetColor(255,255,255)				
		Local f:AngelFont = GameFonts.normal
		If (Not blink Or Millisecs() / 1000 Mod 2 = 0) Then f.DrawText(t, Application.WIDTH / 2 - f.TextWidth(t) / 2, 175)
	End Method
	
	Method GetScore:String()
		Local scoreTxt:String
		For Local i:Int = 0 To 5 - String(score).Length()
			scoreTxt = "0" + scoreTxt
		Next
		scoreTxt += score
		Return scoreTxt	
	End
	
	Method RenderScore:Void()
		GameFonts.normal.DrawText(GetScore(), 10, 10)
		GameFonts.normal.DrawText((level+1), Application.WIDTH - GameFonts.normal.TextWidth(level) - 15, 10)
		
		For Local i:Int = 1 To Bullet.bullets - Bullet.bulletsInUse
			DrawImage(Bullet.img, Application.WIDTH - 16 * i, Application.HEIGHT - 16)
		Next
		
	End
	
	Method OnEnter:Void()
		GameObject.Init()
		Base.Init()
		Station.Init()
		Bullet.Init()
		Explosion.Init()
		Asteroid.Init()
		PowerUp.Init()

		InitGame()
		InitLevel(level)
	End
	
	Method ClearLevel:Void()
		For Local go := Eachin GameObject.list			
			Local a := Asteroid(go)
			Local b := Bullet(go)
			Local e := Explosion(go)
			
			If (a) Then a.Destroy()
			If (b) Then b.Destroy()
			If (e) Then e.Destroy()
		Next
	End
	
	Method InitLevel:Void(l:Int)		
		launchDelay =  60 * (6 - l / 2)
		timer = launchDelay
		launchAmount = 2 + (l / 3)
		launchDx = 0.2 + (l * 0.1)
		launchDy = (launchDx * 1.5) + (l * 0.1)
		Seed = level
		launchCount = 3 + (l * 2)
	End
	
	Method InitGame:Void()
		level = 0
		score = 0
		state = GET_READY
		background[0] = LoadImage("gfx/bg01.png")
		background[1] = LoadImage("gfx/bg02.png")

		Base.Create()
				
		Station.Create(11, 255, 0)
		Station.Create(235,248, 1)
		Station.Create(331,248, 1)
		Station.Create(416,248, 1)		
	End
	
	Method OnLeave:Void()
		GameObject.list.Clear()
		background[0] = Null
		background[1] = Null
	End

	Method CheckCollision:Void()
		
		Local stationsLeft:Int = 0
		Local explode:Bool = False
		
		For Local a := Eachin GameObject.list
			If (Station(a) And Not Station(a).IsDestroyed()) Then stationsLeft += 1
			If (Asteroid(a))
				Local asteroid:Asteroid = Asteroid(a)
				If (Not a.IsDestroyed())		
					For Local obj := Eachin GameObject.list
						If (Not obj.IsDestroyed())
							If (Bullet(obj))
								'Asteroid <--> Bullet								
								If Collision.IntersectCircle(a.x, a.y, Asteroid.collisionRadius, obj.x, obj.y, Bullet.collisionRadius)
									asteroid.Explode()
									obj.Destroy()
									score += 50
									explode = True
								End
							Else If (Explosion(obj))
								'Asteroid <--> Explosion
								If Collision.IntersectCircle(a.x, a.y, Asteroid.collisionRadius, obj.x, obj.y, Explosion.collisionRadius)
									If (Rnd(0, 100) > 95) Then PowerUp.Create(a.x, a.y, (obj.x - a.x) / 20, -Abs((obj.y - a.y) / 10))
									asteroid.Explode()
									score += 75
									explode = True
								End
							Else If (Station(obj))
								'Asteroid <--> Station
								Local x:Int = obj.x + (Station.img[Station(obj).type].Width() - Station.collisionRadius) / 2
								Local y:Int = obj.y + (Station.img[Station(obj).type].Height() - Station.collisionRadius) / 2
								If Collision.IntersectRect(a.x - Asteroid.collisionRadius / 2, a.y - Asteroid.collisionRadius / 2, Asteroid.collisionRadius, Asteroid.collisionRadius, x, y, Station.collisionRadius, Station.collisionRadius)
									obj.Destroy()
									explode = True
									asteroid.Explode()
								End
							End
						End If
						If (a.IsDestroyed()) Then Exit
					Next				
					If (a.IsDestroyed()) Then Continue
				End If
			End If
		Next
		
		If (explode) Then SoundManager.Play(SoundManager.EXPLODE)
		
		'Check if game is over
		If (stationsLeft <= 0)
			ClearLevel()
			state = GAME_OVER
			timer = 0
		End
	End		
End

