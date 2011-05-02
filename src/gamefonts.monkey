
Strict

Import angelfont

Class GameFonts
	Global normal:AngelFont
	
	Function Load:Void()
		normal = New AngelFont()
		normal.LoadFont("fonts/angel_verdana")
	End
End