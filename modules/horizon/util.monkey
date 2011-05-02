
' Module hoirzon.util

Private

Import "native/util.${TARGET}.${LANG}"

Public 

Extern
	Class Util="util"
		#if TARGET="ios"
			Function NavigateToUrl(path$)="util::NavigateToUrl"
		#else
			Function NavigateToUrl(path$)="util.NavigateToUrl"
		#end
	End
Public