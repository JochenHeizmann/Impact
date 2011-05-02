
Strict

Import mojo
Import monkey
Import scene

Import application
Import soundmanager

Class SceneLogo Extends Scene
	Field logo:Image
	Field timer:Int = 0
	
	Method OnUpdate:Void()
		If (timer = 0)
			timer = Millisecs() + 3000
			SoundManager.PlayMusic()
		End
		If (timer < Millisecs()) Then Application.GetInstance().SetNextScene("title")
	End
	
	Method OnRender:Void()		
		DrawImage(logo, 0, 0)
	End
	
	Method OnEnter:Void()
		logo = LoadImage("gfx/logo.png")
	End
	
	Method OnLeave:Void()
		logo = Null
	End
End

