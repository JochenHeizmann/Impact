
Strict

Class Collision
	Function IntersectRect:Bool(x1:Float, y1:Float, w1:Float, h1:Float, x2:Float, y2:Float, w2:Float, h2:Float)
		If (x1 > (x2 + w2) Or (x1 + w1) < x2) Then Return False
		If (y1 > (y2 + h2) Or (y1 + h1) < y2) Then Return False
		Return True
	End
	
	Function IntersectCircle:Bool(x1:Float, y1:Float, r1:Float, x2:Float, y2:Float, r2:Float)
		Local dx:Float
		Local dy:Float 
		Local distance:Float
		
		dx = x1 - x2
		dy = y1 - y2
			
		distance = Sqrt(Pow(dx, 2) + Pow(dy, 2))- r1 - r2
		If distance < 0.0 Then Return True
		Return False
	End
End

