
Strict

Import src.application

Import src.scenetitle
Import src.scenegame
Import src.scenelogo

Import src.faderbrightness
Import src.soundmanager
Import src.gamefonts

Function Main:Int()
	Local app:Application = Application.GetInstance()
	app.Init()
	app.AddFader(New FaderBrightness)
	
	SoundManager.LoadSounds()
	GameFonts.Load()
	
	app.AddScene("logo", New SceneLogo)
	app.AddScene("title", New SceneTitle)
	app.AddScene("game", New SceneGame)
	app.Run()
	Return 0
End
