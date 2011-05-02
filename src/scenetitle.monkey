
Strict

Import mojo
Import scene

Import application
Import gamefonts
Import horizon.util

Class SceneTitle Extends Scene
	#if TARGET="android" Or TARGET="ios"
		Const TEXT_START:String = "Touch to start a new game"
	#else
		Const TEXT_START:String = "Click to start a new game"
	#end
	
	Field titlepic:Image
	
	Method OnUpdate:Void()
		If MouseHit(MOUSE_LEFT)
			If (MouseY() < 60) 
				Util.NavigateToUrl("http://www.intermediaware.com")
			Else
				Application.GetInstance().SetNextScene("game")
			End If
		End If
	End
	
	Method OnRender:Void()
		DrawImage(titlepic, 0, 0)
		If (Millisecs() / 1000 Mod 2 = 0) Then GameFonts.normal.DrawText(TEXT_START, 66, 227)
		PushMatrix
			Scale(0.6, 0.6)
			GameFonts.normal.DrawText("Code by @joemanaco      GFX by @Emme73", 100, 450)
		PopMatrix
		
		
		PushMatrix
			Scale(0.5, 0.5)
			GameFonts.normal.DrawText("More free games?", 480, 60, True)
		PopMatrix
	End
	
	Method OnEnter:Void()
		titlepic = LoadImage("gfx/title.png")
	End
	
	Method OnLeave:Void()
	End
End
