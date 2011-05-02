
Strict

Import mojo
Import monkey

Import scene
Import fader

Class Application Extends App

	Global application:Application

	Const SCENE_ENTERING:Int = 0
	Const SCENE_ACTIVE:Int = 1
	Const SCENE_LEAVING:Int = 2
	
	Const WIDTH:Float = 480
	Const HEIGHT:Float = 320
	
	Field state:Int
		
	Field zoomFactorX:Float
	Field zoomFactorY:Float

	Field scenes:StringMap<Scene>
	Field currentScene:Scene
	Field nextScene:Scene
	Field faders:List<Fader>
	
	Field loading:Bool
	
	Method OnCreate:Int()
		SetUpdateRate(60)
		zoomFactorX = Float(DeviceWidth()) / Float(WIDTH)
		zoomFactorY = Float(DeviceHeight()) / Float(HEIGHT)
		Return 0
	End
	
	Method OnUpdate:Int()
		currentScene.OnUpdate()
		If (state <> SCENE_ACTIVE)
			Local changeState:Bool = True
			For Local f:Fader = Eachin faders
				If (f.IsFading())
					changeState = False
				End
				f.OnUpdate()
			Next
			If (changeState)
				If (state = SCENE_ENTERING And loading = False)
					SetState(SCENE_ACTIVE)
				Else If (state = SCENE_LEAVING)
					SetState(SCENE_ENTERING)
					currentScene.OnLeave()
					currentScene = nextScene
					currentScene.OnEnter()					
					For Local f:Fader = Eachin faders
						f.FadeIn()
					Next
				End
			End
		End
		Return 0
	End
	
	Method SetNextScene:Void(sceneName:String)
		If (nextScene)
			If (nextScene.name = sceneName) Then Return
		End
		SetState(SCENE_LEAVING)
		nextScene = scenes.Get(sceneName)
		For Local f:Fader = Eachin faders
			f.FadeOut()
		Next
	End
	
	Method GetState:Int()
		Return state
	End
	
	Method SetState:Void(st:Int)
		state = st
	End
	
	
	Method OnRender:Int()
		Scale(zoomFactorX, zoomFactorY)
		loading = False
		If (currentScene) Then currentScene.OnRender()
		If (state <> SCENE_ACTIVE)
			For Local f:Fader = Eachin faders
				f.OnRender()
			Next
		End
		Return 0
	End
	
	Method OnLoading:Int()
		loading = True
		Local t:String = "Loading...Please stand by"
		SetColor(0,255, 255)
		SetAlpha(0.5)
		DrawText(t, Application.WIDTH / 2, Application.HEIGHT - 40, .5, .5)
		Return 0
	End Method

	Method OnResume:Int()
		Return 0
	End Method
	
	Method OnSuspend:Int()
		Return 0
	End Method

	Function GetInstance:Application()
		If (Not application)
			application = New Application()
		End
		Return application
	End	
	
	Method AddFader:Void(f:Fader)
		faders.AddLast(f)
	End
	
	Method AddScene:Void(sceneName:String, scene:Scene)
		If (scenes.IsEmpty()) Then currentScene = scene
		scene.name = sceneName
		scenes.Set(sceneName, scene)
	End
	
	Method RemoveAllFaders:Void()
		faders.Clear()
	End
			
	Method Init:Void()
		faders = New List<Fader>
		scenes = New StringMap<Scene>
	End Method
	
	Method Run:Void()
		If (Not currentScene) Then Error("No scenes found!")
		currentScene.OnEnter()
		For Local f:Fader = Eachin faders
			f.FadeIn()
		Next
	End
End

