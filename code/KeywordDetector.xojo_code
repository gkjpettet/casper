#tag Class
Protected Class KeywordDetector
Inherits Shell
	#tag Event
		Sub DataAvailable()
		  dim data as Text = me.ReadAll().ToText
		  
		  if data.Contains("Detected!") then DetectionOccurred()
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
		  
		  CASPER_LISTEN_PATH = _
		  App.ExecutableFile.Parent.Parent.Parent.Parent.Parent.Child("helpers").Child("keyword detector").Child("keyword_detector.py").ShellPath.ToText
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Listen(keyword as Text = "casper")
		  'Starts our custom Python script to listen passively for the passed keyword.
		  ' Stops the script if it's already running.
		  
		  if not initialised then
		    Initialise()
		    initialised = True
		  end if
		  
		  me.Stop()
		  
		  me.Execute(PYTHON_PATH + " " + CASPER_LISTEN_PATH + " --keyword " + keyword)
		  
		  mListening = True
		End Sub
	#tag EndMethod

	#tag Method, Flags = &h0
		Sub Stop()
		  if me.isRunning then me.Close()
		  
		  mListening = False
		End Sub
	#tag EndMethod


	#tag Hook, Flags = &h0
		Event DetectionOccurred()
	#tag EndHook


	#tag Property, Flags = &h21
		#tag Note
			The location of the capser_listen.py script
		#tag EndNote
		Private CASPER_LISTEN_PATH As Text
	#tag EndProperty

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

	#tag Property, Flags = &h21
		Private mListening As Boolean = False
	#tag EndProperty

	#tag Property, Flags = &h21
		#tag Note
			The location of the python interpreter
		#tag EndNote
		Private PYTHON_PATH As Text
	#tag EndProperty


	#tag ViewBehavior
		#tag ViewProperty
			Name="Arguments"
			Visible=true
			Group="Position"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Backend"
			Visible=true
			Group="Position"
			Type="String"
			EditorType="String"
		#tag EndViewProperty
		#tag ViewProperty
			Name="Canonical"
			Visible=true
			Group="Position"
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
			Name="Mode"
			Visible=true
			Group="Position"
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
			Group="Position"
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
