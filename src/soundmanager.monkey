
Strict

Import mojo.audio

Class SoundManager
	Const CHANNEL_MUSIC:Int = 0
	Const CHANNEL_SFX:Int = 1
	
	Const ROCKET:Int = 0
	Const EXPLODE:Int = 1
	Const SOUNDS:Int = 2
	
	Global backgroundMusic:Sound
	Global sfx:Sound[SOUNDS]
	
	
	Function LoadSounds:Void()
		#if TARGET="flash"
			backgroundMusic = LoadSound("sfx/theme.mp3")
			sfx[ROCKET] = LoadSound("sfx/rocket.mp3")
			sfx[EXPLODE] = LoadSound("sfx/xplode.mp3")
		#else If TARGET="android"
			backgroundMusic = LoadSound("sfx/theme.ogg")
			sfx[ROCKET] = LoadSound("sfx/rocket.ogg")
			sfx[EXPLODE] = LoadSound("sfx/xplode.ogg")
		#else
			backgroundMusic = LoadSound("sfx/theme.wav")
			sfx[ROCKET] = LoadSound("sfx/rocket.wav")
			sfx[EXPLODE] = LoadSound("sfx/xplode.wav")
		#endif	
	End
	
	Function PlayMusic:Void()
		PlaySound(backgroundMusic, CHANNEL_MUSIC, 1)
	End
	
	Function StopMusic:Void()
		StopChannel(backgroundMusic)
	End
	
	Function Play:Void(sound:Int)
		StopChannel(sound + CHANNEL_SFX)
		PlaySound(sfx[sound], sound + CHANNEL_SFX)
	End			
End

