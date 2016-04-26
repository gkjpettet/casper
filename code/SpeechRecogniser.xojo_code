#tag Class
Protected Class SpeechRecogniser
Inherits Shell
	#tag Event
		Sub DataAvailable()
		  dim result as Text
		  dim data as String = me.ReadAll()
		  
		  if data.Contains("Listening...") then
		    mListening = True
		    StartedListening()
		  end if
		  
		  if data.Contains("STT output:") then 
		    ' We've successfully translated the speech, grab it, trim it and return it
		    result = data.Right(data.Len - data.InStr("STT output:")).Trim.ToText
		    TranscriptionComplete(result)
		    me.Stop()
		    return
		  end if
		End Sub
	#tag EndEvent


	#tag Method, Flags = &h21
		Private Sub Initialise()
		  ' These may need to be changed depending on where the relevant version of
		  ' Python is installed
		  #if TargetMacOS
		    PYTHON_PATH = "/usr/local/bin/python"
		  #elseif TargetWin32
		    PYTHON_PATH = "python"
		  #else
		    PYTHON_PATH = "python"
		  #endif
		  
		  STT_PATH = _
		  App.ExecutableFile.Parent.Parent.Parent.Parent.Parent.Child("helpers").Child("speech processing").Child("stt.py").ShellPath.ToText
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Listen()
		  'Starts our custom Python script to listen for speech and convert to text
		  ' Stops the script if it's already running.
		  
		  if not initialised then
		    Initialise()
		    initialised = True
		  end if
		  
		  me.Stop()
		  
		  me.Execute(PYTHON_PATH + " " + STT_PATH)
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Stop()
		  if me.isRunning then me.Close()
		  
		  mListening = False
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event StartedListening()
	#tag EndHook

	#tag Hook, Flags = &h0
		Event TranscriptionComplete(result as Text)
	#tag EndHook


	#tag Property, Flags = &h21
		Private initialised As Boolean = False
	#tag EndProperty

	#tag ComputedProperty, Flags = &h0
		#tag Getter
			Get
			  return mListening
			End Get
		#tag EndGetter
		#tag Setter
			Set
			  ' Read only.
			End Set
		#tag EndSetter
		listening As Boolean
	#tag EndComputedProperty

	#tag Property, Flags = &h0
		mListening As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		Private PYTHON_PATH As Text
	#tag EndProperty

	#tag Property, Flags = &h21
		Private STT_PATH As Text
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Arguments"
			Visible=true
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backend"
			Visible=true
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Canonical"
			Visible=true
			Type="Boolean"
			EditorType="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Index"
			Visible=true
			Group="ID"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Left"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="listening"
			Group="Behavior"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="mListening"
			Group="Behavior"
			InitialValue="False"
			Type="Boolean"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Mode"
			Visible=true
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Name"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Super"
			Visible=true
			Group="ID"
			Type="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="TimeOut"
			Visible=true
			Type="Integer"
			EditorType="Integer"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Top"
			Visible=true
			Group="Position"
			Type="Integer"
		#tag EndViewProperty
	#tag EndViewBehavior
End Class
#tag EndClass
