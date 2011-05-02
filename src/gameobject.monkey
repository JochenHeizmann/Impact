
Strict

Class GameObject Abstract
	Global list:List<GameObject>

	Field x:Float
	Field y:Float

	Function Init:Void() Abstract
	
	Method OnRender:Void() Abstract
	Method OnUpdate:Void() Abstract
	Method Destroy:Void() Abstract
	
	Method New()
		If( list = Null) Then list = New List<GameObject>
		list.AddLast(Self)
	End

	Function RenderAll:Void() 
		For Local obj := Eachin list		
			If (Not obj.IsDestroyed()) Then obj.OnRender()
		Next
	End
	
	Function UpdateAll:Void() 
		For Local obj := Eachin list
			If (Not obj.IsDestroyed()) Then obj.OnUpdate()
		Next
	End
	
	Method IsDestroyed:Bool()
		Return False
	End	
End
