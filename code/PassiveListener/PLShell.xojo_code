#tag Class
Private Class PLShell
Inherits Shell
	#tag Event
		Sub DataAvailable()
		  dim data as Text = me.ReadAll().ToText
		  
		  if data.Contains("Detected!") then MsgBox("You said Casper!")
		End Sub
	#tag EndEvent


End Class
#tag EndClass
