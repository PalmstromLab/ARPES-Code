#pragma rtGlobals=1		// Use modern global access method.

//structure needed for reading the header of xy file 
Structure file_header
	Variable nCurves 
	Variable nValues
	Variable aSpan
	Variable KEnergy
	Variable deltaE	
	Variable deltaA
	Variable aLow
	Variable aHigh
	Variable eLow
	Variable eHigh
	Variable eAngle
	Variable tiltAngle
	Variable eShift
	Variable tiTime
	Variable phEnergy
	Variable Keithley
EndStructure

Menu "Macros"
	"Data Analysis for ARPES", Display_Load_and_Set_Panel()
End

//main panel, is used to load the data files and choose the other functions
Window Load_and_Set_Panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(28,59,1367,621) as "Load_and_Set_Panel"
	NewDataFolder/O root:Load_and_Set_Panel
	SetDataFolder root:Load_and_Set_Panel
	
	SetDrawLayer UserBack
	//SetDrawEnv fillfgc= (17408,17408,17408)
	//DrawRect 283,314,427,560
	SetDrawEnv fillfgc= (17408,17408,17408)
	DrawRect 617,1,1187,62
	SetDrawEnv fillfgc= (17408,17408,17408)
	DrawRect 564,311,728,540
	SetDrawEnv fillfgc= (17408,17408,17408)
	DrawRect 107,1,591,62
	SetDrawEnv fillfgc= (17408,17408,17408)
	DrawRect 1,48,100,300
	
	Make/O/T/N=(1000,20) ListWave1
	Make/O/N=(1000,20) sw1
	Make/O/T/N=20 titles1					// three rows to match 3-column ListWave
	titles1[0] = "\f01Nr."
	titles1[1] = "\f01Name of the file"
	titles1[2] = "\f01Emis."
	titles1[3] = "\f01Tilt/Emis"
	titles1[4] = "\f01Width"
	titles1[5] = "\f01High[eV]"
	titles1[6] = "\f01Low[eV]"
	titles1[7] = "\f01Shift[eV]"
	titles1[8] = "\f01Delta x"
	titles1[9] = "\f01Kei.[nA]"
	titles1[10] = "\f01Exp.[s]"
	titles1[11] = "\f01Ph.[eV]"
	titles1[12] = "\f01WF[eV]"
	titles1[13] = "\f01Ef [eV]"
	titles1[14] = "\f01S.E."
	titles1[15] = "\f01S.A."
	
	titles1[16] = "\f01H."
	titles1[17] = "\f01B."
	titles1[18] = "\f01S."
	titles1[19] = "\f01D."
	
	String 	/G Title_left1 = ""
	String 	/G Title_right1 =""
	String 	/G Title_main =""
	
	Variable /G deltaA = 1
	Variable /G last_number
	Variable /G selection1
	Variable /G last_column = -1
	
	Button Load_File_Button,pos={116,9},size={101,49},proc=Load_File,title="Load file"
	Button Load_File_Button,fSize=14
	
	Button Up_Button,pos={30,53},size={44,40},proc=UpOrDown,title="UP",fSize=14
	
	Button Down_Button,pos={29,255},size={44,40},proc=UpOrDown,title="DN",fSize=14
	
	Button Smooting_Button_1,pos={573,319},size={147,60},proc=Set_smoothing,title="Set Parameters"
	Button Smooting_Button_1,fSize=14
	
	Button button1,pos={226,9},size={103,49},proc=Remove_file,title="Remove Files"
	Button button1,fSize=14
	
	Button Make_Button,pos={573,470},size={147,60},proc=ButtonProc_MakeFrame,title="Make Frame\rAverage"
	Button Make_Button,fSize=14
	
	//Button Take_left_button,pos={1250,350},size={82,23},proc=take_left1,title="Take L"
	//Button Take_left_button,fSize=14,disable=0
	
	//Button Take_right_button,pos={1250,380},size={82,24},proc=take_right1,title="Take R"
	//Button Take_right_button,fSize=14,disable=0
	
	ListBox list0,pos={103,68},size={1232,230},proc=ListBoxProc,font="Arial CE"
	ListBox list0,fSize=12,frame=2,listWave=root:Load_and_Set_Panel:ListWave1
	ListBox list0,selWave=root:Load_and_Set_Panel:sw1
	ListBox list0,titleWave=root:Load_and_Set_Panel:titles1,mode= 5,editStyle= 2
	ListBox list0,widths={5,24,6,7,6,8,8,7,8,7,6,6,6,6,5,5,4,4,4,4}
	
	TitleBox title0,pos={770,335},size={9,9},fSize=14
	TitleBox title0,variable= root:Load_and_Set_Panel:Title_left1
	
	TitleBox title1,pos={1000,335},size={9,9},fSize=14
	TitleBox title1,variable= root:Load_and_Set_Panel:Title_right1
	
	TitleBox title2,pos={770,305},size={9,9},fSize=14
	TitleBox title2,title="To Insert an image select Name of the file in the table and press key L or R"
	
	Button blend_button,pos={600,400},size={90,50},proc=Blend_button,title="Blend"
	Button blend_button,fSize=14,disable=0
	
	Button button0,pos={624,8},size={135,50},proc=ButtonProc_Multiple,title="Blend Multiple\r& Compute"
	Button button0,fSize=14 
	
	//Button SetScale2,pos={645,499},size={142,45},proc=ButtonProc_SetScale,title="Set Scale"
	//Button SetScale2,fSize=14,disable=0 
	
	//Button removedefects2,pos={644,379},size={145,53},proc=RemoveDefects2,title="Remove Defects"
	//Button removedefects2,fSize=14
	
	//Button HotPix1,pos={645,439},size={142,45},proc=ButtonProc_RemoveHotPix2,title="Remove Hot Pix."
	//Button HotPix1,fSize=14,disable=0 
	
	Button buttonDisplayExtract,pos={896,8},size={126,50},proc=DisplayExtractPanel,title="Display\r& Extract"
	Button buttonDisplayExtract,fSize=14,disable=0
	
	//CheckBox check0,pos={1260,312},size={36,26},title="2nd\rder."
	//CheckBox check0,labelBack=(47872,47872,47872),fSize=12,value= 0
	
	Button buttonSave,pos={464,9},size={120,49},proc=ButtonProc_SaveExperiment,title="Save Experiment"
	Button buttonSave,fSize=14,disable=0
	
	Button buttonLoad,pos={337,9},size={119,48},proc=ButtonProc_LoadExperiment,title="Load Experiment"
	Button buttonLoad,fSize=14,disable=0
	
	TitleBox copyrights1,pos={1200,1},size={256,34},title="Author:\rJacek R. Osiecki\rjacos78@gmail.com\rModified: Johan Adell"
	TitleBox copyrights1,fStyle=1
	TitleBox version1,pos={5,5},size={55,34},title=" Ver. 3.301"
	TitleBox version1,fStyle=1
	//TitleBox copyrights2,pos={1035,23},size={207,21},title="sci. consultant: Roger I. Uhrberg"
	//TitleBox copyrights2,fStyle=1, fsize=10 
	//TitleBox copyrights3,pos={1035,45},size={207,21},title="sci. consultant: T. Balasubramanian"
	//TitleBox copyrights3,fStyle=1, fsize=10 
	
	Button Build3D,pos={763,8},size={128,50},proc=ButtonProc_Build3D,title="Build 3D"
	Button Build3D,fSize=14
	
	Button LoadRHO,pos={1266,490},size={60,20},proc=LoadRHOfile,title="Load rho"
	Button LoadRHO,fSize=12,disable=0
	
	Button Display3Drho,pos={1253,520},size={80,30},proc=ButtonProc_Build3Ddensity,title="Display rho"
	Button Display3Drho,fSize=12,disable=0
	
	Button B_LoadMatrix,pos={1250,400},size={80,40},proc=Load_Matrix,title="Load\rMatrix"
	Button B_LoadMatrix,fSize=14,disable=0
	
	Button InsertWave1,pos={4,210},size={94,35},proc=InsertWave,title="Load Column"
	Button InsertWave1,fSize=14,disable=0 
	
	Button InsertWave2,pos={11,97},size={78,50},proc=SetValues,title="Set One\rColumn"
	Button InsertWave2,fSize=14
	
	Button InsertValues1,pos={5,152},size={92,50},proc=InsertValues,title="Set Multiple\rColumns"
	Button InsertValues1,fSize=14
	
	Button buttonAnalyzeCore,pos={1027,8},size={126,50},proc=ButtonProc_AnalyzeCore,title="Analyze\rCore"
	Button buttonAnalyzeCore,fSize=14
	
	Display/W=(765,360,965,560)/HOST=# 
	RenameWindow #,G0
	SetActiveSubwindow ##
	
	Display/W=(994,360,1194,560)/HOST=# 
	RenameWindow #,G1
	SetActiveSubwindow ##
	
	Display/W=(5,305,275,555)/HOST=# 
	RenameWindow #,G3
	SetActiveSubwindow ##
	
	Display/W=(280,305,550,555)/HOST=# 
	RenameWindow #,G2
	SetActiveSubwindow ##
	
EndMacro

Window Final_Blend() : Panel
	PauseUpdate; Silent 1		// building window...
	SetDataFolder root:Final_Blend
	NewPanel /K=1 /W=(10,55,1349,617)
	Dowindow/C $"Final_Blend"
	Display/W=(453,309,653,509)/HOST=# 
	RenameWindow #,G0
	SetActiveSubwindow ##
	
	Button change_toKbutton,pos={5,110},size={80,40},proc=change_toK,title="Change to\rk Parallel" , anchor=MC
	Button derivative,pos={5,155},size={80,40},proc=displayDer,title="Change to\r 2nd Derivative"
	Button Recalculate,pos={5,230},size={80,40},proc=recalculateA,title="Recalculate"
	Button removedefects,pos={5,275},size={80,40},proc=RemoveDefects,title="Remove\r defects"
	Button changeE , pos={5,350} , size={80,35} , proc=ChangeEmissions , title="Change\rEmissons"
	ValDisplay AngleShift  , pos={10,390} , size={60,35} , value= _NUM: 0 
	Button buttonDisplayExtract,pos={5,450},size={80,39},proc=DisplayExtractPanel2,title="Display\r& Extract"
	Button buttonDisplayExtract,fSize=13
			
	Wavestats/Q/Z FinalBlendBE
	Variable/G varMin = V_Min
	Variable/G varMax = V_max
			
	TitleBox zminimo title="zMin ",pos={5,25}
			
	Slider contrastmin,vert= 0,pos={41,27},size={290,16},proc=contrast
	Slider contrastmin,limits={V_min,V_max,0},variable=varMin,ticks= 0
			
	TitleBox zmax title="zMax",pos={5,3}
			
	Slider contrastmax,vert= 0,pos={41,7},size={290,16},proc=contrast
	Slider contrastmax,limits={V_min,V_max,0},variable=varMax,ticks= 0
			
	Button profiles,pos={270,50},size={60,40},proc=Profiles1,title="Profiles"
			
	Button ExportImage,pos={200,50},size={60,40},proc=ExportImages,title="Export\r Image"
			
	Button InverseImage,pos={115,50},size={30,20},proc=InverseImages,title="Inv"
			
	Button Reset,pos={480,40},size={60,20},proc=ResetScale,title="Reset" ,fSize=16
			
	Button ShowM,pos={155,70},size={30,20},proc=ShowMultiple,title="SM"
			
	SetVariable gamma1,pos={10,50},size={100,20},proc=GammaImage,title="Gamma"
	SetVariable gamma1,labelBack=(43520,43520,43520),fSize=14
	SetVariable gamma1,limits={-inf,inf,0.1},value= _NUM:1
			
	PopupMenu popup0,pos={10,75},size={55,20},proc=ChangeColor
	PopupMenu popup0,mode=1,popvalue="Grays",value= #"\"Grays;VioletOrangeYellow\""
			
	SetVariable SetLeftUpper,pos={355,10},size={110,20},proc=SetAllAxis,title="Upper"
	SetVariable SetLeftUpper,fSize=14,limits={-inf,inf,0.01},value= _NUM:Ymax
			
	SetVariable SetLeftLower,pos={355,35},size={110,20},proc=SetAllAxis,title="Lower"
	SetVariable SetLeftLower,fSize=14,limits={-inf,inf,0.01},value= _NUM:Ymin
			
	SetVariable SetBottomLeft,pos={345,70},size={100,20},proc=SetAllAxis,title="Left"
	SetVariable SetBottomLeft,fSize=14,limits={-inf,inf,0.01},value= _NUM:Xmin
			
	SetVariable SetBottomRight,pos={455,70},size={100,20},proc=SetAllAxis,title="Right"
	SetVariable SetBottomRight,fSize=14,limits={-inf,inf,0.01},value= _NUM:Xmax
			
	CheckBox check1 title="Grid",pos={155,50},size={50,20},proc=CheckProc_Grid,value=1,labelBack=(52224,52224,52224)
EndMacro

Function Display_Final_Blend(): Panel
	
	DoWindow/F Final_Blend					//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		return 0
	endif
	
	Execute "Final_Blend()"
	
End

//smoothing panel, used to set smoothing parameters
Window Smoothing_Panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(734,58,1289,805) as "Smoothing_Panel"
	
	Slider slider0,pos={8,198},size={192,16},proc=SliderProc
	Slider slider0,limits={0,80,1},variable= root:Specs:K0,vert= 0,ticks= 0
	
	SetVariable setvar0,pos={278,201},size={149,16},bodyWidth=60,proc=SetVarProc,title="Number of passes"
	SetVariable setvar0,labelBack=(60928,60928,60928),value= _NUM:0
	
	SetVariable setvar1,pos={280,448},size={149,16},bodyWidth=60,proc=SetVarProc,title="Number of passes"
	SetVariable setvar1,labelBack=(60928,60928,60928),value= _NUM:0

	Display/W=(10,5,200,195)/HOST=#
	RenameWindow #,G0
	SetActiveSubwindow ##
	Display/W=(8,245,198,445)/HOST=# 
	RenameWindow #,G1
	SetActiveSubwindow ##
	Display/W=(9,491,199,689)/HOST=# 
	RenameWindow #,G2
	SetActiveSubwindow ##
	Display/W=(213,5,500,195)/HOST=# 
	RenameWindow #,G3
	SetActiveSubwindow ##
	Display/W=(214,245,500,441)/HOST=# 
	RenameWindow #,G4
	SetActiveSubwindow ##
	Display/W=(213,491,497,686)/HOST=# 
	RenameWindow #,G5
	SetActiveSubwindow ##
EndMacro

Window MultipleSet_Panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(50,100,1070,320) as "Multiple Settings"	
	SetDataFolder root:Load_and_Set_Panel
	Variable /G last_tab = 0
	
	TabControl multiple,pos={17,10},size={980,160},proc=tabs1
	TabControl multiple,tabLabel(0)="Emission"
	TabControl multiple,tabLabel(1)="Tilt / Emission"
	TabControl multiple,tabLabel(2)="Width"
	TabControl multiple,tabLabel(3)="E. High"
	TabControl multiple,tabLabel(4)="E. Low"
	TabControl multiple,tabLabel(5)="E. Shift"
	TabControl multiple,tabLabel(6)="Delta A."
	TabControl multiple,tabLabel(7)="Keithley"
	TabControl multiple,tabLabel(8)="Exposure"
	TabControl multiple,tabLabel(9)="Photon E."
	TabControl multiple,tabLabel(10)="Work Function"
	TabControl multiple,tabLabel(11)="E. Fermi"
	TabControl multiple,tabLabel(12)="S.E."
	TabControl multiple,tabLabel(13)="S.A."
	TabControl multiple,tabLabel(14)="H.,B.,S.,D."
	
	SetVariable setvar01,pos={10,60},size={170,30},bodyWidth=80,title="Offset"
	SetVariable setvar01,value= _NUM:0, fsize=16, disable=0
	SetVariable setvar02,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar02,value= _NUM:0, fsize=16, disable=0
	SetVariable setvar03,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar03,value= _NUM:0, fsize=16, disable=0
	SetVariable setvar04,pos={60,180},size={150,30},bodyWidth=60,title="Start from"
	SetVariable setvar04,value= _NUM:0, fsize=16, disable=0
	SetVariable setvar05,pos={200,180},size={150,30},bodyWidth=60,title="End at"
	SetVariable setvar05,value= _NUM:0, fsize=16, disable=0
	CheckBox check0,pos={60,120},size={56,26},title="Set"
	CheckBox check0,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	SetVariable setvar11,pos={10,60},size={170,30},bodyWidth=80,title="Offset"
	SetVariable setvar11,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar12,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar12,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar13,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar13,value= _NUM:0, fsize=16, disable=1
	CheckBox check1,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check1,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	SetVariable setvar21,pos={10,60},size={170,30},bodyWidth=80,title="Offset"
	SetVariable setvar21,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar22,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar22,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar23,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar23,value= _NUM:0, fsize=16, disable=1
	CheckBox check2,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check2,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	SetVariable setvar31,pos={10,60},size={170,30},bodyWidth=80,title="Offset" ,  limits={0,inf,0.1 }
	SetVariable setvar31,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar32,pos={180,60},size={150,30},bodyWidth=80,title="Delta" ,  limits={-inf,inf,0.1 }
	SetVariable setvar32,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar33,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar33,value= _NUM:0, fsize=16, disable=1
	CheckBox check3,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check3,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	SetVariable setvar41,pos={10,60},size={170,30},bodyWidth=80,title="Offset" , limits={0,inf,0.1 }
	SetVariable setvar41,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar42,pos={180,60},size={150,30},bodyWidth=80,title="Delta",  limits={-inf,inf,0.1 }
	SetVariable setvar42,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar43,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar43,value= _NUM:0, fsize=16, disable=1
	CheckBox check4,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check4,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	SetVariable setvar51,pos={10,60},size={170,30},bodyWidth=80,title="Offset" , limits={-inf,inf,0.1}
	SetVariable setvar51,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar52,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar52,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar53,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar53,value= _NUM:0, fsize=16, disable=1
	CheckBox check5,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check5,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	SetVariable setvar61,pos={10,60},size={170,30},bodyWidth=80,title="Offset", limits={0,inf,0.1}
	SetVariable setvar61,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar62,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar62,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar63,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar63,value= _NUM:0, fsize=16, disable=1
	CheckBox check6,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check6,labelBack=(47872,47872,47872),fSize=16,value= 0
	
	SetVariable setvar71,pos={10,60},size={170,30},bodyWidth=80,title="Offset" , limits={0,inf,0.1 }
	SetVariable setvar71,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar72,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar72,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar73,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar73,value= _NUM:0, fsize=16, disable=1
	CheckBox check7,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check7,labelBack=(47872,47872,47872),fSize=16,value= 0
	
	SetVariable setvar81,pos={10,60},size={170,30},bodyWidth=80,title="Offset" , limits={0,inf,1 }
	SetVariable setvar81,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar82,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar82,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar83,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar83,value= _NUM:0, fsize=16, disable=1
	CheckBox check8,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check8,labelBack=(47872,47872,47872),fSize=16,value= 0
	
	SetVariable setvar91,pos={10,60},size={170,30},bodyWidth=80,title="Offset", limits={0,inf,1 }
	SetVariable setvar91,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar92,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar92,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar93,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar93,value= _NUM:0, fsize=16, disable=1
	CheckBox check9,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check9,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	SetVariable setvar101,pos={10,60},size={170,30},bodyWidth=80,title="Offset" , limits={0,inf,0.1 }
	SetVariable setvar101,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar102,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar102,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar103,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar103,value= _NUM:0, fsize=16, disable=1
	CheckBox check10,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check10,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	SetVariable setvar111,pos={10,60},size={170,30},bodyWidth=80,title="Offset", limits={0,inf,0.1 }
	SetVariable setvar111,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar112,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar112,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar113,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar113,value= _NUM:0, fsize=16, disable=1
	CheckBox check11,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check11,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	SetVariable setvar121,pos={10,60},size={170,30},bodyWidth=80,title="Offset", limits={0,inf,10 }
	SetVariable setvar121,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar122,pos={180,60},size={150,30},bodyWidth=80,title="Delta"
	SetVariable setvar122,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar123,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar123,value= _NUM:0, fsize=16, disable=1
	CheckBox check12,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check12,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	SetVariable setvar131,pos={10,60},size={170,30},bodyWidth=80,title="Offset", limits={0,inf,10 }
	SetVariable setvar131,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar132,pos={180,60},size={150,30},bodyWidth=80,title="Delta" 
	SetVariable setvar132,value= _NUM:0, fsize=16, disable=1
	SetVariable setvar133,pos={370,60},size={150,30},bodyWidth=80,title="Correction"
	SetVariable setvar133,value= _NUM:0, fsize=16, disable=1
	CheckBox check13,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check13,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	CheckBox check141,pos={40,60},size={40,40},title="Hot. Pixels", disable=1
	CheckBox check141,labelBack=(47872,47872,47872),fSize=16,value= 0
	CheckBox check142,pos={200,60},size={40,40},title="Background", disable=1
	CheckBox check142,labelBack=(47872,47872,47872),fSize=16,value= 0
	CheckBox check143,pos={360,60},size={40,40},title="Straight", disable=1
	CheckBox check143,labelBack=(47872,47872,47872),fSize=16,value= 0
	CheckBox check144,pos={520,60},size={40,40},title="Defects", disable=1
	CheckBox check144,labelBack=(47872,47872,47872),fSize=16,value= 0
	CheckBox check14,pos={60,120},size={56,26},title="Set", disable=1
	CheckBox check14,labelBack=(47872,47872,47872),fSize=16,value= 1
	
	Button Cancel1, pos={400,180}, size={80,30},proc=SetMultiple, title="Cancel" ,fSize=16
	Button Continue1, pos={600,180}, size={80,30},proc=SetMultiple, title="Continue" ,fSize=16
EndMacro

Function Display_MultipleSet_Panel(): Panel
	
	WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
	WAVE sw1 = root:Load_and_Set_Panel:sw1	
	
	DoWindow/F MultipleSet_Panel					//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		return 0
	endif
	
	Execute "MultipleSet_Panel()"
	Variable size1,size2,size3
	size1 = DimSize(ListWave1,0)
	size3 = DimSize(ListWave1,1) -6
	size2 = 0
	Variable i				
	for(i=0;i<size1;i+=1)
		if(cmpstr(ListWave1[i][1],"" ) == 0)
			size2 =i
			break
		endif
	endfor
	
	for ( i = 0 ; i < size2 ; i = i + 1)
		if(  (sw1[i][1] == (2^0) ) )
			break	
		endif
	endfor
	Variable index_selection = i 
	SetVariable setvar04 ,value = _NUM:1
	SetVariable setvar05 ,value = _NUM:size2
	
	String name1,name2,name3,name4
	for(i=0;i<size3;i+=1)
		name1 = "setvar"+num2str(i)+"1"
		name2 = "setvar"+num2str(i)+"2"
		name3 = "setvar"+num2str(i)+"3"
		SetVariable $name1 , value = _NUM:str2num(ListWave1[0][i+2])
		if(i==0)
			if( cmpstr(ListWave1[1][i+2],"") != 0 )
				SetVariable $name2 , value = _NUM:(str2num(ListWave1[1][i+2]) - str2num(ListWave1[0][i+2]) )
			endif
		else
			SetVariable $name2 , value = _NUM:0
		endif
		SetVariable $name3 , value = _NUM:0
	endfor
		
	name1 = "check"+num2str(i)+"1"
	name2 = "check"+num2str(i)+"2"
	name3 = "check"+num2str(i)+"3"
	name4 = "check"+num2str(i)+"4"
	CheckBox $name1 , value = ( (sw1[0][16] & (2^4)) ? 1 : 0 )
	CheckBox $name2 , value = ( (sw1[0][17] & (2^4)) ? 1 : 0 )
	CheckBox $name3 , value = ( (sw1[0][18] & (2^4)) ? 1 : 0 )
	CheckBox $name4 , value = ( (sw1[0][19] & (2^4)) ? 1 : 0 )
End


Window Multiple_Panel() : Panel
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /W=(20,400,1260,720) as "Multiple_Panel"
	
	//SetVariable setvar0,pos={6,7},size={60,20},proc=SetVarProc_1,title="Nr."
	//SetVariable setvar0,labelBack=(43520,43520,43520),fSize=14
	//SetVariable setvar0,valueBackColor=(65535,65535,65535)
	//SetVariable setvar0,limits={0,11,1},value= _NUM:0
	
	Button button0,pos={10,10},size={100,30},disable=0,proc=ButtonProc_Insert,title="Insert"
	Button button0,fSize=14
	
	Button button4,pos={120,10},size={100,30},disable=0,proc=ButtonProc_Insert,title="Insert All"
	Button button4,fSize=14
	
	Button button5,pos={230,10},size={100,30},disable=0,proc=ButtonProc_Remove,title="Remove"
	Button button5,fSize=14
	
	Button button6,pos={340,10},size={100,30},proc=ButtonProc_RemoveAll,title="Remove All"
	Button button6,fSize=14
	
	Button button1,pos={450,10},size={100,30},proc=ButtonProc_MoveLeft,title="Move Left"
	Button button1,fSize=14

	Button button2,pos={560,10},size={100,30},proc=ButtonProc_MoveRight,title="Move Right"
	Button button2,fSize=14
	
	Button button3,pos={670,10},size={100,30},disable=0,proc=ButtonProc_BlendNew,title="Blend"
	Button button3,fSize=14
	
	ListBox list2, pos={5,60} ,size={1220,245}, proc = ListBoxProc2 , fSize = 12 , special={1,200,1} , font="Arial CE" , frame= 2 
	ListBox list2, listWave=root:Multiple_Panel:ListWave2,selWave=root:Multiple_Panel:sw2,titleWave=root:Multiple_Panel:titles2
	ListBox list2, mode= 5, editStyle= 2, widths = {200}
	
	//Button button4,pos={370,7},size={150,20},disable=0,proc=ButtonProc_Display,title="Display 2nd Derivative"
	//Button button4,fSize=14
	SetWindow kwTopWin,hook(listResize)=ListResizeHook2
	
EndMacro

//
Function Display_Smoothing_Panel(): Panel
					
	DoWindow/F Smoothing_Panel					//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		return 0
	endif
	
	Execute "Smoothing_Panel()"
	
End

//function 
Function Display_Load_and_Set_Panel()
	
	String message = "Jacek R. Osiecki \"Software development for analyzis of 2-D ARPES data at I4\".\rMax-lab Activity Report 2010, p.498.\rContact, Jacek Osiecki, e-mail: jacos78@gmail.com, jacos@ifm.liu.se "
	DoAlert /T="I know that the author will be pleased if I cite the reference in my publications." 0, message
	
	DoWindow/F Load_and_set_Panel					//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		return 0
	endif
	
	String data_folder
	data_folder = "root:Specs"						//makes the main folder
	NewDataFolder/O $data_folder
	SetDataFolder $data_folder
	
	DFREF dfr = GetDataFolderDFR()
	String 	/G list_file_path = ""
	String 	/G list_file_name =""
	String 	/G list_folder =""
	Variable 	/G val_slider1 =	0
	Variable 	/G val_slider2 =	0
	Variable 	/G val_slider3 =	0
	Variable 	/G root:Specs:val_slider4 =0
	Variable 	/G root:Specs:val_slider5 =0
	
	Variable/G Multiplier  = 1
	Variable 	/G imin =	0
	Variable 	/G jmin =	0
	Variable 	/G shift1 =	20
	Variable /G root:Specs:divide = 0
	Variable /G  Smooth1
	Execute "Load_and_Set_Panel()"
	
End

Window Blending_Panel() : Panel
	
	DoWindow/F Blended_Panel					//pulls the window to the front
	PauseUpdate; Silent 1		// building window...
	NewPanel /K=1 /N=Blended_Panel /W=(336,105,1200,726) as "Blended_Panel"
	
	Slider slider0,pos={620,20},size={56,345},proc=SliderProc_Blended
	Slider slider0,limits={0,100,1},variable= root:Specs:K1,ticks= 0
	
	Slider slider1,pos={60,400},size={540,56},proc=SliderProc_Blended
	Slider slider1,limits={0,100,1},variable= root:Specs:K2,vert= 0,ticks= 0
	
	SetVariable setvar1,pos={660,410},size={180,24},proc=SetVarProc_Blended1,title="Angle Shift"
	SetVariable setvar1,labelBack=(56576,56576,56576),fSize=16,value= _NUM:0
	SetVariable setvar1,limits={-inf,inf,1},value= _NUM:0
	
	ValDisplay valdisp0,pos={718,440},size={100,17} , title="deg", fSize=15
	ValDisplay valdisp0,limits={-inf,inf,0},barmisc={0,1000}
	ValDisplay valdisp0,value= _NUM:0
	
	ValDisplay valdisp1,pos={730,510},size={90,17} , title="eV", fSize=15
	ValDisplay valdisp1,limits={-inf,inf,0},barmisc={0,1000}
	ValDisplay valdisp1,value= _NUM:0

	ValDisplay valdispAvg,pos={636,585},size={70,17},fSize=16
	ValDisplay valdispAvg,limits={0,0,0},barmisc={0,1000},value = #"0"
	
	SetVariable setvar0,pos={653,480},size={180,24},proc=SetVarProc_Blended1,title="Energy Shift"
	SetVariable setvar0,labelBack=(60928,60928,60928),fSize=16
	SetVariable setvar0,valueBackColor=(65535,65535,65535),value= _NUM:0
	SetVariable setvar0,limits={-inf,inf,1},value= _NUM:0
	
	Button buttonUD,pos={570,425},size={50,20},proc=ButtonProc,title="Down"
	
	Button buttonBlend,pos={780,580},size={70,30},proc=ButtonProc_Blend2,title="Blend"
	Button buttonBlend,fSize=20,fStyle=0,disable=2
	
	Button SetScale1,pos={635,440},size={75,20},proc=ButtonProc_SetScale,title="Set Scale"
	Button SetScale1,fSize=14,fStyle=1,disable=2
	
	Button AcceptAngle , pos = {635,540} , size = {100,30} , proc = ButtonProc_AcceptL , title = "Change Left"
	Button AcceptAngle , fSize = 14 , fStyle = 1
	
	Button AcceptEnergy , pos = {750,540} , size = {100,30} , proc = ButtonProc_AcceptR ,title = "Change Right"
	Button AcceptEnergy , fSize = 14 , fStyle = 1
	
	CheckBox check0,pos={350,420},size={56,26},title="2nd der."
	CheckBox check0,labelBack=(47872,47872,47872),fSize=16,value= 0 , proc=CheckProc
	
	ValDisplay cross1,pos={489,422},size={60,21},fSize=16
	ValDisplay cross1,limits={0,0,0},barmisc={0,1000},value= _NUM:0
	
	ValDisplay cross2,pos={624,380},size={47,21},fSize=16
	ValDisplay cross2,limits={0,0,0},barmisc={0,1000},value= _NUM:0

	Display/W=(9,10,620,400)/HOST=# 
	RenameWindow #,G0
	SetActiveSubwindow ##
	
	Display/W=(8,451,619,610)/HOST=# 
	RenameWindow #,G1
	SetActiveSubwindow ##
	
	Display/W=(680,10,850,400)/HOST=# 
	RenameWindow #,G2
	SetActiveSubwindow ##
	
	SetDataFolder root:Specs:
	Variable 	/G AngleShift 
	Variable 	/G EnergyShift
	
EndMacro

Function Display_Blended_Panel(): Panel
	
	DoWindow/F Blended_Panel					//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		return 0
	endif
	NVAR divide = root:Specs:divide
	Execute "Blending_Panel()"
	
End

Function Display_Multiple_Panel(): Panel
	
	DoWindow/F Multiple_Panel					//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		return 0
	endif
	
	NewDataFolder/O/S root:Multiple_Panel
	SetDataFolder root:Multiple_Panel
	Make/O/T/N=(1,30) ListWave2
	Make/O/N=(1,30) sw2
	Make/O/T/N=30 titles2	
	Make/O/T/N=30 list_names
	Variable /G window_images
	String 	/G list_graphs = ""
	Execute "Multiple_Panel()"
	
End

Function Load_Matrix(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			String  	curve_list 							//list of all curves in the given folder
			String 	path_list								//list of all paths, witchout name of the file
			String 	name_file_list						//name of the file
			String	data_folder 
	
			Variable ref_file								//Variable keeps refernce to the flie
			Variable position1								//Varaible used to keep position in the file
			Variable nCurves						//Varaible used to keep number of curves in the file
			Variable number_folders						//keeps number of folders in a given folder
			Variable counter1
			Variable extension
			Variable help1
			Variable Rows, Columns
			Variable i , j
			Variable Lower, Higher
			Variable aSpan, Low1, High1
			Variable Status
			
			Variable nValues
			Variable deltaE
			Variable aLow
			Variable aHigh
			Variable eLow
			Variable eHigh
			Variable tiTime
			Variable keithley
			Variable eAngle
			Variable deltaA	
			Variable nrImages
			Variable nrCurves
			Variable ordinateR
							
			//String 	message		= 	"Select a file"
			String	full_path
			String 	file_path
			String 	file_name
			SVAR 	list_file_path 		= 	root:Specs:list_file_path	
			SVAR 	list_file_name	= 	root:Specs:list_file_name	
			SVAR 	list_folder 		= 	root:Specs:list_folder
			NVAR 	val1 			=	root:Specs:val_slider1
			NVAR 	val2 			=	root:Specs:val_slider2
			NVAR 	val3 			=	root:Specs:val_slider3
	
			WAVE/T 	ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
			WAVE 		sw1			=	root:Load_and_Set_Panel:sw1	
			NVAR		last_number	=	root:Load_and_Set_Panel:last_number
			
			String 	name1,name2,name3,name4			
			
			Variable folder_index , wave_index , nrItems
			String dataFolderList , wave_list,  folder_name , wave_name
			SetDataFolder root:
			DFREF saveDFR = GetDataFolderDFR()	
			dataFolderList = DataFolderDir(1 ,saveDFR )
			dataFolderList = StringByKey("FOLDERS", dataFolderList, ":")
			dataFolderList = ReplaceString(",", dataFolderList, ";")
			
			Prompt folder_name,"Choose Folder",popup dataFolderList
			DoPrompt "Choose",folder_name
			if (V_Flag)
				return -1		// Canceled
			endif

			//open/R ref_file as full_path
			//nrCurves = Read_nrImages(ref_file)
			//ordinateR = Read_ordinateR(ref_file)
			//Close ref_file
			//curve_list = WaveList("*",";","")
			SetDataFolder root:$folder_name
			wave_List = DataFolderDir(2)
			wave_List = StringByKey("WAVES", wave_List, ":")
			wave_List = ReplaceString(",", wave_List, ";")


			Prompt wave_name,"Choose wave",popup wave_List
			DoPrompt "Choose", wave_name
			if (V_Flag)
				return -1		// Canceled
			endif
			
			Variable dim_offsetX = 7
			//Variable dim_offsetY
			Variable dim_offsetZ = 5
			Variable dim_dx = 0.06
			//Variable dim_dy
			Variable dim_dz = 0.002
			Prompt dim_offsetX, "Dimension x: Angle offset (positive value)"
			Prompt dim_dx, "Dimension x: delta Angle"
			//Prompt dim_offsetY, "Angle y offset"
			Prompt dim_offsetZ, "Dimension z: Energy offset (Kinetic Energy)"
			//Prompt dim_dy, "Dimension y delta"
			Prompt dim_dz, "Dimension z: delta Energy"
			DoPrompt "Give scaling values, read them in HDF5Browser",dim_offsetX,dim_dx,dim_offsetZ,dim_dz
				
			if (V_Flag)
				return -1		// Canceled
			endif

			file_name = folder_name
					
			data_folder = "root:Specs:"
			data_folder = data_folder + file_name
					
			MoveDataFolder root:$(file_name) , root:Specs
			WAVE box3D = $wave_name
			
			nCurves = DimSize(box3D,1)
			nrImages = DimSize(box3D,0)
			nValues = DimSize(box3D,2)
			deltaE = dim_dz
								
			aSpan = dim_offsetX * 2
			deltaA = dim_dx
			//deltaA = 0.14881
			//aSpan = nCurves * deltaA
			//aSpan = ordinateR
			aLow = (deltaA - aSpan )/2
			aHigh = aLow  + (nCurves -1) * deltaA
			eLow  = dim_offsetZ
			eHigh = eLow + (DimSize(box3D,1)-1) * dim_dz
			eAngle = 0
							
			tiTime = 1
			keithley = 1
		
			//curve_list = WaveList("*",";","")
			String beginning , ending
			beginning = "slice"
			ending=""
			String new_name
			for(i=1;i<=nrImages;i+=1)
				new_name = beginning + "_"+num2str(i) + ending
				data_folder = "root:Specs:"
				data_folder = data_folder + new_name
				NewDataFolder/S root:Specs:$new_name
				Make/O/N=(nValues,nCurves) $new_name
				WAVE WaveLoaded = $new_name
				Make/O /N=(DimSize(WaveLoaded,1)) nwave
				SetScale/P x, eLow, deltaE,"Kinetic Energy [eV]" WaveLoaded
           			SetScale/P y, aLow , deltaA, "Angle [deg]" WaveLoaded
										
				SetDataFolder root:Specs:$(file_name)
				WaveLoaded[][] = box3D[i][q][p]	
				Mirror_Image(WaveLoaded)

				list_file_path 				= 	AddListItem(data_folder, list_file_path , ";", Inf)		 //Adds item to the end of the string
				list_file_name 			= 	AddListItem(new_name, list_file_name , ";", Inf)
				list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
				counter1 				=	ItemsInList(list_file_name)
				counter1					= 	counter1 - 1
				name1 					=	StringFromList(counter1, list_file_name)
				ListWave1[counter1][0] 	=	num2str(counter1 + 1)
				ListWave1[counter1][1] 	=	name1
				ListWave1[counter1][2] = num2str(0)
				ListWave1[counter1][3] = num2str(0)
				ListWave1[counter1][4] = num2str( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) )
				ListWave1[counter1][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
				ListWave1[counter1][6] = num2str( DimOffset(WaveLoaded,0) )
				ListWave1[counter1][7] = num2str(0)
				ListWave1[counter1][8] = num2str(DimDelta(WaveLoaded,1) )
				ListWave1[counter1][9] = num2str(1)
				ListWave1[counter1][10] = num2str(tiTime)
				ListWave1[counter1][11] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) + 4.5)
				ListWave1[counter1][12] = num2str(4.5)
				ListWave1[counter1][13] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
				ListWave1[counter1][14] = num2str(0)
				ListWave1[counter1][15] = num2str(0)
				ListWave1[counter1][16] = num2str(0)
				ListWave1[counter1][17] = num2str(0)
				ListWave1[counter1][18] = num2str(0)
				ListWave1[counter1][19] = num2str(0)
										
				sw1[counter1][16] = sw1[counter1][16] | (2^5)
				sw1[counter1][17] = sw1[counter1][17] | (2^5)
				sw1[counter1][18] = sw1[counter1][18] | (2^5)
				sw1[counter1][19] = sw1[counter1][19] | (2^5)
										
				sw1[counter1][0]			=   	sw1[counter1][1] | (2^1)
				sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
				sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
				sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
				sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
				sw1[counter1][6]			=   	sw1[counter1][6] | (2^1)
				sw1[counter1][7]			=   	sw1[counter1][7] | (2^1)
				sw1[counter1][8]			=   	sw1[counter1][8] | (2^1)
				sw1[counter1][9]			=   	sw1[counter1][9] | (2^1)
				sw1[counter1][10]			=   	sw1[counter1][10] | (2^1)
				sw1[counter1][11]			=   	sw1[counter1][10] | (2^1)
				sw1[counter1][12]			=   	sw1[counter1][12] | (2^1)
				sw1[counter1][13]			=   	sw1[counter1][13] | (2^1)
				sw1[counter1][14]			=   	sw1[counter1][14] | (2^1)
				sw1[counter1][15]			=   	sw1[counter1][15] | (2^1)
										
			endfor
			KillDataFolder root:Specs:$(file_name)
					
			SetDataFolder root:Specs		
			
		break
	endswitch
	return 0
End

//function which is linked with the Load button in the main panel, activates after click
Function Load_File(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	
	STRUCT file_header set
	
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			String  	curve_list 							//list of all curves in the given folder
			String 	path_list								//list of all paths, witchout name of the file
			String 	name_file_list						//name of the file
			String	data_folder 
	
			Variable ref_file								//Variable keeps refernce to the flie
			Variable position1								//Varaible used to keep position in the file
			Variable nCurves						//Varaible used to keep number of curves in the file
			Variable number_folders						//keeps number of folders in a given folder
			Variable counter1
			Variable extension
			Variable help1
			Variable Rows, Columns
			Variable i , j
			Variable Lower, Higher
			Variable aSpan, Low1, High1
			Variable Status
			
			Variable nValues
			Variable deltaE
			Variable aLow
			Variable aHigh
			Variable eLow
			Variable eHigh
			Variable tiTime
			Variable keithley
			Variable eAngle
			Variable deltaA	
			Variable nrImages
			Variable nrCurves
			Variable ordinateR
							
			//String 	message		= 	"Select a file"
			String	full_path
			String 	file_path
			String 	file_name
			SVAR 	list_file_path 		= 	root:Specs:list_file_path	
			SVAR 	list_file_name	= 	root:Specs:list_file_name	
			SVAR 	list_folder 		= 	root:Specs:list_folder
			NVAR 	val1 			=	root:Specs:val_slider1
			NVAR 	val2 			=	root:Specs:val_slider2
			NVAR 	val3 			=	root:Specs:val_slider3
	
			WAVE/T 	ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
			WAVE 		sw1			=	root:Load_and_Set_Panel:sw1	
			NVAR		last_number	=	root:Load_and_Set_Panel:last_number
			
			String 	name1,name2,name3,name4
	
			String 	file_filters = "Data Files (*.xy,*.sp2,*.txt,*.sh5,*.itx):.xy,.sp2,.txt,.sh5,.itx;"		//filter for Open
			String 	buffer1, buffer2
			DFREF 	dfr
			STRUCT file_header fh
			
			String message = "Select one or more files"
			String outputPaths
			//Open /R /F=file_filters /M=message ref_file		//if the file was not opend the ref_file variable is unchanged
			Open /D /R /MULT=1 /F=file_filters /M=message ref_file
			DoUpdate 
			outputPaths = S_fileName
			Variable all_selection = 1
			Variable orientationVH =1
			if (strlen(outputPaths) == 0)
				Print "Cancelled"
				Return 0
			else
				Variable numFilesSelected = ItemsInList(outputPaths, "\r")
				Variable k
				Variable position
				aSpan = 21
				for(k=0; k<numFilesSelected; k+=1)
					String path = StringFromList(k, outputPaths, "\r")
					//Printf "%d: %s\r", k, path	
					full_path = path
					position = ItemsInList(full_path, ":")
					file_name = StringFromList(position - 1, full_path, ":")
					position = strsearch(full_path,":",inf,1)
					file_path = full_path[0 , position]
					//Open /C="IGR0" /P= path ref_file	
					//FStatus ref_file	
					//If(V_flag == 0)
					//	return 0
					//endif
				
					//file_path 	= 	S_path						//contains path to the computer folder						
					//file_name 	= 	S_fileName					//contains name of the file with extension
					//full_path		= 	file_path + file_name
				
					// here checking file extension and removing extension
					help1  = strsearch(file_name,".xy",0)
					if( help1 > -1 )
						name1 = file_name
						extension = 0
					endif
					help1  = strsearch(file_name,".sp2",0)
					if( help1 > -1 )
						name1 = file_name
						extension = 1
					endif
					help1  = strsearch(file_name,".txt",0)
					if( help1 > -1 )
						name1 = file_name
						extension = 2
					endif
					help1  = strsearch(file_name,".sh5",0)
					if( help1 > -1 )
						name1 = file_name
						extension = 3
					endif				
					help1  = strsearch(file_name,".itx",0)
					if( help1 > -1 )
						name1 = file_name
						extension = 4
					endif		
			
					//name1 		= 	ReplaceString(".xy", file_name, "")		//contains name of the flie without extension
			
					data_folder = "root:Specs:"
					data_folder = data_folder + file_name
			
					if(strsearch(list_file_name,file_name,0) == -1 )
		
						switch(extension)
							case 0:
								SPECS_Load_XYnew (full_path)
								//name2 = file_name + " [corrected]"
								//name3 = "root:Specs:" + file_name
								//RemoveImage /W=# $name2
								//KillWindow  #
								MoveDataFolder root:$(file_name) , root:Specs
							      
							        open/R ref_file as full_path
								nrCurves = Read_nrImages(ref_file)
								ordinateR = Read_ordinateR(ref_file)
								Close ref_file
								
								curve_list = WaveList("*",";","")
								nCurves = ItemsInList(curve_list)
								
								nrImages = nCurves/nrCurves
								
								name2 = StringFromList(1, curve_list)
								nValues = numpnts($name2)
								deltaE = deltax($name2)
								
								aSpan = ordinateR
								deltaA = aSpan/(nrCurves - 1)
								//deltaA = 0.14881
								//aSpan = nCurves * deltaA
								//aSpan = ordinateR
								aLow = (deltaA - aSpan )/2
								aHigh = aLow  + (nCurves -1) * deltaA
								eLow  = leftx($name2)
								eHigh = rightx($name2)
								eAngle = 0
							
								tiTime = 1
								keithley = 1
		
								//curve_list = WaveList("*",";","")
								if( nrImages == 1 )
									Make/O/N=(nValues,nCurves) Angle_2D
						
									SetScale/P x, eLow, deltaE,"Kinetic Energy [eV]" Angle_2D
           						 		SetScale/P y, aLow , deltaA, "Angle [deg]" Angle_2D
						
									for(i = 0; i <nCurves;i+=1)	// Initialize variables;continue test
										name1 = StringFromList(i, curve_list)
										Wave v1 = $name1
										Angle_2D[][i] = v1	[p]	
										//KillWaves v1						// Condition;update loop variables
									endfor
									//KillWaves v1
									
									String wave_name = "Angle_2D"
									Mirror_Image($wave_name)
									Duplicate /O Angle_2D , $file_name
									WAVE WaveLoaded = $file_name
									KillWaves Angle_2D
									
									list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
									list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
									list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
									counter1 				=	ItemsInList(list_file_name)
									counter1					= 	counter1 - 1
									name1 					=	StringFromList(counter1, list_file_name)
									ListWave1[counter1][0] 	=	num2str(counter1 + 1)
									ListWave1[counter1][1] 	=	name1
									ListWave1[counter1][2] = num2str(0)
									ListWave1[counter1][3] = num2str(0)
									ListWave1[counter1][4] = num2str( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) )
									ListWave1[counter1][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
									ListWave1[counter1][6] = num2str( DimOffset(WaveLoaded,0) )
									ListWave1[counter1][7] = num2str(0)
									ListWave1[counter1][8] = num2str(DimDelta(WaveLoaded,1) )
									ListWave1[counter1][9] = num2str(1)
									ListWave1[counter1][10] = num2str(tiTime)
									ListWave1[counter1][11] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) + 4.5)
									ListWave1[counter1][12] = num2str(4.5)
									ListWave1[counter1][13] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
									ListWave1[counter1][14] = num2str(0)
									ListWave1[counter1][15] = num2str(0)
									ListWave1[counter1][16] = num2str(0)
									ListWave1[counter1][17] = num2str(0)
									ListWave1[counter1][18] = num2str(0)
									ListWave1[counter1][19] = num2str(0)
									
									sw1[counter1][16] = sw1[counter1][16] | (2^5)
									sw1[counter1][17] = sw1[counter1][17] | (2^5)
									sw1[counter1][18] = sw1[counter1][18] | (2^5)
									sw1[counter1][19] = sw1[counter1][19] | (2^5)
									
									sw1[counter1][0]			=   	sw1[counter1][1] | (2^1)
									sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
									sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
									sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
									sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
									sw1[counter1][6]			=   	sw1[counter1][6] | (2^1)
									sw1[counter1][7]			=   	sw1[counter1][7] | (2^1)
									sw1[counter1][8]			=   	sw1[counter1][8] | (2^1)
									sw1[counter1][9]			=   	sw1[counter1][9] | (2^1)
									sw1[counter1][10]			=   	sw1[counter1][10] | (2^1)
									sw1[counter1][11]			=   	sw1[counter1][10] | (2^1)
									sw1[counter1][12]			=   	sw1[counter1][12] | (2^1)
									sw1[counter1][13]			=   	sw1[counter1][13] | (2^1)
									sw1[counter1][14]			=   	sw1[counter1][14] | (2^1)
									sw1[counter1][15]			=   	sw1[counter1][15] | (2^1)
									
									Make/O /N=(DimSize(WaveLoaded,1)) nwave
								else
									String beginning , ending
									sscanf file_name, "%[^.]%s", beginning , ending
									String new_name
									for(i=1;i<=nrImages;i+=1)
										new_name = beginning + "_"+num2str(i) + ending
										data_folder = "root:Specs:"
										data_folder = data_folder + new_name
										NewDataFolder/S root:Specs:$new_name
									
										Make/O/N=(nValues,nrCurves) $new_name
										WAVE WaveLoaded = $new_name
										Make/O /N=(DimSize(WaveLoaded,1)) nwave
										SetScale/P x, eLow, deltaE,"Kinetic Energy [eV]" WaveLoaded
           						 			SetScale/P y, aLow , deltaA, "Angle [deg]" WaveLoaded
										
										SetDataFolder root:Specs:$(file_name)
										for(j = ((i-1)*nrCurves); j <(i*nrCurves);j+=1)	// Initialize variables;continue test
											name1 = StringFromList(j, curve_list)
											Wave v1 = $name1
											WaveLoaded[][j-(i-1)*nrCurves] = v1[p]	
											//KillWaves v1						// Condition;update loop variables
										endfor
										Mirror_Image(WaveLoaded)
										//Duplicate /O Angle_2D , $new_name
										//WAVE WaveLoaded = $new_name
										//KillWaves Angle_2D
										
										list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
										list_file_name 			= 	AddListItem(new_name, list_file_name , ";", Inf)
										list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
										counter1 				=	ItemsInList(list_file_name)
										counter1					= 	counter1 - 1
										name1 					=	StringFromList(counter1, list_file_name)
										ListWave1[counter1][0] 	=	num2str(counter1 + 1)
										ListWave1[counter1][1] 	=	name1
										ListWave1[counter1][2] = num2str(0)
										ListWave1[counter1][3] = num2str(0)
										ListWave1[counter1][4] = num2str( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) )
										ListWave1[counter1][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
										ListWave1[counter1][6] = num2str( DimOffset(WaveLoaded,0) )
										ListWave1[counter1][7] = num2str(0)
										ListWave1[counter1][8] = num2str(DimDelta(WaveLoaded,1) )
										ListWave1[counter1][9] = num2str(1)
										ListWave1[counter1][10] = num2str(tiTime)
										ListWave1[counter1][11] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) + 4.5)
										ListWave1[counter1][12] = num2str(4.5)
										ListWave1[counter1][13] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
										ListWave1[counter1][14] = num2str(0)
										ListWave1[counter1][15] = num2str(0)
										ListWave1[counter1][16] = num2str(0)
										ListWave1[counter1][17] = num2str(0)
										ListWave1[counter1][18] = num2str(0)
										ListWave1[counter1][19] = num2str(0)
										
										sw1[counter1][16] = sw1[counter1][16] | (2^5)
										sw1[counter1][17] = sw1[counter1][17] | (2^5)
										sw1[counter1][18] = sw1[counter1][18] | (2^5)
										sw1[counter1][19] = sw1[counter1][19] | (2^5)
										
										sw1[counter1][0]			=   	sw1[counter1][1] | (2^1)
										sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
										sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
										sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
										sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
										sw1[counter1][6]			=   	sw1[counter1][6] | (2^1)
										sw1[counter1][7]			=   	sw1[counter1][7] | (2^1)
										sw1[counter1][8]			=   	sw1[counter1][8] | (2^1)
										sw1[counter1][9]			=   	sw1[counter1][9] | (2^1)
										sw1[counter1][10]			=   	sw1[counter1][10] | (2^1)
										sw1[counter1][11]			=   	sw1[counter1][10] | (2^1)
										sw1[counter1][12]			=   	sw1[counter1][12] | (2^1)
										sw1[counter1][13]			=   	sw1[counter1][13] | (2^1)
										sw1[counter1][14]			=   	sw1[counter1][14] | (2^1)
										sw1[counter1][15]			=   	sw1[counter1][15] | (2^1)
										
									endfor
									KillDataFolder root:Specs:$(file_name)
								endif
								//KillWaves v1
								SetDataFolder root:Specs		
								break
							case 1:
								name3 = "root:Specs:" + file_name
								name1 = GetDataFolder(1)
								name1 = "root:'" + file_name + "':"
								Status = DataFolderExists ( name1 ) 
								if ( status == 1 )
 									KillDataFolder ( name1 )
 								endif
 							
 								status = SPECS_Load_SP2_WithOptions(full_path, 0, 1, 1)
								if(status != 0)
								 	return 0
								endif
								name2 = WaveName("",0,4)
								//String win_name
								//String only_name
	
								//only_name = GetDataFolder(0)
								//sscanf only_name, "%[^.]", only_name
								//strsearch(win_name,only_name,0) 
								
								//name2 = file_name + " [corrected]"
								Wave WaveLoaded = $name2
								Rename $name2 , $file_name
								
								RemoveImage /W=# $file_name
								KillWindow  #
							
								status = WaveExists (WaveLoaded)
								if(status == 0)
								 	return 0
								endif
								MoveDataFolder root:$(file_name) , root:Specs
							
								Variable tiT
								getNoteTiTime(WaveLoaded, tiT)
								if( tiT == 0)
									tiTime = 1
								else 
									tiTime = tiT
								endif
							
								keithley = 1
								Mirror_Image(WaveLoaded)
								
								list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
								list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
								list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
								counter1 				=	ItemsInList(list_file_name)
								counter1					= 	counter1 - 1
								name1 					=	StringFromList(counter1, list_file_name)
								ListWave1[counter1][0] 	=	num2str(counter1 + 1)
								ListWave1[counter1][1] 	=	name1
								ListWave1[counter1][2] = num2str(0)
								ListWave1[counter1][3] = num2str(0)
								ListWave1[counter1][4] = num2str( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) )
								ListWave1[counter1][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
								ListWave1[counter1][6] = num2str( DimOffset(WaveLoaded,0) )
								ListWave1[counter1][7] = num2str(0)
								ListWave1[counter1][8] = num2str(DimDelta(WaveLoaded,1) )
								ListWave1[counter1][9] = num2str(1)
								ListWave1[counter1][10] = num2str(tiTime)
								ListWave1[counter1][11] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) + 4.5)
								ListWave1[counter1][12] = num2str(4.5)
								ListWave1[counter1][13] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
								ListWave1[counter1][14] = num2str(0)
								ListWave1[counter1][15] = num2str(0)
								ListWave1[counter1][16] = num2str(0)
								ListWave1[counter1][17] = num2str(0)
								ListWave1[counter1][18] = num2str(0)
								ListWave1[counter1][19] = num2str(0)
								
								sw1[counter1][16] = sw1[counter1][16] | (2^5)
								sw1[counter1][17] = sw1[counter1][17] | (2^5)
								sw1[counter1][18] = sw1[counter1][18] | (2^5)
								sw1[counter1][19] = sw1[counter1][19] | (2^5)
								
								sw1[counter1][0]			=   	sw1[counter1][1] | (2^1)
								sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
								sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
								sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
								sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
								sw1[counter1][6]			=   	sw1[counter1][6] | (2^1)
								sw1[counter1][7]			=   	sw1[counter1][7] | (2^1)
								sw1[counter1][8]			=   	sw1[counter1][8] | (2^1)
								sw1[counter1][9]			=   	sw1[counter1][9] | (2^1)
								sw1[counter1][10]			=   	sw1[counter1][10] | (2^1)
								sw1[counter1][11]			=   	sw1[counter1][10] | (2^1)
								sw1[counter1][12]			=   	sw1[counter1][12] | (2^1)
								sw1[counter1][13]			=   	sw1[counter1][13] | (2^1)
								sw1[counter1][14]			=   	sw1[counter1][14] | (2^1)
								sw1[counter1][15]			=   	sw1[counter1][15] | (2^1)

								Make/O /N=(DimSize(WaveLoaded,1)) nwave
								//Close ref_file
								break
							case 2:
								Variable nrwa
 								status = Read_xyScientaFile (full_path,file_name,set) 
 								nrwa = status
								if(status == 0)
								 	return 0
								endif
								if(status == 1)
									name2 = "Matrix0"
									Wave WaveLoaded = $name2
								
									status = WaveExists (WaveLoaded)
									if(status == 0)
								 		return 0
									endif
								
									Rows = DimSize(WaveLoaded, 0 )
									Columns = DimSize(WaveLoaded, 1 )
									deltaA =  DimDelta(WaveLoaded,1)
									deltaE =  DimDelta(WaveLoaded,0)
								
									Variable emission ,left , right , left1 ,right1
									emission = 0
									left1 = DimOffset(WaveLoaded,1)
									right1 = left1 + DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1)
									left = emission - (( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) ) - deltaA )/ 2
									right = emission + (( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) ) - deltaA )/ 2
									SetScale/P y, left , deltaA, "Angle [deg]" WaveLoaded
									
									Mirror_Image(WaveLoaded)
								
									tiTime = 1
									keithley = 1
							
									//Angle jest unsingned
							
									list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
									list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
									list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
									counter1 				=	ItemsInList(list_file_name)
									counter1					= 	counter1 - 1
									name1 					=	StringFromList(counter1, list_file_name)
									ListWave1[counter1][0] 	=	num2str(counter1 + 1)
									ListWave1[counter1][1] 	=	name1
									ListWave1[counter1][2] = num2str(0)
									ListWave1[counter1][3] = num2str(0)
									ListWave1[counter1][4] = num2str( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) )
									ListWave1[counter1][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
									ListWave1[counter1][6] = num2str( DimOffset(WaveLoaded,0) )
									ListWave1[counter1][7] = num2str(0)
									ListWave1[counter1][8] = num2str(DimDelta(WaveLoaded,1) )
									ListWave1[counter1][9] = num2str(1)
									ListWave1[counter1][10] = num2str(tiTime)
									ListWave1[counter1][11] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) + 4.5)
									ListWave1[counter1][12] = num2str(4.2)
									ListWave1[counter1][13] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
									ListWave1[counter1][14] = num2str(0)
									ListWave1[counter1][15] = num2str(0)
									ListWave1[counter1][16] = num2str(0)
									ListWave1[counter1][17] = num2str(0)
									ListWave1[counter1][18] = num2str(0)
									ListWave1[counter1][19] = num2str(0)
									
									sw1[counter1][16] = sw1[counter1][16] | (2^5)
									sw1[counter1][17] = sw1[counter1][17] | (2^5)
									sw1[counter1][18] = sw1[counter1][18] | (2^5)
									sw1[counter1][19] = sw1[counter1][19] | (2^5)
									
									sw1[counter1][0]			=   	sw1[counter1][1] | (2^1)
									sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
									sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
									sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
									sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
									sw1[counter1][6]			=   	sw1[counter1][6] | (2^1)
									sw1[counter1][7]			=   	sw1[counter1][7] | (2^1)
									sw1[counter1][8]			=   	sw1[counter1][8] | (2^1)
									sw1[counter1][9]			=   	sw1[counter1][9] | (2^1)
									sw1[counter1][10]			=   	sw1[counter1][10] | (2^1)
									sw1[counter1][11]			=   	sw1[counter1][10] | (2^1)
									sw1[counter1][12]			=   	sw1[counter1][12] | (2^1)
									sw1[counter1][13]			=   	sw1[counter1][13] | (2^1)
									sw1[counter1][14]			=   	sw1[counter1][14] | (2^1)
									sw1[counter1][15]			=   	sw1[counter1][15] | (2^1)

									Make/O /N=(DimSize(WaveLoaded,1)) nwave
									Make/O /N=(DimSize(WaveLoaded,1)) integrated_wave
									Variable dim1 , h1 , h2
									dim1 = DimSize(WaveLoaded,1)
									if( dim1 == 1 )
										Make/O /N=(DimSize(WaveLoaded,0)) spectrum_wave	
										h1 = DimOffset(WaveLoaded,0)
										h2 = DimDelta(WaveLoaded,0)
										SetScale /P x, h1, h2 , spectrum_wave
										spectrum_wave = WaveLoaded
									endif
									variable w1 , w2
									for ( w1=0; w1<Columns;w1=w1+1)
										for ( w2=0; w2<Rows;w2=w2+1)
											integrated_wave[w1] = integrated_wave[w1] + WaveLoaded[w2][w1] 
										endfor
									endfor
									SetScale /P x, right1, -DimDelta(WaveLoaded,1) , integrated_wave
									
									//KillWaves Angle 
									Rename  Matrix0  , $file_name
									//Close ref_file
									//return 0
								endif
								if(status >1)
									String oriDataFolder , pre1, newDFolder1, newDFolder2 , oriDF
									name2 = "Matrix1"
									Wave WaveLoaded = $name2
									newDFolder1 = RemoveEnding(file_name , ".TXT")
									for(i=0;i<nrwa;i+=1)
										SetDataFolder root:Specs:$file_name	
										newDFolder2 = newDFolder1 + "_"+num2str(i+1) +".txt"
										NewDataFolder/O root:Specs:$newDFolder2	
										
										pre1 = "Matrix" + num2str(i+1)
										WAVE WaveLoaded = $pre1
										SetDataFolder root:Specs:$newDFolder2
										oriDF = GetDataFolder(1)
										MoveWave WaveLoaded,$oriDF
										
										status = WaveExists (WaveLoaded)
										if(status == 0)
									 		return 0
										endif
									
										Rows = DimSize(WaveLoaded, 0 )
										Columns = DimSize(WaveLoaded, 1 )
										deltaA =  DimDelta(WaveLoaded,1)
										deltaE =  DimDelta(WaveLoaded,0)
									
										emission = 0
										left = emission - (( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) ) - deltaA )/ 2
										right = emission + (( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) ) - deltaA )/ 2
										SetScale/P y, left , deltaA, "Angle [deg]" WaveLoaded
										
										Mirror_Image(WaveLoaded)
									
										tiTime = 1
										keithley = 1
								
										//Angle jest unsingned
								
										list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
										list_file_name 			= 	AddListItem(newDFolder2, list_file_name , ";", Inf)
										list_folder 				= 	AddListItem("root:Specs:"+newDFolder2+":", list_folder , ";", Inf)
										counter1 				=	ItemsInList(list_file_name)
										counter1					= 	counter1 - 1
										name1 					=	StringFromList(counter1, list_file_name)
										ListWave1[counter1][0] 	=	num2str(counter1 + 1)
										ListWave1[counter1][1] 	=	name1
										ListWave1[counter1][2] = num2str(0)
										ListWave1[counter1][3] = num2str(0)
										ListWave1[counter1][4] = num2str( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) )
										ListWave1[counter1][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
										ListWave1[counter1][6] = num2str( DimOffset(WaveLoaded,0) )
										ListWave1[counter1][7] = num2str(0)
										ListWave1[counter1][8] = num2str(DimDelta(WaveLoaded,1) )
										ListWave1[counter1][9] = num2str(1)
										ListWave1[counter1][10] = num2str(tiTime)
										ListWave1[counter1][11] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) + 4.5)
										ListWave1[counter1][12] = num2str(4.2)
										ListWave1[counter1][13] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
										ListWave1[counter1][14] = num2str(0)
										ListWave1[counter1][15] = num2str(0)
										ListWave1[counter1][16] = num2str(0)
										ListWave1[counter1][17] = num2str(0)
										ListWave1[counter1][18] = num2str(0)
										ListWave1[counter1][19] = num2str(0)
										
										sw1[counter1][16] = sw1[counter1][16] | (2^5)
										sw1[counter1][17] = sw1[counter1][17] | (2^5)
										sw1[counter1][18] = sw1[counter1][18] | (2^5)
										sw1[counter1][19] = sw1[counter1][19] | (2^5)
										
										sw1[counter1][0]			=   	sw1[counter1][1] | (2^1)
										sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
										sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
										sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
										sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
										sw1[counter1][6]			=   	sw1[counter1][6] | (2^1)
										sw1[counter1][7]			=   	sw1[counter1][7] | (2^1)
										sw1[counter1][8]			=   	sw1[counter1][8] | (2^1)
										sw1[counter1][9]			=   	sw1[counter1][9] | (2^1)
										sw1[counter1][10]			=   	sw1[counter1][10] | (2^1)
										sw1[counter1][11]			=   	sw1[counter1][10] | (2^1)
										sw1[counter1][12]			=   	sw1[counter1][12] | (2^1)
										sw1[counter1][13]			=   	sw1[counter1][13] | (2^1)
										sw1[counter1][14]			=   	sw1[counter1][14] | (2^1)
										sw1[counter1][15]			=   	sw1[counter1][15] | (2^1)	
	
										Make/O /N=(DimSize(WaveLoaded,1)) nwave
									
										//KillWaves Angle 
										Rename  WaveLoaded  , $newDFolder2
									endfor
									KillDataFolder root:Specs:$file_name
								endif
								if(status == -2)
									name2 = "Matrix0"
									Wave WaveLoaded = $name2
								
									status = WaveExists (WaveLoaded)
									if(status == 0)
								 		return 0
									endif
								
									Rows = DimSize(WaveLoaded, 0 )
									deltaE =  DimDelta(WaveLoaded,0)
									Columns = DimSize(WaveLoaded, 1)
									
									tiTime = set.tiTime
									keithley = 1
							
									//Angle jest unsingned
							
									list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
									list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
									list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
									counter1 				=	ItemsInList(list_file_name)
									counter1					= 	counter1 - 1
									name1 					=	StringFromList(counter1, list_file_name)
									ListWave1[counter1][0] 	=	num2str(counter1 + 1)
									ListWave1[counter1][1] 	=	name1
									ListWave1[counter1][2] = num2str(0)
									ListWave1[counter1][3] = num2str(0)
									ListWave1[counter1][4] = num2str(Rows*deltaE)
									ListWave1[counter1][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
									ListWave1[counter1][6] = num2str( DimOffset(WaveLoaded,0) )
									ListWave1[counter1][7] = num2str(0)
									ListWave1[counter1][8] = num2str(DimDelta(WaveLoaded,0) )
									ListWave1[counter1][9] = num2str(1)
									ListWave1[counter1][10] = num2str(tiTime)
									ListWave1[counter1][11] = num2str(set.phEnergy)
									ListWave1[counter1][12] = num2str(4.2)
									ListWave1[counter1][13] = num2str(  set.phEnergy - 4.2)
									ListWave1[counter1][14] = num2str(0)
									ListWave1[counter1][15] = num2str(0)
									ListWave1[counter1][16] = num2str(0)
									ListWave1[counter1][17] = num2str(0)
									ListWave1[counter1][18] = num2str(0)
									ListWave1[counter1][19] = num2str(0)
									
									sw1[counter1][16] = sw1[counter1][16] | (2^5)
									sw1[counter1][17] = sw1[counter1][17] | (2^5)
									sw1[counter1][18] = sw1[counter1][18] | (2^5)
									sw1[counter1][19] = sw1[counter1][19] | (2^5)
									
									sw1[counter1][0]			=   	sw1[counter1][1] | (2^1)
									sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
									sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
									sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
									sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
									sw1[counter1][6]			=   	sw1[counter1][6] | (2^1)
									sw1[counter1][7]			=   	sw1[counter1][7] | (2^1)
									sw1[counter1][8]			=   	sw1[counter1][8] | (2^1)
									sw1[counter1][9]			=   	sw1[counter1][9] | (2^1)
									sw1[counter1][10]			=   	sw1[counter1][10] | (2^1)
									sw1[counter1][11]			=   	sw1[counter1][10] | (2^1)
									sw1[counter1][12]			=   	sw1[counter1][12] | (2^1)
									sw1[counter1][13]			=   	sw1[counter1][13] | (2^1)
									sw1[counter1][14]			=   	sw1[counter1][14] | (2^1)
									sw1[counter1][15]			=   	sw1[counter1][15] | (2^1)

									Make/O /N=(DimSize(WaveLoaded,0)) nwave
									Make/O /N=(DimSize(WaveLoaded,1)) integrated_wave
									for ( w1=0; w1<Columns;w1=w1+1)
										for ( w2=0; w2<Rows;w2=w2+1)
											integrated_wave[w1] = integrated_wave[w1] + WaveLoaded[w2][w1] 
										endfor
									endfor
									SetScale /P x, DimOffset(WaveLoaded,1), DimDelta(WaveLoaded,1) , integrated_wave
									//KillWaves Angle 
									Rename  Matrix0  , $file_name
								endif
							break
						case 3:
							name3 = "root:Specs:" + file_name
							name1 = GetDataFolder(1)
							name1 = "root:'" + file_name + "':"
							Status = DataFolderExists ( name1 ) 
							if ( status == 1 )
 								KillDataFolder ( name1 )
 							endif
 								
							status = MY_SPECS_Load_SH5(full_path)
							if(status != 0)
								 return 0
							endif
							
							name2 = file_name + "-trans"
							KillWaves $file_name
							Wave WaveLoaded = $name2
							Rename $name2 , $file_name
							
							RemoveImage /W=# $file_name
							KillWindow  #
							
							status = WaveExists (WaveLoaded)
							if(status == 0)
							 	return 0
							endif
							MoveDataFolder root:$(file_name) , root:Specs
						
							//getNoteTiTime(WaveLoaded, tiT)
							if( tiT == 0)
								tiTime = 1
							else 
								tiTime = tiT
							endif
						
							keithley = 1
						
							//Rows = DimSize(WaveLoaded, 0 )
							//Columns = DimSize(WaveLoaded, 1 )
					
							// zostawic matryca jest floating point
							//Make/O/N=(Rows,Columns) Angle_2D
								
							Mirror_Image(WaveLoaded)
							//Angle_2D  = WaveLoaded
							//Angle_2D = Angle_2D / tiTime / keithley

		           				//SetScale/P x, DimOffset(WaveLoaded,0) , DimDelta(WaveLoaded,0),"Kinetic Energy [eV]" Angle_2D
		           				//SetScale/P y, DimOffset(WaveLoaded,1) , DimDelta(WaveLoaded,1), "Angle [deg]" Angle_2D

							list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
							list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
							list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
							counter1 				=	ItemsInList(list_file_name)
							counter1					= 	counter1 - 1
							name1 					=	StringFromList(counter1, list_file_name)
							ListWave1[counter1][0] 	=	num2str(counter1 + 1)
							ListWave1[counter1][1] 	=	name1
							ListWave1[counter1][2] = num2str(0)
							ListWave1[counter1][3] = num2str(0)
							ListWave1[counter1][4] = num2str( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) )
							ListWave1[counter1][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
							ListWave1[counter1][6] = num2str( DimOffset(WaveLoaded,0) )
							ListWave1[counter1][7] = num2str(0)
							ListWave1[counter1][8] = num2str(DimDelta(WaveLoaded,1) )
							ListWave1[counter1][9] = num2str(1)
							ListWave1[counter1][10] = num2str(tiTime)
							ListWave1[counter1][11] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) + 4.5)
							ListWave1[counter1][12] = num2str(4.5)
							ListWave1[counter1][13] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
							ListWave1[counter1][14] = num2str(0)
							ListWave1[counter1][15] = num2str(0)
							ListWave1[counter1][16] = num2str(0)
							ListWave1[counter1][17] = num2str(0)
							ListWave1[counter1][18] = num2str(0)
							ListWave1[counter1][19] = num2str(0)
								
							sw1[counter1][16] = sw1[counter1][16] | (2^5)
							sw1[counter1][17] = sw1[counter1][17] | (2^5)
							sw1[counter1][18] = sw1[counter1][18] | (2^5)
							sw1[counter1][19] = sw1[counter1][19] | (2^5)
								
							sw1[counter1][0]			=   	sw1[counter1][1] | (2^1)
							sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
							sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
							sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
							sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
							sw1[counter1][6]			=   	sw1[counter1][6] | (2^1)
							sw1[counter1][7]			=   	sw1[counter1][7] | (2^1)
							sw1[counter1][8]			=   	sw1[counter1][8] | (2^1)
							sw1[counter1][9]			=   	sw1[counter1][9] | (2^1)
							sw1[counter1][10]			=   	sw1[counter1][10] | (2^1)
							sw1[counter1][11]			=   	sw1[counter1][10] | (2^1)
							sw1[counter1][12]			=   	sw1[counter1][12] | (2^1)
							sw1[counter1][13]			=   	sw1[counter1][13] | (2^1)
							sw1[counter1][14]			=   	sw1[counter1][14] | (2^1)
							sw1[counter1][15]			=   	sw1[counter1][15] | (2^1)
							//KillWaves Angle 
							Make/O /N=(DimSize(WaveLoaded,1)) nwave
								
							break
							
						case 4:
							name3 = "root:Specs:" + file_name
							name1 = GetDataFolder(1)
							name1 = "root:'" + file_name + "':"
							Status = DataFolderExists ( name1 ) 
							if ( status == 1 )
 								KillDataFolder ( name1 )
 							endif	
							//LoadWave /A=Matrix /G /K=0 /M  /O path
							
							NewDataFolder/O root:Specs:$file_name
							SetDataFolder root:Specs:$file_name
							
							LoadWave /T /M  /O path
							if(status != 0)
								 return 0
							endif
							
							name2 = StringFromList(0, S_waveNames)
							Wave WaveLoaded = $name2
								
							status = WaveExists (WaveLoaded)
							if(status == 0)
							 	return 0
							endif
								
							Rows = DimSize(WaveLoaded, 0 )
							Columns = DimSize(WaveLoaded, 1 )
							deltaA =  DimDelta(WaveLoaded,1)
							deltaE =  DimDelta(WaveLoaded,0)
								
							//Variable emission ,left , right
							emission = 0
							left = emission - (( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) ) - deltaA )/ 2
							right = emission + (( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) ) - deltaA )/ 2
							SetScale/P y, left , deltaA, "Angle [deg]" WaveLoaded
							
							Mirror_Image(WaveLoaded)
							
							tiTime = 1
							keithley = 1
															//Angle jest unsingned
							list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
							list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
							list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
							counter1 				=	ItemsInList(list_file_name)
							counter1					= 	counter1 - 1
							name1 					=	StringFromList(counter1, list_file_name)
							ListWave1[counter1][0] 	=	num2str(counter1 + 1)
							ListWave1[counter1][1] 	=	name1
							ListWave1[counter1][2] = num2str(0)
							ListWave1[counter1][3] = num2str(0)
							ListWave1[counter1][4] = num2str( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) )
							ListWave1[counter1][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
							ListWave1[counter1][6] = num2str( DimOffset(WaveLoaded,0) )
							ListWave1[counter1][7] = num2str(0)
							ListWave1[counter1][8] = num2str(DimDelta(WaveLoaded,1) )
							ListWave1[counter1][9] = num2str(1)
							ListWave1[counter1][10] = num2str(tiTime)
							ListWave1[counter1][11] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) + 4.5)
							ListWave1[counter1][12] = num2str(4.5)
							ListWave1[counter1][13] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
							ListWave1[counter1][14] = num2str(0)
							ListWave1[counter1][15] = num2str(0)
							ListWave1[counter1][16] = num2str(0)
							ListWave1[counter1][17] = num2str(0)
							ListWave1[counter1][18] = num2str(0)
							ListWave1[counter1][19] = num2str(0)
								
							sw1[counter1][16] = sw1[counter1][16] | (2^5)
							sw1[counter1][17] = sw1[counter1][17] | (2^5)
							sw1[counter1][18] = sw1[counter1][18] | (2^5)
							sw1[counter1][19] = sw1[counter1][19] | (2^5)
								
							sw1[counter1][0]			=   	sw1[counter1][1] | (2^1)
							sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
							sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
							sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
							sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
							sw1[counter1][6]			=   	sw1[counter1][6] | (2^1)
							sw1[counter1][7]			=   	sw1[counter1][7] | (2^1)
							sw1[counter1][8]			=   	sw1[counter1][8] | (2^1)
							sw1[counter1][9]			=   	sw1[counter1][9] | (2^1)
							sw1[counter1][10]			=   	sw1[counter1][10] | (2^1)
							sw1[counter1][11]			=   	sw1[counter1][10] | (2^1)
							sw1[counter1][12]			=   	sw1[counter1][12] | (2^1)
							sw1[counter1][13]			=   	sw1[counter1][13] | (2^1)
							sw1[counter1][14]			=   	sw1[counter1][14] | (2^1)
							sw1[counter1][15]			=   	sw1[counter1][15] | (2^1)
							//KillWaves Angle 
							Rename  $name2  , $file_name
							Make/O /N=(DimSize(WaveLoaded,1)) nwave
								
							break
						endswitch
					endif
				endfor
			endif
			
		break
	endswitch
	return 0
End

Function Read_xyScientaFile(path,file_name,set)	
	STRING path,file_name
	
	STRUCT file_header &set
	Variable ref_file
	Variable position
	Variable help1,help2
	Variable bindingE ,excitationE
	Variable help3,help4,help5,help6
	Variable deltaA, deltaE
	String buffer1,buffer2
	STRUCT file_header h
	Variable j,i
	String curve_name 
	String value1, value2
	Variable V_logEOF
	Variable V_filePos
	Variable size3
	
	SetDataFolder root:Specs:
	open/R ref_file as path
	FStatus ref_file
	if(!V_flag)
		return 0
	endif
	FReadLine /T="\n"  ref_file, buffer1				//this buffer keeps all the data from the file
	FReadLine /T="\n"  ref_file, buffer1
	FReadLine /T="\n"  ref_file, buffer1
	//FReadLine  ref_file, buffer1
	
	position = strsearch(buffer1, "Version=1.2.2", 0)
		
	if(position != -1)
		FSetPos ref_file, 0
		FReadLine /T=""  ref_file, buffer1
		//FStatus ref_file
		//position= V_filePos
		//FSetPos ref_file, position + 20
		FReadLine /T="\n"  ref_file, buffer1
		FReadLine /T="\n"  ref_file, buffer1
		FReadLine /T="\n"  ref_file, buffer1
		sscanf buffer1,"Dimension 1 size=%f", help5
		FReadLine /T="\n"  ref_file, buffer2
		sscanf buffer2,"Dimension 1 scale=%f %f", help1, help2
		
		FReadLine /T="\n"   ref_file, buffer2
		FReadLine /T="\n"   ref_file, buffer2
		FReadLine /T="\n"   ref_file, buffer2
		position = strsearch(buffer2, "Dimension 2 scale=", 0)
		if(position != -1)
			sscanf buffer2,"Dimension 2 scale=%f %f", help3, help4
			deltaE = abs(help2 - help1)
			deltaA = help4 - help3
			
			NewDataFolder/O $file_name
			SetDataFolder root:Specs:$file_name
			
			LoadWave /A=Matrix /G /K=0 /M  /O path
			WAVE Matrix0
			DeletePoints /M=1 0, 1, Matrix0		
		
			SetScale/P x, help1, deltaE,"Kinetic Energy [eV]" Matrix0
			SetScale/P y, help3 , deltaA, "Angle [deg]" Matrix0	
		else
			do
				FReadLine /T="\n"   ref_file, buffer2
				position = strsearch(buffer2, "Excitation Energy=", 0)	
				if (position != -1)
					sscanf buffer2,"Excitation Energy=%f", help6
					set.phEnergy = help6
					FReadLine /T="\n"   ref_file, buffer2
					FReadLine /T="\n"   ref_file, buffer2
					FReadLine /T="\n"   ref_file, buffer2
					FReadLine /T="\n"   ref_file, buffer2
					sscanf buffer2,"Low Energy=%f", help1
					FReadLine /T="\n"   ref_file, buffer2
					FReadLine /T="\n"   ref_file, buffer2
					sscanf buffer2,"Energy Step=%f", deltaE
					FReadLine /T="\n"   ref_file, buffer2
					sscanf buffer2,"Step Time=%f", help6
					set.tiTime = help6/1000
					break					// This breaks out of the loop.
				endif
			while(1)
			NewDataFolder/O $file_name
			SetDataFolder root:Specs:$file_name
			
			LoadWave /G /K=0 /M  /O path
			WAVE wave0
			wave0[][0] = wave0[p][1]
			Redimension /N=(help5) wave0		
		
			SetScale/P x, help1, deltaE,"Kinetic Energy [eV]" wave0
		endif
		close ref_file
		return -2
	else	
		FSetPos ref_file, 0
		
		position =  FindStringFile(ref_file, "Dimension 1 name=")
		if(position == -1)
			close ref_file
			return 0
		endif
		FSetPos ref_file, position	
		
		FReadLine /T=(num2char(13))  ref_file, buffer2
		String nameB
		sscanf buffer2,"Dimension 1 name=%s", nameB
		excitationE = 0 
		if( cmpstr ( nameB, "Binding") == 0  )
			bindingE = 1
			position =  FindStringFile(ref_file, "Excitation Energy=")
			if(position == -1)
				close ref_file
				return 0
			endif
			FSetPos ref_file, position	
		
			FReadLine /T=(num2char(13))  ref_file, buffer2
			sscanf buffer2,"Excitation Energy=%f", excitationE	
		endif
		
		position =  FindStringFile(ref_file, "Dimension 1 scale=")
		if(position == -1)
			close ref_file
			return 0
		endif
		FSetPos ref_file, position	
		
		FReadLine /T=(num2char(13))  ref_file, buffer2
		sscanf buffer2,"Dimension 1 scale=%f %f", help1, help2
		
		position =  FindStringFile(ref_file, "Dimension 2 scale=")
		if(position == -1)
			//close ref_file
			//return 0
		else
			help3 = 0
			help4 = 0
			FSetPos ref_file, position
			FReadLine /T=(num2char(13))  ref_file, buffer2
			sscanf buffer2,"Dimension 2 scale=%f %f", help3, help4
		endif
		
		deltaE = abs(help2 - help1)
		deltaA = help4 - help3
		
		Variable workF
		workF = 4.0
		Variable helpB
		if(bindingE ==1)
			helpB = help1
			help1 = excitationE - workF - help1 
		endif
		
		position =  FindStringFile(ref_file, "Dimension 3 size=")
		if(position != -1)
			FSetPos ref_file, position
			FReadLine /T=(num2char(13))  ref_file, buffer2
			size3 = 0
			sscanf buffer2,"Dimension 3 size=%i ", size3
		endif
		close ref_file
		
		if(size3 == 0 || size3 ==1)
			NewDataFolder/O $file_name
			SetDataFolder root:Specs:$file_name
			
			LoadWave /A=Matrix /G /K=0 /M  /O path
			WAVE Matrix0
			DeletePoints /M=1 0, 1, Matrix0	
			if(deltaA == 0)
				SetScale/P x, helpB, -deltaE,"Kinetic Energy [eV]" Matrix0
			else	
				SetScale/P x, help1, deltaE,"Kinetic Energy [eV]" Matrix0
			endif
			SetScale/P y, help3 , deltaA, "Angle [deg]" Matrix0	
			return 1
		else
			NewDataFolder/O $file_name
			SetDataFolder root:Specs:$file_name
			
			LoadWave /A=Matrix /G /K=0 /M  /O path
			WAVE Matrix0
			KillWaves Matrix0
			
			String pre1	
			for(i=0;i<size3;i+=1)
				pre1 = "Matrix" + num2str(i+1)
				WAVE Matrix = $pre1
				DeletePoints /M=1 0, 1, Matrix		
	
				SetScale/P x, help1, deltaE,"Kinetic Energy [eV]" Matrix
				SetScale/P y, help3 , deltaA, "Angle [deg]" Matrix
			endfor
			return size3	
		endif
	endif
	return 1
End

Function FindStringFile(ref_file, keyword)
	Variable ref_file
	String keyword
	
	Variable i, position
	String buffer1
	Variable V_filePos
	
	FSetPos ref_file, 0
	for(i=0;i<200;i+=1)
		FStatus ref_file
		FReadLine /T="\n"  ref_file, buffer1	
		position = strsearch(buffer1, keyword, 0)
		if(position >= 0)
			return V_filePos
		endif
	endfor
	return -1	
End

Function Read_nrImages(ref_file)	
	Variable ref_file
	
	Variable position
	Variable help1,help2
	String buffer1,buffer2
	Variable j,i
	String curve_name
	String value1, value2
	
	FSetPos ref_file, 0
	FReadLine /T=""  ref_file, buffer1				//this buffer keeps all the data from the file
	FStatus ref_file
	for(i  = 0 ;i < 20 ;i+=1)
		position = strsearch(buffer1, "Curves/Scan:", 0)
		FSetPos ref_file, position
		FReadLine /T=(num2char(13))  ref_file, buffer2
		sscanf buffer2,"Curves/Scan:       %d", help1
	endfor
	
	return help1
End

Function Read_ordinateR(ref_file)	
	Variable ref_file
	
	Variable position
	Variable help1,help2
	String buffer1,buffer2
	Variable j,i
	String curve_name
	String value1, value2
	
	FSetPos ref_file, 0
	FReadLine /T=""  ref_file, buffer1				//this buffer keeps all the data from the file
	FStatus ref_file
	for(i  = 0 ;i < 20 ;i+=1)
		position = strsearch(buffer1, "OrdinateRange:", 0)
		FSetPos ref_file, position
		FReadLine /T=(num2char(13))  ref_file, buffer2
		sscanf buffer2,"OrdinateRange: %f", help1
	endfor
	
	return help1
End

Function Read_xyFile(ref_file)	
	Variable ref_file
	
	Variable position
	Variable help1,help2
	String buffer1,buffer2
	STRUCT file_header h
	Variable j,i
	String curve_name
	String value1, value2
	
	FReadLine /T=""  ref_file, buffer1				//this buffer keeps all the data from the file
	FStatus ref_file
	
	position = strsearch(buffer1, "Curves/Scan:", 0)
	FSetPos ref_file, position
	FReadLine /T=(num2char(13))  ref_file, buffer2
	sscanf buffer2,"Curves/Scan:       %d", help1
	h.nCurves = help1
	
	position = strsearch(buffer1, "Values/Curve:", 0)
	FSetPos ref_file, position
	FReadLine /T=(num2char(13))  ref_file, buffer2
	sscanf buffer2,"Values/Curve:      %d", help1
	h.nValues = help1
	
	position = strsearch(buffer1, "Kinetic Energy:", 0)
	FSetPos ref_file, position
	FReadLine /T=(num2char(13))  ref_file, buffer2
	sscanf buffer2,"Kinetic Energy:    %f", help1
	h.KEnergy = help1
	
	position = strsearch(buffer1, "OrdinateRange:", 0)
	FSetPos ref_file, position
	FReadLine /T=(num2char(13))  ref_file, buffer2
	sscanf buffer2,"OrdinateRange: %f", help1
	h.aSpan = help1
	
	position = strsearch(buffer1, "Cycle: 0, Curve: 0", 0)
	FSetPos ref_file, position
	FReadLine /T=(num2char(13))  ref_file, buffer2
	FReadLine /T=(num2char(13))  ref_file, buffer2
	FReadLine /T=(num2char(13))  ref_file, buffer2
	FReadLine /T=(num2char(13))  ref_file, buffer2
	FReadLine /T=(num2char(13))  ref_file, buffer2
	sscanf buffer2,"%e", help1
	FReadLine /T=(num2char(13))  ref_file, buffer2
	sscanf buffer2,"%e", help2
	
	h.deltaE = help2 - help1
	
	FSetPos ref_file, position
	
	for(j = 0 ; j < h.nCurves ; j+= 1)
		curve_name = "curve" + num2str(j)
		Make/D/N = (h.nValues) $curve_name
		Wave w1 = $curve_name
		FReadLine /T=(num2char(13))  ref_file, buffer2
		FReadLine /T=(num2char(13))  ref_file, buffer2
		FReadLine /T=(num2char(13))  ref_file, buffer2
		FReadLine /T=(num2char(13))  ref_file, buffer2	
		
		for(i = 0 ; i < h.nValues ; i+= 1)
	
			FReadLine /T=(num2char(13))  ref_file, buffer2
			sscanf buffer2,"%f   %f", help1, help2
			w1[i] = help2
	
		endfor
		FReadLine /T=(num2char(13))  ref_file, buffer2
	endfor	
	
	Make header	// Make a wave
	StructPut /B=0 h, header
	
End

//    .................................................

Function Set_Smoothing(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			DoUpdate
			DFREF 		dfr
			Variable		i, number
			String		name1,name2
			SVAR 		list_folder 	= 	root:Specs:list_folder
			WAVE 		sw1			=	root:Load_and_Set_Panel:sw1
			WAVE/T 	ListWave = 	root:Load_and_Set_Panel:ListWave1
	
			//SetDataFolder root:Specs:
			//ControlInfo /W=# list0
			//name1 = S_DataFolder  + S_Value
			
			//WAVE/T 		ListWave = $name1
			
			Variable counter1, counter2
			Variable test2 ,j
			number = DimSize(ListWave,0) 
			counter1 = ItemsInList(list_folder)
			counter2 = DimSize(ListWave,1) 
			test2 = 0
			for(i = 0; i < number ; i += 1)
				for(j = 0; j < counter2 ; j += 1)
					if( (sw1[i][j] & 2^0) != 0 )
						test2 = i 
						break
					endif
				endfor
				if( test2 != 0 )
					break
				endif
			endfor
			
			i = test2
			
			name2 =  ListWave[i][1]
			if(	 cmpstr ( name2, "") == 0  )
				return 0
			endif
			
			DoWindow $"Smoothing_Panel"			//pulls the window to the front
			//exists 
			If(V_Flag != 0)									//checks if there is a window....
				String nameA
				nameA = ImageNameList("Smoothing_Panel#G0", "" )
				nameA = StringFromList(0, nameA)
				if( cmpstr (nameA, "")  == 1)
					RemoveImage /W=Smoothing_Panel#G0 $nameA
				endif
				nameA = ImageNameList("Smoothing_Panel#G2", "" )
				nameA = StringFromList(0, nameA)
				if( cmpstr (nameA, "")  == 1 )
					RemoveImage /W=Smoothing_Panel#G2 $nameA
				endif
				
				nameA=TraceNameList("Smoothing_Panel#G1",";",1+4)
				nameA = StringFromList(0, nameA)
				if( cmpstr (nameA, "")  == 1 )
					RemoveFromGraph /W=Smoothing_Panel#G1 $nameA
				endif
			
				nameA=TraceNameList("Smoothing_Panel#G1",";",1+4)
				nameA = StringFromList(0, nameA)
				if( cmpstr (nameA, "")  == 1 )
					RemoveFromGraph /W=Smoothing_Panel#G1 $nameA
				endif
				
				nameA=TraceNameList("Smoothing_Panel#G3",";",1+4)
				nameA = StringFromList(0, nameA)
				if( cmpstr (nameA, "")  == 1 )
					RemoveFromGraph /W=Smoothing_Panel#G3 $nameA
				endif
				
				KillWindow Smoothing_Panel
				if(DataFolderExists("root:Smoothing_Panel"))
					KillDataFolder root:Smoothing_Panel
				endif
			else 
				if( DataFolderExists("root:Smoothing_Panel" ) )
					KillDataFolder root:Smoothing_Panel
				endif
			endif
			
			//SetDataFolder root:Specs:$name2
			//WAVE Angle_2D = $name2

			
			//Variable number0
			//number0  = DimSize(Angle_2D,0)
			//name1 = StringFromList(i, list_folder)
				
			PauseUpdate; Silent 1		// building window...
			DoUpdate
			NewPanel /K=1 /W=(10,70,700,700)  /N=Smoothing_Panel
			//ControlBar/T 40
			NewDataFolder/O root:Smoothing_Panel
			SetDataFolder  root:Smoothing_Panel
			Variable /G last_slider=0
			Make/O /N=(1,1) Angle_2D_
			SetDataFolder root:Specs:$listWave[i][1]	
			Wave nwave
			SetDataFolder  root:Smoothing_Panel
			//Duplicate/O nwave , wave_FermiEdge
			Variable /G row_nr
			row_nr = i
			Final_2D(i, Angle_2D_)
			//Cut_SetEmission( i, Angle_2D_ )
			//H_B_D( i, Angle_2D_ )
			
			Variable number0
			number0  = DimSize(Angle_2D_,0)
			SetDataFolder  root:Smoothing_Panel
			WAVE Crossection1
			WAVE Crossection2
			WAVE Crossection3
			WAVE Crossection4
			WAVE Crossection5
			
			Make/O/N=(number0) Crossection1 
			Make/O/N=(number0) Crossection2 
			Make/O/N=(number0) Crossection3 
			Make/O/N=(number0) Crossection4
			Make/O/N=(number0) Crossection5
			
			Variable val1, val2 
			Variable /G flag_1 = 1
			val1 =  str2num( ListWave[i][14] ) 
			val2 =  str2num( ListWave[i][15] ) 
			
			SetDataFolder  root:Smoothing_Panel
			Duplicate Angle_2D_, Angle_2D_smoothed_x
			Duplicate Angle_2D_, Angle_dif2_2D_x
			Duplicate Angle_2D_, Angle_dif2_2D_positive_x
			
			Duplicate Angle_2D_, Angle_2D_smoothed_y
			Duplicate Angle_2D_, Angle_dif2_2D_y
			Duplicate Angle_2D_, Angle_dif2_2D_positive_y
			
			Duplicate Angle_2D_, Display1
			Duplicate Angle_2D_, Display2
			
			SetScale/P x,DimOffset(Angle_2D_ , 0), DimDelta(Angle_2D_ , 0), "", Crossection1
			SetScale/P x,DimOffset(Angle_2D_ , 0), DimDelta(Angle_2D_ , 0), "", Crossection2
			SetScale/P x,DimOffset(Angle_2D_ , 0), DimDelta(Angle_2D_ , 0), "", Crossection3
			SetScale/P x,DimOffset(Angle_2D_ , 0), DimDelta(Angle_2D_ , 0), "", Crossection4
			SetScale/P x,DimOffset(Angle_2D_ , 0), DimDelta(Angle_2D_ , 0), "", Crossection5
			
			Slider slider0,pos={70,42},size={330,20},proc=SliderProc
			Slider slider0,limits={0,DimSize(Angle_2D_,1),1},variable= root:Smoothing_Panel:K0,vert= 0,ticks= 0
			
			Slider slider1,pos={5,65},size={20,250},proc=SliderProc2
			Slider slider1,limits={0,DimSize(Angle_2D_,0),1},variable= root:Smoothing_Panel:K1,vert= 1,ticks= 0
			Slider slider1,disable=0
			
			SetVariable setvar0,pos={10,4} ,size={140,20},bodyWidth=55,proc=SetVarProc,title="Smoothing Factor \rEnergy Axis (S.E.)"  , fsize=12
			SetVariable setvar0 limits={0,inf,10}
			SetVariable setvar0,labelBack=(60928,60928,60928),value= _NUM:val1 
			
			SetVariable setvar1,pos={165,4},size={140,20},bodyWidth=55,proc=SetVarProc,title="Smoothing Factor \rAngular Axis (S.A.)" , fsize=12
			SetVariable setvar1 limits={0,inf,10}
			SetVariable setvar1,labelBack=(60928,60928,60928),value= _NUM:val2 , disable=0 
			
			SetVariable setvar2,pos={335,5},size={60,20},bodyWidth=65,proc=SetVarProc_Ef,title="Ef" , fsize=14
			SetVariable setvar2 limits={0,inf,0.1}
			SetVariable setvar2,labelBack=(60928,60928,60928),value= _NUM:str2num(ListWave[i][13])
			
			PopupMenu popup1,pos={405,5},size={60,20},proc=PopupMenu_1,fSize=16
			PopupMenu popup1,mode=1,popvalue="E. Axis",value= #"\"E. Axis;A. Axis;E.+A. Axis\""
			
			PopupMenu popup2,pos={410,35},size={60,20},proc=PopupMenu_2 ,fSize=16
			PopupMenu popup2,mode=1,popvalue="Real",value= #"\"Real;Positive\""
			
			CheckBox check1,pos={490,35},size={60,40},title="H.", proc=CheckProc_1, disable=0 
			CheckBox check1,labelBack=(47872,47872,47872),fSize=16,value=str2num(ListWave[i][16])
			
			CheckBox check2,pos={530,35},size={60,20},title="B.", proc=CheckProc_1 , disable=0
			CheckBox check2,labelBack=(47872,47872,47872),fSize=16,value=str2num(ListWave[i][17])
			
			CheckBox check3,pos={570,35},size={60,40},title="S.", proc=CheckProc_1, disable=0 
			CheckBox check3,labelBack=(47872,47872,47872),fSize=16,value=str2num(ListWave[i][18])
			
			CheckBox check4,pos={610,35},size={60,20},title="D.", proc=CheckProc_1 , disable=0
			CheckBox check4,labelBack=(47872,47872,47872),fSize=16,value=str2num(ListWave[i][19])
			
			Button Find_FE,pos={490,3},size={100,25},proc=Button_FindFermiEdge,title="Find Ef Edge"
			Button Find_FE,fSize=14
			
			Button write,pos={600,3},size={80,25},proc=Button_WriteEdge,title="Write Edge"
			Button write,fSize=14
				
			SetVariable setvar0,value= _NUM: str2num (ListWave[i][14])
			SetVariable setvar1,value= _NUM: str2num (ListWave[i][15])
			
			Variable nPointsX , nPointsY 
			WAVE w0 = Angle_2D_
			
			WAVE w1 = Angle_2D_smoothed_x
			WAVE w4 = Angle_dif2_2D_x
			WAVE w5 = Angle_dif2_2D_positive_x
			
			WAVE z1 = Angle_2D_smoothed_y
			WAVE z4 = Angle_dif2_2D_y
			WAVE z5 = Angle_dif2_2D_positive_y
			
			val1 =  str2num( ListWave[i][14] ) 
			val2 =  str2num( ListWave[i][15] ) 
			
			Smooth_2D(w1,0,val1)		
			Display1 = w1		
			Smooth_2D(z1,1,val2)
			Duplicate/O w1, w4
			Diff_2D(w4,0)
			Duplicate/O w4, w5 
			Cut_Negative_2D(w5)
			Duplicate/O z1, z4
			Diff_2D(z4,1)
			Duplicate/O z4, z5 
			Cut_Negative_2D(z5)
			Display2 = w4
					
			Display/W=(0.06,0.1,0.6,0.53)/HOST=#
			RenameWindow #,G0
			AppendImage /W=# Display1
			ModifyGraph  /W=# swapXY=1 //, noLabel(bottom)=1
			SetActiveSubwindow ##
			
			Display/W=(0.61,0.1,0.99,0.53)/HOST=# 
			RenameWindow #,G1
			AppendToGraph /W=# Crossection1
			AppendToGraph /W=# /C=(0,65535,0) Crossection4
			ModifyGraph  /W=# swapXY=1 //margin=-1, swapXY=1 , noLabel(bottom)=1 , noLabel(left)=1
			SetActiveSubwindow ##
			
			Display/W=(0.06,0.54,0.6,0.99)/HOST=# 
			RenameWindow #,G2
			AppendImage /W=# Display2
			ModifyGraph  /W=# swapXY=1//, margin=-1
			SetActiveSubwindow ##
			
			Display/W=(0.61,0.54,0.99,0.99)/HOST=# 
			RenameWindow #,G3
			AppendToGraph /W=# Crossection3
			ModifyGraph  /W=# swapXY=1 //margin=-1 //, swapXY=1 , noLabel(left)=1
			SetActiveSubwindow ##
			
			Variable pointX = ceil (DimSize(Angle_2D_smoothed_x,1)/2)
			execute/Z/Q "Cursor/W=Smoothing_Panel#G0 /P/S=0/I/H=2/C=(65280,0,0) C Display1 0,"+num2str(pointX)
			execute/Z/Q "Cursor/W=Smoothing_Panel#G2 /P/S=0/I/H=2/C=(65280,0,0) D Display2 0,"+num2str(pointX)
			Slider slider0 , value = pointX
			CursorDependencyForGraph2()
			
			Crossection1 = Display1[p][pointX]
			Crossection3 = Angle_dif2_2D_x[p][pointX]
			Crossection4 = Angle_2D_[p][pointX]
			Crossection5 = Display2[p][pointX]
	
			Variable columns 
			Variable Fermi_Energy
			Variable deltaA = DimDelta(w0,0)
			Fermi_Energy = str2num(ListWave[row_nr][13])
			columns = DimSize(w0,1)
			Make/O/N=(columns) xWave1
			Make/O/N=(columns) xWave2
			Make/O/N=(columns) yWave1
			Make/O/N=(columns) yWave2
			Make/O/N=(columns) wave_FermiEdge
			
			
			Variable centerP1, centerP2
			centerP1 = trunc(DimSize(nwave,0)/2)
			centerP2 = trunc(DimSIze(wave_FermiEdge,0)/2)
			
			if(centerP1 == centerP2)
				wave_FermiEdge[] = nwave[p]	
			endif
			if(centerP1>centerP2)
				wave_FermiEdge[] = nwave[centerP1-centerP2 + p] 
			endif
			if(centerP1<centerP2)
				wave_FermiEdge[centerP2-centerP1,centerP2+centerP1] = nwave[centerP1-centerP2+p]
				wave_FermiEdge[0,centerP2-centerP1-1] = nwave[0]
				wave_FermiEdge[centerP2+centerP1+1,inf] = nwave[DimSize(nwave,0)-1]
			endif
			
			for(i=0;i<columns;i=i+1)
				xwave1[i] = Fermi_Energy
				xwave2[i] = Fermi_Energy -  wave_FermiEdge[i]*deltaA
				ywave1[i] = DimOffset(w0,1)  + i*DimDelta(w0,1)
				ywave2[i] = DimOffset(w0,1)  + i*DimDelta(w0,1)
			endfor
			AppendToGraph /W=#G0 /C=(0,65280,0) ywave1 vs xwave1
			AppendToGraph /W=#G0 /C=(0,0,65280)ywave2 vs xwave2
			//CursorDependencyForGraph3()
			break
		endswitch
	return 0
End

Function Button_WriteEdge(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			SVAR list_folder = root:Specs:list_folder
			WAVE/T ListWave = root:Load_and_Set_Panel:ListWave1
			String name1,name2,name3, name4,name5
			name1 = ba.win
			
			Setdatafolder "root:"+name1
			NVAR row_nr
			Wave wave_FermiEdge
			WAVE Angle_2D_
			WAVE Display1, Display2
			
			WAVE w0 = Angle_2D_
			WAVE w1 = Angle_2D_smoothed_x
			WAVE w4 = Angle_dif2_2D_x
			WAVE w5 = Angle_dif2_2D_positive_x
			
			WAVE z0 = Angle_2D_
			WAVE z1 = Angle_2D_smoothed_y
			WAVE z4 = Angle_dif2_2D_y
			WAVE z5 = Angle_dif2_2D_positive_y
			NVAR row_nr
			Variable val1, val2
		
			Variable centerP1, centerP2
			Variable counter1,counter2
			
			counter1 = ItemsInList(list_folder)
			counter2 = DimSize(ListWave,1) 
			Variable first = row_nr +1
			Variable last = first
				
			Prompt first, "Nr of the First Image:"
			Prompt last, "Nr of the Last Image:"
			DoPrompt	"Enter Values",  first, last
			
			if (V_Flag)
				return 0									// user canceled
			endif
			
			first = round(first)
			if(last<first)
				return 0
			endif
			if(first<1)
				first = 1
			endif
			if(first>counter1)
				break
			endif
			if(last >counter1)
				last = counter1
			endif
			if(last <1)
				last = 1
			endif
			Variable m
			for(m = first-1;m<last;m+=1)

				SetDataFolder root:Specs:$listWave[m][1]	
				Wave nwave
				Setdatafolder "root:"+name1
				centerP2 = trunc(DimSize(nwave,0)/2)
				centerP1 = trunc(DimSIze(wave_FermiEdge,0)/2)
				nwave = 0
				if(centerP1 == centerP2)
					nwave[] = wave_FermiEdge[p]	
				endif
				if(centerP1>centerP2)
					nwave[] = wave_FermiEdge[centerP1-centerP2 + p] 
				endif
				if(centerP1<centerP2)
					nwave[centerP2-centerP1,centerP2+centerP1] = wave_FermiEdge[centerP1-centerP2+p]
					nwave[0,centerP2-centerP1-1] = wave_FermiEdge[0]
					nwave[centerP2+centerP1+1,inf] = wave_FermiEdge[DimSize(nwave,0)-1]
				endif
			
			endfor
			
			SetDataFolder root:Specs:$listWave[row_nr][1]	
			Wave nwave
			Final_2D( row_nr, Angle_2D_)	
			//Cut_SetEmission( row_nr, Angle_2D_ )
			//H_B_D( row_nr, Angle_2D_ )
			w1 = w0
			z1 = z0
			val1 =  str2num( ListWave[row_nr][14] ) 
			val2 =  str2num( ListWave[row_nr][15] ) 
			
			Smooth_2D(w1,0,val1)				
			Smooth_2D(z1,1,val2)
			Duplicate/O w1, w4
			Duplicate/O z1, z4
			Diff_2D(w4,0)
			Diff_2D(z4,1)
			Duplicate/O w4, w5 
			Duplicate/O z4, z5 
			Cut_Negative_2D(w5)
			Cut_Negative_2D(z5)
			
			Variable help1, help2
			ControlInfo popup1
			help1 = V_value
			ControlInfo popup2
			help2 = V_value
			
			switch(help1)
				case 1:
					switch(help2)
						case 1:
							Display1 = w1
							Display2 = w4
						break
						case 2:
							Display1 = w1
							Display2 = w5
						break
					endswitch
				break
				case 2:
					switch(help2)
						case 1:
							Display1 = z1
							Display2 = z4
						break
						case 2:
							Display1 = z1
							Display2 = z5
						break
					endswitch
				break
				case 3:
					switch(help2)
						case 1:
							Display1 = w1 + z1
							Display2 = w4 + z4	
						break
						case 2:
							Display1 = w1 + z1
							Display2 = w5 + z5	
						break
					endswitch
				break
			endswitch
			
			DoUpdate
			break
	endswitch

	return 0
End

Function SetVarProc_Ef(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva
	
	//if(sva.eventCode == -1)
	//	return 0
	//endif
	switch( sva.eventCode )
		case -1:
			break
		case 1: // mouse up
			Variable dval = sva.dval
			String name1
			
			WAVE/T ListWave = root:Load_and_Set_Panel:ListWave1
			name1 = sva.win
			Setdatafolder "root:"+name1
			Wave Angle_2D_
			Wave xwave1
			Wave xwave2
			Wave wave_FermiEdge
			NVAR row_nr
			Variable columns, i
			
			Variable deltaA = DimDelta(Angle_2D_,0)
			columns = DimSize(xwave1,0)
			for(i=0;i<columns;i=i+1)
				xwave1[i] = dval
				xwave2[i] = dval -  wave_FermiEdge[i]*deltaA
			endfor	
			ListWave[row_nr][13] = num2str(dval)
		break
		case 2: // Enter key
		case 3: // Live update
			WAVE/T ListWave = root:Load_and_Set_Panel:ListWave1
			dval = sva.dval
			name1 = sva.win
			Setdatafolder "root:"+name1
			Wave Angle_2D_
			Wave xwave1
			Wave xwave2
			Wave wave_FermiEdge
			NVAR row_nr
			
			deltaA = DimDelta(Angle_2D_,0)
			columns = DimSize(xwave1,0)
			for(i=0;i<columns;i=i+1)
				xwave1[i] = dval
				xwave2[i] = dval -  wave_FermiEdge[i]*deltaA
			endfor	
			ListWave[row_nr][13] = num2str(dval)
		break
	endswitch
	return 0
End

Function Button_FindFermiEdge(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			WAVE/T ListWave = root:Load_and_Set_Panel:ListWave1
			String name1,name2,name3, name4,name5
			name1 = ba.win
			Setdatafolder "root:"+name1
			NVAR row_nr
			Wave Angle_2D_
			Wave xwave1
			Wave xwave2
			Wave ywave1
			Wave ywave2
			Wave Display1
			Wave Display2
			Wave wave_FermiEdge
			
			WAVE /T W_WaveList
			name3 = name1+"#G0"
			name5 = TraceNameList(name3,";",1)
			name2 = StringFromList (0, name5, ";")
			name5 = StringFromList (1, name5, ";")
			name4 = ImageNameList(name3,";")
			name4 = StringFromList (0, name4,";")
			WAVE Crossection =TraceNameToWaveRef(name3, name2 )
			WAVE Image =  ImageNameToWaveRef(name3, name4 )
			Variable rows, columns
			Variable i, i1, i2 ,j , v_min , k , jmin
			rows = DimSize(Image,0)
			columns = DimSize(Image,1)
			Variable ic , FermiLevel
			FermiLevel = str2num(Listwave[row_nr][13])
			ic = trunc ( ( FermiLevel - DimOffset(Image,0) ) / DimDelta(Image,0) )
			i1 = ic - 100
			i2 = DimSize(Image, 0)

			Variable help1,help2
			Variable points
			points = i2-i1 + 1

			Make/Free/N=(points) Short
			
			//Make/O/N=columns 
			//Duplicate Image, Image2
			for(i=0;i<columns;i=i+1)
				Short[] = Image[p+i1][i]
				Differentiate Short
				V_min = Short[0]
				for(j=0;j<=points;j=j+1)
					help1 = Short[j]
					if(help1 < V_min)
						V_min = help1
						jmin = j
					endif		
				endfor
				wave_FermiEdge[i] = jmin
				xwave2[i] = DimOffset(Image,0)  + (i1 + jmin)*DimDelta(Image,0)
				ywave2[i] = DimOffset(Image,1)  + i*DimDelta(Image,1)
			endfor
			Variable imax, v_max
			imax = numpnts(wave_FermiEdge)
			v_max = 0
			for(i=0;i<imax;i=i+1)
				help1 = wave_FermiEdge[i]
				if( v_max < help1)
					v_max = help1
				endif
			endfor
			for(i=0;i<imax;i=i+1)
				help1 = wave_FermiEdge[i]
				wave_FermiEdge[i] = v_max - help1
			endfor
			DoUpdate
			break
	endswitch

	return 0
End

Function CheckProc_1(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	switch( cba.eventCode )
		case 2: // mouse up
			WAVE 		sw1=root:Load_and_Set_Panel:sw1
			WAVE/T 	ListWave1=root:Load_and_Set_Panel:ListWave1
			String name1
			name1 = cba.ctrlName 
			Variable checked = cba.checked
			SetDataFolder  root:Smoothing_Panel
			WAVE Angle_2D_
			WAVE Display1, Display2
			
			WAVE w0 = Angle_2D_
			WAVE w1 = Angle_2D_smoothed_x
			WAVE w4 = Angle_dif2_2D_x
			WAVE w5 = Angle_dif2_2D_positive_x
			
			WAVE z0 = Angle_2D_
			WAVE z1 = Angle_2D_smoothed_y
			WAVE z4 = Angle_dif2_2D_y
			WAVE z5 = Angle_dif2_2D_positive_y
			NVAR row_nr
			Variable val1, val2
			
			strswitch(name1)
				
				case "check1":
					if(checked)
						sw1[row_nr][16] = sw1[row_nr][16] | (2^4)
						ListWave1[row_nr][16] = num2str(1)
					else
						sw1[row_nr][16] = sw1[row_nr][16] & ~(2^4)
						ListWave1[row_nr][16] = num2str(0)
					endif
				break
				case "check2":
					if(checked)
						sw1[row_nr][17] = sw1[row_nr][17] | (2^4)
						ListWave1[row_nr][17] = num2str(1)
					else
						sw1[row_nr][17] = sw1[row_nr][17] & ~(2^4)
						ListWave1[row_nr][17] = num2str(0)
					endif	

				break
				case "check3":
					if(checked)
						sw1[row_nr][18] = sw1[row_nr][18] | (2^4)
						ListWave1[row_nr][18] = num2str(1)
					else
						sw1[row_nr][18] = sw1[row_nr][18] & ~(2^4)
						ListWave1[row_nr][18] = num2str(0)
					endif	
				break	
				case "check4":
					if(checked)
						sw1[row_nr][19] = sw1[row_nr][19] | (2^4)
						ListWave1[row_nr][19] = num2str(1)
					else
						sw1[row_nr][19] = sw1[row_nr][19] & ~(2^4)
						ListWave1[row_nr][19] = num2str(0)
					endif	
				break
			endswitch
			
			Final_2D( row_nr, Angle_2D_)
			//Variable flag_straight
			//Cut_SetEmission( row_nr, Angle_2D_ )
			//flag_straight = str2num( ListWave1[row_nr][18] )
			//if(flag_straight)
			//	Straight_2D( row_nr, Angle_2D_ )
			//endif
			//H_B_D( row_nr, Angle_2D_ )
			w1 = w0
			z1 = z0
			val1 =  str2num( ListWave1[row_nr][14] ) 
			val2 =  str2num( ListWave1[row_nr][15] ) 
			
			Smooth_2D(w1,0,val1)				
			Smooth_2D(z1,1,val2)
			Duplicate/O w1, w4
			Duplicate/O z1, z4
			Diff_2D(w4,0)
			Diff_2D(z4,1)
			Duplicate/O w4, w5 
			Duplicate/O z4, z5 
			Cut_Negative_2D(w5)
			Cut_Negative_2D(z5)
			
			Variable help1, help2
			ControlInfo popup1
			help1 = V_value
			ControlInfo popup2
			help2 = V_value
			
			switch(help1)
				case 1:
					switch(help2)
						case 1:
							Display1 = w1
							Display2 = w4
						break
						case 2:
							Display1 = w1
							Display2 = w5
						break
					endswitch
				break
				case 2:
					switch(help2)
						case 1:
							Display1 = z1
							Display2 = z4
						break
						case 2:
							Display1 = z1
							Display2 = z5
						break
					endswitch
				break
				case 3:
					switch(help2)
						case 1:
							Display1 = w1 + z1
							Display2 = w4 + z4	
						break
						case 2:
							Display1 = w1 + z1
							Display2 = w5 + z5	
						break
					endswitch
				break
			endswitch
	
		break
	endswitch
	DoUpdate
	return 0
End

Function Smooth_2D(wave1, dim, SF)
	Wave wave1
	Variable dim 
	Variable SF
	
	Variable i
	Variable size1, size2
	
	switch(dim)
		case 0:
			if(SF>0)
				size1 = DimSize(wave1,1)
				size2 = DimSize(wave1,0)
				Make /FREE /N=(size2) v1 
				for(i = 0; i <size1;i+=1)	// Initialize variables;continue test
					v1 =  wave1[p][i]
					Smooth SF , v1
					wave1[][i] = v1[p]
				endfor
			else
				return -1
			endif
		break
		
		case 1:
			if(SF>0)
				size1 = DimSize(wave1,0)
				size2 = DimSize(wave1,1)
				Make /FREE /N=(size2) v1 
				for(i = 0; i <size1;i+=1)	// Initialize variables;continue test
					v1 =  wave1[i][p]
					Smooth SF , v1
					wave1[i][] = v1[q]
				endfor
			endif
		break
	endswitch
	return 0
End

Function Diff_2D(wave1, dim)
	Wave wave1
	Variable dim 
	Variable SF
	
	Variable i
	Variable size1, size2
	
	switch(dim)
		case 0:
			size1 = DimSize(wave1,1)
			size2 = DimSize(wave1,0)
			Make /FREE /N=(size2) v1 
			for(i = 0; i <size1;i+=1)	// Initialize variables;continue test
				v1 =  wave1[p][i]
				Differentiate v1
				Differentiate v1
				wave1[][i] = -v1[p]
			endfor
		break
		
		case 1:
			size1 = DimSize(wave1,0)
			size2 = DimSize(wave1,1)
			Make /FREE /N=(size2) v1 
			for(i = 0; i <size1;i+=1)	// Initialize variables;continue test
				v1 =  wave1[i][p]
				Differentiate v1
				Differentiate v1
				wave1[i][] = -v1[q]
			endfor
		break
	endswitch
	return 0
End

Function Cut_Negative_2D(wave1)
	Wave wave1
	
	Variable i , j , help1
	Variable size1, size2
	size1 = DimSize(wave1,0)
	size2 = DimSize(wave1,1)
	for(i=0;i<size1;i+=1)
		for(j=0;j<size2;j+=1)
			help1 = wave1[i][j]
			if(help1<0)
				wave1[i][j] = 0
			endif
		endfor
	endfor
	return 0
End

Function PopupMenu_1(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa

	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			
			SetDataFolder  root:Smoothing_Panel
			WAVE Display1, Display2
			WAVE w1 = Angle_2D_smoothed_x
			WAVE z1 = Angle_2D_smoothed_y
			WAVE w4 = Angle_dif2_2D_x
			WAVE z4 = Angle_dif2_2D_y
			WAVE w5 = Angle_dif2_2D_positive_x
			WAVE z5 = Angle_dif2_2D_positive_y
			
			Variable help1 , help2			
			ControlInfo popup2
			help2 = V_value
			switch(popNum)
				case 1:
					switch(help2)
						case 1:
							Display1 = w1
							Display2 = w4  
						break
						case 2:
							Display1 = w1
							Display2 = w5  	
						break
					endswitch
				break
				case 2:
					switch(help2)
						case 1:
							Display1 = z1
							Display2 = z4  
						break
						case 2:
							Display1 = z1
							Display2 = z5  	
						break
					endswitch
				break
				case 3:
					switch(help2)
						case 1:
							Display1 = w1 + z1 
							Display2 = w4 + z4 
						break
						case 2:
							Display1 = w1 + z1 
							Display2 = w5 + z5  	
						break
					endswitch
				break
			endswitch	
		break
	endswitch

	return 0
End

Function PopupMenu_2(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa

	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			
			SetDataFolder  root:Smoothing_Panel
			WAVE Display1, Display2
			WAVE w1 = Angle_2D_smoothed_x
			WAVE z1 = Angle_2D_smoothed_y
			WAVE w4 = Angle_dif2_2D_x
			WAVE z4 = Angle_dif2_2D_y
			WAVE w5 = Angle_dif2_2D_positive_x
			WAVE z5 = Angle_dif2_2D_positive_y
			
			Variable help1 , help2			
			ControlInfo popup1
			help2 = V_value
			switch(popNum)
				case 1:
					switch(help2)
						case 1:
							Display1 = w1
							Display2 = w4  
						break
						case 2:
							Display1 = z1
							Display2 = z4  	
						break
						case 3:
							Display1 = w1 + z1 
							Display2 = w4 + z4 
						break
					endswitch
				break
				case 2:
					switch(help2)
						case 1:
							Display1 = w1
							Display2 = w5  
						break
						case 2:
							Display1 = z1
							Display2 = z5  	
						break
						case 3:
							Display1 = w1 + z1 
							Display2 = w5 + z5 
						break
					endswitch
				break
			endswitch	
		break
	endswitch

	return 0
End

Function ButtonProc_RemoveHotPix2(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Variable i,j
			Variable Rows, Columns
			Variable Average1,Average2
			Variable help1 , Columns1
			Wave v1,v2
			Variable number
			WAVE/T ListWave 	= 	root:Load_and_Set_Panel:ListWave1	
			WAVE sw1			=	root:Load_and_Set_Panel:sw1		
			String name2
			Variable counter1, counter2
			Variable test2
			
			number = DimSize(ListWave,0) 
			number = DimSize(ListWave,0) 
			counter2 = DimSize(ListWave,1) 
			test2 = 0
			for(i = 0; i < number ; i += 1)
				for(j = 0; j < counter2 ; j += 1)
					if( (sw1[i][j] & 2^0) != 0 )
						test2 = i 
						break
					endif
				endfor
				if( test2 != 0 )
					break
				endif
			endfor
			
			i = test2
				
			name2 =  ListWave[i][1]
			if(	 cmpstr ( name2, "") == 0  )
				return 0
			endif
			
			//SetDataFolder root:Specs:$name2
			//WAVE ori_wave = $name2
			NewDataFolder/O root:HotPixels
			SetDataFolder  root:HotPixels
			
			String name3 = "root:HotPixels:\'" +name2 + "\'"
			Cut_Frame_2D( i, name3 )
			SetDataFolder  root:HotPixels
			WAVE ori_wave = $name2
			
			Rows = DimSize(ori_wave, 0 )
			Columns = DimSize(ori_wave, 1 )
			Columns1 = Columns -1
			
			KillWaves v1,v2
			
			NewDataFolder/O root:HotPixels
			SetDataFolder  root:HotPixels
			
			Make/O/N =(Rows)  Crossection1
			Make/O/N =(Rows)  Crossection2
			Make/O/N =(Rows)  v1 
			Make/O/N =(Rows)  v2 
			
			Duplicate/O ori_wave, wave0
			Duplicate/O ori_wave, wave1
			Duplicate/O ori_wave, wave2
			Duplicate/O ori_wave, wave3
			
			Variable nPointsX , nPointsY 
			nPointsX = DimSize(wave0,0)
			nPointsY = DimSize(wave0,1)
			Make/O/N =(nPointsX)  v1 
			Make/O/N =(nPointsY)  v2 
			for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
				v1 =  wave0[p][i]
				Differentiate v1
				Differentiate v1
				wave2[][i] = -v1[p]
			endfor
			
			for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
				v2 =  wave0[i][p]
				Differentiate v2
				Differentiate v2
				wave3[i][] = -v2[q]		
			endfor
			KillWaves v1,v2
			
			Variable val1, val2 
			
			val1 =  30
			val2 =  0
			nPointsX = DimSize(ori_wave,0)
			nPointsY = DimSize(ori_wave,1)
			Make/O/N =(nPointsX)  v1 
			Make/O/N =(nPointsY)  v2 
					
			//if(val1 > 0 )
			//	for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
			//		v1 =  wave1[p][i]
			//		Smooth val1 , v1
			//		wave1[][i] = v1[p]
			//	endfor
			//endif
					
			//if(val2 > 0 )
			//	for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
			//		v2 =  wave1[i][p]
			//		Smooth val2 , v2
			//		wave1[i][] = v2[q]
			//	endfor
			//endif
			KillWaves v1,v2
			KillWaves ori_wave
			String /G Memory1 
			Variable 	/G start1
			Variable 	/G end1
			Memory1 = "root:Specs:" + name2
			DoWindow/F $"HotPixels"			//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow $"Profiles_FinalBlend"
			//endif
			//------------display the results
			if (V_Flag==1)	
				
			else
				Display/K=1 /W=(400,80,1000,550)
				Dowindow/C $"HotPixels"	
				
				AppendImage /L=bottomImage /B=leftImage wave1
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				
				ControlBar/L 160
				ControlBar/T 105
				
				DoUpdate 
				ModifyGraph margin =40
				ModifyGraph margin(right) =20
				ModifyGraph margin(top) =10
				ModifyGraph margin(bottom)=20
				ModifyGraph mode=2,rgb=(0,0,0)
				DoUpdate 
				//ModifyGraph freePos(leftImage)={0.1,kwFraction}
				//ModifyGraph freePos(bottomImage)={0.1,kwFraction}
				ModifyGraph freePos(leftImage)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage)={0.1,0.6}
				ModifyGraph axisEnab(leftImage)={0.1,1}
				
				DoUpdate 	
				
				AppendToGraph /L=bottomC /B=leftC Crossection1 Crossection2
				ModifyGraph freePos(leftC)={0.1,kwFraction}
				ModifyGraph freePos(bottomC)={0.75,kwFraction}
				ModifyGraph axisEnab(bottomC)={0.1,1}
				ModifyGraph axisEnab(leftC)={0.75,1}
				
				Slider Line1 , pos={100,120} , size={10,400} , proc=moveLine1def , live=1
				Slider Line1 , limits = { 0 , ( DimSize(wave0,0) - 1 ) , 1 } , value= 0 , side= 0 , vert= 1 , ticks= 0
				
				Slider Line2 , pos={135,120} , size={10,400} , proc=moveLine2def , live=1
				Slider Line2 , limits = { 0 , ( DimSize(wave0,0) - 1 ) , 1 } , value= 0 , side= 0 , vert= 1 , ticks= 0
				
				Slider Line3 , pos={250,85} , size={300,13} , proc=moveLine4def , live=1
				Slider Line3 , limits = { 0 , ( DimSize(wave0,1) - 1 ) , 1 } , value= 0 , side= 0 , vert= 0 , ticks= 0
				
				ValDisplay Position1, pos={5,120} , value=0,   title="Pos.",size={80,20},value=0,frame=1,fSize=14
				ValDisplay Position2, pos={5,140} , value=0,  title="unit", size={80,20},value=0,frame=1,fSize=14
				ValDisplay Position3, pos={5,160} , value=0,   title="Pos.",size={80,20},value=0,frame=1,fSize=14
				ValDisplay Position4, pos={5,180} , value=0,  title="unit", size={80,20},value=0,frame=1,fSize=14
				
				Wavestats/Q/Z wave0
				
				TitleBox zmin title="Min",pos={185,35}
				Slider contrastmin,vert= 0,pos={220,35},size={290,16},proc=contrast0
				Slider contrastmin,limits={V_min,V_max,0},ticks= 0,value=V_min
			
				TitleBox zmax title="Max",pos={185,5}
				Slider contrastmax,vert= 0,pos={220,5},size={290,16},proc=contrast0
				Slider contrastmax,limits={V_min,V_max,0},ticks= 0,value=V_max
				
				String listColors 
				listColors = CTabList()
				PopupMenu popup0,pos={10,70},size={45,20},proc=ChangeColor2
				PopupMenu popup0,mode=1,popvalue="Grays",value= "*COLORTABLEPOP*"
				//PopupMenu popup0,mode=1,popvalue="Grays",value= #"\"Grays;VioletOrangeYellow\""
				
				Button RemoveB,pos={5,220},size={85,40},proc=RemoveHotPixels,title="Remove\r Hot Pixels"
				Button RemoveB,fSize=14
				
				Button RemoveBAll,pos={5,460},size={85,60},proc=ApplyHotPixels,title="Remove\r Hot Pixels\rfor All"
				Button RemoveBAll,fSize=14,disable=0
				
				DoUpdate 
				GetWindow $"HotPixels" wavelist
			endif
		break
	endswitch

	return 0
End

Function ButtonProc_RemoveHotPix(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Variable i,j
			Variable Rows, Columns
			Variable Average1,Average2
			Variable help1 , Columns1
			Wave v1,v2
			Variable number
			WAVE/T ListWave 	= 	root:Load_and_Set_Panel:ListWave1	
			WAVE sw1			=	root:Load_and_Set_Panel:sw1		
			String name2
			Variable counter1, counter2
			Variable test2
			
			number = DimSize(ListWave,0) 
			number = DimSize(ListWave,0) 
			counter2 = DimSize(ListWave,1) 
			test2 = 0
			for(i = 0; i < number ; i += 1)
				for(j = 0; j < counter2 ; j += 1)
					if( (sw1[i][j] & 2^0) != 0 )
						test2 = i 
						break
					endif
				endfor
				if( test2 != 0 )
					break
				endif
			endfor
			
			i = test2
				
			name2 =  ListWave[i][1]
			if(	 cmpstr ( name2, "") == 0  )
				return 0
			endif
			
			//SetDataFolder root:Specs:$name2
			//WAVE ori_wave = $name2
			NewDataFolder/O root:HotPixels
			SetDataFolder  root:HotPixels
			
			String name3 = "root:Defect_Removal_Tool:\'" +name2 + "\'"
			Cut_Frame_2D( i, name3 )
			SetDataFolder  root:Defect_Removal_Tool
			WAVE ori_wave = $name2
			
			Rows = DimSize(ori_wave, 0 )
			Columns = DimSize(ori_wave, 1 )
			Columns1 = Columns -1
			
			KillWaves v1,v2
			
			NewDataFolder/O root:HotPixels
			SetDataFolder  root:HotPixels
			
			Make/O/N =(Rows)  Crossection1
			Make/O/N =(Rows)  Crossection2
			Make/O/N =(Rows)  v1 
			Make/O/N =(Rows)  v2 
			
			Duplicate/O ori_wave, wave0
			Duplicate/O ori_wave, wave1
			
			//Duplicate/O Angle_2D , Angle_2D_smoothed
			
			Variable nPointsX , nPointsY 
			Variable val1, val2 
			
			val1 =  30
			val2 =  0
			nPointsX = DimSize(ori_wave,0)
			nPointsY = DimSize(ori_wave,1)
			Make/O/N =(nPointsX)  v1 
			Make/O/N =(nPointsY)  v2 
					
			if(val1 > 0 )
				for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
					v1 =  wave1[p][i]
					Smooth val1 , v1
					wave1[][i] = v1[p]
				endfor
			endif
					
			if(val2 > 0 )
				for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
					v2 =  wave1[i][p]
					Smooth val2 , v2
					wave1[i][] = v2[q]
				endfor
			endif
			KillWaves v1,v2
			
			String /G Memory1 
			Variable 	/G start1
			Variable 	/G end1
			Memory1 = "root:Specs:" + name2
			DoWindow/F $"HotPixels"			//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow $"Profiles_FinalBlend"
			//endif
			//------------display the results
			if (V_Flag==1)	
				
			else
				Display/K=1 /W=(400,80,1000,550)
				Dowindow/C $"HotPixels"	
				
				AppendImage /L=bottomImage /B=leftImage wave0
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				
				ControlBar/L 160
				ControlBar/T 105
				
				DoUpdate 
				ModifyGraph margin =40
				ModifyGraph margin(right) =20
				ModifyGraph margin(top) =10
				ModifyGraph margin(bottom)=20
				ModifyGraph mode=2,rgb=(0,0,0)
				DoUpdate 
				//ModifyGraph freePos(leftImage)={0.1,kwFraction}
				//ModifyGraph freePos(bottomImage)={0.1,kwFraction}
				ModifyGraph freePos(leftImage)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage)={0.1,0.6}
				ModifyGraph axisEnab(leftImage)={0.1,1}
				
				DoUpdate 	
				
				AppendToGraph /L=bottomC /B=leftC Crossection1 Crossection2
				ModifyGraph freePos(leftC)={0.1,kwFraction}
				ModifyGraph freePos(bottomC)={0.75,kwFraction}
				ModifyGraph axisEnab(bottomC)={0.1,1}
				ModifyGraph axisEnab(leftC)={0.75,1}
				
				Slider Line1 , pos={100,120} , size={10,400} , proc=moveLine1def , live=1
				Slider Line1 , limits = { 0 , ( DimSize(wave0,0) - 1 ) , 1 } , value= 0 , side= 0 , vert= 1 , ticks= 0
				
				Slider Line2 , pos={135,120} , size={10,400} , proc=moveLine2def , live=1
				Slider Line2 , limits = { 0 , ( DimSize(wave0,0) - 1 ) , 1 } , value= 0 , side= 0 , vert= 1 , ticks= 0
				
				Slider Line3 , pos={250,85} , size={300,13} , proc=moveLine4def , live=1
				Slider Line3 , limits = { 0 , ( DimSize(wave0,1) - 1 ) , 1 } , value= 0 , side= 0 , vert= 0 , ticks= 0
				
				ValDisplay Position1, pos={5,120} , value=0,   title="Pos.",size={80,20},value=0,frame=1,fSize=14
				ValDisplay Position2, pos={5,140} , value=0,  title="unit", size={80,20},value=0,frame=1,fSize=14
				ValDisplay Position3, pos={5,160} , value=0,   title="Pos.",size={80,20},value=0,frame=1,fSize=14
				ValDisplay Position4, pos={5,180} , value=0,  title="unit", size={80,20},value=0,frame=1,fSize=14
				
				Wavestats/Q/Z wave0
				
				TitleBox zmin title="Min",pos={185,35}
				Slider contrastmin,vert= 0,pos={220,35},size={290,16},proc=contrast0
				Slider contrastmin,limits={V_min,V_max,0},ticks= 0,value=V_min
			
				TitleBox zmax title="Max",pos={185,5}
				Slider contrastmax,vert= 0,pos={220,5},size={290,16},proc=contrast0
				Slider contrastmax,limits={V_min,V_max,0},ticks= 0,value=V_max
				
				String listColors 
				listColors = CTabList()
				PopupMenu popup0,pos={10,70},size={45,20},proc=ChangeColor2
				PopupMenu popup0,mode=1,popvalue="Grays",value= "*COLORTABLEPOP*"
				//PopupMenu popup0,mode=1,popvalue="Grays",value= #"\"Grays;VioletOrangeYellow\""
				
				Button RemoveB,pos={5,220},size={85,40},proc=RemoveHotPixels,title="Remove\r Hot Pixels"
				Button RemoveB,fSize=14
				
				Button RemoveBAll,pos={5,460},size={85,60},proc=RemoveHotPixelsAll,title="Remove\r Hot Pixels\rfor All"
				Button RemoveBAll,fSize=14,disable=0
				
				DoUpdate 
				GetWindow $"HotPixels" wavelist
			endif
		break
	endswitch

	return 0
End

Function ApplyHotPixels(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			NVAR flag_hotpix = root:Load_and_Set_Panel:flag_hotpix
			 flag_hotpix = 1
		break
	endswitch
	
	return 0
End

Function RemoveHotPixels(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			DoWindow/F HotPixels			//pulls the window to the front
			If(V_flag != 0)	
				RemoveImage /W=HotPixels wave1	
				RemoveFromGraph /W=HotPixels Crossection1
				RemoveFromGraph /W=HotPixels Crossection2
				//KillWindow Defect_Removal_Tool	
				KillDataFolder root:HotPixels
			endif
			
		break
	
		case 2: // mouse up
			// click code here
			String name1,name2,name3, name4 , name6
			Setdatafolder root:Load_and_Set_Panel:
			WAVE /T W_WaveList
			name3 = ba.win
			GetWindow $name3 , wavelist
			//name2 = W_WaveList[1][0]
			//name4 = W_WaveList[0][0]
			name2 = TraceNameList("#",";",1)
			name2 = StringFromList (0, name2, ";")
			name4 = ImageNameList("#",";")
			name4 = StringFromList (0, name4,";")
			WAVE Crossection =TraceNameToWaveRef("", name2 )
			WAVE Image =  ImageNameToWaveRef("", name4 )
			name6 = ba.win
			Setdatafolder root:$name6
			WAVE wave0
			WAVE wave1
			WAVE wave2
			WAVE wave3
			
			Variable rows, columns
			Variable i, i1, i2 ,j , v_min , k
			rows = DimSize(Image,0)
			columns = DimSize(Image,1)
			//if (strlen(csrinfo(A,""))==0)
			//	break
			//endif
			//if (strlen(csrinfo(B,""))==0)
			//	break
			//endif
			//i1 = pcsr(A,"#")
			//i2 = pcsr(B,"#")
			//if(i1>i2)
			//	i2 = pcsr(A,"#")
			//	i1 = pcsr(B,"#")
			//endif

			//NVAR start1 = root:HotPixels:start1
			//NVAR end1 = root:HotPixels:end1
			//start1 = i1
			//end1  = i2
			
			//Duplicate Image, Image2
			//Variable factor1, factor2 , factor3 , help3
			//factor1 = 0.20
			//factor2 = factor1 + 1
			//factor3 = 1 - factor1
			//for(i=0;i<columns;i=i+1)
			//	for(j=i1;j<i2;j=j+1)
			//		help2 = Image[j][i]
			//		help1 = Image2[j][i]
			//		help3 = help2/help1
			//		if(help2 > help1)
			//			if(help3 > factor2 )
			//				Image[j][i] = 	help1	
			//			endif
			//		else
			//			if(help3 < factor3 )
			//				Image[j][i] = 	help1	
			//			endif		 	
			//		endif		
			//	endfor
			//endfor 
			//WAVE W_ImageHist
			
			Variable help1,help2 ,help3 , help4,help5
			ImageHistogram  wave2
			WAVE W_ImageHist
			Duplicate/O W_ImageHist , hist1
			ImageHistogram  wave3
			Duplicate/O W_ImageHist , hist2
			
			Variable threshold1,threshold2 , n_pix , index0 , index1, index2 , val1, val2
			n_pix = numpnts(hist1)
			index0 = round(abs(DimOffset(hist1,0)/DimDelta(hist1,0)))
			for(i = index0;i<n_pix;i+=1)
				help1 = hist1[i]
				if(hist1[i]==0)
					break
				endif
			endfor
			index1= i
			val1 = DimOffset(hist1,0) + DimDelta(hist1,0)*index1
			
			n_pix = numpnts(hist2)
			index0 = round(abs(DimOffset(hist2,0)/DimDelta(hist2,0)))
			for(i = index0;i<n_pix;i+=1)
				if(hist2[i]==0)
					break
				endif
			endfor
			index2= i
			val2 = DimOffset(hist2,0) + DimDelta(hist2,0)*index2
			
			wave1 = wave0
			Variable nPointsX , nPointsY 
			nPointsX = DimSize(wave0,0) -1
			nPointsY = DimSize(wave0,1) 
			Make/O/N =(nPointsX)  v1 
			Make/O/N =(nPointsY)  v2 
			for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
				for(j=1;j<nPointsX;j+=1)
					help1 = wave2[j][i]
					help2 = wave2[j+1][i]
					help3 = wave2[j-1][i]
					help4 = wave1[j-1][i]
					help5 = wave1[j+1][i]
					if(help1>val1 )
						if(help2<=val1)
							if(help3<=val1)
								if(help4<help5)
									wave1[j][i] = wave1[j-1][i]
								else
									wave1[j][i] = wave1[j+1][i]
								endif
							else
								wave1[j][i] = wave1[j+1][i]
							endif
						else
							if(help3<=val1)
								wave1[j][i] = wave1[j-1][i]
							else
									
							endif
							
						//wave1[j][i] = wave1[j-1][i]
						endif
						
					endif
				endfor	
			endfor
			
			nPointsX = DimSize(wave0,0) 
			nPointsY = DimSize(wave0,1) -1 
			for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
				for(j=1;j<nPointsY;j+=1)
					help1 = wave3[i][j]
					help2 = wave3[i][j+1]
					help3 = wave3[i][j-1]
					help4 = wave1[i][j-1]
					help5 = wave1[i][j+1]
					if(help1>val2 )
						if(help2<=val2)
							if(help3<=val2)
								if(help4<help5)
									wave1[i][j] = wave1[i][j-1]
								else
									wave1[i][j] = wave1[i][j+1]
								endif
							else
								wave1[i][j] = wave1[i][j+1]
							endif
						else
							if(help3<=val2)
								wave1[i][j] = wave1[i][j-1]
							else
									
							endif	
						endif	
					endif
				endfor
			endfor
			KillWaves v1,v2
			
			//Crossection[] = Image[p][qcsr(B,"#")]
			Button RemoveBAll,disable=0
			DoUpdate
			break
	endswitch

	return 0
End

Function RemoveHotPixelsAll(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			SetDataFolder root:Specs:
			SVAR list_folder //= root:Specs:list_folder
			
			String name6
			name6 = ba.win
			SetDataFolder root:$name6
			//WAVE temporary1
			String name1, name2
			name1 = "root:"+name6+":start1"
			name2 = "root:"+name6+":end1"
			NVAR start1 = $name1
			NVAR end1 = $name2
			WAVE/T ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
			//WAVE nwave
			Variable number1
			number1 = ItemsInList( list_folder ) 
			Variable j , k
			
			Variable startingN = 1
			Variable endAt =number1
			
			Prompt startingN, "Start From:"
			Prompt endAt,"End At:"
			DoPrompt "Choose:  Starting Number and End Number",startingN,endAt
			if (V_Flag)
				return 0									// user canceled
			endif
			
			for( k = startingN -1; k<(endAt) ;k =k +1 )
				//ListWave1[j][column]  = num2str (offset + delta*j)
				//help1 =  str2num (listWave[row][2])
				//if( abs ( Smooth1 - help1 ) > 0.01 )
				//	Smooth1 = str2num (listWave[row][2])
				name1 = listWave1[k][1]
				name2 = "root:Specs:" + name1 
				SetDataFolder root:Specs:$listWave1[k][1]
				
				WAVE Image1 = $name1
				Variable rows, columns
				rows = DimSize(Image1,0)
				columns = DimSize(Image1,1)
				Make/O/N =(rows)  v1 
				Make/O/N =(columns)  v2 
				Wave v1
				Wave v2
				
				Duplicate /FREE Image1 , Image2
				
				Variable i, i1, i2 , v_min , jmin
				Variable help1,help2
				
				i1 = start1
				i2 = end1
				
				Variable nPointsX , nPointsY 
				Variable val1, val2 
			
				val1 =  30
				val2 =  0
				nPointsX = DimSize(Image1,0)
				nPointsY = DimSize(Image1,1)
				Make/O/N =(nPointsX)  v1 
				Make/O/N =(nPointsY)  v2 
					
				if(val1 > 0 )
					for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
						v1 =  Image2[p][i]
						Smooth val1 , v1
						Image2[][i] = v1[p]
					endfor
				endif
					
				if(val2 > 0 )
					for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
						v2 =  Image2[i][p]
						Smooth val2 , v2
						Image2[i][] = v2[q]
					endfor
				endif
				
				Variable factor1, factor2 , factor3 , help3
				factor1 = 0.20
				factor2 = factor1 + 1
				factor3 = 1 - factor1
				for(i=0;i<columns;i=i+1)
					for(j=i1;j<i2;j=j+1)
						help2 = Image1[j][i]
						help1 = Image2[j][i]
						help3 = help2/help1
						if(help2 > help1)
							if(help3 > factor2 )
								Image1[j][i] = help1	
							endif
						else
							if(help3 < factor3 )
								Image1[j][i] = help1	
							endif		 	
						endif		
					endfor
				endfor
				Set_Angle_2D( k )
			endfor
			KillWaves v1,v2
		break
	endswitch

	return 0
End

Function moveLine4def(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			//Print sa
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1
				String name2 , name3 , name4 , name5 , name6
				WAVE /T W_WaveList
				//WAVE Crossection1
				
				name1 = ImageNameList("", "" )
				name1 = StringFromList (0, name1  , ";")
				
				name3 = sa.win
				GetWindow $name3 , wavelist
				//name2 = W_WaveList[1][0]
				//name4 = W_WaveList[0][0]
				name2 = TraceNameList("#",";",1)
				name5 = StringFromList (1, name2, ";")
				name2 = StringFromList (0, name2, ";")
				name4 = ImageNameList("#",";")
				name4 = StringFromList (0, name4,";")
				//name4 = GetWavesDataFolder($name2, 1 )
				WAVE Crossection =TraceNameToWaveRef("", name2 )
				WAVE Crossection2 =TraceNameToWaveRef("", name5 )
				WAVE Image =  ImageNameToWaveRef("", name4 )
				name6 = sa.win
				Setdatafolder root:$name6
				WAVE Image2 =  wave1
				//name2 = TraceNameList("",";",0)
				
				DoUpdate
				//Setdatafolder root:Specs:
				
				//WAVE EDC=EDC
				
				
				if (strlen(csrinfo(A,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 A "+name1+" 0,0"
					//ValDisplay Position2,value=_NUM:vcsr(A,"")
					//ValDisplay Position1,value=_NUM:curval
				endif
				if (strlen(csrinfo(B,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 B "+name1+" 0,0"
					//ValDisplay Position2,value=_NUM:vcsr(A,"")
					//ValDisplay Position1,value=_NUM:curval
				endif
				
				if (cmpstr(sa.ctrlName,"Line3")==0)
					//VCS = Image1[p][curval]
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 A "+name1+" pcsr(A,\"\"),"+num2str(curval)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 B "+name1+" pcsr(B,\"\"),"+num2str(curval)
					
					//Crossection[] = Image[p][curval]
					//ValDisplay Position1,value=_NUM:curval
					//ValDisplay Position2,value=_NUM:vcsr(A,"")
					
				endif
				
			endif
			
			if( sa.eventCode  == 4 ) // mouse up
				Setdatafolder root:Specs:
				WAVE /T W_WaveList
				name3 = sa.win
				GetWindow $name3 , wavelist
				//name2 = W_WaveList[1][0]
				//name4 = W_WaveList[0][0]
				name2 = TraceNameList("#",";",1)
				name5 = StringFromList (1, name2, ";")
				name2 = StringFromList (0, name2, ";")
				name4 = ImageNameList("#",";")
				name4 = StringFromList (0, name4,";")
				WAVE Crossection =TraceNameToWaveRef("", name2 )
				WAVE Crossection2 =TraceNameToWaveRef("", name5 )
				WAVE Image =  ImageNameToWaveRef("", name4 )
				name6 = sa.win
				Setdatafolder root:$name6
				WAVE Image2 =  wave1
				
				if (strlen(csrinfo(A,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 A "+name1+" 0,0"
					//ValDisplay Position2,value=_NUM:vcsr(A,"")
					//ValDisplay Position1,value=_NUM:curval
				endif
				if (strlen(csrinfo(B,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 B "+name1+" 0,0"
					//ValDisplay Position2,value=_NUM:vcsr(A,"")
					//ValDisplay Position1,value=_NUM:curval
				endif
				Crossection[] = Image[p][qcsr(B,"#")]
				Crossection2[] = Image2[p][qcsr(B,"#")]
				DoUpdate
			
			endif
		break
	endswitch

	return 0
End

Function CursorDependencyForGraph2()
	String graphName = WinName(0,64)
	
	GetWindow $graphName activeSW
	String graphName1= "G0"
	String graphName2= "G2"
	if( strlen(graphName) )
		String df= GetDataFolder(1);
		NewDataFolder/O root:WinGlobals
		NewDataFolder/O/S root:WinGlobals:$graphName1
 		String/G S_CursorCInfo
		Variable/G dependentC
		SetFormula dependentC, "CursorMoved2(S_CursorCInfo,\"G0\")"
		
		NewDataFolder/O/S root:WinGlobals:$graphName2
		String/G S_CursorDInfo
 		Variable/G dependentD
		SetFormula dependentD, "CursorMoved2(S_CursorDInfo,\"G2\")"
		
		SetDataFolder df
	endif
End

Function CursorDependencyForGraph3()
	String graphName = WinName(0,1)
	
	GetWindow $graphName activeSW
	String graphName2= "G2"
	if( strlen(graphName) )
		String df= GetDataFolder(1);
		NewDataFolder/O root:WinGlobals
		
		NewDataFolder/O/S root:WinGlobals:$graphName2
		String/G S_CursorDInfo
 		Variable/G dependentD
		SetFormula dependentD, "CursorMoved3(S_CursorDInfo,\"G2\")"
		SetDataFolder df
	endif
End

Function CursorMoved2(info,name)
	String info
	String name
	
	Variable result= NaN			// error result
	// Check that the top graph is the one in the info string.
	String topGraph= name
	String name2 = WinName(0,64)
	String graphName= StringByKey("GRAPH", info)
	GetWindow $name2 activeSW
	String name3 = name2 +"#"+topGraph
	if( CmpStr(name3, S_value) == 0 )
		if( CmpStr(graphName, topGraph) == 0 )
			// If the cursor is being turned off
			// the trace name will be zero length.
			String tName= StringByKey("TNAME", info)
			if( strlen(tName) )			// cursor still on
				String df= GetDataFolder(1);
				Variable iVal , xVal , jVal
				SetDataFolder root:Smoothing_Panel:
				NVAR last_slider
				strswitch(topGraph)
					case "G0":
						WAVE wave0 = Angle_2D_
						WAVE wave1 = $tName
						WAVE wave2 = Display2

						WAVE wave3 = Crossection1
						WAVE wave4 = Crossection3
						WAVE wave5 = Crossection4
						iVal = qcsr(C)
						jVal = pcsr(C)
						xVal = vcsr (C)
						if(!last_slider)
							wave3[] = wave1[p][iVal]
							wave4[] = wave2[p][iVal]
							wave5[] = wave0[p][iVal]
							execute/Z/Q "Cursor/W=Smoothing_Panel#G2 /P/S=0/I/H=2/C=(65280,0,0) D Display2 0,"+num2str(iVal)
							Slider slider0 , value = iVal
						else
							wave3[] = wave1[jVal][p]
							wave4[] = wave2[jVal][p]
							wave5[] = wave0[jVal][p]
							execute/Z/Q "Cursor/W=Smoothing_Panel#G2 /P/S=0/I/H=3/C=(65280,0,0) D Display2 "+num2str(jVal) + ",0"
							Slider slider1 , value = jVal
						endif
						break
					case "G2":
						WAVE wave1 = Display1
						WAVE wave2 = $tName
						WAVE wave0 = Angle_2D_
						
						WAVE wave3 = Crossection1
						WAVE wave4 = Crossection3
						WAVE wave5 = Crossection4
						iVal = qcsr(D)
						jVal = pcsr(D)
						xVal = vcsr (D)
						if(!last_slider)
							wave3[] = wave1[p][iVal]
							wave4[] = wave2[p][iVal]
							wave5[] = wave0[p][iVal]
							execute/Z/Q "Cursor/W=Smoothing_Panel#G0 /P/S=0/I/H=2/C=(65280,0,0) C Display1 0,"+num2str(iVal)
							Slider slider0 , value = iVal
						else
							wave3[] = wave1[jVal][p]
							wave4[] = wave2[jVal][p]
							wave5[] = wave0[jVal][p]
							execute/Z/Q "Cursor/W=Smoothing_Panel#G0 /P/S=0/I/H=3/C=(65280,0,0) C Display1 "+num2str(jVal) + ",0"
							Slider slider1 , value = jVal
						endif
						break
				endswitch
				SetDataFolder df
			endif
		endif
	endif
	return result
End

Function SliderProc(sa) : SliderControl
	STRUCT WMSliderAction &sa
	
	//if(sa.eventCode == -1)
	//	return 0
	//endif
	
	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			if( sa.eventCode & 2 ) 
				SetDataFolder root:Smoothing_Panel:
				NVAR last_slider
				last_slider=0
				Wave Angle_2D_
				Wave Crossection1 = Crossection1
				Wave Crossection2 = Crossection2
				Wave Crossection3 = Crossection3
				Wave Crossection4 = Crossection4
				Wave Crossection5 = Crossection5
				
				Redimension/N=(DimSize(Angle_2D_,0)) Crossection1 
				Redimension/N=(DimSize(Angle_2D_,0)) Crossection2 
				Redimension/N=(DimSize(Angle_2D_,0)) Crossection3 
				Redimension/N=(DimSize(Angle_2D_,0)) Crossection4 
				Redimension/N=(DimSize(Angle_2D_,0)) Crossection5  
					
				SetScale/P x,DimOffset(Angle_2D_ , 0), DimDelta(Angle_2D_ , 0), "", Crossection1
				SetScale/P x,DimOffset(Angle_2D_ , 0), DimDelta(Angle_2D_ , 0), "", Crossection2
				SetScale/P x,DimOffset(Angle_2D_ , 0), DimDelta(Angle_2D_ , 0), "", Crossection3
				SetScale/P x,DimOffset(Angle_2D_ , 0), DimDelta(Angle_2D_ , 0), "", Crossection4
				SetScale/P x,DimOffset(Angle_2D_ , 0), DimDelta(Angle_2D_ , 0), "", Crossection5
				
				ModifyGraph  /W=Smoothing_Panel#G1 swapXY=1
				ModifyGraph  /W=Smoothing_Panel#G3 swapXY=1
				
				SetAxis/A /W=Smoothing_Panel#G1
				SetAxis/A /W=Smoothing_Panel#G3
			endif
			
			if( sa.eventCode & 1 ) // value set
				Variable		 x,i
				WAVE 		sw1=root:Load_and_Set_Panel:sw1	
				String		name1,name2

				ControlInfo /W=Load_and_Set_Panel list0
				name1 = S_DataFolder  + S_Value
				WAVE/T ListWave = $name1
				name1 = sa.win
				SetDataFolder root:Smoothing_Panel:
				WAVE Angle_2D_ 
				WAVE Display1 
				WAVE Display2
				WAVE w0 = Angle_2D_ 
				WAVE w1 = Display1 
				WAVE w4 = Display2
						
				Wave Crossection1 = Crossection1
				Wave Crossection2 = Crossection2
				Wave Crossection3 = Crossection3
				Wave Crossection4 = Crossection4
				Wave Crossection5 = Crossection5
					
				ControlInfo /W=Smoothing_Panel check1
				Variable curval = sa.curval
				
				Variable help1 , help2			
				ControlInfo popup1
				help1 = V_value
				ControlInfo popup2
				help2 = V_value
				switch(help1)
					case 1:
						Crossection1 = Display1[p][curval]
						Crossection3 = Display2[p][curval]
						Crossection4 = w0[p][curval]
					break
					case 2:
						Crossection1 = Display1[p][curval]
						Crossection3 = Display2[p][curval]
						Crossection4 = w0[p][curval]
					break
					case 3:
						Crossection1 = Display1[p][curval]
						Crossection3 = Display2[p][curval]
						Crossection4 = w0[p][curval]*2
					break
				endswitch	
			
				execute/Z/Q "Cursor/W=Smoothing_Panel#G0 /S=0/P/I/H=2/C=(65280,0,0) C Display1 0," + num2str(curval)
				execute/Z/Q "Cursor/W=Smoothing_Panel#G2 /S=0/P/I/H=2/C=(65280,0,0) D Display2 0," + num2str(curval)
		
			endif
			break
	endswitch

	return 0
End 

Function SliderProc2(sa) : SliderControl
	STRUCT WMSliderAction &sa
	
	//if(sa.eventCode == -1)
	//	return 0
	//endif
	
	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			if( sa.eventCode & 2 )
				SetDataFolder root:Smoothing_Panel:
				NVAR last_slider
				last_slider=1
				Wave Crossection1 = Crossection1
				Wave Crossection2 = Crossection2
				Wave Crossection3 = Crossection3
				Wave Crossection4 = Crossection4
				Wave Crossection5 = Crossection5
				
				Redimension/N=(DimSize(Angle_2D_,1)) Crossection1 
				Redimension/N=(DimSize(Angle_2D_,1)) Crossection2 
				Redimension/N=(DimSize(Angle_2D_,1)) Crossection3 
				Redimension/N=(DimSize(Angle_2D_,1)) Crossection4 
				Redimension/N=(DimSize(Angle_2D_,1)) Crossection5  
					
				SetScale/P x,DimOffset(Angle_2D_ , 1), DimDelta(Angle_2D_ , 1), "", Crossection1
				SetScale/P x,DimOffset(Angle_2D_ , 1), DimDelta(Angle_2D_ , 1), "", Crossection2
				SetScale/P x,DimOffset(Angle_2D_ , 1), DimDelta(Angle_2D_ , 1), "", Crossection3
				SetScale/P x,DimOffset(Angle_2D_ , 1), DimDelta(Angle_2D_ , 1), "", Crossection4
				SetScale/P x,DimOffset(Angle_2D_ , 1), DimDelta(Angle_2D_ , 1), "", Crossection5
				
				ModifyGraph  /W=Smoothing_Panel#G1 swapXY=0
				ModifyGraph  /W=Smoothing_Panel#G3 swapXY=0
				
				SetAxis/A /W=Smoothing_Panel#G1
				SetAxis/A /W=Smoothing_Panel#G3
			endif
			if( sa.eventCode & 1 ) // value set
				Variable		 x,i
				WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
				String		name1,name2

				ControlInfo /W=Load_and_Set_Panel list0
				name1 = S_DataFolder  + S_Value
				WAVE/T 		ListWave = $name1
				name1 = sa.win
				SetDataFolder root:Smoothing_Panel:
				WAVE Angle_2D_ 
				WAVE Display1 
				WAVE Display2
				WAVE w0 = Angle_2D_ 
				WAVE w1 = Display1 
				WAVE w4 = Display2
				
				Wave Crossection1 = Crossection1
				Wave Crossection2 = Crossection2
				Wave Crossection3 = Crossection3
				Wave Crossection4 = Crossection4
				Wave Crossection5 = Crossection5
	
				Variable curval = sa.curval
				//name2 = "curve" + num2str(curval)
				
				Variable help1 , help2			
				ControlInfo popup1
				help1 = V_value
				ControlInfo popup2
				help2 = V_value
				switch(help1)
					case 1:
						Crossection1 = Display1[curval][p]
						Crossection3 = Display2[curval][p]
						Crossection4 = w0[curval][p]
					break
					case 2:
						Crossection1 = Display1[curval][p]
						Crossection3 = Display2[curval][p]
						Crossection4 = w0[curval][p]
					break
					case 3:
						Crossection1 = Display1[curval][p]
						Crossection3 = Display2[curval][p]
						Crossection4 = w0[curval][p]*2
					break
				endswitch	
				
				execute/Z/Q "Cursor/W=Smoothing_Panel#G0 /S=0/P/I/H=3/C=(65280,0,0) C Display1 " + num2str(curval) + " ,0 "
				execute/Z/Q "Cursor/W=Smoothing_Panel#G2 /S=0/P/I/H=3/C=(65280,0,0) D Display2 " + num2str(curval) + " ,0 "
		
			endif
			break
	endswitch

	return 0
End 


Function SetVarProc(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva
	
	//if(sva.eventCode == -1)
	//	return 0
	//endif
	switch( sva.eventCode )
		case -1:
			String nameA
			nameA = ImageNameList("Smoothing_Panel#G0", "" )
			nameA = StringFromList(0, nameA)
			if( cmpstr (nameA, "")  == 1)
				RemoveImage /W=Smoothing_Panel#G0 $nameA
			endif
			nameA = ImageNameList("Smoothing_Panel#G2", "" )
			nameA = StringFromList(0, nameA)
			if( cmpstr (nameA, "")  == 1 )
				RemoveImage /W=Smoothing_Panel#G2 $nameA
			endif
			
			nameA=TraceNameList("Smoothing_Panel#G1",";",1+4)
			nameA = StringFromList(0, nameA)
			if( cmpstr (nameA, "")  == 1 )
				RemoveFromGraph /W=Smoothing_Panel#G1 $nameA
			endif
			
			nameA=TraceNameList("Smoothing_Panel#G1",";",1+4)
			nameA = StringFromList(0, nameA)
			if( cmpstr (nameA, "")  == 1 )
				RemoveFromGraph /W=Smoothing_Panel#G1 $nameA
			endif
			
			nameA=TraceNameList("Smoothing_Panel#G3",";",1+4)
			nameA = StringFromList(0, nameA)
			if( cmpstr (nameA, "")  == 1 )
				RemoveFromGraph /W=Smoothing_Panel#G3 $nameA
			endif
			nameA = "root:" + sva.win+":"
			if( DataFolderExists(nameA) )
				SetDataFolder root:$sva.win
				String name1,name3
				name1 = sva.win
				name3 = name1+"#G0"				
				if(WaveExists(ywave1))
					name1 = TraceNameList(name3,";",1)
					name1 = StringFromList (0, name1  , ";")
					if(cmpstr(name1,"")!=0)
						RemoveFromGraph/W=$name3 $name1
					endif
				endif	
				if(WaveExists(ywave2))
					name1 = TraceNameList(name3,";",1)
					name1 = StringFromList (0, name1  , ";")
					if(cmpstr(name1,"")!=0)
						RemoveFromGraph/W=$name3 $name1
					endif
				endif				
				KillDataFolder root:$sva.win
			endif
			
			nameA = "root:WinGlobals:G0:"
			if( DataFolderExists(nameA) )
				KillDataFolder $nameA
			endif
			
			nameA = "root:WinGlobals:G2:"
			if( DataFolderExists(nameA) )
				KillDataFolder $nameA
			endif
			
			break
		case 1: // mouse up
			WAVE v1 , v2
			String		name2,name4
			SVAR	 	list_folder 	= 	root:Specs:list_folder
			Variable 		number,i,j , help1
			//WAVE/T ListWave1	=	root:ListWave1
			WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
			NVAR 	val1 	=	root:Specs:val_slider1
			NVAR 	val2 	=	root:Specs:val_slider2
			NVAR	flag_1 = root:Smoothing_Panel:flag_1
			//NVAR 	val3 	=	root:Specs:val_slider3
			
			ControlInfo /W=Load_and_Set_Panel list0
			name1 = S_DataFolder  + S_Value
			WAVE/T 		ListWave = $name1
				
			number = DimSize(ListWave,0) 
			Variable test2 , counter2
			test2 = 0
			counter2 = DimSize(ListWave,1) 
			for(i = 0; i < number ; i += 1)
				for(j = 0; j < counter2 ; j += 1)
					if( (sw1[i][j] & 2^0) != 0 )
						test2 = i 
						break
					endif
				endfor
				if( test2 != 0 )
					break
				endif
			endfor
			SetDataFolder root:Specs:$ListWave[i][1]
			i = test2
				
			name2 =  ListWave[i][1]
			if(	 cmpstr ( name2, "") == 0  )
				return 0
			endif
			
			SetDataFolder root:$sva.win
			NVAR last_slider
			WAVE Angle_2D_
			WAVE Display1
			WAVE Display2
				
			WAVE w0 = Angle_2D_
			WAVE w1 = Angle_2D_smoothed_x
			WAVE w4 = Angle_dif2_2D_x
			WAVE w5 = Angle_dif2_2D_positive_x
			w1=w0
			
			WAVE z0 = Angle_2D_
			WAVE z1 = Angle_2D_smoothed_y
			WAVE z4 = Angle_dif2_2D_y
			WAVE z5 = Angle_dif2_2D_positive_y
			z1=z0
			
			Wave Crossection1 = Crossection1
			Wave Crossection2 = Crossection2
			Wave Crossection3 = Crossection3
			Wave Crossection4 = Crossection4
			Wave Crossection5 = Crossection5

			Variable dval = sva.dval
			String sval = sva.sval
			name3 =	sva.ctrlName 
			strswitch(name3)
				case "setvar0":
					w1 = w0
					val1 = dval
					//ListWave[i][14] = num2str(val1)
					ControlInfo /W=Smoothing_Panel setvar1
					val2 = V_value
					
					Duplicate/O Angle_2D_, w1
					Duplicate/O Angle_2D_, z1
					Smooth_2D(w1, 0, val1)				
					Smooth_2D(z1, 1, val2)
					Duplicate/O w1, w4
					Duplicate/O z1, z4
					Diff_2D(w4,0)
					Diff_2D(z4,1)
					Duplicate/O w4, w5 
					Duplicate/O z4, z5 
					Cut_Negative_2D(w5)
					Cut_Negative_2D(z5)
				
					//execute/Z/Q "Cursor/W=Smoothing_Panel#G0 /P/I/H=3/C=(65280,0,0) C Angle_2D_smoothed " + num2str(j) + " ,0 "
					//execute/Z/Q "Cursor/W=Smoothing_Panel#G2 /P/I/H=3/C=(65280,0,0) D Angle_dif2_2D " + num2str(j) + " ,0 "	
					flag_1 = 0
					Variable  help2	, help3	
					if(last_slider==0)
						Redimension/N=(DimSize(w0,0)) Crossection1 
						Redimension/N=(DimSize(w0,0)) Crossection3 
						Redimension/N=(DimSize(w0,0)) Crossection4 
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection1
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection3
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection4
						ModifyGraph  /W=Smoothing_Panel#G1 swapXY=1
						ModifyGraph  /W=Smoothing_Panel#G3 swapXY=1
						SetAxis/A /W=Smoothing_Panel#G1
						SetAxis/A /W=Smoothing_Panel#G3
						
						ControlInfo slider0
						help3 = V_value
					else
						Redimension/N=(DimSize(w0,1)) Crossection1 
						Redimension/N=(DimSize(w0,1)) Crossection3 
						Redimension/N=(DimSize(w0,1)) Crossection4 
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection1
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection3
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection4
						ModifyGraph  /W=Smoothing_Panel#G1 swapXY=0
						ModifyGraph  /W=Smoothing_Panel#G3 swapXY=0
						SetAxis/A /W=Smoothing_Panel#G1
						SetAxis/A /W=Smoothing_Panel#G3
						
						ControlInfo slider1
						help3 = V_value
					endif
					
					ControlInfo popup1
					help1 = V_value
					ControlInfo popup2
					help2 = V_value
					switch(help1)
						case 1:
							switch(help2)
								case 1:
									Display1 = w1
									Display2 = w4
									break
								case 2:
									Display1 = w1
									Display2 = w5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]
							endif
						break
						case 2:
							switch(help2)
								case 1:
									Display1 = z1
									Display2 = z4
									break
								case 2:
									Display1 = z1
									Display2 = z5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]
							endif
						break
						case 3:
							switch(help2)
								case 1:
									Display1 = w1 + z1
									Display2 = w4 + z4
									break
								case 2:
									Display1 = w1 + z1
									Display2 = w5 + z5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]*2
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]*2
							endif
						break
					endswitch
					
				break
			case "setvar1":
					w1 = w0
					val2 = dval
					//ListWave[i][15] = num2str(val2)
					ControlInfo /W=Smoothing_Panel setvar0
					val1 = V_value
		
					Duplicate/O Angle_2D_, w1
					Duplicate/O Angle_2D_, z1
					Smooth_2D(w1, 0, val1)				
					Smooth_2D(z1, 1, val2)
					Duplicate/O w1, w4
					Duplicate/O z1, z4
					Diff_2D(w4,0)
					Diff_2D(z4,1)
					Duplicate/O w4, w5 
					Duplicate/O z4, z5 
					Cut_Negative_2D(w5)
					Cut_Negative_2D(z5)
					
					flag_1 = 0
					
					if(last_slider==0)
						Redimension/N=(DimSize(w0,0)) Crossection1 
						Redimension/N=(DimSize(w0,0)) Crossection3 
						Redimension/N=(DimSize(w0,0)) Crossection4 
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection1
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection3
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection4
						ModifyGraph  /W=Smoothing_Panel#G1 swapXY=1
						ModifyGraph  /W=Smoothing_Panel#G3 swapXY=1
						SetAxis/A /W=Smoothing_Panel#G1
						SetAxis/A /W=Smoothing_Panel#G3
						
						ControlInfo slider0
						help3 = V_value
					else
						Redimension/N=(DimSize(w0,1)) Crossection1 
						Redimension/N=(DimSize(w0,1)) Crossection3 
						Redimension/N=(DimSize(w0,1)) Crossection4 
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection1
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection3
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection4
						ModifyGraph  /W=Smoothing_Panel#G1 swapXY=0
						ModifyGraph  /W=Smoothing_Panel#G3 swapXY=0
						SetAxis/A /W=Smoothing_Panel#G1
						SetAxis/A /W=Smoothing_Panel#G3
						
						ControlInfo slider1
						help3 = V_value
					endif
					
					ControlInfo popup1
					help1 = V_value
					ControlInfo popup2
					help2 = V_value
					switch(help1)
						case 1:
							switch(help2)
								case 1:
									Display1 = w1
									Display2 = w4
									break
								case 2:
									Display1 = w1
									Display2 = w5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]
							endif
						break
						case 2:
							switch(help2)
								case 1:
									Display1 = z1
									Display2 = z4
									break
								case 2:
									Display1 = z1
									Display2 = z5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]
							endif
						break
						case 3:
							switch(help2)
								case 1:
									Display1 = w1 + z1
									Display2 = w4 + z4
									break
								case 2:
									Display1 = w1 + z1
									Display2 = w5 + z5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]*2
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]*2
							endif
						break
					endswitch	
					
				break
			endswitch	
		break
		case 2: // Enter key
		case 3: // Live update
			WAVE v1 , v2
			SVAR	 	list_folder 	= 	root:Specs:list_folder
			//WAVE/T ListWave1	=	root:ListWave1
			WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
			NVAR 	val1 	=	root:Specs:val_slider1
			NVAR 	val2 	=	root:Specs:val_slider2
			NVAR	flag_1 = root:Smoothing_Panel:flag_1
			//NVAR 	val3 	=	root:Specs:val_slider3
			
			ControlInfo /W=Load_and_Set_Panel list0
			name1 = S_DataFolder  + S_Value
			WAVE/T 		ListWave = $name1
				
			number = DimSize(ListWave,0) 
			test2 = 0
			counter2 = DimSize(ListWave,1) 
			for(i = 0; i < number ; i += 1)
				for(j = 0; j < counter2 ; j += 1)
					if( (sw1[i][j] & 2^0) != 0 )
						test2 = i 
						break
					endif
				endfor
				if( test2 != 0 )
					break
				endif
			endfor
			SetDataFolder root:Specs:$ListWave[i][1]
			i = test2
				
			name2 =  ListWave[i][1]
			if(	 cmpstr ( name2, "") == 0  )
				return 0
			endif
			
			SetDataFolder root:$sva.win
			NVAR last_slider
			WAVE Angle_2D_
			WAVE Display1
			WAVE Display2
				
			WAVE w0 = Angle_2D_
			WAVE w1 = Angle_2D_smoothed_x
			WAVE w4 = Angle_dif2_2D_x
			WAVE w5 = Angle_dif2_2D_positive_x
			w1=w0
			
			WAVE z0 = Angle_2D_
			WAVE z1 = Angle_2D_smoothed_y
			WAVE z4 = Angle_dif2_2D_y
			WAVE z5 = Angle_dif2_2D_positive_y
			z1=z0
			
			Wave Crossection1 = Crossection1
			Wave Crossection2 = Crossection2
			Wave Crossection3 = Crossection3
			Wave Crossection4 = Crossection4
			Wave Crossection5 = Crossection5
			
			dval = sva.dval
			sval = sva.sval
			
			name3 =	sva.ctrlName 
			strswitch(name3)
				case "setvar0":
					w1 = w0
					val1 = dval
					ListWave[i][14] = num2str(val1)
					ControlInfo /W=Smoothing_Panel setvar1
					val2 = V_value
					
					Duplicate/O Angle_2D_, w1
					Duplicate/O Angle_2D_, z1
					Smooth_2D(w1, 0, val1)				
					Smooth_2D(z1, 1, val2)
					Duplicate/O w1, w4
					Duplicate/O z1, z4
					Diff_2D(w4,0)
					Diff_2D(z4,1)
					Duplicate/O w4, w5 
					Duplicate/O z4, z5 
					Cut_Negative_2D(w5)
					Cut_Negative_2D(z5)
				
					//execute/Z/Q "Cursor/W=Smoothing_Panel#G0 /P/I/H=3/C=(65280,0,0) C Angle_2D_smoothed " + num2str(j) + " ,0 "
					//execute/Z/Q "Cursor/W=Smoothing_Panel#G2 /P/I/H=3/C=(65280,0,0) D Angle_dif2_2D " + num2str(j) + " ,0 "	
					flag_1 = 0
					if(last_slider==0)
						Redimension/N=(DimSize(w0,0)) Crossection1 
						Redimension/N=(DimSize(w0,0)) Crossection3 
						Redimension/N=(DimSize(w0,0)) Crossection4 
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection1
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection3
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection4
						ModifyGraph  /W=Smoothing_Panel#G1 swapXY=1
						ModifyGraph  /W=Smoothing_Panel#G3 swapXY=1
						SetAxis/A /W=Smoothing_Panel#G1
						SetAxis/A /W=Smoothing_Panel#G3
						
						ControlInfo slider0
						help3 = V_value
					else
						Redimension/N=(DimSize(w0,1)) Crossection1 
						Redimension/N=(DimSize(w0,1)) Crossection3 
						Redimension/N=(DimSize(w0,1)) Crossection4 
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection1
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection3
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection4
						ModifyGraph  /W=Smoothing_Panel#G1 swapXY=0
						ModifyGraph  /W=Smoothing_Panel#G3 swapXY=0
						SetAxis/A /W=Smoothing_Panel#G1
						SetAxis/A /W=Smoothing_Panel#G3
						
						ControlInfo slider1
						help3 = V_value
					endif
					
					ControlInfo popup1
					help1 = V_value
					ControlInfo popup2
					help2 = V_value
					switch(help1)
						case 1:
							switch(help2)
								case 1:
									Display1 = w1
									Display2 = w4
									break
								case 2:
									Display1 = w1
									Display2 = w5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]
							endif
						break
						case 2:
							switch(help2)
								case 1:
									Display1 = z1
									Display2 = z4
									break
								case 2:
									Display1 = z1
									Display2 = z5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]
							endif
						break
						case 3:
							switch(help2)
								case 1:
									Display1 = w1 + z1
									Display2 = w4 + z4
									break
								case 2:
									Display1 = w1 + z1
									Display2 = w5 + z5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]*2
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]*2
							endif
						break
					endswitch
					
				break
			case "setvar1":
					w1 = w0
					val2 = dval
					ListWave[i][15] = num2str(val2)
					ControlInfo /W=Smoothing_Panel setvar0
					val1 = V_value
		
					Duplicate/O Angle_2D_, w1
					Duplicate/O Angle_2D_, z1
					Smooth_2D(w1, 0, val1)				
					Smooth_2D(z1, 1, val2)
					Duplicate/O w1, w4
					Duplicate/O z1, z4
					Diff_2D(w4,0)
					Diff_2D(z4,1)
					Duplicate/O w4, w5 
					Duplicate/O z4, z5 
					Cut_Negative_2D(w5)
					Cut_Negative_2D(z5)
					
					flag_1 = 0
					
					if(last_slider==0)
						Redimension/N=(DimSize(w0,0)) Crossection1 
						Redimension/N=(DimSize(w0,0)) Crossection3 
						Redimension/N=(DimSize(w0,0)) Crossection4 
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection1
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection3
						SetScale/P x,DimOffset(w0 , 0), DimDelta(w0 , 0), "", Crossection4
						ModifyGraph  /W=Smoothing_Panel#G1 swapXY=1
						ModifyGraph  /W=Smoothing_Panel#G3 swapXY=1
						SetAxis/A /W=Smoothing_Panel#G1
						SetAxis/A /W=Smoothing_Panel#G3
						
						ControlInfo slider0
						help3 = V_value
					else
						Redimension/N=(DimSize(w0,1)) Crossection1 
						Redimension/N=(DimSize(w0,1)) Crossection3 
						Redimension/N=(DimSize(w0,1)) Crossection4 
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection1
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection3
						SetScale/P x,DimOffset(w0 , 1), DimDelta(w0 , 1), "", Crossection4
						ModifyGraph  /W=Smoothing_Panel#G1 swapXY=0
						ModifyGraph  /W=Smoothing_Panel#G3 swapXY=0
						SetAxis/A /W=Smoothing_Panel#G1
						SetAxis/A /W=Smoothing_Panel#G3
						
						ControlInfo slider1
						help3 = V_value
					endif
					
					ControlInfo popup1
					help1 = V_value
					ControlInfo popup2
					help2 = V_value
					switch(help1)
						case 1:
							switch(help2)
								case 1:
									Display1 = w1
									Display2 = w4
									break
								case 2:
									Display1 = w1
									Display2 = w5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]
							endif
						break
						case 2:
							switch(help2)
								case 1:
									Display1 = z1
									Display2 = z4
									break
								case 2:
									Display1 = z1
									Display2 = z5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]
							endif
						break
						case 3:
							switch(help2)
								case 1:
									Display1 = w1 + z1
									Display2 = w4 + z4
									break
								case 2:
									Display1 = w1 + z1
									Display2 = w5 + z5
									break
							endswitch
							if(last_slider==0)
								Crossection1 = Display1[p][help3]
								Crossection3 = Display2[p][help3]
								Crossection4 = w0[p][help3]*2
							else
								Crossection1 = Display1[help3][p]
								Crossection3 = Display2[help3][p]
								Crossection4 = w0[help3][p]*2
							endif
						break
					endswitch	
					
				break
			endswitch
		break
	endswitch
	return 0
End

Function ListBoxProc(lba) : ListBoxControl
	STRUCT WMListboxAction &lba
	Variable row = lba.row
	Variable col = lba.col
	WAVE/T/Z listWave = lba.listWave
	WAVE/Z selWave = lba.selWave
	String name1,name2, name3,nameS
	SVAR 	list_file_path 		= 	root:Specs:list_file_path	
	SVAR 	list_file_name	= 	root:Specs:list_file_name	
	SVAR 	list_folder 		= 	root:Specs:list_folder
	SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
	SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
	//NVAR last_number = root:BlenderPanel:last_number
	
	switch( lba.eventCode )
		case -1: // control being killed
			SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
			SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
			If( cmpstr ( Title_left1, "") != 0 )
				RemoveImage /W=Load_and_Set_Panel#G0 L_image1
			endif
			If( cmpstr ( Title_right1, "") != 0 )
				RemoveImage /W=Load_and_Set_Panel#G1 R_image1
			endif
			DoWindow/F Blended_Panel					//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow Blended_Panel
			endif
			if(DataFolderExists("root:Blending_Panel"))
				KillDataFolder root:$"Blending_Panel"
			endif
			
			DoWindow/F Profiles_FinalBlend					//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow Profiles_FinalBlend	
			endif
			
			DoWindow/F Final_Blend				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow Final_Blend		
			endif
			if(DataFolderExists("root:Final_Blend"))
				KillDataFolder root:$"Final_Blend"
			endif
			
			DoWindow/F Multiple_Panel					//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow Multiple_Panel	
			endif
			if(DataFolderExists("root:Multiple_Panel"))
				KillDataFolder root:$"Multiple_Panel"
			endif
			
			DoWindow/F $"Display_and_Extract2"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Display_and_Extract2"
			endif
			
			DoWindow/F $"Display_and_Extract"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Display_and_Extract"
			endif
			if(DataFolderExists("root:Display_and_Extract:"))
				KillDataFolder root:$"Display_and_Extract"
			endif
			
			DoWindow/F $"Spectrum"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Spectrum"
			endif
			
			DoWindow/F $"Display_and_Extract"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Display_and_Extract"
			endif
			
			String nameA,nameB
			nameA = ImageNameList("Load_and_Set_Panel#G3", "" )
			nameA = StringFromList(0, nameA)
			nameB= TraceNameList("Load_and_Set_Panel#G3", ";",1)
			nameB = StringFromList(0, nameB)
			if( cmpstr (nameA, "")  == 1 ||  cmpstr (nameA, "")  == -1)
				RemoveImage /W=Load_and_Set_Panel#G3 $nameA
			endif
			if( cmpstr (nameB, "")  == 1 ||  cmpstr (nameB, "")  == -1)
				RemoveFromGraph /W=Load_and_Set_Panel#G3 $nameB
			endif
			nameA = ImageNameList("Load_and_Set_Panel#G2", "" )
			nameA = StringFromList(0, nameA)
			nameB= TraceNameList("Load_and_Set_Panel#G2", ";",1)
			nameB = StringFromList(0, nameB)
			if( cmpstr (nameA, "")  == 1 ||  cmpstr (nameA, "")  == -1)
				RemoveImage /W=Load_and_Set_Panel#G2 $nameA
			endif
			if( cmpstr (nameB, "")  == 1 ||  cmpstr (nameB, "")  == -1)
				RemoveFromGraph /W=Load_and_Set_Panel#G2 $nameB
			endif
			DoWindow/F $"Angle_Energy"			//pulls the window to the front
			if (V_Flag==1)	
				DoWindow/K $"Angle_Energy"	
			endif
			
			DoWindow/F $"k_Space_2D"			//pulls the window to the front
			if (V_Flag==1)	
				DoWindow/K $"k_Space_2D"	
			endif
			
			DoWindow/F $"Arbitrary_Plane"			//pulls the window to the front
			if (V_Flag==1)	
				DoWindow/K $"Arbitrary_Plane"
			endif
			
			if(DataFolderExists("root:folder3D"))
				KillDataFolder root:$"folder3D"
			endif
				
			KillDataFolder root:Specs:
			KillDataFolder root:Load_and_Set_Panel
			
			if(DataFolderExists("root:WinGlobals:"))
				KillDataFolder root:$"WinGlobals"
			endif
			
			break
		case 8: // mouse up
			if( col==16 || col == 17 || col == 18 || col == 19)
				name1 = listWave[row][1]	
				name2 = "root:Specs:" + name1
			
				SetDataFolder root:Specs:$listWave[row][1]
				NVAR flag_hotPix
				NVAR flag_back	
				NVAR flag_straight
				NVAR flag_defects
				NVAR energy1
				NVAR energy2
				WAVE nwave
				if( (selWave[row][16] & (2^4)) == 0)
					listWave[row][16] = num2str(0)	
				else
					listWave[row][16] = num2str(1)
				endif
				if( (selWave[row][17] & (2^4)) == 0)
					listWave[row][17] = num2str(0)	
				else
					listWave[row][17] = num2str(1)
				endif
				if( (selWave[row][18] & (2^4)) == 0)
					listWave[row][18] = num2str(0)	
				else
					listWave[row][18] = num2str(1)
				endif
				if( (selWave[row][19] & (2^4)) == 0)
					listWave[row][19] = num2str(0)	
				else
					listWave[row][19] = num2str(1)
				endif
			endif
			break
		case 9: 
			break
		case 10: 
			break
		case 11:
			break
		case 12: 
			String char
			char = num2char(row )
			Variable size2 , i
			size2 = ItemsInList ( list_file_name )
			for ( i = 0 ; i <= size2 ; i = i + 1)
				if( (selWave[i][1] == (2^0)) )
					break	
				endif
			endfor
			if(i == size2)
				break
			endif
			name2 = ListWave[i][1]
			strswitch(char)
				case "l":
					SetDataFolder root:Load_and_Set_Panel
					WAVE Display2
					Duplicate/O Display2, L_image1
					Variable val1, val2
					val1 =  str2num( ListWave[row][14] ) 
					val2 =  str2num( ListWave[row][15] ) 
					Variable flag_background 
					flag_background = str2num( ListWave[row][17] )
					if(flag_background)
						Background_2D( Display2 , str2num( ListWave[row][13] ))
					endif
					flag_defects = str2num( ListWave[row][17] )
					if(flag_defects)
						Defects_2D( Display2)
					endif
					Smooth_2D(L_image1, 0, val1)
					
					name1 = ImageNameList("Load_and_set_Panel#G0", "" )
					name1 = StringFromList (0, name1  , ";")
					if( cmpstr ( name1, "") == 0 ) 
						AppendImage /W=Load_and_set_Panel#G0 L_image1
						ModifyGraph  /W=Load_and_set_Panel#G0 swapXY=1
						ModifyGraph /W=Load_and_Set_Panel#G0 margin=-1
						ModifyGraph /W=Load_and_Set_Panel#G0 noLabel=2
						ModifyGraph /W=Load_and_Set_Panel#G0 frameStyle= 6
						
						Title_left1 = name2
					else	
					
						Title_left1 = name2
					endif
					
					break
				case "r":
					SetDataFolder root:Load_and_Set_Panel
					WAVE Display2
					Duplicate/O Display2, R_image1
					val1 =  str2num( ListWave[row][14] ) 
					val2 =  str2num( ListWave[row][15] ) 
					flag_background = str2num( ListWave[row][17] )
					if(flag_background)
						Background_2D( Display2 , str2num( ListWave[row][13] ))
					endif
					flag_defects = str2num( ListWave[row][17] )
					if(flag_defects)
						Defects_2D( Display2)
					endif
					Smooth_2D(R_image1, 0, val1)
					
					name1 = ImageNameList("Load_and_set_Panel#G1", "" )
					name1 = StringFromList (0, name1  , ";")
					if( cmpstr ( name1, "") == 0 ) 
						AppendImage /W=Load_and_set_Panel#G1 R_image1
						ModifyGraph  /W=Load_and_set_Panel#G1 swapXY=1
						ModifyGraph /W=Load_and_Set_Panel#G1 margin=-1
						ModifyGraph /W=Load_and_Set_Panel#G1 noLabel=2
						ModifyGraph /W=Load_and_Set_Panel#G1 frameStyle= 6
						
						Title_right1 = name2
					else	
					
						Title_right1 = name2
					endif
				
					break
			endswitch

		case 2: 
			if( col==16 || col == 17 || col == 18 || col == 19)
				name1 = listWave[row][1]	
				name2 = "root:Specs:" + name1
			
				SetDataFolder root:Specs:$listWave[row][1]
				NVAR flag_hotPix
				NVAR flag_back	
				NVAR flag_straight
				NVAR flag_defects
				NVAR energy1
				NVAR energy2
				WAVE nwave
				if( (selWave[row][16] & (2^4)) == 0)
					listWave[row][16] = num2str(0)	
				else
					listWave[row][16] = num2str(1)
				endif
				if( (selWave[row][17] & (2^4)) == 0)
					listWave[row][17] = num2str(0)	
				else
					listWave[row][17] = num2str(1)
				endif
				if( (selWave[row][18] & (2^4)) == 0)
					listWave[row][18] = num2str(0)	
				else
					listWave[row][18] = num2str(1)
				endif
				if( (selWave[row][19] & (2^4)) == 0)
					listWave[row][19] = num2str(0)	
				else
					listWave[row][19] = num2str(1)
				endif
			endif
			break
		case 3: 
			break
		case 4: // cell selection
			Variable value2
			NVAR last_column
			
			if( col==1 )
			//if(last_column != col)
				name1 = listWave[row][1]
				if( cmpstr ( name1 , "") == 0)
					break
				endif
				
				if( strsearch(name1,".rho",0) != -1)
					name2 = "root:Specs:" + name1
				
					SetDataFolder root:Specs:$listWave[row][1]
					WAVE wave1 = Density2D
					SetDataFolder root:Load_and_Set_Panel
					WAVE Display1
					Duplicate/O wave1 , Display1
					
					name3 = ImageNameList("Load_and_set_Panel#G3", "" )
					name3 = StringFromList (0, name3  , ";")
					
					if( cmpstr ( name3, "") == 0 ) 
						AppendImage /W=Load_and_set_Panel#G3 Display1
						ModifyGraph  /W=Load_and_set_Panel#G3 swapXY=1
					endif
					
					break
				endif
				
				name2 = "root:Specs:" + name1
				
				SetDataFolder root:Specs:$listWave[row][1]
				WAVE wave1 = $listWave[row][1]
				//WAVE Angle_2D
				
				SetDataFolder root:Load_and_Set_Panel
				WAVE Display1
				Duplicate/O wave1 , Display1
				
				if( DimSize(Display1,1)==0 )
					Button InsertWave2,disable=2
					Button InsertValues1,disable=2
					Button Build3D,disable=2
					Button button0,disable=2
					Button blend_button,disable=2
					Button Smooting_Button_1,disable=2
					Button buttonDisplayExtract,disable=2
					Button Make_Button,disable=2
					Button InsertWave1,disable=2
					Button buttonAnalyzeCore,disable=0
					
					name3 = ImageNameList("Load_and_set_Panel#G3", "" )
					name3 = StringFromList (0, name3  , ";")
					nameS = TraceNameList("Load_and_set_Panel#G3", ";", 1)
					nameS = StringFromList (0, nameS  , ";")
					if( cmpstr ( nameS, "") == 0 ) 
						//AppendToGraph /W=Load_and_set_Panel#G3 Display1
						//ModifyGraph  /W=Load_and_set_Panel#G3 swapXY=1
						if( cmpstr ( name3, "") == 0 ) 
							AppendToGraph /W=Load_and_set_Panel#G3 Display1
							ModifyGraph  /W=Load_and_set_Panel#G3 swapXY=0
						else
							RemoveImage /W=Load_and_set_Panel#G3 Display1 
							RemoveImage /W=Load_and_set_Panel#G2 Display2
							AppendToGraph /W=Load_and_set_Panel#G3 Display1
							ModifyGraph  /W=Load_and_set_Panel#G3 swapXY=0
						endif
					endif
					break
				else
					Button InsertWave2,disable=0
					Button InsertValues1,disable=0
					Button Build3D,disable=0
					Button button0,disable=0
					Button blend_button,disable=0
					Button Smooting_Button_1,disable=0
					Button buttonDisplayExtract,disable=0
					Button Make_Button,disable=0
					Button InsertWave1,disable=0
					Button buttonAnalyzeCore,disable=2
					
				endif
				
				name3 = ImageNameList("Load_and_set_Panel#G3", "" )
				name3 = StringFromList (0, name3  , ";")
				
				nameS = TraceNameList("Load_and_set_Panel#G3", ";", 1)
				nameS = StringFromList (0, nameS  , ";")
				
				if( cmpstr ( name3, "") == 0 ) 
					if( cmpstr ( nameS, "") == 0 ) 	
						AppendImage /W=Load_and_set_Panel#G3 Display1
						ModifyGraph  /W=Load_and_set_Panel#G3 swapXY=1
					else
						RemoveFromGraph /W=Load_and_set_Panel#G3 Display1
						AppendImage /W=Load_and_set_Panel#G3 Display1
						ModifyGraph  /W=Load_and_set_Panel#G3 swapXY=1 
					endif
				endif
			
				Variable left, right 
				Variable emission
				Variable delta
				emission = 0
				left = emission - ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
				right = emission + ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
				
				execute/Z/Q "Cursor /A=1 /W=Load_and_Set_Panel#G3 /S=2/H=1/I/C=(65280,0,0) A Display1 " + listWave[row][6] + "," +  num2str ( left ) 
				execute/Z/Q "Cursor /A=1 /W=Load_and_Set_Panel#G3 /S=2/H=1/I/C=(65280,0,0) B Display1 " + listWave[row][5] + "," +  num2str ( right ) 
				
				emission = 0
				left = emission - ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
				right = emission + ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
				
				SetDataFolder root:Load_and_Set_Panel
				WAVE Display2
				
				Duplicate/O/R= ( str2num( listWave[row][6] ), str2num( listWave[row][5] ) )( left, right ) Display1, Display2
				
				//Final_2D( row, Display2)
				Cut_SetEmission( row , Display2 )
				Variable flag_hp
				flag_hp = str2num( ListWave[row][16] )
				if(flag_hp)
					HotPix_2D( Display2 )
				endif
				Variable flag_str
				flag_str = str2num( ListWave[row][18] )
				if(flag_str)
					Straight_2D( row, Display2 )
				endif
				//H_B_D( row_nr, Angle_2D_ )
				
				name3 = ImageNameList("Load_and_Set_Panel#G2", "" )
				name3 = StringFromList (0, name3  , ";")
				
				if( cmpstr ( name3, "") == 0 )
					AppendImage /W=Load_and_set_Panel#G2 Display2
					ModifyGraph  /W=Load_and_set_Panel#G2 swapXY=1
				endif
		
			endif
			
			last_column = col
			DoUpdate
			break
		case 5: // cell selection plus shift key
			
			break
		case 6: // begin edit
			break
		case 7: // finish edit
			nameS = TraceNameList("Load_and_set_Panel#G3", ";", 1)
			nameS = StringFromList (0, nameS  , ";")
			if( cmpstr ( nameS, "") != 0 )
				break	
			endif	
			SetDataFolder root:Specs:$listWave[row][1]
			WAVE wave1 = $listWave[row][1]
			SetDataFolder root:Load_and_Set_Panel
			WAVE Display1
			WAVE Display2
			Duplicate/O wave1 , Display1
			execute/Z/Q "Cursor /A=1 /W=Load_and_Set_Panel#G3 /S=2/H=1/I/C=(65280,0,0) A Display1 " + listWave[row][6] + "," +  num2str ( -1*( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2 ) 
			execute/Z/Q "Cursor /A=1 /W=Load_and_Set_Panel#G3 /S=2/H=1/I/C=(65280,0,0) B Display1 " + listWave[row][5] + "," +  num2str ( ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2 ) 
				
				
			if((col == 0))
				Variable counter1
				Variable new_value
				Variable size1
				Variable n1, n2
				SetDataFolder root:Load_and_Set_Panel
				
				counter1 = ItemsInList(list_file_name) 
				if(cmpstr(listWave[row][0],"")==0 )
					listWave[row][0] = num2str(row+1)
					return 0
				endif
				
				if(counter1 == 1)
					listWave[row][0] = num2str(row+1)
					return 0
				endif
				
				new_value = str2num (listWave[row][0])
				
				n1 = WhichListItem( ListWave[row][1], list_file_name )
				n2 = WhichListItem( ListWave[new_value-1][1], list_file_name )		
				if( (row+1) == new_value)
					return 0
				endif
				if( (round(new_value) - new_value ) != 0 )
					listWave[row][0] = num2str(row+1)
					return 0
				endif
				if( new_value > 0 && new_value <= counter1 )
					list_file_name = Shift_Item( list_file_name, n1, n2 )
					list_file_path = Shift_Item( list_file_path, n1, n2 )
					list_folder = Shift_Item( list_folder, n1, n2 )
					
					size1 = DimSize(listWave,1)
					Make/T /FREE /N=(size1) temp_elem
					Make /FREE /N=(size1) temp_elem2
					if(new_value < (row + 1))
						temp_elem = listWave[row][p]
						temp_elem2 = selWave[row][p]
						for(i = row ; i > (new_value -1) ;i=i-1)
							listWave[i][] = listWave[i-1][q]
							listWave[i][0] = num2str(i+1) 
							selWave[i][] = selWave[i-1][q]
						endfor
						listWave[new_value-1][] = temp_elem[q]
						selWave[new_value-1][] = temp_elem2[q]
					else
						temp_elem = listWave[row][p]
						temp_elem2 = selWave[row][p]
						for(i = row ; i <(new_value-1) ;i=i+1)
							listWave[i][] = listWave[i+1][q] 
							listWave[i][0] = num2str(i+1) 
							selWave[i][] = selWave[i+1][q] 
						endfor
						listWave[new_value-1][] = temp_elem[q]
						selWave[new_value-1][] = temp_elem2[q]
					endif
				else
					listWave[row][0] = num2str(row+1)
				endif
						
				KillWaves temp_elem
				break
			endif
			
			if( col == 8 )
				SetDataFolder root:Specs:$listWave[row][1]
				WAVE wave1 = $listWave[row][1]
				SetScale_2D( row , wave1 )
				
				SetDataFolder root:Load_and_Set_Panel
				WAVE Display1
				Duplicate/O wave1 , Display1
				
				name1 = ImageNameList("Load_and_set_Panel#G3", "" )
				name1 = StringFromList (0, name1  , ";")
				
				if( cmpstr ( name1, "") == 0 ) 
					AppendImage /W=Load_and_set_Panel#G3 Display1
					ModifyGraph  /W=Load_and_set_Panel#G3 swapXY=1
				endif
				
				SetDataFolder root:Load_and_Set_Panel
				WAVE Display2
				
				Duplicate/O/R= ( str2num( listWave[row][6] ), str2num( listWave[row][5] ) )( left, right ) Display1, Display2
				
				Cut_SetEmission( row , Display2 )
				flag_str = str2num( ListWave[row][18] )
				if(flag_str)
					Straight_2D( row, Display2 )
				endif
				flag_hp = str2num( ListWave[row][17] )
				if(flag_hp)
					HotPix_2D( Display2 )
				endif
				//H_B_D( row_nr, Angle_2D_ )
				
				name3 = ImageNameList("Load_and_Set_Panel#G2", "" )
				name3 = StringFromList (0, name3  , ";")
				
				if( cmpstr ( name3, "") == 0 )
					AppendImage /W=Load_and_set_Panel#G2 Display2
					ModifyGraph  /W=Load_and_set_Panel#G2 swapXY=1
				endif
				
				SetDataFolder root:
			endif
			
			if( col==2 || col == 4 || col == 5 || col == 6 || col == 7 )
				Cut_SetEmission( row , Display2 )
				flag_str = str2num( ListWave[row][18] )
				if(flag_str)
					Straight_2D( row, Display2 )
				endif
				//H_B_D( row, Display2 )
			endif
			
		break
	endswitch

	return 0
End

Function UpOrDown(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			WAVE sw1 = root:Load_and_Set_Panel:sw1
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			SVAR 	list_file_path 		= 	root:Specs:list_file_path	
			SVAR 	list_file_name	= 	root:Specs:list_file_name	
			SVAR 	list_folder 		= 	root:Specs:list_folder
			
			String file_path	
			String file_name1, file_name2
			String folder
			Variable n1,n2 , index
						
			Variable i , j , k
			Variable size1 , size2
			SetDataFolder root:Specs:
			size1 = DimSize ( sw1 , 1)
			size2 = DimSize ( sw1 , 0)
			Make/O /N = (size1) , temp1sw
			Make/O /N = (size1) , temp2sw
		
			Make/O /T /N = (size1) , temp1list
			Make/O /T /N = (size1) , temp2list

			strswitch (ba.ctrlname)
				case "Up_button":
					for ( i = 0 ; i < size2 ; i = i + 1)
						if( (sw1[i][0] == (2^0)) || (sw1[i][1] == (2^0)) || (sw1[i][2] == (2^0)) || (sw1[i][3] == (2^0)) || (sw1[i][4] == (2^0)) || (sw1[i][5] == (2^0)) || (sw1[i][6] == (2^0)) || (sw1[i][7] == (2^0)) )
							break	
						endif
					endfor
					j = i - 1
					if( i != 0 && ( cmpstr ( ListWave1[i][1] , "")  != 0 ) )
						temp1sw = sw1[i][p]
						temp2sw  = sw1[j][p] 
						
						temp1list = ListWave1[i][p]
						temp2list  = ListWave1[j][p] 
					
						sw1[i][0,size1] = temp2sw[q]
						sw1[j][0,size1] = temp1sw[q]
						
						ListWave1[i][0,size1] = temp2list[q]
						ListWave1[j][0,size1] = temp1list[q]
						
						ListWave1[i][0] = num2str(i+1)
						ListWave1[j][0] = num2str(j+1)
						
						n1 = WhichListItem( ListWave1[j][1], list_file_name )
						n2 = WhichListItem( ListWave1[i][1], list_file_name )
						
						list_file_name = Swap_Items( list_file_name, n1, n2 )
						list_file_path = Swap_Items( list_file_path, n1, n2 )
						list_folder = Swap_Items( list_folder, n1, n2 )
						//file_name1 = StringFromList( n1, list_file_name )
						//file_name2 = StringFromList( n2, list_file_name )
						//list_file_name = RemoveListItem( n1, list_file_name )
						//list_file_name = AddListItem( file_name1, list_file_name , ";",j)
						//index = WhichListItem( file_name2, list_file_name )
						//list_file_name = RemoveListItem( index, list_file_name )
						//list_file_name = AddListItem( file_name2, list_file_name , ";",i)
						
					endif
					
					Killwaves temp1sw,temp2sw ,  temp1list,temp2list
					break
				case "Down_button":
					for ( k = 0 ; k < size2 ; k = k + 1)
						if( cmpstr ( ListWave1[k][1] , "")  == 0 )
							break	
						endif
					endfor
					for ( i = 0 ; i < k ; i = i + 1)
						if( (sw1[i][0] == (2^0)) || (sw1[i][1] == (2^0)) || (sw1[i][2] == (2^0)) || (sw1[i][3] == (2^0)) || (sw1[i][4] == (2^0)) || (sw1[i][5] == (2^0)) || (sw1[i][6] == (2^0)) || (sw1[i][7] == (2^0)) )
							break	
						endif
					endfor
					j = i + 1
					if( i != (k - 1)  && ( cmpstr ( ListWave1[i][1] , "")  != 0 ) )
						temp1sw = sw1[i][p]
						temp2sw  = sw1[j][p] 
						
						temp1list = ListWave1[i][p]
						temp2list  = ListWave1[j][p] 
					
						sw1[i][0,size1] = temp2sw[q]
						sw1[j][0,size1] = temp1sw[q]
						
						ListWave1[i][0,size1] = temp2list[q]
						ListWave1[j][0,size1] = temp1list[q]
						
						ListWave1[i][0] = num2str(i+1)
						ListWave1[j][0] = num2str(j+1)
						
						n1 = WhichListItem( ListWave1[j][1], list_file_name )
						n2 = WhichListItem( ListWave1[i][1], list_file_name )
						
						list_file_name = Swap_Items( list_file_name, n1, n2 )
						list_file_path = Swap_Items( list_file_path, n1, n2 )
						list_folder = Swap_Items( list_folder, n1, n2 )
						
					endif
					Killwaves temp1sw,temp2sw ,  temp1list,temp2list
					break
			endswitch
			
			break
	endswitch

	return 0
End

Function/S Swap_Items(list, index1, index2)
	String list
	Variable index1, index2
	
	String name1 , name2 
	Variable index
	name1 = StringFromList( index1, list )
	name2 = StringFromList( index2, list )
	list = RemoveListItem( index1, list )
	list = AddListItem( name1, list , ";", index2)
	index = WhichListItem( name2, list )
	list = RemoveListItem( index, list )
	list = AddListItem( name2, list , ";", index1)
	return list
End

Function/S Shift_Item(list, index1, index2)
	String list
	Variable index1, index2
	
	String name1
	name1 = StringFromList( index1, list )
	list = RemoveListItem( index1, list )
	list = AddListItem( name1, list , ";", index2)
	return list
End

Function ButtonProc_MakeFrame(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			WAVE sw1 = root:Load_and_Set_Panel:sw1
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			SVAR list_file_name  	= 	root:Specs:list_file_name 
			SVAR list_file_path 	= 	root:Specs:list_file_path
			SVAR 	list_folder 	= 	root:Specs:list_folder
			WAVE/T ListWave2 
			Setdatafolder root:Specs:
			Duplicate/O sw1 , sw2
			Duplicate/O/T ListWave1 , ListWave2
			
			String name1, name2,name3,name4
			Variable number, maxnumber
			maxnumber = ItemsInList(list_file_name)
			if(maxnumber < 2)
				break
			endif
			Variable selected_row,selected_column,columns
			Variable i,j
			selected_row = -1
			selected_column = -1
			columns = DimSize(ListWave1,1)
			for(i = 0; i < maxnumber ; i += 1)
				for(j = 0; j < columns ; j += 1)
					if( (sw1[i][j] & 2^0) != 0 )
						selected_row = i 
						break
					endif
				endfor
			endfor
			if( selected_row == -1 || selected_row>(maxnumber))
				DoPrompt	"Select one image"
				break
			endif
			name1 =  ListWave1[selected_row][1]
			if(selected_row ==(maxnumber-1))	
				name2 =  ListWave1[selected_row][1]
			else
				name2 =  ListWave1[selected_row+1][1]
			endif 
			number = selected_row +2 
			
			name3 = RemoveEnding(name1 , ".sp2") + "b.sp2" 
			Prompt name1, "1st image", popup list_file_name
			Prompt name2, "2nd image", popup list_file_name
			Prompt name3, "give the name to a new image"
			Prompt number,  "Insert an image as a number (from " + num2str(1) +" till "+ num2str(maxnumber+1)+"):"
			DoPrompt	"Select two images and set the number for a new one",  name1, name2, number,name3
			
			if (V_Flag)
				return 0									// user canceled
			endif
			
			name4=ListMatch(list_file_name, name3 )
			if(	 cmpstr ( name4, "") != 0  )
				KillWaves sw2 , ListWave2
				break
			endif
			
			if(!cmpstr (name1,""))
				KillWaves sw2 , ListWave2
				break
			endif
			if(!cmpstr (name2,""))
				KillWaves sw2 , ListWave2
				break
			endif

			if( number<1 || number>(maxnumber+1) )
				break 
			endif	
			
			Variable selected_row1, selected_row2
			for(i = 0; i < maxnumber ; i += 1)
				if( cmpstr ( name1, ListWave1[i][1] ) == 0)	
						selected_row1 = i 
				endif
				if( cmpstr ( name2, ListWave1[i][1] ) == 0)	
						selected_row2 = i 
				endif
			endfor
			
			ListWave1[maxnumber][] = ListWave1[selected_row1][q]
			ListWave1[maxnumber][1] = name3
			ListWave1[maxnumber][0] = num2str(maxnumber+1)
			sw1[maxnumber][] = sw1[selected_row1][q]
			sw1[maxnumber][1] = sw1[maxnumber][1] & ~2^0 
			
			NewDataFolder /O root:Specs:$name3
			Setdatafolder root:Specs:$name1
			Wave image1 = $name1
			Wave line = nwave
			Setdatafolder root:Specs:$name2
			Wave image2 = $name2
			Setdatafolder root:Specs:$name3
			Duplicate/O image1, $name3
			Wave image3 = $name3
			
			Variable Average1, Average2,help1
			ImageStats image1	
			Average1 = V_avg
			ImageStats image2
			Average2 = V_avg
			help1 = Average1/Average2
			image2 = image2*help1
				
			image3 = image1 + image2
			image3 = image3/2
			Duplicate/O line, nwave
			
			Setdatafolder root:Specs:
			String item1,item2,item3
			Variable n1, n2
			
			n1 = WhichListItem( ListWave1[selected_row1][1], list_file_name )		
			
			item1 = "do not exist" 
			item2 = StringFromList(n1, list_file_name) 
			item3 = StringFromList(n1, list_folder) 
			
			item3 = RemoveEnding(item3 , item2) + name3
			item2 = name3
			list_file_path 	= 	AddListItem(item1, list_file_path , ";", Inf)		 //Adds item to the end of the string
			list_file_name = 	AddListItem(item2, list_file_name , ";", Inf)
			list_folder = 	AddListItem(item3, list_folder , ";", Inf)
			
			n1 = WhichListItem( ListWave1[maxnumber][1], list_file_name )
			n2 = WhichListItem( ListWave1[number-1][1], list_file_name )		
		
			list_file_name = Shift_Item( list_file_name, n1, n2 )
			list_file_path = Shift_Item( list_file_path, n1, n2 )
			list_folder = Shift_Item( list_folder, n1, n2 )
			
			Variable size1,size2,tilt1
			size1 = DimSize(listWave1,1)
			Make/T /FREE /N=(size1) temp_elem
			Make /FREE /N=(size1) temp_sw
			tilt1 = ( str2num(listWave1[selected_row1][3]) + str2num(listWave1[selected_row2][3]) )/2
			
			temp_elem[] = listWave1[maxnumber][p]
			ListWave2[number-1,maxnumber][] = ListWave1[p-1][q]
			ListWave2[number-1][] = temp_elem[q]
			ListWave1[][] = ListWave2[p][q] 
			ListWave1[0,maxnumber][0] = num2str(p+1)
			ListWave1[number-1][3] = num2str(tilt1)
			
			temp_sw[] = sw1[maxnumber][p]
			sw2[number-1,maxnumber][] = sw1[p-1][q]
			sw2[number-1][] = temp_sw[q]
			sw1[][] = sw2[p][q] 
			//Variable size1
			//size1 = DimSize(listWave1,1)
			//Make/T /FREE /N=(size1) temp_elem
			//temp_elem = listWave1[maxnumber][p]
			//for(i = maxnumber-1 ; i > (number -1) ;i=i-1)
			//	listWave1[i][] = listWave1[i-1][q]
			//	listWave1[i][0] = num2str(i+1) 
			//endfor
			//listWave1[number-1][] = temp_elem[q]
			//listWave1[number-1][0] = num2str(number) 
			
			Setdatafolder root:Specs:
			KillWaves sw2 , ListWave2 
			break
	endswitch

	return 0
End

Function Remove_file(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			STRUCT 	file_header fh
			Setdatafolder root:
			WAVE sw1			=	root:Load_and_Set_Panel:sw1	
			Setdatafolder root:Specs:
			SVAR list_folder 	= 	root:Specs:list_folder
			SVAR list_file_path 	= 	root:Specs:list_file_path
			SVAR list_file_name  	= 	root:Specs:list_file_name 
			STRING name1,name2
			Variable i,j,k, number
			SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
			SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
			Variable counter1 , counter2 
			Variable test2
			
			DoWindow  Smoothing_Panel	
			if(V_flag == 1)
				KillWindow  Smoothing_Panel	
			endif
			
			String name3
			name3 = ImageNameList("Load_and_set_Panel#G3", "" )
			name3 = StringFromList (0, name3  , ";")
			If( cmpstr ( name3, "") != 0 ) 
				RemoveImage /W=Load_and_set_Panel#G3 Display1
			endif
			
			name3 = ImageNameList("Load_and_Set_Panel#G2", "" )
			name3 = StringFromList (0, name3  , ";")
			If( cmpstr ( name3, "") != 0 )
				RemoveImage /W=Load_and_set_Panel#G2 Display2
			endif
			
			ControlInfo /W=Load_and_Set_Panel list0
			name1 = S_DataFolder  + S_Value
			WAVE/T 		ListWave = $name1
			
			counter1 = ItemsInList(list_file_name)
			counter2 = DimSize(ListWave,1) 
			test2 = 0
			for(i = 0; i < counter1 ; i += 1)
				for(j = 0; j < counter2 ; j += 1)
					if( (sw1[i][j] & 2^0) != 0 )
						test2 = i 
						break
					endif
				endfor
				if( test2 != 0 )
					break
				endif
			endfor
				
			name2 =  ListWave[test2][1]
			if(	 cmpstr ( name2, "") == 0  )
				return 0
			endif
			
			//SetDataFolder root:Specs:$name2
			Variable first = test2 +1
			Variable last = first
				
			Prompt first, "Nr of the First Image:"
			Prompt last, "Nr of the Last Image:"
			DoPrompt	"Enter Values",  first, last
			
			if (V_Flag)
				return 0									// user canceled
			endif
			
			first = round(first)
			if(last<first)
				return 0
			endif
			if(first<1)
				first = 1
			endif
			if(first>counter1)
				break
			endif
			if(last >counter1)
				last = counter1
			endif
			if(last <1)
				last = 1
			endif
			Variable m
			for(m = first-1;m<last;m+=1)
				i = first-1
				name2 =  ListWave[i][1]
				if(	 cmpstr ( name2, "") == 0  )
					return 0
				endif
			
				Variable help1
				help1 = WhichListItem(name2, list_file_name)
				name1 			=	StringFromList(help1, list_folder)
				name2 			=	StringFromList(help1, list_file_name)
				list_file_path		=	RemoveListItem(help1, list_file_path)		 //Adds item to the end of the string
				list_file_name 	= 	RemoveListItem(help1, list_file_name)
				list_folder 		= 	RemoveListItem(help1, list_folder)
				ListWave[i][0]    	=	""
				ListWave[i][1] 	= 	""
				ListWave[i][2] 	= 	""
				ListWave[i][3] 	= 	""
				ListWave[i][4] 	= 	""
				ListWave[i][5]    	=	""
				ListWave[i][6] 	= 	""
				ListWave[i][7] 	= 	""
				ListWave[i][8] 	= 	""
				ListWave[i][9] 	= 	""
				ListWave[i][10] 	= 	""
				ListWave[i][11] 	= 	""
				ListWave[i][12] 	= 	""
				ListWave[i][13] 	= 	""
				ListWave[i][14] 	= 	""
				ListWave[i][15] 	= 	""
				ListWave[i][16] 	= 	""
				ListWave[i][17] 	= 	""
				ListWave[i][18] 	= 	""
				ListWave[i][19] 	= 	""
				
				sw1[i][0]			=   	sw1[i][0] & ~(2^1)
				sw1[i][1]			=   	sw1[i][1] & ~(2^1)
				sw1[i][2]			=   	sw1[i][2] & ~(2^1)
				sw1[i][3]			=   	sw1[i][3] & ~(2^1)
				sw1[i][4]			=   	sw1[i][4] & ~(2^1)
				sw1[i][5]			=   	sw1[i][5] & ~(2^1)
				sw1[i][6]			=   	sw1[i][6] & ~(2^1)
				sw1[i][7]			=   	sw1[i][7] & ~(2^1)
				sw1[i][8]			=   	sw1[i][8] & ~(2^1)
				sw1[i][9]			=   	sw1[i][9] & ~(2^1)
				sw1[i][10]		=   	sw1[i][10] & ~(2^1)
				sw1[i][11]		=   	sw1[i][11] & ~(2^1)
				sw1[i][12]		=   	sw1[i][12] & ~(2^1)
				sw1[i][13]		=   	sw1[i][13] & ~(2^1)
				sw1[i][14]		=   	sw1[i][14] & ~(2^1)
				sw1[i][15]		=   	sw1[i][15] & ~(2^1)
				sw1[i][16]		=   	sw1[i][16] & ~(2^5)
				sw1[i][17]		=   	sw1[i][17] & ~(2^5)
				sw1[i][18]		=   	sw1[i][18] & ~(2^5)
				sw1[i][19]		=   	sw1[i][19] & ~(2^5)
				
				sw1[i][16]		=   	sw1[i][16] & ~(2^4)
				sw1[i][17]		=   	sw1[i][17] & ~(2^4)
				sw1[i][18]		=   	sw1[i][18] & ~(2^4)
				sw1[i][19]		=   	sw1[i][19] & ~(2^4)
				
				counter1 = ItemsInList(list_file_name)
				for(j = first-1 ; j < counter1 ; j += 1)
				 	k= j + 1
					if( cmpstr ( ListWave[k][0], "")  == 0 )
						break
					endif
					ListWave[j][0] = 	num2str(j+1)
					ListWave[j][1] = 	ListWave[k][1]
					ListWave[j][2] = 	ListWave[k][2]
					ListWave[j][3] = 	ListWave[k][3]
					ListWave[j][4] = 	ListWave[k][4]
					ListWave[j][5] = 	ListWave[k][5]
					ListWave[j][6] = 	ListWave[k][6]
					ListWave[j][7] = 	ListWave[k][7]
					ListWave[j][8] = 	ListWave[k][8]
					ListWave[j][9] = 	ListWave[k][9]
					ListWave[j][10] = 	ListWave[k][10]
					ListWave[j][11] = 	ListWave[k][11]
					ListWave[j][12] = 	ListWave[k][12]
					ListWave[j][13] = 	ListWave[k][13]
					ListWave[j][14] = 	ListWave[k][14]
					ListWave[j][15] = 	ListWave[k][15]
					ListWave[j][16] = 	ListWave[k][16]
					ListWave[j][17] = 	ListWave[k][17]
					ListWave[j][18] = 	ListWave[k][18]
					ListWave[j][19] = 	ListWave[k][19]
					
					sw1[j][16] = 	sw1[k][16]
					sw1[j][17] = 	sw1[k][17]
					sw1[j][18] = 	sw1[k][18]
					sw1[j][19] = 	sw1[k][19]
					
					ListWave[k][0] 	= 	""
					ListWave[k][1] 	= 	""
					ListWave[k][2] 	= 	""
					ListWave[k][3] 	= 	""
					ListWave[k][4] 	= 	""
					ListWave[k][5] 	= 	""
					ListWave[k][6] 	= 	""
					ListWave[k][7] 	= 	""
					ListWave[k][8] 	= 	""
					ListWave[k][9] 	= 	""
					ListWave[k][10] 	= 	""
					ListWave[k][11] 	= 	""
					ListWave[k][12] 	= 	""
					ListWave[k][13] 	= 	""
					ListWave[k][14] 	= 	""
					ListWave[k][15] 	= 	""
					ListWave[k][16] 	= 	""
					ListWave[k][17] 	= 	""
					ListWave[k][18] 	= 	""
					ListWave[k][19] 	= 	""
					
					sw1[j][0]			=   	sw1[j][0] | (2^1)
					sw1[j][2]			=   	sw1[j][2] | (2^1)
					sw1[j][3]			=   	sw1[j][3] | (2^1)
					sw1[j][4]			=   	sw1[j][4] | (2^1)
					sw1[j][5]			=   	sw1[j][5] | (2^1)
					sw1[j][6]			=   	sw1[j][6] | (2^1)
					sw1[j][7]			=   	sw1[j][7] | (2^1)
					sw1[j][8]			=   	sw1[j][8] | (2^1)
					sw1[j][9]			=   	sw1[j][9] | (2^1)
					sw1[j][10]		=   	sw1[j][10] | (2^1)
					sw1[j][11]		=   	sw1[j][11] | (2^1)
					sw1[j][12]		=   	sw1[j][12] | (2^1)
					sw1[j][13]		=   	sw1[j][13] | (2^1)
					sw1[j][14]		=   	sw1[j][14] | (2^1)
					sw1[j][15]		=   	sw1[j][15] | (2^1)
					sw1[j][16]		=   	sw1[j][16] | (2^5)
					sw1[j][17]		=   	sw1[j][17] | (2^5)
					sw1[j][18]		=   	sw1[j][18] | (2^5)
					sw1[j][19]		=   	sw1[j][19] | (2^5)
					
					sw1[k][0]			=   	sw1[k][0] & ~(2^1)
					sw1[k][2]			=   	sw1[k][2] & ~(2^1)
					sw1[k][3]			=   	sw1[k][3] & ~(2^1)
					sw1[k][4]			=   	sw1[k][4] & ~(2^1)
					sw1[k][5]			=   	sw1[k][5] & ~(2^1)
					sw1[k][6]			=   	sw1[k][6] & ~(2^1)
					sw1[k][7]			=   	sw1[k][7] & ~(2^1)
					sw1[k][8]			=   	sw1[k][8] & ~(2^1)
					sw1[k][9]			=   	sw1[k][9] & ~(2^1)
					sw1[k][10]			=   	sw1[k][10] & ~(2^1)
					sw1[k][11]			=   	sw1[k][11] & ~(2^1)
					sw1[k][12]			=   	sw1[k][12] & ~(2^1)
					sw1[k][13]			=   	sw1[k][13] & ~(2^1)
					sw1[k][14]			=   	sw1[k][14] & ~(2^1)
					sw1[k][15]			=   	sw1[k][15] & ~(2^1)
					sw1[k][16]			=   	sw1[k][16] & ~(2^5)
					sw1[k][17]			=   	sw1[k][17] & ~(2^5)
					sw1[k][18]			=   	sw1[k][18] & ~(2^5)
					sw1[k][19]			=   	sw1[k][18] & ~(2^5)
				endfor
				KillDataFolder root:Specs:$name2
				
			endfor
						
			//if( cmpstr ( Title_left1, name2)  == 0)
			//	Title_left1 = ""
			//	RemoveImage /W=Load_and_Set_Panel#G0 Angle_2D
			//endif
			
			//if(cmpstr ( Title_right1, name2)  == 0)
			//	Title_right1 = ""
			//	RemoveImage /W=Load_and_Set_Panel#G1 Angle_2D
			//endif
			
			
			//String nameA
			//SetWindow Load_and_Set_Panel#G3
			//nameA = ImageNameList("Load_and_Set_Panel#G3", "" )
			//nameA = StringFromList(0, nameA)
			//if( cmpstr (nameA, "")  == 1 ||  cmpstr (nameA, "")  == -1)
			//	RemoveImage /W=Load_and_Set_Panel#G3 $nameA
			//endif
			
			//nameA = ImageNameList("Load_and_Set_Panel#G2", "" )
			//nameA = StringFromList(0, nameA)
			//if( cmpstr (nameA, "")  == 1 ||  cmpstr (nameA, "")  == -1)
			//	RemoveImage /W=Load_and_Set_Panel#G2 $nameA
			//endif
			
			//KillDataFolder root:Specs:$name2
			break
	endswitch

	return 0
End

Function take_left1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			WAVE sw1	=	root:Load_and_Set_Panel:sw1	
			STRING name2,name1
			Variable i, number
			SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
			SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
			STRUCT file_header fh
			ControlInfo /W=Load_and_Set_Panel list0
			name1 = S_DataFolder  + S_Value
			WAVE/T 		ListWave = $name1
				
			number = DimSize(ListWave,0) 
			for(i = 0; i < number ; i += 1)
				if( (sw1[i][0] & 2^0) != 0 ||  (sw1[i][1] & 2^0) != 0 || (sw1[i][2] & 2^0) != 0 || (sw1[i][3] & 2^0) != 0 || (sw1[i][4] & 2^0) != 0  || (sw1[i][5] & 2^0) != 0  || (sw1[i][6] & 2^0) != 0  || (sw1[i][7] & 2^0) != 0)
					break
				endif
			endfor
			name2 =  ListWave[i][1]
			if(	 cmpstr ( name2, "") == 0  )
				return 0
			endif
			SetDataFolder root:Specs:$name2
			WAVE Angle_2D
			If( cmpstr ( Title_left1, "") != 0 )
				RemoveImage /W=Load_and_Set_Panel#G0 Angle_2D
			endif
			Title_left1 = name2
			AppendImage /W=Load_and_Set_Panel#G0 Angle_2D
			ModifyGraph  /W=Load_and_Set_Panel#G0 swapXY=1
			ModifyGraph /W=Load_and_Set_Panel#G0 margin=-1
			ModifyGraph /W=Load_and_Set_Panel#G0 noLabel=2
			ModifyGraph /W=Load_and_Set_Panel#G0 frameStyle= 6
			SetDataFolder root:Load_and_Set_Panel:
			Duplicate/O Angle_2D, L_image1
			//execute/Z/Q "Cursor/W=Load_and_Set_Panel#G0 /P/S=2/I/H=2/C=(65280,0,0) A Angle_2D_smoothed 0," + num2str(fh.nCurves-1)
		break
	endswitch

	return 0
End

Function take_right1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			WAVE sw1	=	root:Load_and_Set_Panel:sw1	
			STRING name2,name1
			Variable i,number
			SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
			SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
			STRUCT file_header fh
			ControlInfo /W=Load_and_Set_Panel list0
			name1 = S_DataFolder  + S_Value
			WAVE/T 		ListWave = $name1
				
			number = DimSize(ListWave,0) 
			for(i = 0; i < number ; i += 1)
				if( (sw1[i][0] & 2^0) != 0 ||  (sw1[i][1] & 2^0) != 0 || (sw1[i][2] & 2^0) != 0 || (sw1[i][3] & 2^0) != 0 || (sw1[i][4] & 2^0) != 0 || (sw1[i][5] & 2^0) != 0  || (sw1[i][6] & 2^0) != 0  || (sw1[i][7] & 2^0) != 0)
					break
				endif
			endfor
			name2 =  ListWave[i][1]
			if(	 cmpstr ( name2, "") == 0  )
				return 0
			endif
			SetDataFolder root:Specs:$name2
			WAVE Angle_2D
			If( cmpstr ( Title_right1, "") != 0 )
				RemoveImage /W=Load_and_Set_Panel#G1 Angle_2D	
			endif
			Title_right1 = name2
			AppendImage /W=Load_and_Set_Panel#G1 Angle_2D
			ModifyGraph  /W=Load_and_Set_Panel#G1 swapXY=1
			ModifyGraph /W=Load_and_Set_Panel#G1 margin=-1
			ModifyGraph /W=Load_and_Set_Panel#G1 noLabel=2
			ModifyGraph /W=Load_and_Set_Panel#G1 frameStyle= 6
			SetDataFolder root:Load_and_Set_Panel:
			Duplicate/O Angle_2D, R_image1
			//execute/Z/Q "Cursor/W=Load_and_Set_Panel#G1 /P/S=2/I/H=2/C=(0,65280,0) B Angle_2D_smoothed 0,0"
		break
	endswitch

	return 0
End

Function Blend_button(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Variable nrPixE
			Variable nrPixA
			
			STRING name1,name2,name3
			Variable i,j,k, number
			SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
			SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
			Variable help1,help2,help3,help4,help5,help6
			
			If( cmpstr ( Title_left1, "") == 0 )
				return 0
			endif
			If( cmpstr ( Title_right1, "") == 0 )
				return 0
			endif
			
			DoWindow/F Blended_Panel					//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow Blended_Panel
			endif
			if(DataFolderExists("root:Blending_Panel"))
				KillDataFolder root:$"Blending_Panel"
			endif
			
			Variable La,Ra,Lke,Hke,deltaA,deltaE
			Setdatafolder root:Load_and_Set_Panel:
			Wave Angle_2D = L_image1
			La = DimOffset(Angle_2D,1)
			Ra = DimOffset(Angle_2D,1) + (DimSize(Angle_2D,1) - 1)*DimDelta(Angle_2D,1)
			Lke = DimOffset(Angle_2D,0)
			Hke = DimOffset(Angle_2D,0) + (DimSize(Angle_2D,0) - 1)*DimDelta(Angle_2D,0)
			deltaA = DimDelta(Angle_2D,1)
			deltaE = DimDelta(Angle_2D,0)
			
			Wave Angle_2D = R_image1
			help1 = DimOffset(Angle_2D,1)
			help2 = DimOffset(Angle_2D,1) + (DimSize(Angle_2D,1) - 1)*DimDelta(Angle_2D,1)
			help3 = DimOffset(Angle_2D,0)
			help4 = DimOffset(Angle_2D,0) + (DimSize(Angle_2D,0) - 1)*DimDelta(Angle_2D,0)	
			help5 = DimDelta(Angle_2D,1)
			help6 = DimDelta(Angle_2D,0)
			if(La>help1)
				La = help1
			endif
			if(Ra<help2)
				Ra = help2
			endif
			if(Lke>help3)
				Lke = help3
			endif
			if(Hke<help4)
				Hke = help4
			endif
			if(deltaA>help5)
				deltaA = help5
			endif
			if(deltaE>help6)
				deltaA = help6
			endif
			
			Variable totalNrPixA , totalNrPixE
			totalNrPixA = round((Ra - La)/deltaA) + 1
			totalNrPixE = round((Hke - Lke)/deltaE) + 1
			
			NewDataFolder /O root:$"Blending_Panel"
			SetDataFolder root:$"Blending_Panel"
			
			Variable /G vectorA = 0
			Variable /G vectorE = 0
			Variable/G Normalization = 1
			
			Make/O/N=(totalNrPixE,totalNrPixA) FinalBlendKE
			FinalBlendKE = 0
			SetScale/P x, Lke, deltaE,"" FinalBlendKE
           		SetScale/P y, La, deltaA, "" FinalBlendKE
           		Duplicate/O FinalBlendKE , TemporaryHoldKE_L
           		Duplicate/O FinalBlendKE , TemporaryHoldKE_R
           		Duplicate/O FinalBlendKE , FinalBlendKEori
			
			Variable La1,Ra1
			Variable La2,Ra2
			Variable He1,Le1
			Variable He2,Le2
			
			Setdatafolder root:Load_and_Set_Panel:
			Wave Angle_2D = L_image1
			
			SetDataFolder root:$"Blending_Panel"
			Duplicate/O Angle_2D, L_Image
			Duplicate/O Angle_2D, L_Image_dif
			
			Wave v1
			nrPixE = DimSize(L_Image_dif,0)
			nrPixA = DimSize(L_Image_dif,1)
			Make/FREE /N=(nrPixE)  v1 
			
			L_Image_dif = 0
			for(i = 0; i <nrPixA;i+=1)	// Initialize variables;continue test
				v1 =  L_Image[p][i]
				//Smooth 2 , v1
				Differentiate/METH=0/EP=0 v1
				Differentiate/METH=0/EP=0 v1
				L_Image_dif[][i] = -v1[p]
			endfor
			
			La1 = DimOffset(L_Image,1)
			Ra1 = DimOffset(L_image,1) + (DimSize(L_image,1)-1)*DimDelta(L_image,1)
			He1 = DimOffset(L_image,0) + (DimSize(L_image,0)-1)*DimDelta(L_image,0)
			Le1 = DimOffset(L_image,0)
			
			Variable index1A,index2A,index3A,index4A
			Variable index1E,index2E,index3E,index4E
			index1A = round ( ( La1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
			index3A = round ( ( Ra1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) 
			index1E = round ( ( Le1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
			index3E = round ( ( He1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
			
			TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image(x)(y)
			FinalBlendKE = TemporaryHoldKE_L
			
			Setdatafolder root:Load_and_Set_Panel:
			Wave Angle_2D = R_image1
			
			SetDataFolder root:$"Blending_Panel"
			Duplicate/O Angle_2D,  R_Image 
			Duplicate/O Angle_2D,  R_Image_dif
			
			nrPixE = DimSize(R_Image_dif,0)
			nrPixA = DimSize(R_Image_dif,1)
			Make/FREE /N=(nrPixE)  v1 
			
			R_Image_dif = 0
			for(i = 0; i <nrPixA;i+=1)	// Initialize variables;continue test
				v1 =  R_Image[p][i]
				//Smooth 2 , v1
				Differentiate/METH=0/EP=0 v1
				Differentiate/METH=0/EP=0 v1
				R_Image_dif[][i] = -v1[p]
			endfor
			KillWaves v1
				
			La2 = DimOffset(R_image,1)
			Ra2 = DimOffset(R_image,1) + (DimSize(R_image,1)-1)*DimDelta(R_image,1)
			He2 = DimOffset(R_image,0) + (DimSize(R_image,0)-1)*DimDelta(R_image,0)
			Le2 = DimOffset(R_image,0)
				
			index1A = round ( ( La1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
			index3A = round ( ( Ra1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) 
			index2A = round ( ( La2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
			index4A = round ( ( Ra2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
			
			index1E = round ( ( Le1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
			index3E = round ( ( He1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
			index2E = round ( ( Le2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
			index4E = round ( ( He2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
				
			TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
			
			Variable Average1, Average2
				
			if( index3A >= index2A )
				if( index2A >= index1A )
					Average1 = 0
					Average2 = 0
					for(j=index2A;j<=index3A;j+=1)
						for(i=0;i<totalNrPixE;i+=1)
							help2 = TemporaryHoldKE_R[i][j]
							help1 = TemporaryHoldKE_L[i][j]
							if( help1!= 0 && help2!=0 )
								Average1+=help1
								Average2+=help2
							endif
						endfor
					endfor
					Normalization=Average1/Average2
					TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
					FinalBlendKE[][index3A+1,index4A] = TemporaryHoldKE_R[p][q]
				else
					if(index1A > index4A)
						Average1 = 1
						Average2 = 1	
					else
						for(j=index1A;j<=index4A;j+=1)
								for(i=0;i<totalNrPixE;i+=1)
								help2 = TemporaryHoldKE_R[i][j]
								help1 = TemporaryHoldKE_L[i][j]
								if( help1!= 0 && help2!=0 )
									Average1+=help1
									Average2+=help2
								endif
							endfor
						endfor	
						Normalization=Average1/Average2
						TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
						FinalBlendKE[][index2A+1,index4A] = TemporaryHoldKE_R[p][q]	
					endif
				endif
			else
				Average1 = 1
				Average2 = 1	
				Normalization=Average1/Average2
				TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
				FinalBlendKE[][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
			endif
	
			Make/O/N=(totalNrPixA) Crossection6
			Make/O/N=(totalNrPixA) Crossection7
			
			Make/O/N=(totalNrPixE) Crossection8
			Make/O/N=(totalNrPixE) Crossection9
			
			DoWindow/F Blended_Panel					//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow Blended_Panel
			endif
			Display_Blended_Panel()
			
			Slider slider0,limits={0,(totalNrPixE - 1),1}
			Slider slider1,limits={0,(totalNrPixA - 1),1}
			
			DoUpdate
			
			AppendImage /W=Blended_Panel#G0 FinalBlendKE
			//AppendImage /W=Blended_Panel#G0 tImageLR2
			ModifyGraph  /W=Blended_Panel#G0 swapXY=1
			
			AppendToGraph /W=Blended_Panel#G1 Crossection6
			AppendToGraph /W=Blended_Panel#G1 /C=(0,65535,0) Crossection7
			
			ModifyGraph /W=Blended_Panel#G2 swapXY=1
			AppendToGraph /W=Blended_Panel#G2 Crossection8
			AppendToGraph /W=Blended_Panel#G2 /C=(0,65535,0) Crossection9
			//ModifyGraph /W=Blended_Panel#G2 notation(bottom)=1
			
			Variable index3Ehalf
  			index3Ehalf = round(index3E/2)
  			
			execute/Z/Q "Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE "+num2str(index3Ehalf)+"," +num2str(index3A)
			execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=1/C=(65280,0,0) B FinalBlendKE 0,0"
			CursorDependencyForGraph()
			//execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,65280,0) B ImageLR 0," + num2str(jmax -1- jmin)
			//execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) C ImageLR 0," + nu1m2str(jmax -1)
			SetVariable setvar0 value = _NUM:0
			ValDisplay valdispAvg,value=_NUM:0
			//Killwaves tImageLR1,tImageLR2
		break
	endswitch

	return 0
End

Function Blend_buttonNew(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			STRING name1,name2,name3
			Variable i,j,k, number
			SVAR Title_left1 = root:Title_left1
			SVAR Title_right1 = root:Title_right1
			STRUCT file_header fh1 
			STRUCT file_header fh2
			
			Variable eA1, eA2
			Variable La1,Ra1
			Variable La2,Ra2
			Variable He1, Le1
			Variable He2, Le2
			Variable y1,y2,y3,y4
			
			Variable aNumber1, aNumber2
			Variable deltaA1, deltaA2
			Variable deltaE1, deltaE2
	
			Variable LaNew, RaNew
			Variable aNumberNew
			Variable eNumber1, eNumber2
			Variable overlapN
			Variable LeNew , HeNew
			
			If( cmpstr ( Title_left1, "") == 0 )
				return 0
			endif
			If( cmpstr ( Title_right1, "") == 0 )
				return 0
			endif
	
			Setdatafolder root:Specs:$Title_left1
			StructGet /B=0 fh1, header
			Setdatafolder root:Specs:
			WAVE L_image1
			ControlInfo /W=Load_and_Set_Panel check0
			if(V_Value == 1)
				Setdatafolder root:Specs:$Title_left1
				WAVE Angle_dif2_2D
				L_image1 = -Angle_dif2_2D
				Setdatafolder root:Specs:
			else	
				Setdatafolder root:Specs:$Title_left1
				WAVE Angle_2D_smoothed
				L_image1 = Angle_2D_smoothed
				Setdatafolder root:Specs:
			endif

			//Duplicate/O/O Angle_2D_smoothed,L_image1
			eA1 = fh1.eAngle 
			La1 = fh1.aLow
			Ra1 = fh1.aHigh
			He1 = fh1.eHigh
			Le1 = fh1.eLow
			
			aNumber1 = DimSize(L_image1,1)
			eNumber1 = DimSize(L_image1,0) 
			deltaE1 = DimDelta(L_image1,0)
			
			Setdatafolder root:Specs:$Title_right1
			StructGet /B=0 fh2, header
			Setdatafolder root:Specs:
			WAVE R_image1
			if(V_Value == 1)
				Setdatafolder root:Specs:$Title_right1
				WAVE Angle_dif2_2D
				R_image1 = -Angle_dif2_2D
				Setdatafolder root:Specs:
			else
				Setdatafolder root:Specs:$Title_right1
				WAVE Angle_2D_smoothed
				R_image1 = Angle_2D_smoothed
				Setdatafolder root:Specs:
			endif
			//Duplicate/O/O Angle_2D_smoothed,R_image1
			eA2 = fh2.eAngle 
			La2 = fh2.aLow
			Ra2 = fh2.aHigh
			He2 = fh2.eHigh
			Le2 = fh2.eLow
			
			aNumber2 = DimSize(R_image1,1)
			eNumber2 = DimSize(R_image1,0) 
			
			ControlInfo /W=Load_and_Set_Panel list0
			name3 = S_DataFolder  + S_Value
			WAVE/T 		ListWave = $name3
			number = DimSize(ListWave,0) 
			
			if(Ra1 < La2)
				Return 0
				Print "Images do not overlap"
			endif
			
			overlapN = round( (Ra1 - La2)/fh2.deltaA )
			aNumberNew = aNumber1 + aNumber2 - overlapN
			LaNew = La1
			RaNew = Ra2
			
			Setdatafolder root:Specs:
			Make/O/N=(eNumber1,aNumberNew) tImageLR
			tImageLR = 0
			If(Le1 < Le2)
				LeNew = Le2
			else
				LeNew = Le1
			endif
			
			If(He1 < He2)
				HeNew = He1
			else
				HeNew = He2
			endif
			
			SetScale /I x, LeNew, HeNew,"Kinetic Energy [eV]" ,tImageLR
			SetScale /I y, LaNew, RaNew, "Angle [deg]" ,tImageLR
			Variable x1,x2,x3,x4
			Duplicate/O tImageLR tImageLR1
			Duplicate/O tImageLR tImageLR2
				
			//x1 = round( (La1 - DimOffset(tImageLR, 1))/DimDelta(tImageLR,1))
			x1 = 0
			x2 = round ((Ra1 - DimOffset(tImageLR, 1))/DimDelta(tImageLR,1)) 
			x3 = round ((La2 - DimOffset(tImageLR, 1))/DimDelta(tImageLR,1))
			x4 = round ((Ra2 - DimOffset(tImageLR, 1))/DimDelta(tImageLR,1)) 
			
			Variable offsetA, offsetE
			ControlInfo /W=Blended_Panel setvar0
			offsetA = V_Value
			ControlInfo /W=Blended_Panel setvar1
			offsetE = V_Value
			
			tImageLR1[][x1,x2] = L_image1[p][q]
			tImageLR2[][x3,x4] = R_image1[p][q-x3]
			tImageLR[][x3,x2] = tImageLR1[p][q] - tImageLR2[p][q]
			
			
			Variable sum1,sum2,sum3,divider
			sum1 = 0
			sum2 = 0
			divider = 0
			for(i = x3 ; i < x2 ; i+=1)
				for(j = 0; j< eNumber1 ; j+=1)
					sum1 = tImageLR[j][i] + sum1
					sum2 = tImageLR1[j][i] + sum2
					sum3 = tImageLR2[j][i] + sum3
				endfor
			endfor
			
			if(sum1 > 0)
				divider = sum1/sum3 + 1
				tImageLR2 = tImageLR2 * divider
			else
				divider = abs (sum1/sum2) + 1
				tImageLR1 = tImageLR1 * divider
			endif
			SetDataFolder root:Specs:
			NVAR AngleShift
			NVAR EnergyShift
			AngleShift = 0
			EnergyShift = 0

			tImageLR[][x1,x2] =  tImageLR1[p][q]
			tImageLR[][x3,x4] =  tImageLR2[p][q]
			
			Make/O/N=(aNumberNew) Crossection6
			Make/O/N=(aNumberNew) Crossection7
			
			Make/O/N=(eNumber1) Crossection8
			Make/O/N=(eNumber1) Crossection9
			
			DoWindow/F Blended_Panel					//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow Blended_Panel
			endif
			Display_Blended_Panel()
			Slider slider0,limits={0,(eNumber1 - 1),1}
			Slider slider1,limits={0,(aNumberNew-1),1}
			
			AppendImage /W=Blended_Panel#G0 tImageLR
			//AppendImage /W=Blended_Panel#G0 tImageLR2
			ModifyGraph  /W=Blended_Panel#G0 swapXY=1
			
			AppendToGraph /W=Blended_Panel#G1 Crossection6
			AppendToGraph /W=Blended_Panel#G1 /C=(0,65535,0) Crossection7
			
			ModifyGraph /W=Blended_Panel#G2 swapXY=1
			AppendToGraph /W=Blended_Panel#G2 Crossection8
			AppendToGraph /W=Blended_Panel#G2 /C=(0,65535,0) Crossection9
			//ModifyGraph /W=Blended_Panel#G2 notation(bottom)=1
			
			execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=1/C=(0,0,65280) A tImageLR 0,0"
			execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=1/C=(65280,0,0) B tImageLR 0,0"
			CursorDependencyForGraph()
			//execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,65280,0) B ImageLR 0," + num2str(jmax -1- jmin)
			//execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) C ImageLR 0," + nu1m2str(jmax -1)
			SetVariable setvar0 value = _NUM:0
			
			//Killwaves tImageLR1,tImageLR2
		break
	endswitch

	return 0
End


Function Blend_button1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:
			WAVE sw1			=	root:sw1	
			WAVE/T ListWave1	=	root:ListWave1
			Setdatafolder root:Specs:
			SVAR list_folder 	= 	root:Specs:list_folder
			SVAR list_file_path 	= 	root:Specs:list_file_path
			SVAR list_file_name  	= 	root:Specs:list_file_name 
			STRING name1,name2,name3
			Variable i,j,k, number
			SVAR Title_left1 = root:Title_left1
			SVAR Title_right1 = root:Title_right1
			Variable smoothing1, smoothing2
			
			STRUCT file_header fh1 
			STRUCT file_header fh2
			
			If( cmpstr ( Title_left1, "") == 0 )
				return 0
			endif
			If( cmpstr ( Title_right1, "") == 0 )
				return 0
			endif
			
			name1 		= 	ReplaceString(".xy", Title_left1, "")
			name2 		=    "root:specs:" + name1
			Setdatafolder name2
			StructGet /B=0 fh1, header
			name1 		= 	ReplaceString(".xy", Title_right1, "")
			name2 		=    "root:specs:" + name1
			Setdatafolder name2
			StructGet /B=0 fh2, header
			
			Setdatafolder root:Specs:
			WAVE L_image = root:Specs:L_image
			WAVE R_image = root:Specs:R_image
			Duplicate/O/O L_image,L_image_dif
			Duplicate/O/O R_image,R_image_dif
			Duplicate/O/O R_image,R_image1
			
			number = ItemsInList(list_folder)
			for(i = 0; i < number ; i += 1)
				name3 = ListWave1[i][0]
				if ( cmpstr (name3 , Title_left1) == 0 )
					smoothing1 =  str2num (ListWave1[i][2])
				endif
				if ( cmpstr (name3, Title_right1) == 0)
					smoothing2 =  str2num (ListWave1[i][2])
				endif
					
			endfor
			
			Make/O/N =(fh1.nValues)  v1 
			Wave/D v1
			Wave/D v2
			Duplicate/O/O v1,v2
				
			for(i = 0; i <fh1.nCurves;i+=1)	// Initialize variables;continue test
				v1 =  L_image[p][i]
				v2 = v1
				if(smoothing1 > 0 )
					Smooth smoothing1 , v2
				endif
				Differentiate v2
				L_image_dif[][i] = v2[p]
				
				v1 =  R_image[p][i]
				v2 = v1
				if(smoothing2 > 0 )
					Smooth smoothing2 , v2
				endif
				Differentiate v2
				R_image_dif[][i] = v2[p]
			endfor
			
			NVAR shift1 = root:Specs:shift1
			Variable shift2 , shift3
			Variable  j1, j2, i1,i2, jmax, imax
			Variable sum1
			Variable n,m
			Variable max1
			Variable help1,help2,help3 ,help4,help5, help6,help7,help8
			Variable counter1
			NVAR imin = root:Specs:imin
			NVAR jmin = root:Specs:jmin
			Variable jmax1
			NVAR val_slider4 = root:Specs:val_slider4
			shift1 = 20
			shift2 = shift1 * 2
			shift3 = shift2 + 1
			
			jmax1 = val_slider4
			jmax  = fh1.nCurves
			imax  = fh1.nValues
			if(WaveExists(Matrix) == 1)
				KillWaves Matrix
			endif  
			Make /O/N=(shift3,jmax1) Matrix
			help6 = 10000
			//i and j are the index numbers of the Matrix ... formed by the differnce of the 2 window_images
			//this loop is looking for minimum of 2 differentiated window_images
			
			for(j = 0; j <jmax1;j+=1)
				help8 = j + 1 - jmax
				for(i = 0; i <shift3;i+=1)
					sum1 = 0
					counter1= 0
					help1 = imax - abs ( shift1 - i ) 
					help2 = i - shift1
					if(i < shift1)
						for ( j1 = jmax - j - 1; j1<jmax ; j1+=1)
							j2 = j1 + help8
							//j2 = j1 - jmax + 1 + j
							//help1 = imax - abs ( shift1 - i ) 
							//help2 = i - shift1
							for(i1 = 0 ; i1 < help1; i1 +=1)
								i2 = i1 - help2
								help4 = L_image_dif[i1][j1]
								help5 = R_image_dif[i2][j2]
								sum1 = sum1 + abs(help4 - help5)
								counter1 += 1
							endfor
						endfor
					else
						for ( j1 = jmax - j - 1; j1<jmax ; j1+=1)
							j2 = j1 + help8
							//j2 = j1 - jmax + 1 + j
							//help1 = imax - abs ( shift1 - i ) 
							//help2 = i - shift1
							for(i2 = 0 ; i2 < help1; i2 +=1)
								i1 = i2 + help2
								help4 = L_image_dif[i1][j1]
								help5 = R_image_dif[i2][j2]
								sum1 = sum1 + abs(help4 - help5)
								counter1 += 1
							endfor	
						endfor	
					endif
					help7 = sum1/counter1
					if(  help7 < help6 )
						help6 = help7
						imin = i
						jmin = j
					endif
					help7 = sum1/counter1
					Matrix[i][j] = sum1/counter1	
				endfor
			endfor
			
			print imin
			print jmin
			Killwaves v2,v1
			help1 = imax + abs(shift1 - imin) 	//height of the new matrix after blending ....  
			help2 = jmax + jmax - 1 - jmin			//width of the new matrix after blending ....  
			help3 = abs(shift1 - imin)			//number of cells shifted vertically
			help4 = jmin + 1					//number of cells shifted horizontally
			Make/O/N=(help1,help2) Blend_temp1
			Make/O/N=(help1,help2) Blend_temp2
			
			NVAR divide2 = root:Specs:divide
			Variable divide1
			divide2  = 0
			
			j = jmin
			i = imin
			divide1 = 0
			counter1= 0
			//this loop is calculating the average divider
			for ( j1 = jmax - j - 1; j1<jmax ; j1+=1)
				j2 = j1 - jmax + 1 + j
				help1 = imax - abs ( shift1 - i ) 
				help2 = i - shift1
				if(i < shift1)
					for(i1 = 0 ; i1 < help1; i1 +=1)
						i2 = i1 - help2
						help4 = L_image[i1][j1]
						help5 = R_image[i2][j2]
						divide1 = help4/help5
						divide2 = divide2 + divide1
						counter1 += 1
					endfor
				else
					for(i2 = 0 ; i2 < help1; i2 +=1)
						i1 = i2 + help2
						help4 = L_image[i1][j1]
						help5 = R_image[i2][j2]
						divide1 = help4/help5
						divide2 = divide2 + divide1
						counter1 += 1
					endfor	
				endif	
			endfor
			
			divide2 = divide2/counter1
			R_image1 = 	divide2*R_image //multiplying by divider to get better averrage
			
			j = jmin
			i = imin
			divide1 = 0
			counter1= 0
			//this loop is setting ratio of the values in common area
			for ( j1 = jmax - j - 1; j1<jmax ; j1+=1)
				j2 = j1 - jmax + 1 + j
				help1 = imax - abs ( shift1 - i ) 
				help2 = i - shift1
				help7 = j2 / j
				help6 = 1 - help7
				if(i < shift1)
					for(i1 = 0 ; i1 < help1; i1 +=1)
						i2 = i1 - help2
						help4 = L_image[i1][j1]
						help5 = R_image1[i2][j2]
						R_image1[i2][j2] = help4 * help6 + help5 * help7
					endfor
				else
					for(i2 = 0 ; i2 < help1; i2 +=1)
						i1 = i2 + help2
						help4 = L_image[i1][j1]
						help5 = R_image1[i2][j2]
						R_image1[i2][j2] = help4 * help6 + help5 * help7
					endfor	
				endif	
			endfor
			
			help1 = imax + abs(shift1 - imin)
			help2 = 2 * jmax - 1 - jmin
			help3 = abs(shift1 - imin)

			if( imin < shift1 )
			
				for(i = 0; i <imax;i+=1)
					for(j = 0; j <jmax;j+=1)
						Blend_temp1[(i + help3)][j] = L_image_dif[i][j]
						Blend_temp2[(i + help3)][j] = L_image[i][j]
					endfor
				endfor
				
				for(i = 0; i <imax;i+=1)
					for(j = 0; j < jmax;j+=1)
						Blend_temp1[i][(j + jmax - jmin -1)] = R_image_dif[i][j]
						Blend_temp2[i][(j + jmax - jmin -1)] = R_image1[i][j]
					endfor
				endfor
				
			else
			
				for(i = 0; i <imax;i+=1)
					for(j = 0; j <jmax;j+=1)
						Blend_temp1[i][j] = L_image_dif[i][j]
						Blend_temp2[i][j] = L_image[i][j]
					endfor
				endfor
				
				for(i = 0; i <imax;i+=1)
					for(j = 0; j <jmax;j+=1)
						Blend_temp1[(i + help3)][(j + jmax - jmin -1)] = R_image_dif[i][j]
						Blend_temp2[(i + help3)][(j + jmax - jmin -1)] = R_image1[i][j]
					endfor
				endfor
					
			endif
			Make/O/N=(help2) Crossection6
			DoWindow/F Blended_Panel					//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow Blended_Panel
			endif
			Display_Blended_Panel()
			Slider slider0,limits={0,(fh1.nValues-1),1} 
			
			AppendImage /W=Blended_Panel#G0 Blend_temp2
			ModifyGraph  /W=Blended_Panel#G0 swapXY=1
			AppendToGraph /W=Blended_Panel#G1 Crossection6
			execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=3/C=(65280,0,0) A Blend_temp2 0,0"
			execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,65280,0) B Blend_temp2 0," + num2str(jmax -1- jmin)
			execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) C Blend_temp2 0," + num2str(jmax -1)
			SetVariable setvar0 value = _NUM:divide2
			break
	endswitch

	return 0
End

Function SetVar_overlap(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			String name1,name2,name3,name4
			SVAR Title_left1 = root:Title_left1
			SVAR Title_right1 = root:Title_right1
			
			if(cmpstr (Title_left1, "") == 0)
				break
			endif
			
			if(cmpstr (Title_right1, "") == 0)
				break
			endif
			
			name1 = "root:Specs:" + ReplaceString(".xy", Title_left1, "") + ":header"
			name2 = "root:Specs:" + ReplaceString(".xy", Title_right1, "") + ":header"
			
			STRUCT file_header fh1 
			STRUCT file_header fh2 
			StructGet /B=0 fh1, $name1
			StructGet /B=0 fh2, $name2
			if( dval >= fh1.nCurves )
				break
			endif
			execute/Z/Q "Cursor/W=Load_and_Set_Panel#G0 /P/I/H=2/C=(65280,0,0) A Angle_2D 0," + num2str(fh1.nCurves - dval)
			execute/Z/Q "Cursor/W=Load_and_Set_Panel#G1 /P/I/H=2/C=(0,65280,0) B Angle_2D 0," + num2str(dval -1)
			
			break
	endswitch

	return 0
End

Function SetVarProc_blended(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			NVAR imin = root:Specs:imin
			NVAR jmin = root:Specs:jmin
			NVAR shift1 = root:Specs:shift1
			Variable i , j , jmax, imax
			String name1, name2
			SVAR Title_left1 = root:Title_left1
			SVAR Title_right1 = root:Title_right1
			WAVE Blend_temp2 = root:Specs:Blend_temp2	
			Variable help3,help1,help2
			WAVE L_image = root:Specs:L_image
			WAVE R_image1 = root:Specs:R_image1
			WAVE R_image = root:Specs:R_image
			Wave Crossection6 = Crossection6
			NVAR val_slider5 = root:Specs:val_slider5
			
			help3 = abs(shift1 - imin)
			name1 = "root:Specs:" + ReplaceString(".xy", Title_left1, "") + ":header"
			name2 = "root:Specs:" + ReplaceString(".xy", Title_right1, "") + ":header"
			
			STRUCT file_header fh1 
			STRUCT file_header fh2 
			StructGet /B=0 fh1, $name1
			StructGet /B=0 fh2, $name2
			
			NVAR val_slider4 = root:Specs:val_slider4 
			jmax  = fh1.nCurves
			imax  = fh1.nValues
			
			R_image1 = R_image
			R_image1 = R_image1*dval
			
			help1 = imax + abs(shift1 - imin)
			help2 = 2 * jmax - 1 - jmin + val_slider5
			help3 = abs(shift1 - imin)
			
			Redimension /N =(help1,help2)  Blend_temp2
			Redimension /N = (help2)  Crossection6
			
			if( imin < shift1 )
			
				for(i = 0; i <imax;i+=1)
					for(j = 0; j <jmax;j+=1)
						Blend_temp2[(i + help3)][j] = L_image[i][j]
					endfor
				endfor
				
				for(i = 0; i <imax;i+=1)
					for(j = 0; j < jmax;j+=1)
						Blend_temp2[i][(j + jmax - jmin -1+ val_slider5)] = R_image1[i][j]
					endfor
				endfor
				
			else
			
				for(i = 0; i <imax;i+=1)
					for(j = 0; j <jmax;j+=1)
						Blend_temp2[i][j] = L_image[i][j]
					endfor
				endfor
				
				for(i = 0; i <imax;i+=1)
					for(j = 0; j <jmax;j+=1)
						Blend_temp2[(i + help3)][(j + jmax - jmin -1+ val_slider5)] = R_image1[i][j]
					endfor
				endfor
					
			endif
			Crossection6[] = Blend_temp2[K1][p]
			break
	endswitch

	return 0
End

Function SliderProc_Blended(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String		name1,name2,name3
				Variable 		number
				//Wave Crossection6 = Crossection6
				//Wave Crossection7 = Crossection7
				SVAR Title_left1 = root:Title_left1
				SVAR Title_right1 = root:Title_right1
				
				SetDataFolder root:Blending_Panel
				SVAR K1
				Variable help1
				Wave FinalBlendKE
				WAVE TemporaryHoldKE_L
				WAVE TemporaryHoldKE_R
				
				Wave Crossection6
				Wave Crossection7
				Wave Crossection8
				Wave Crossection9
				
				if (cmpstr(sa.ctrlName,"slider0")==0)
					Crossection6[] = TemporaryHoldKE_L[ curval ] [p]
					Crossection7[] = TemporaryHoldKE_R[ curval] [p]
					ControlInfo slider1
					execute/Z/Q "Cursor /A=1 /W=Blended_Panel#G0 /P/I/H=1/C=(65280,0,0) B FinalBlendKE " + num2str(curval) +"," + num2str (V_value)
					ValDisplay cross2,value=_NUM:hcsr(B,"Blended_Panel#G0")
				endif
				if (cmpstr(sa.ctrlName,"slider1")==0)
					Crossection8[] = TemporaryHoldKE_L[p] [ curval]
					Crossection9[] = TemporaryHoldKE_R[p] [curval]
					ControlInfo slider0
					execute/Z/Q "Cursor /A=1 /W=Blended_Panel#G0 /P/I/H=1/C=(65280,0,0) B FinalBlendKE " + num2str(V_value) + ","+ num2str(curval)
					ValDisplay cross1,value=_NUM:vcsr(B,"Blended_Panel#G0")
				endif		
			endif
			break
	endswitch
	return 0
End

Function SetVarProc_Blended1(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			String name1 = sva.ctrlName
			
			SetDataFolder root:Specs:	
			WAVE Crossection6
			WAVE Crossection7
			WAVE Crossection8
			WAVE Crossection9
			Variable num1,num2
			ControlInfo /W=Blended_Panel buttonUD
			num2 = strsearch(S_recreation,"Down",0)
			//Print S_recreation
			Variable La1, Ra1
			Variable La2, Ra2
			Variable x1,x2,x3,x4
			Variable Le1,Le2,He1,He2
			Variable y1,y2,y3,y4
	
			WAVE L_image1
			WAVE R_image1
			WAVE L_image2
			WAVE R_image2
			WAVE tImageLR
			WAVE tImageLR1
			WAVE tImageLR2
			WAVE tImageLRa
			WAVE tImageLR1a
			WAVE tImageLR2a
			
			Variable n1, n2
			NVAR AngleShift
			NVAR EnergyShift
			Variable AS = AngleShift
			Variable ES = EnergyShift
			Variable value
			Variable numberAvg,i,j,sum4,numberj
			Variable help2
			
			Variable checked
			ControlInfo check0
			checked = V_value
					
			strswitch(name1)
				case "setvar0":
						
					SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
					SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
					SetDataFolder root:Blending_Panel
					NVAR vectorA
					NVAR vectorE
					vectorA = vectorA + dval
					SVAR K1
					Variable help1
					WAVE FinalBlendKE
					WAVE FinalBlendKEori
					Duplicate/O FinalBlendKEori, FinalBlendKE
					WAVE TemporaryHoldKE_L
					WAVE TemporaryHoldKE_R
					
					Variable index1A,index2A,index3A,index4A
					Variable index1E,index2E,index3E,index4E
					Variable deltaA , deltaE
			
					Variable aShift
					ControlInfo setvar1
					aShift = V_value
					
					n1 = DimSize(FinalBlendKE,0) 
					n2 = DimSize(FinalBlendKE,1) + aShift
					deltaA = DimDelta(FinalBlendKE,1)
					deltaE = DimDelta(FinalBlendKE,0)
					Redimension /N=(n1 , n2 ) FinalBlendKE
					Redimension /N=(n1 , n2 ) TemporaryHoldKE_L
					Redimension /N=(n1 , n2 ) TemporaryHoldKE_R
					
					Setdatafolder root:Load_and_Set_Panel:
					Wave L_image1
					Wave Angle_2D = L_image1		
					
					SetDataFolder root:$"Blending_Panel"
					Duplicate/O Angle_2D, L_Image
					WAVE L_Image_dif
					
					La1 = DimOffset(L_Image,1)
					Ra1 = DimOffset(L_image,1) + (DimSize(L_image,1)-1)*DimDelta(L_image,1)
					He1 = DimOffset(L_image,0) + (DimSize(L_image,0)-1)*DimDelta(L_image,0)
					Le1 = DimOffset(L_image,0)
			
					Setdatafolder root:Load_and_Set_Panel:
					Wave R_image1
					Wave Angle_2D = R_image1		
					
					SetDataFolder root:$"Blending_Panel"
					Duplicate/O Angle_2D, R_Image
					WAVE R_Image_dif
			
					La2 = DimOffset(R_image,1)
					Ra2 = DimOffset(R_image,1) + (DimSize(R_image,1)-1)*DimDelta(R_image,1)
					He2 = DimOffset(R_image,0) + (DimSize(R_image,0)-1)*DimDelta(R_image,0)
					Le2 = DimOffset(R_image,0)
					
					index1A = round ( ( La1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
					index3A = round ( ( Ra1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) 
					index2A = round ( ( La2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) + aShift
					index4A = round ( ( Ra2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) + aShift
			
					index1E = round ( ( Le1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
					index3E = round ( ( He1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
					index2E = round ( ( Le2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) + dval
					index4E = round ( ( He2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) + dval
					
					Slider slider1,limits={0,(n2 - 1),1}
					if(checked)
						TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image_dif(x)(y)
					else
						TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image(x)(y)
					endif
					//TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image(x)(y)
					SetScale/P y, La2 + aShift*deltaA, deltaA, "" R_Image
					SetScale/P x, Le2 + dval*deltaE, deltaE, "" R_Image
					
					SetScale/P y, La2 + aShift*deltaA, deltaA, "" R_Image_dif
					SetScale/P x, Le2 + dval*deltaE, deltaE, "" R_Image_dif
					//TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
					
					SetDataFolder root:Blending_Panel
					NVAR Normalization

					Variable totalNrPixE
					totalNrPixE = DimSize(TemporaryHoldKE_R,0)
					TemporaryHoldKE_R = 0
					
					if(checked)
						TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image_dif(x)(y)
					else
						TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
					endif
			
					//TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
					Variable Average1, Average2
					help1 = 0
					help2 = 0
					
					if(!checked)
						if( index3A >= index2A )
							if( index2A >= index1A )
								Average1 = 0
								Average2 = 0
								for(j=index2A;j<=index3A;j+=1)
									for(i=0;i<totalNrPixE;i+=1)
										help2 = TemporaryHoldKE_R[i][j]
										help1 = TemporaryHoldKE_L[i][j]
										if( help1!= 0 && help2!=0 )
											Average1+=help1
											Average2+=help2
										endif
									endfor
								endfor
								Normalization=Average1/Average2
								TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
								//FinalBlendKE[][index3A+1,index4A] = TemporaryHoldKE_R[p][q]
							else
								if(index1A > index4A)
									Average1 = 1
									Average2 = 1	
								else
									for(j=index1A;j<=index4A;j+=1)
											for(i=0;i<totalNrPixE;i+=1)
											help2 = TemporaryHoldKE_R[i][j]
											help1 = TemporaryHoldKE_L[i][j]
											if( help1!= 0 && help2!=0 )
												Average1+=help1
												Average2+=help2
											endif
										endfor
									endfor	
									Normalization=Average1/Average2
									TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
									//FinalBlendKE[][index2A+1,index4A] = TemporaryHoldKE_R[p][q]	
								endif
							endif
						else
							Average1 = 1
							Average2 = 1	
							Normalization=Average1/Average2
							TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
							//FinalBlendKE[][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
						endif
					endif
						//SetScale/P x, Lke, deltaE,"" FinalBlendKE
     		      				//SetScale/P y, La1 + dval*deltaA, deltaA, "" TemporaryHoldKE_R
           				SetDataFolder root:Blending_Panel
           				
					if(num2 != -1)
						Button buttonUD,title="Down"
						FinalBlendKE[index2E,index4E][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
						FinalBlendKE[index1E,index3E][index1A,Index3A] = TemporaryHoldKE_L[p][q]
						execute/Z/Q "Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0," +num2str(index3A)
						//Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0, index3A 
					else
						Button buttonUD,title="Up"
						FinalBlendKE[index1E,index3E][index1A,Index3A] = TemporaryHoldKE_L[p][q]
						FinalBlendKE[index2E,index4E][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
						execute/Z/Q "Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0," +num2str(index2A)
						//Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0,index2A 
					endif	
					ValDisplay valdisp1,value=_NUM:dval*deltaE
					DoUpdate
					break
				case "setvar1":
					SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
					SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
					SetDataFolder root:Blending_Panel
					NVAR vectorA
					NVAR vectorE
					vectorA = vectorA + dval
					SVAR K1
					WAVE FinalBlendKE
					WAVE FinalBlendKEori
					Duplicate/O FinalBlendKEori, FinalBlendKE
					WAVE TemporaryHoldKE_L
					WAVE TemporaryHoldKE_R
			
					Variable eShift
					ControlInfo setvar0
					eShift = V_value
					
					n1 = DimSize(FinalBlendKE,0)
					n2 = DimSize(FinalBlendKE,1) + dval
					deltaA = DimDelta(FinalBlendKE,1)
					deltaE = DimDelta(FinalBlendKE,0)
					Redimension /N=(n1 , n2 ) FinalBlendKE
					Redimension /N=(n1 , n2 ) TemporaryHoldKE_L
					Redimension /N=(n1 , n2 ) TemporaryHoldKE_R
					
					Setdatafolder root:Load_and_Set_Panel:
					Wave L_image1
					Wave Angle_2D = L_image1		
					
					SetDataFolder root:$"Blending_Panel"
					Duplicate/O Angle_2D, L_Image
					WAVE L_Image_dif
					
					La1 = DimOffset(L_Image,1)
					Ra1 = DimOffset(L_image,1) + (DimSize(L_image,1)-1)*DimDelta(L_image,1)
					He1 = DimOffset(L_image,0) + (DimSize(L_image,0)-1)*DimDelta(L_image,0)
					Le1 = DimOffset(L_image,0)
			
					Setdatafolder root:Load_and_Set_Panel:
					Wave R_image1
					Wave Angle_2D = R_image1		
					
					SetDataFolder root:$"Blending_Panel"
					Duplicate/O Angle_2D, R_Image
					WAVE R_Image_dif
					
					La2 = DimOffset(R_image,1)
					Ra2 = DimOffset(R_image,1) + (DimSize(R_image,1)-1)*DimDelta(R_image,1)
					He2 = DimOffset(R_image,0) + (DimSize(R_image,0)-1)*DimDelta(R_image,0)
					Le2 = DimOffset(R_image,0)
					
					index1A = round ( ( La1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
					index3A = round ( ( Ra1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) 
					index2A = round ( ( La2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) + dval
					index4A = round ( ( Ra2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) + dval
			
					index1E = round ( ( Le1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
					index3E = round ( ( He1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
					index2E = round ( ( Le2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) + eShift
					index4E = round ( ( He2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) + eShift
					
					Slider slider1,limits={0,(n2 - 1),1}
					TemporaryHoldKE_L = 0
					if(checked)
						TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image_dif(x)(y)
					else
						TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image(x)(y)
					endif
					
					//TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image(x)(y)
					SetScale/P y, La2 + dval*deltaA, deltaA, "" R_Image
					SetScale/P x, Le2 + eShift*deltaE, deltaE, "" R_Image
					
					SetScale/P y, La2 + dval*deltaA, deltaA, "" R_Image_dif
					SetScale/P x, Le2 + eShift*deltaE, deltaE, "" R_Image_dif
			
					//TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
					
					SetDataFolder root:Blending_Panel
					NVAR Normalization
					
					totalNrPixE = DimSize(TemporaryHoldKE_R,0)
					TemporaryHoldKE_R = 0
					if(checked)
						TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image_dif(x)(y)
					else
						TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
					endif
					
					//TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)

					help1 = 0
					help2 = 0
					
					if(!checked)
						if( index3A >= index2A )
							if( index2A >= index1A )
								Average1 = 0
								Average2 = 0
								for(j=index2A;j<=index3A;j+=1)
									for(i=0;i<totalNrPixE;i+=1)
											help2 = TemporaryHoldKE_R[i][j]
										help1 = TemporaryHoldKE_L[i][j]
										if( help1!= 0 && help2!=0 )
											Average1+=help1
											Average2+=help2
										endif
									endfor
								endfor
								Normalization=Average1/Average2
								TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
								//FinalBlendKE[][index3A+1,index4A] = TemporaryHoldKE_R[p][q]
							else
								if(index1A > index4A)
									Average1 = 1
									Average2 = 1	
								else
									for(j=index1A;j<=index4A;j+=1)
											for(i=0;i<totalNrPixE;i+=1)
											help2 = TemporaryHoldKE_R[i][j]
											help1 = TemporaryHoldKE_L[i][j]
											if( help1!= 0 && help2!=0 )
												Average1+=help1
												Average2+=help2
											endif
										endfor
									endfor	
									Normalization=Average1/Average2
									TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
									//FinalBlendKE[][index2A+1,index4A] = TemporaryHoldKE_R[p][q]	
								endif
							endif
						else
							Average1 = 1
							Average2 = 1	
							Normalization=Average1/Average2
							TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
							//FinalBlendKE[][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
						endif
					endif
					//SetScale/P x, Lke, deltaE,"" FinalBlendKE
           				//SetScale/P y, La1 + dval*deltaA, deltaA, "" TemporaryHoldKE_R
           				SetDataFolder root:Blending_Panel
           				
					if(num2 != -1)
						Button buttonUD,title="Down"
						FinalBlendKE[index2E,index4E][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
						FinalBlendKE[index1E,index3E][index1A,Index3A] = TemporaryHoldKE_L[p][q]
				
						//Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0, index3A 
					else
						Button buttonUD,title="Up"
						FinalBlendKE[index1E,index3E][index1A,Index3A] = TemporaryHoldKE_L[p][q]
						FinalBlendKE[index2E,index4E][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
						
						//Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0,index2A 
					endif	
					ValDisplay valdisp0,value=_NUM:dval *deltaA
					DoUpdate
					break
			endswitch

		break
	endswitch
	//execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,65280,0) B Blend_temp2 0," + num2str(jmax -1- jmin + dval)
	//execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) C Blend_temp2 0," + num2str(jmax -1 + dval)
	return 0
End

Function SetVarProc_Blended2(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval

			NVAR imin = root:Specs:imin
			NVAR jmin = root:Specs:jmin
			NVAR shift1 = root:Specs:shift1
			Variable i , j , jmax, imax
			String name1, name2
			SVAR Title_left1 = root:Title_left1
			SVAR Title_right1 = root:Title_right1
			WAVE Blend_temp2 = root:Specs:Blend_temp2	
			Variable help3,help2,help1
			WAVE L_image = root:Specs:L_image
			WAVE R_image1 = root:Specs:R_image1
			WAVE R_image = root:Specs:R_image
			Wave Crossection6 = Crossection6
			NVAR val_slider5 = root:Specs:val_slider5
			
			val_slider5 = dval
			
			name1 = "root:Specs:" + ReplaceString(".xy", Title_left1, "") + ":header"
			name2 = "root:Specs:" + ReplaceString(".xy", Title_right1, "") + ":header"
			
			STRUCT file_header fh1 
			STRUCT file_header fh2 
			StructGet /B=0 fh1, $name1
			StructGet /B=0 fh2, $name2
			
			NVAR val_slider4 = root:Specs:val_slider4 
			jmax  = fh1.nCurves
			imax  = fh1.nValues
			
			help1 = imax + abs(shift1 - imin)
			help2 = 2 * jmax - 1 - jmin + dval
			help3 = abs(shift1 - imin)
			
			Redimension /N =(help1,help2)  Blend_temp2
			Redimension /N = (help2)  Crossection6
			
			if( imin < shift1 )
			
				for(i = 0; i <imax;i+=1)
					for(j = 0; j <jmax;j+=1)
						Blend_temp2[(i + help3)][j] = L_image[i][j]
					endfor
				endfor
				
				for(i = 0; i <imax;i+=1)
					for(j = 0; j < jmax;j+=1)
						Blend_temp2[i][(j + jmax - jmin -1 + dval)] = R_image1[i][j]
					endfor
				endfor
				
			else
			
				for(i = 0; i <imax;i+=1)
					for(j = 0; j <jmax;j+=1)
						Blend_temp2[i][j] = L_image[i][j]
					endfor
				endfor
				
				for(i = 0; i <imax;i+=1)
					for(j = 0; j <jmax;j+=1)
						Blend_temp2[(i + help3)][(j + jmax - jmin -1 + dval)] = R_image1[i][j]
					endfor
				endfor
					
			endif
			Crossection6[] = Blend_temp2[K1][p]
			
			break
	endswitch
	execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,65280,0) B Blend_temp2 0," + num2str(jmax -1- jmin + dval)
	execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) C Blend_temp2 0," + num2str(jmax -1 + dval)
	return 0
End

Function SetVarProc_1(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			SVAR list_graphs = root:Specs:list_graphs
			WAVE/T list_names = root:Specs:list_names
			Variable help1
			Variable i
			String name1,name2,name3
			Variable length1, length2
			Variable xmid , x0
			NVAR window_images = root:Specs:window_images
			Variable counter1, counter2
			
			counter1 	=	ItemsInList(list_graphs)
			window_images = dval
			
			if( window_images > 1)
				Button button3,title="Blend"
			else
				Button button3,title="Compute"
			endif
			
			length1 = 1400
			length2 = (5 + 120)*dval
			xmid = length1/2
			x0 = xmid - length2/2
			
			if(dval == 0)
				Button button0,disable=2
				Button button4,disable=2
			else
				Button button0,disable=0
				if( dval >1)
					Button button4,disable=0
				else
					Button button4,disable=2
				endif
				
			endif
			
			if(counter1 == window_images)
				break
			endif
			
			if(counter1 == 0)
				for(i = 0 ; i<window_images; i += 1)
					name1 = "G" + num2str(i)
					list_graphs	= 	AddListItem(name1,  list_graphs , ";", Inf)
					name2 = "title" + name1
					name3 = "Multiple_Panel#" + name1
					x0 = x0 + 5
					Display/W=(x0,60,x0 + 120,180)/HOST=Multiple_Panel
					//ModifyGraph height=150, width=150
					ModifyGraph margin=-1
					RenameWindow #,$name1
					SetActiveSubwindow ##
				
					name2 = "title" + name1
				
					TitleBox $name2,pos={x0,190},size={9,9},fSize=12
					x0 = x0 + 120
				endfor
				break	
			endif
			
			if ( counter1 < window_images)
				for(i = 0 ; i<counter1; i += 1)
					name1 = "G" + num2str(i)
					name2 = "title" + name1
					name3 = "Multiple_Panel#" + name1
					x0 = x0 + 5

					//MoveWindow /W = $name3 x0,50,x0 + 150,200
					MoveSubwindow /W=$name3 fnum=(x0,60,x0 + 120,180)
					//SetActiveSubwindow ##
					TitleBox $name2,pos={x0,190}
					//TitleBox $name2, fSize=12
					x0 = x0 + 120
				endfor

				for(i = counter1 ; i<window_images; i += 1)
					name1 = "G" + num2str(i)
					list_graphs	= 	AddListItem(name1,  list_graphs , ";", Inf)
					x0 = x0 + 5
					Display/W=(x0,60,x0 + 120,180)/HOST=Multiple_Panel
					ModifyGraph margin=-1
					RenameWindow #,$name1
					SetActiveSubwindow ##
				
					name2 = "title" + name1
				
					TitleBox $name2,pos={x0,190},size={9,9},fSize=12
					x0 = x0 + 120
				endfor
			else
				for(i = counter1 -1 ; i>=window_images; i -= 1)
					name1 = "G" + num2str(i)
					name2 = "title" + name1
					name3 = "Multiple_Panel#" + name1
					KillWindow $name3
					KillControl  /W=Multiple_Panel $name2
					list_names[i] = ""
					list_graphs  = RemoveListItem(i, list_graphs )
				endfor
				
				for(i = 0 ; i<window_images; i += 1)
					name1 = "G" + num2str(i)
					name2 = "title" + name1
					name3 = "Multiple_Panel#" + name1
					x0 = x0 + 5
					MoveSubwindow /W=$name3 fnum=(x0,60,x0 + 120,180)
					TitleBox $name2,pos={x0,190}
					x0 = x0 + 120
				endfor
				
			endif
			counter1 	=	ItemsInList(list_graphs)
			counter2 = 0
			for(i = 0; i < counter1; i+=1)
				if(cmpstr(list_names[i], "" ) != 0)
					counter2 +=1
				endif
			endfor
			
			if(counter1 == counter2)
				if(counter1 == 0)
					Button button3,disable=2
				else
					Button button3,disable=0
				endif	
			else
				Button button3,disable=2		
			endif
			
			break
	endswitch

	return 0
End

Function ButtonProc_Multiple(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:
			WAVE sw1			=	root:Load_and_Set_Panel:sw1	
			WAVE/T ListWave1	=	root:Load_and_Set_Panel:ListWave1
			Setdatafolder root:Specs:
			SVAR list_folder 	= 	root:Specs:list_folder
			SVAR list_file_path 	= 	root:Specs:list_file_path
			SVAR list_file_name  	= 	root:Specs:list_file_name 
			STRING name1,name2,name3
			Variable i,j,k, number
			SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
			SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
			
			DoWindow/F Multiple_Panel					//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				//KillWindow Multiple_Panel
			endif
			
			Display_Multiple_Panel()
			break
	endswitch

	return 0
End

Function ButtonProc_Insert(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1:
			WAVE/T titles2 = root:Multiple_Panel:titles2
			WAVE/T ListWave2 = root:Multiple_Panel:ListWave2
			Variable counter2 , i
			counter2 = DimSize(ListWave2,1) 
			SetDataFolder root:Multiple_Panel
			for(i = 0;i<counter2;i+=1)
				if( cmpstr(ListWave2[0][i],"") != 0 )
					DoWindow $ListWave2[0][i]
					if(V_flag)
						DoWindow/K $ListWave2[0][i]	
						KillWaves $titles2[i]
					endif	
					ListWave2[0][i] = ""
					titles2[i] = ""
				endif
			endfor
			break
		case 2: // mouse up
			// click code here
			String name1,name2
			NVAR window_images = root:Specs:window_images
			SVAR list_folder 	= 	root:Specs:list_folder
			SVAR list_file_name  	= 	root:Specs:list_file_name 
			SetDataFolder root:Multiple_Panel
			SVAR list_graphs = root:Multiple_Panel:list_graphs
			WAVE/T list_names = root:Multiple_Panel:list_names
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			
			WAVE/T titles2 = root:Multiple_Panel:titles2
			WAVE/T ListWave2 = root:Multiple_Panel:ListWave2
			WAVE sw2 = root:Multiple_Panel:sw2
			
			Variable counter1
			Variable logic1
			Variable test1,test2 ,j
			
			strswitch ( ba.ctrlName)
				case "button0":
					Prompt name1, "Select image", popup list_file_name
					DoPrompt	"Select image",  name1
			
					if(!cmpstr (name1,""))
						break
					endif

					counter1 = DimSize(ListWave1,0)
					test1 = -1
					for(j = 0; i < counter1 ; j += 1)
						if( cmpstr(ListWave1[j][1],name1) == 0 )
							test1 = j+1
							break
						endif
					endfor
					if(test1 == -1)
						return 0
					endif
					
					counter2 = DimSize(ListWave2,1)
					test2 = -1
					for(i = 0; i < counter2 ; i += 1)
						if( (sw2[0][i] & 2^0) != 0 )
							test2 = i 
							break
						endif
					endfor
					if(test2 == -1 )
						for(i = 0; i < counter2 ; i += 1)
							if( cmpstr(ListWave2[0][i],"") == 0 )
								test2 = i 
								break
							endif
						endfor
						if(test2 == -1 )
							return 0
						endif
					else
						name2 = "Nr"+num2str(test1)
						DoWindow $name2
						if(V_flag)
							return 0 
						endif	
						
						if( cmpstr(ListWave2[0][i],"") != 0 )
							DoWindow $ListWave2[0][test2]
							if(V_flag)
								DoWindow/K $ListWave2[0][test2]	
								ListWave2[0][test2] = ""
							endif	
							titles2[test2] = ""
						else
							titles2[test2] = ""
						endif		
					endif
					
					Setdatafolder root:Specs:$name1
					WAVE wave1 = $name1
					list_names[test2] = name1
					//Display/W=(100,100,500,500) /HIDE=1 /K=3
					String newName = "Nr"+num2str(test1)

					SetDataFolder root:Multiple_Panel
					Wave wave2 
					Duplicate/O wave1 , wave2
					if( waveExists($name1) )
						KillWaves $name1
					endif
					Rename wave2, $name1
					Final_2D(j, wave2)
					
					DoWindow $newName
					if(V_flag)
						DoWindow/K $newName
					endif
					Display/W=(100,100,500,500) /HIDE=1 /K=3 /N=$newName 
					//RenameWindow # , $newName
					AppendImage /W=# wave2
					ModifyGraph margin=0 , swapXY=1 ,noLabel=0
					ModifyGraph width=400, height=400
					ListWave2[0][test2] = newName
					titles2[test2] = name1
					DoUpdate
				break
			case "button4":
				Variable first = 1
				Variable nrImages
				counter1 = DimSize(ListWave1,0)
				test2 = -1
				for(i = 0; i < counter1 ; i += 1)
					if( cmpstr(ListWave1[i][1],"") == 0 )
						test2 = i 
						break
					endif
				endfor
				
				if(test2 == -1 )
					return 0
				endif	
				
				Variable last = test2
				
				Prompt first, "Nr of the First Image:"
				Prompt last, "Nr of the Last Image:"
				DoPrompt	"Enter Values",  first, last
				
				if (V_Flag)
					return 0									// user canceled
				endif
			
				counter1 = DimSize(ListWave2,1)
				counter2 = ItemsInList (list_folder) 
				first = round(first)
				if(last<first)
					return 0
				endif
				if(first<1)
					first = 1
				endif
				if(first>counter2)
					first = counter1
				endif
				if(last >counter2)
					last = counter2
				endif
				if(last <1)
					last = 1
				endif
				
				for(i = 0;i<counter1;i+=1)
					if( cmpstr(ListWave2[0][i],"") != 0 )
						DoWindow $ListWave2[0][i]	
						if(V_flag)
							DoWindow/K $ListWave2[0][i]	
						endif	
						ListWave2[0][i] = ""
						titles2[i] = ""
					endif
				endfor
				
				nrImages = last - first +1
				for(i = 0 ; i < nrImages; i+=1)
						if( cmpstr(ListWave2[0][i],"") != 0 )
							DoWindow $ListWave2[0][i]
							if(V_flag)
								DoWindow/K $ListWave2[0][i]	
								ListWave2[0][i] = ""
							endif	
							titles2[i] = ""
						else
							titles2[i] = ""
						endif
							
					name1 = ListWave1[first+i-1][1]
					Setdatafolder root:Specs:$ListWave1[first+i-1][1]
					WAVE wave1 = $name1
					list_names[i] = name1
					//Display/W=(100,100,500,500) /HIDE=1 /K=3
					newName = "Nr"+num2str(first+i)
					//name3 = "root:Multiple_Panel:\'" +name1 + "\'"
					//Cut_Frame_2D( first+i-1, name3 )
					//SetDataFolder root:Multiple_Panel
					//Make_Corrections_2D(name1)
					//WAVE wave2 = $name1
					SetDataFolder root:Multiple_Panel
					Wave wave2 
					Duplicate/O wave1 , wave2
					if( waveExists($name1) )
						KillWaves $name1
					endif
					Rename wave2, $name1
					Final_2D(first+i-1, wave2)
					
					DoWindow $newName
					if(V_flag)
						DoWindow/K $newName
					endif
					Display/W=(100,100,500,500) /HIDE=1 /K=3 /N=$newName 
					//RenameWindow # , $newName
					AppendImage /W=# wave2
					ModifyGraph margin=0 , swapXY=1 ,noLabel=0
					ModifyGraph width=400, height=400
					ListWave2[0][i] = newName
					titles2[i] = name1
					DoUpdate
				endfor
				
				SetActiveSubwindow $"Multiple_Panel"
		
			break
		endswitch 
		break
	endswitch
	return 0
End

Function ButtonProc_Remove(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			String name1,name2, name3 , name4
			NVAR window_images = root:Specs:window_images
			SVAR list_folder 	= 	root:Specs:list_folder
			SVAR list_file_name  	= 	root:Specs:list_file_name 
			SetDataFolder root:Multiple_Panel
			SVAR list_graphs = root:Multiple_Panel:list_graphs
			WAVE/T list_names = root:Multiple_Panel:list_names
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			
			WAVE/T titles2 = root:Multiple_Panel:titles2
			WAVE/T ListWave2 = root:Multiple_Panel:ListWave2
			WAVE sw2 = root:Multiple_Panel:sw2
			
			Variable i
			Variable counter1,counter2
			Variable logic1
			Variable test2 ,j
			counter1 = DimSize(ListWave1,1) 
			counter2 = DimSize(sw2,1) 
			test2 = -1
			for(i = 0; i < counter2 ; i += 1)
				if( (sw2[0][i] & 2^0) != 0 )
					test2 = i 
					break
				endif
			endfor
			if(test2 == -1 )
				return 0
			else
				if( cmpstr(ListWave2[0][test2],"") != 0 )
					DoWindow $ListWave2[0][test2]
					if(V_flag)
						DoWindow/K $ListWave2[0][test2]	
					endif	
					KillWaves $titles2[test2]
					ListWave2[0][test2] = ""
					titles2[test2] = ""
					//sw2[0][test2] = sw2[0][test2] | (2^0)
					if(i<(counter1-1))
						sw2[0][i] = sw2[0][i] & !(2^0)
						sw2[0][i+1] = sw2[0][i+1] | 2^0
					endif
				else
					return 0
				endif		
			endif
			break
	endswitch

	return 0
End

Function ButtonProc_RemoveAll(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			String name1,name2, name3 , name4
			NVAR window_images = root:Specs:window_images
			SVAR list_folder 	= 	root:Specs:list_folder
			SVAR list_file_name  	= 	root:Specs:list_file_name 
			SetDataFolder root:Multiple_Panel
			SVAR list_graphs = root:Multiple_Panel:list_graphs
			WAVE/T list_names = root:Multiple_Panel:list_names
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			
			WAVE/T titles2 = root:Multiple_Panel:titles2
			WAVE/T ListWave2 = root:Multiple_Panel:ListWave2
			WAVE sw2 = root:Multiple_Panel:sw2
			
			Variable i
			Variable counter1,counter2
			Variable logic1
			Variable test2 ,j
			counter2 = DimSize(ListWave2,1) 
			for(i = 0;i<counter2;i+=1)
				if( cmpstr(ListWave2[0][i],"") != 0 )
					DoWindow $ListWave2[0][i]
					if(V_flag)
						DoWindow/K $ListWave2[0][i]	
						KillWaves $titles2[i]
					endif
					ListWave2[0][i] = ""
					titles2[i] = ""
				endif
			endfor
				
			break
	endswitch

	return 0
End

Function ButtonProc_MoveLeft(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			String name1,name2, name3 , name4
			NVAR window_images = root:Specs:window_images
			SVAR list_folder 	= 	root:Specs:list_folder
			SVAR list_file_name  	= 	root:Specs:list_file_name 
			SetDataFolder root:Multiple_Panel
			SVAR list_graphs = root:Multiple_Panel:list_graphs
			WAVE/T list_names = root:Multiple_Panel:list_names
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			
			WAVE/T titles2 = root:Multiple_Panel:titles2
			WAVE/T ListWave2 = root:Multiple_Panel:ListWave2
			WAVE sw2 = root:Multiple_Panel:sw2
			
			Variable i
			Variable counter1,counter2
			Variable logic1
			Variable test2 ,j
			counter1 = ItemsInList(list_graphs)
			counter2 = DimSize(sw2,1) 
			test2 = -1
			for(i = 0; i < counter2 ; i += 1)
				if( (sw2[0][i] & 2^0) != 0 )
					test2 = i 
					break
				endif
			endfor
			if(test2 == -1 )
				return 0
			else
				if( cmpstr(ListWave2[0][i],"") != 0 )
					if(test2==0)
						return 0
					else
						name1 = ListWave2[0][i]
						name2 = ListWave2[0][i-1]
						name3 = titles2[i]
						name4 = titles2[i-1]
						ListWave2[0][i] = name2
						ListWave2[0][i-1] = name1
						titles2[i] = name4
						titles2[i-1] = name3
						sw2[0][i] = sw2[0][i] & !(2^0)
						sw2[0][i-1] = sw2[0][i-1] | 2^0
					endif
				else
					return 0
				endif		
			endif
			break
	endswitch

	return 0
End

Function ButtonProc_MoveRight(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			NVAR window_images = root:Multiple_Panel:window_images
			WAVE/T list_names = root:Multiple_Panel:List_names
			SVAR  list_graphs = root:Multiple_Panel:list_graphs
			KillWaves list_names
			KillVariables window_images
			KillStrings list_graphs
			break
		case 2: // mouse up
			// click code here
			
			String name1,name2, name3 , name4
			NVAR window_images = root:Specs:window_images
			SVAR list_folder 	= 	root:Specs:list_folder
			SVAR list_file_name  	= 	root:Specs:list_file_name 
			SetDataFolder root:Multiple_Panel
			SVAR list_graphs = root:Multiple_Panel:list_graphs
			WAVE/T list_names = root:Multiple_Panel:list_names
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			
			WAVE/T titles2 = root:Multiple_Panel:titles2
			WAVE/T ListWave2 = root:Multiple_Panel:ListWave2
			WAVE sw2 = root:Multiple_Panel:sw2
			
			Variable i
			Variable counter1,counter2
			Variable logic1
			Variable test2 ,j
			counter1 = ItemsInList(list_graphs)
			counter2 = DimSize(sw2,1) 
			test2 = -1
			for(i = 0; i < counter2 ; i += 1)
				if( (sw2[0][i] & 2^0) != 0 )
					test2 = i 
					break
				endif
			endfor
			if(test2 == -1 )
				return 0
			else
				if( cmpstr(ListWave2[0][i],"") != 0 )
					if(test2==29)
						return 0
					else
						name1 = ListWave2[0][i]
						name2 = ListWave2[0][i+1]
						name3 = titles2[i]
						name4 = titles2[i+1]
						ListWave2[0][i] = name2
						ListWave2[0][i+1] = name1
						titles2[i] = name4
						titles2[i+1] = name3
						sw2[0][i] = sw2[0][i] & !(2^0)
						sw2[0][i+1] = sw2[0][i+1] | 2^0
					endif
				else
					return 0
				endif		
			endif
			break
	endswitch

	return 0
End

Function ButtonProc_Blend(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			//WAVE ijmin = root:Specs:ijmin
			//WAVE dividers =  root:Specs:dividers
			Variable counter1,counter2
			//SVAR list_graphs = root:Specs:list_graphs
			//WAVE/T list_names = root:Specs:list_names
			STRING name1, name2,name3
			Variable i , j, k, number
			
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			WAVE/T ListWave2 = root:Multiple_Panel:ListWave2
			WAVE sw2 = root:Multiple_Panel:sw2
			WAVE/T titles2 = root:Multiple_Panel:titles2
			Variable test2
			
			counter1 = DimSize(sw2,1)
			counter2 = DimSize(sw2,1) 
			test2 = -1
			for(i = 0; i < counter2 ; i += 1)
				if( cmpstr(ListWave2[0][i],"") != 0 )
					test2 = i 
					break
				endif
			endfor
			if(test2 == -1 )
				return 0
			endif
			
			NewDataFolder/O root:Final_Blend
			Setdatafolder root:Final_Blend
			Variable/G KineticFermi 
			Variable/G PhotonEnergy  
			Variable/G WorkFunction
			
			if( str2num(ListWave1[test2][14]) != 0 ) 
				KineticFermi = str2num(ListWave1[test2][14])
			endif
			if( str2num(ListWave1[test2][12]) != 0 ) 
				PhotonEnergy  = str2num(ListWave1[test2][12])
			endif
			if( str2num(ListWave1[test2][13]) != 0 ) 
				WorkFunction  = str2num(ListWave1[test2][12])
			endif
			
			Variable doFermi = 2
			Prompt doFermi,"Do you know Kinetic Energy for Fermi level?",popup "No;Yes"
			DoPrompt "Choose",doFermi
			if (V_Flag)
				return -1		// Canceled
			endif
			doFermi -= 1

			Variable/G AngleOffset
			//Variable/G Multiplier
			//NVAR Multiplier
			Variable Multiplier = 1
			AngleOffset = 0
			Variable PE, WF , Resolution , KF
			Resolution = Multiplier
			PE = PhotonEnergy
			WF = WorkFunction
			if(KineticFermi == 0 )
				KF = PhotonEnergy - WorkFunction
			else
				KF = KineticFermi
			endif
			if(doFermi)
				Prompt PE, "Photon Energy [eV]"
				Prompt WF, "Work Function [eV]"
				Prompt KF, "Kinetic Energy of Fermi level [eV]"
				Prompt Resolution, "Multiplication factor"		
				DoPrompt "ENTER THE PARAMETERS",PE,WF, KF, Resolution
				
				PhotonEnergy = PE
				WorkFunction = WF
				KineticFermi = KF
				Multiplier = Resolution
				if (V_Flag)
					return -1		// Canceled
				endif
				
			else
				Prompt PE, "Photon Energy in eV"
				Prompt WF, "Work Function in eV"
				Prompt Resolution, "Multiplication factor"		
				DoPrompt "ENTER THE PARAMETERS",PE,WF, Resolution
				
				PhotonEnergy = PE
				WorkFunction = WF
				Multiplier = Resolution
				KineticFermi = 0
				if (V_Flag)
					return -1		// Canceled
				endif
				
			endif
			
			DoWindow/F $"Final_Blend"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Final_Blend"
			endif
			
			DoUpdate
			
			DoWindow/F $"Display_and_Extract2"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Display_and_Extract2"
			endif
			
			DoWindow/F $"Spectrum"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Spectrum"
			endif
			
			Variable progress , limit1
			progress = 0
			Variable all2blend
			Variable remaining
			remaining = counter2 - test2 - 1
			all2blend = 1
			for(i = test2 + 1; i < remaining ; i += 1)
				if( cmpstr(ListWave2[0][i],"") != 0 )
					all2blend+=1 
				else
					break
				endif
			endfor
			counter1 = all2blend
			limit1 = (counter1)*6 + 5
			DoWindow ProgressPanel
			if(V_flag == 1)
				DoWindow/K ProgressPanel
			endif
				 
			NewPanel /N=ProgressPanel /W=(285,111,739,193)
			ValDisplay valdisp0,pos={18,32},size={342,18},limits={0,limit1,0},barmisc={0,0}
			ValDisplay valdisp0,value=_NUM:progress
			ValDisplay valdisp0,mode= 3,highColor=(0,65535,0)
			DoUpdate /W=ProgressPanel /E=1
			
			WAVE L_image
			WAVE R_image
			STRUCT file_header fh1
			STRUCT file_header fh2
			
			Variable La1,Ra1
			Variable La2,Ra2
			Variable He1,Le1
			Variable He2,Le2
			Variable aNumber1, aNumber2
			Variable deltaA1, deltaA2
			Variable deltaE1, deltaE2
	
			Variable LaNew, RaNew
			Variable LeNew, HeNew
			Variable aNumberNew
			Variable eNumberNew
			Variable eNumber1, eNumber2
			Variable overlapN , eShift1 , eShift2
			
			Variable x1,x2,x3,x4
			Variable y1,y2,y3,y4
			
			Variable multiplierE1, multiplierE2
			Variable multiplierA1,multiplierA2
			
			Variable deltaAn , deltaEn
			Variable overlapNe ,overlapNa
			
			//Ustawianie parametrow lewego obrazu.	
			Setdatafolder root:Specs:$titles2[test2]
			WAVE Angle_2D
			Setdatafolder root:Final_Blend
			Duplicate/O Angle_2D,L_image
			//eA1 = fh1.eAngle 
			La1 = DimOffset(L_image,1)
			Ra1 = DimOffset(L_image,1) + (DimSize(L_image,1)-1)*DimDelta(L_image,1)
			He1 = DimOffset(L_image,0) + (DimSize(L_image,0)-1)*DimDelta(L_image,0)
			Le1 = DimOffset(L_image,0)
			deltaA1 = DimDelta(L_image,1)
			deltaE1 = DimDelta(L_image,0)
			aNumber1 = DimSize(L_image,1)
			eNumber1 = DimSize(L_image,0) 
			eShift1 = round ( str2num(ListWave1[test2][9]) / DimDelta(L_image,0) )
			
			// tutaj wazne ustawienie , zeby nie ruszac rozmiarem wzdluz osi energii
			deltaEn = deltaE1
			eNumberNew = eNumber1
			aNumberNew = aNumber1
			Setdatafolder root:Final_Blend
			Make/O/N=( eNumberNew , aNumberNew ) ImageLRmK
			
			//writing values to the matrices from the data files
			for(k = 1 ; k < all2blend ; k+=1)
				progress = progress + 1
				ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
				DoUpdate /W=ProgressPanel
				
				//Ustawianie parametrow prawego obrazu.	
				Setdatafolder root:Specs:$titles2[test2+ k]
				WAVE Angle_2D
				Setdatafolder root:Final_Blend
				Duplicate/O Angle_2D,R_image
				La2 = DimOffset(R_image,1)
				Ra2 = DimOffset(R_image,1) + (DimSize(R_image,1)-1)*DimDelta(R_image,1)
				He2 = DimOffset(R_image,0) + (DimSize(R_image,0)-1)*DimDelta(R_image,0)
				Le2 = DimOffset(R_image,0)
				deltaA2 = DimDelta(R_image,1)
				deltaE2 = DimDelta(R_image,0)
				aNumber2 = DimSize(R_image,1)
				eNumber2 = DimSize(R_image,0) 
				eShift2 = round ( str2num(ListWave1[test2+1][9]) / DimDelta(R_image,0) )
			
				ControlInfo /W=Load_and_Set_Panel list0
				name3 = S_DataFolder  + S_Value
				WAVE/T		ListWave = $name3
				number = DimSize(ListWave,0) 
				
				//Sprawdzenie czy obrazy maja wspolny obszar.
				if(Ra1 < La2)
					//Return 0
					Print "Images do not overlap"
				endif
			
				if( deltaA1 > deltaA2 )
					deltaAn = deltaA2
					overlapNa = abs ( round( (Ra1 - La2)/deltaA1 )) + 1
					aNumberNew = aNumber1 + aNumber2 - overlapNa
				else
					deltaAn = deltaA1
					overlapNa = abs ( round( (Ra1 - La2)/deltaA2 )) + 1
					aNumberNew = aNumber1 + aNumber2 - overlapNa
				endif
			
				If(Le1 < Le2)
					LeNew = Le1
				else
					LeNew = Le2
				endif
			
				if(He1 < He2)
					HeNew = He2
				else
					HeNew = He1
				endif
				
				if( deltaE1 < deltaE2 )
					deltaEn = deltaE1
					overlapNe = abs ( round( (HeNew - LeNew)/deltaEn )) + 1
					eNumberNew = overlapNe
				else
					deltaEn = deltaE2
					overlapNe = abs ( round( (HeNew - LeNew)/deltaEn )) + 1
					eNumberNew = overlapNe
				endif
				
				LaNew = La1
				RaNew = Ra2
			
				Setdatafolder root:Final_Blend
				Redimension/N=(eNumberNew,aNumberNew) ImageLRmK
				
				SetScale /I x , LeNew , HeNew ,"Kinetic Energy [eV]" , ImageLRmK
				SetScale /I y , LaNew , RaNew ,  "Angle [º]" , ImageLRmK

				Duplicate/O ImageLRmK ImageLR1
				Duplicate/O ImageLRmK ImageLR2
				
				ImageLR1 = 0
				ImageLR2 = 0
				
				y1 = round ( ( La1 - DimOffset(ImageLRmK, 1) ) / DimDelta(ImageLRmK,1) )
				y2 = round ( ( Ra1 - DimOffset(ImageLRmK, 1) ) / DimDelta(ImageLRmK,1) ) //+ 1
				y3 = round ( ( La2 - DimOffset(ImageLRmK, 1) ) / DimDelta(ImageLRmK,1) )
				y4 = round ( ( Ra2 - DimOffset(ImageLRmK, 1) ) / DimDelta(ImageLRmK,1) ) //+ 1
	
				x1 = round ( ( Le1 - DimOffset(ImageLRmK, 0) ) / DimDelta(ImageLRmK,0) ) 
				x2 = round ( ( He1 - DimOffset(ImageLRmK, 0) ) / DimDelta(ImageLRmK,0) ) //+ 1
				x3 = round ( ( Le2 - DimOffset(ImageLRmK, 0) ) / DimDelta(ImageLRmK,0) )
				x4 = round ( ( He2 - DimOffset(ImageLRmK, 0) ) / DimDelta(ImageLRmK,0) ) //+ 1
				
		
				//multiplierE1 = DimDelta(L_image, 0) / DimDelta(ImageLR1, 0)
				//multiplierE2 = DimDelta(R_image, 0) / DimDelta(ImageLR2, 0)
				
				multiplierE1 =  DimDelta(ImageLRmK,0) / DimDelta(L_image, 0) 
				multiplierE2 =  DimDelta(ImageLRmK,0) / DimDelta(R_image, 0)
				
				multiplierA1 = DimDelta(ImageLR1, 1) / DimDelta(L_image, 1)
				multiplierA2 = DimDelta(ImageLR2, 1) / DimDelta(R_image, 1) 
				
				//ImageLR1[x1,x2][y1,y2] = L_image [ (p + x1) ] [ (q - y1) * multiplierA1 ]
				//ImageLR2[x3,x4][y3,y4] = R_image [ (p + x3) ] [ (q - y3) * multiplierA2 ]
				
				ImageLR1[x1,x2][y1,y2] = L_image[(p - x1 - eShift1)*multiplierE1] [(q - y1)*multiplierA1]
				ImageLR2[x3,x4][y3,y4] = R_image[(p - x3 - eShift2)*multiplierE2] [(q - y3)*multiplierA2]
				//ImageLRmK[][y3,y2] = ImageLR1[p][q] - ImageLR2[p][q]
				
				//ImageLR1[][x1,x2] = L_image[p][q]
				//ImageLR2[][x3,x4] = R_image[p - eShift2][q-x3]
				//ImageLRmK[][x3,x2] = ImageLR1[p][q] - ImageLR2[p][q]
				
				
				Variable Rows1, Columns1
				Rows1 = DimSize(ImageLR1, 0 )
			    	Columns1 = DimSize(ImageLR1, 1 )
					
				Wave v1, v2
				Make/O/N =(Rows1)  v1 
				Make/O/N =(Rows1)  v2 
				Make/O/N =(Rows1)  v3
				WAVE Image1 = ImageLR1
				WAVE Image2 = ImageLR2
				Variable Average1,Average2
				Variable help1
				progress = progress + 1
				ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
				DoUpdate /W=ProgressPanel
				
				for(i = 0; i <=y2;i+=1)	// Initialize variables;continue test
					v1 =  Image1[p][i]
					v2 =  Image2[p][i]
					Average1 = 0
					for(j = 0; j <Rows1;j+=1)	// Initialize variables;continue test
						Average1 =  v1[j] + Average1
					endfor 
					Average1 = Average1/Rows1
				
					Average2 = 0
					for(j = 0; j <Rows1;j+=1)	// Initialize variables;continue test
						Average2 =  v2[j] + Average2
					endfor 
					Average2 = Average2/Rows1
					if(Average2 != 0)
						help1 = Average1/Average2
						Image2[][i] = v2[p] * help1
					endif
				endfor
				progress = progress + 1
				ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
				DoUpdate /W=ProgressPanel
				
				Variable Columns2
				Columns2 = Columns1 - 1
				for(i = y2; i <Columns2;i+=1)	// Initialize variables;continue test
					v1 =  Image2[p][i]
					v2 =  Image2[p][i + 1]
					Average1 = 0
					for(j = 0; j <Rows1;j+=1)	// Initialize variables;continue test
						Average1 =  v1[j] + Average1
					endfor 
					Average1 = Average1/Rows1
				
					Average2 = 0
					for(j = 0; j <Rows1;j+=1)	// Initialize variables;continue test
						Average2 =  v2[j] + Average2
					endfor 
					Average2 = Average2/Rows1
				
					help1 = Average1/Average2
					Image2[][i +1] = v2[p] * help1
				endfor
				progress = progress + 1
				ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
				DoUpdate /W=ProgressPanel
		
			
				Variable numberY1, numberY2,numberY3
				numberY1 = y2 - y3 + 1
				
				ImageLRmK[][y1,y2] = ImageLR1[p][q]
				ImageLRmK[][y3,y4] = ImageLR2[p][q]
				
				progress = progress + 1
				ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
				DoUpdate /W=ProgressPanel
				
				for(i = y3 ; i <= y2 ; i+=1)
					for(j = 0; j< eNumberNew ; j+=1)
						numberY2 = ( i - y3 ) / ( numberY1 )
						numberY3 = 1 - numberY2
						ImageLRmK[j][i] = numberY3 * ImageLR1[j][i] + numberY2*ImageLR2[j][i] 
					endfor
				endfor
				
				progress = progress + 1
				ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
				DoUpdate /W=ProgressPanel
				
				Setdatafolder root:Final_Blend
				Duplicate/O ImageLRmK,L_image
				La1 = LaNew
				Ra1 = RaNew
				He1 = HeNew
				Le1 = LeNew
			
				aNumber1 = DimSize(ImageLRmK,1)
				eNumber1 = DimSize(ImageLRmK,0) 
				deltaE1 = DimDelta(ImageLRmK,0)
				deltaA1 = DimDelta(ImageLRmK,1)
				eShift1 = 0
			endfor
			
			Setdatafolder root:Final_Blend
			if(counter1 == 1)
				Duplicate/O L_image, ImageLRmK
			endif
			
			Duplicate/O ImageLRmK ImageLRmB
			Duplicate/O ImageLRmK ImageLRmK1
			
			Setdatafolder root:Final_Blend
			WAVE Amatrix=ImageLRmB
			Variable Ymin,Ymax
			
			if(doFermi)
				Ymin=DimOffset( Amatrix,0 ) 
				Ymax=DimOffset( Amatrix , 0 ) + ( Dimsize(Amatrix , 0) - 1 ) * DimDelta( Amatrix , 0 )
				SetScale/I x,Ymin-KineticFermi,Ymax-KineticFermi, "Binding Energy [eV]" ImageLRmB
				
			else
				Ymin=DimOffset( Amatrix,0 ) 
				Ymax=DimOffset( Amatrix , 0 ) + ( Dimsize(Amatrix , 0) - 1 ) * DimDelta( Amatrix , 0 )
				SetScale/I x,Ymin-PhotonEnergy + WF,Ymax-PhotonEnergy + WF, "Binding Energy [eV]" ImageLRmB	
				
			endif
			
			Duplicate/O ImageLRmB, ImageLRmBdif
			
			Variable Rows, Columns
			Rows = DimSize( ImageLRmB , 0 )
			Columns = DimSize( ImageLRmB , 1 )
					
			Wave v1
			Make/O/N =(Rows)  v1 
			
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
			ImageLRmBdif = 0
			for(i = 0; i <Columns;i+=1)	// Initialize variables;continue test
				Redimension/N =(Rows)  v1
				v1 =  ImageLRmB[p][i]
				Smooth 2 , v1
				Differentiate/METH=0/EP=1 v1
				Differentiate/METH=0/EP=1 v1
				ImageLRmBdif[][i] = -v1[p]
			endfor
			KillWaves v1
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
			
			//DoWindow/F $"Final_Blend"				//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow $"Final_Blend"
			//endif
			
			WAVE Amatrix = ImageLRmB
			WAVE AmatrixDif = ImageLRmBdif
				
			NVAR PhotonEnergy
			NVAR WorkFunction
			PE = PhotonEnergy
			WF = WorkFunction
			Variable Xmin,Xmax
			
			Xmin=DimOffset(Amatrix,1) 
			Ymin=DimOffset(Amatrix,0) 
			Xmax=DimOffset(Amatrix,1) + (Dimsize(Amatrix,1)-1) *DimDelta(Amatrix,1)
			Ymax=DimOffset(Amatrix,0) + (Dimsize(Amatrix,0)-1) *DimDelta(Amatrix,0)
				
			Duplicate/O ImageLRmB , KparImageLRmB
			Duplicate/O ImageLRmBdif , KparImageLRmBdif
			KparImageLRmB = 0
			KparImageLRmBdif = 0
			
			WAVE Kmatrix=KparImageLRmB
			WAVE KmatrixDif=KparImageLRmBdif
				
			for(i = 0; i <Columns;i+=1)	// Initialize variables;continue test
				for(j = 0; j <Rows;j+=1)
					if(ImageLRmBdif[j][i] < 0)
						ImageLRmBdif[j][i] = 0
					endif
				endfor
			endfor
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel	
			
			Redimension/N=(-1,Dimsize(Amatrix,1) * Resolution) Kmatrix
			Redimension/N=(-1,Dimsize(Amatrix,1) * Resolution) KmatrixDif
			
			Variable YL=SelectNumber(sign(Xmin)==+1,Ymax,Ymin)
			Variable YR=SelectNumber(sign(Xmax)==+1,Ymin,Ymax)
			progress = progress + 1
			Setscale/I y,0.512*sqrt(PE-WF+YL)*sin(Xmin*Pi/180),0.512*sqrt(PE-WF+YR)*sin(Xmax*Pi/180),"k\B||\M [Å]" Kmatrix
			//Kmatrix=(y>0.512*sqrt(PE-WF+x)*sin(Xmax*Pi/180) || y<0.512*sqrt(PE-WF+x)*sin(Xmin*Pi/180)) ? Nan : Amatrix(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
			progress = progress + 1	
			SetScale/I y,0.512*sqrt(PE-WF+YL)*sin(Xmin*Pi/180),0.512*sqrt(PE-WF+YR)*sin(Xmax*Pi/180),"k\B||\M [Å]" KmatrixDif
			//KmatrixDif=(y>0.512*sqrt(PE-WF+x)*sin(Xmax*Pi/180) || y<0.512*sqrt(PE-WF+x)*sin(Xmin*Pi/180)) ? Nan : AmatrixDif(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
			//progress = progress + 1
			
			Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
			Variable delta_k_n , delta_k_m , delta_phi , delta_theta
			Variable k_n0 , k_m0 , phi0 , theta0
			Variable phi1 , phi2 , theta1 , theta2
			Variable i_n , j_m 
			Variable n_max , m_max
			Variable i_max , j_max
			Variable i_1 , i_2 , j_1 , j_2
			Variable wL , wR , wU , wD 
			Variable o , o_max , E_o0 , delta_E , E_o
						
			Variable C1,C2
			//C1 = 1/(0.512*sqrt(Energy))
			C2 = 180/Pi
						
			n_max = DimSize (Kmatrix,1)
			m_max = DimSize (Kmatrix,1)
			o_max = DimSize (Kmatrix,0)
						
			k_n0 = DimOffset (Kmatrix,1)
			k_m0 = DimOffset (Kmatrix,1)
			E_o0 = DimOffset (Kmatrix,0)
						
			delta_k_n = DimDelta (Kmatrix,1)
			delta_k_m = DimDelta (Kmatrix,1)
			delta_E = DimDelta (Kmatrix,0)
						
			i_max = DimSize (Amatrix,1) - 1
			j_max = DimSize (Amatrix,1) - 1
						
			phi0 = DimOffset (Amatrix,1)
			theta0 = DimOffset (Amatrix,1)
			theta0 = 0
						
			delta_phi = DimDelta (Amatrix,1)
			delta_theta = DimDelta (Amatrix,1)
						
			k_n = k_n0
			k_m = 0
			E_o = PE-WF+E_o0
						
			for(o=0;o<o_max;o=o+1)
				C1 = 1/(0.512*sqrt(E_o))
				for( n=0;n<n_max;n=n+1)
					phi_n_rad = asin( k_n * C1 )
					phi_n = phi_n_rad * C2
					i_n = (phi_n - phi0)/delta_phi
					if(i_n>=0 && i_n<=i_max)
						//for( m=0;m<m_max;m=m+1)
						theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
						j_m = (theta_m - theta0)/delta_theta
						if(j_m>=0 && j_m<=j_max)	
							i_1 = floor(i_n)
							i_2 = ceil(i_n)
							j_1 = floor(j_m)
							j_2 = ceil(j_m)
							wR = i_n - i_1
							wL = 1 - wR
							wU = j_m - j_1
							wD = 1 - wU
							Kmatrix[o][n] = Amatrix[o][i_1]*wL*wD + Amatrix[o][i_2]*wR*wD + Amatrix[o][i_1]*wL*wU + Amatrix[o][i_2]*wR*wU
						else
							Kmatrix[o][n] = Nan
						endif
						//k_m = k_m + delta_k_m
						//endfor
					else
						Kmatrix[o][n] = Nan
					endif
					//k_m = k_m0
					k_n = k_n + delta_k_n
				endfor
				k_n = k_n0
				E_o = E_o + delta_E
			endfor
			
			progress = progress + 1	
			k_n = k_n0
			k_m = 0
			E_o = PE-WF+E_o0
			
			for(o=0;o<o_max;o=o+1)
				C1 = 1/(0.512*sqrt(E_o))
				for( n=0;n<n_max;n=n+1)
					phi_n_rad = asin( k_n * C1 )
					phi_n = phi_n_rad * C2
					i_n = (phi_n - phi0)/delta_phi
					if(i_n>=0 && i_n<=i_max)
						//for( m=0;m<m_max;m=m+1)
						theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
						j_m = (theta_m - theta0)/delta_theta
						if(j_m>=0 && j_m<=j_max)	
							i_1 = floor(i_n)
							i_2 = ceil(i_n)
							j_1 = floor(j_m)
							j_2 = ceil(j_m)
							wR = i_n - i_1
							wL = 1 - wR
							wU = j_m - j_1
							wD = 1 - wU
							KmatrixDif[o][n] = AmatrixDif[o][i_1]*wL*wD + AmatrixDif[o][i_2]*wR*wD + AmatrixDif[o][i_1]*wL*wU + AmatrixDif[o][i_2]*wR*wU
						else
							KmatrixDif[o][n] = Nan
						endif
						//k_m = k_m + delta_k_m
						//endfor
					else
						KmatrixDif[o][n] = Nan
					endif
					//k_m = k_m0
					k_n = k_n + delta_k_n
				endfor
				k_n = k_n0
				E_o = E_o + delta_E
			endfor
			
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
			KillWindow ProgressPanel
			
			Duplicate/O/O ImageLRmB, ImageLRmB1
			Duplicate/O/O KparImageLRmB, KparImageLRmB1
			
			Duplicate/O/O ImageLRmBdif, ImageLRmBdif1			
			Duplicate/O/O KparImageLRmBdif, KparImageLRmBdif1
			
			
			Display/W=(18,58,560,540)
			Dowindow/C $"Final_Blend"
			AppendImage ImageLRmB
			//ModifyGraph lblMargin(left)=3
			//ModifyGraph axOffset(left)=-1.42857
			ModifyGraph  swapXY=1
			ModifyGraph margin =40
			ModifyGraph margin(right) =20
			ModifyGraph margin(top) =10
			
			ModifyGraph manTick(bottom)={0,5,0,1},manMinor(bottom)={1,5}
			ModifyGraph tick(bottom)=2,mirror(bottom)=1
			ModifyGraph manTick(left)={0,1,0,0},manMinor(left)={1,2}
			ModifyGraph tick(left)=2,mirror(left)=1
			
			ModifyGraph grid(bottom)=1,gridRGB(bottom)=(0,0,0)
			ModifyGraph grid(left)=1,gridRGB(left)=(0,0,0)
			
			Controlbar 100
			ControlBar /L 90
			Button change_toKbutton,pos={5,110},size={80,40},proc=change_toK,title="Change to\rk Parallel" , anchor=MC
			
			Button derivative,pos={5,155},size={80,40},proc=displayDer,title="Change to\r 2nd Derivative"
			
			Button Recalculate,pos={5,230},size={80,40},proc=recalculateA,title="Recalculate" , disable=2
			
			Button removedefects,pos={5,275},size={80,40},proc=RemoveDefects,title="Remove\r defects" , disable=2
			
			Button changeE , pos={5,350} , size={80,35} , proc=ChangeEmissions , title="Change\rEmissons"
			ValDisplay AngleShift  , pos={10,390} , size={60,35} , value= _NUM: 0 
			
			Button buttonDisplayExtract,pos={5,450},size={80,39},proc=DisplayExtractPanel2,title="Display\r& Extract" ,disable=2
			Button buttonDisplayExtract,fSize=13
			
			Wavestats/Q/Z ImageLRmB
			Variable/G varMin = V_Min
			Variable/G varMax = V_max
			
			TitleBox zminimo title="zMin ",pos={5,25}
			
			Slider contrastmin,vert= 0,pos={41,27},size={290,16},proc=contrast
			Slider contrastmin,limits={V_min,V_max,0},variable=varMin,ticks= 0
			
			TitleBox zmax title="zMax",pos={5,3}
			
			Slider contrastmax,vert= 0,pos={41,7},size={290,16},proc=contrast
			Slider contrastmax,limits={V_min,V_max,0},variable=varMax,ticks= 0
			
			//Button change_toKbutton,pos={335,5},size={80,40},proc=change_toK,title="Change to\rk Parallel"
			
			//Button Recalculate,pos={420,5},size={65,40},proc=recalculateA,title="Recalculate"
			
			Button profiles,pos={270,50},size={60,40},proc=Profiles1,title="Profiles"
			
			//Button derivative,pos={335,50},size={80,40},proc=displayDer,title="Change to\r 2nd Derivative"
			//Button removedefects,pos={420,50},size={65,40},proc=RemoveDefects,title="Remove\r defects"
			
			Button ExportImage,pos={200,50},size={60,40},proc=ExportImages,title="Export\r Image"
			
			Button InverseImage,pos={115,50},size={30,20},proc=InverseImages,title="Inv"
			
			Button Reset,pos={480,40},size={60,20},proc=ResetScale,title="Reset" ,fSize=16
			
			Button ShowM,pos={155,70},size={30,20},proc=ShowMultiple,title="SM"
			
			//Button changeE , pos={5,350} , size={80,35} , proc=ChangeEmissions , title="Change\rEmissons"
			//ValDisplay AngleShift  , pos={10,390} , size={60,35} , value= _NUM: 0 
			
			SetVariable gamma1,pos={10,50},size={100,20},proc=GammaImage,title="Gamma"
			SetVariable gamma1,labelBack=(43520,43520,43520),fSize=14
			SetVariable gamma1,limits={-inf,inf,0.1},value= _NUM:1
			
			PopupMenu popup0,pos={10,75},size={55,20},proc=ChangeColor
			PopupMenu popup0,mode=1,popvalue="Grays",value= #"\"Grays;VioletOrangeYellow\""
			
			SetVariable SetLeftUpper,pos={355,10},size={110,20},proc=SetAllAxis,title="Upper"
			SetVariable SetLeftUpper,fSize=14,limits={-inf,inf,0.01},value= _NUM:Ymax
			
			SetVariable SetLeftLower,pos={355,35},size={110,20},proc=SetAllAxis,title="Lower"
			SetVariable SetLeftLower,fSize=14,limits={-inf,inf,0.01},value= _NUM:Ymin
			
			SetVariable SetBottomLeft,pos={345,70},size={100,20},proc=SetAllAxis,title="Left"
			SetVariable SetBottomLeft,fSize=14,limits={-inf,inf,0.01},value= _NUM:Xmin
			
			SetVariable SetBottomRight,pos={455,70},size={100,20},proc=SetAllAxis,title="Right"
			SetVariable SetBottomRight,fSize=14,limits={-inf,inf,0.01},value= _NUM:Xmax
			
			CheckBox check1 title="Grid",pos={155,50},size={50,20},proc=CheckProc_Grid,value=1,labelBack=(52224,52224,52224)
			
			Variable /G LeftUpper = Ymax
			Variable /G LeftLower = Ymin
			Variable /G BottomLeft = Xmin
			Variable /G BottomRight = Xmax
			 ImageLRmK = ImageLRmK1
		break
	endswitch

	return 0
End

Function NrinListbox(name1)
	String name1
	
	Variable nr_inListbox
	Variable i,size1
	WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
	size1 = DimSize(ListWave1,0)
	for(i=0;i<size1;i+=1)
		if(cmpstr(name1,ListWave1[i][1]) == 0)
			nr_inListbox = i
		endif	
	endfor
	return nr_inListbox
End

Function ButtonProc_BlendNew(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			//WAVE ijmin = root:Specs:ijmin
			//WAVE dividers =  root:Specs:dividers
			Variable counter1,counter2
			//SVAR list_graphs = root:Specs:list_graphs
			//WAVE/T list_names = root:Specs:list_names
			STRING name1, name2,name3
			Variable i , j, k, number
			Setdatafolder root:Multiple_Panel
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			WAVE/T ListWave2 = root:Multiple_Panel:ListWave2
			WAVE sw2 = root:Multiple_Panel:sw2
			WAVE/T titles2 = root:Multiple_Panel:titles2
			Variable test2 , indexFirst , nrImages , indexLast , test1
			
			counter1 = DimSize(ListWave1,0)
			counter2 = DimSize(ListWave2,1) 
			test2 = -1
			nrImages = 0
			for(i = 0; i < counter2 ; i += 1)
				if( cmpstr(ListWave2[0][i],"") != 0 )
					test2 = i 
					break
				endif
			endfor
			indexFirst = test2
			if(test2 == -1 )
				return 0
			endif
			for(i = test2; i < counter2 ; i += 1)
				if( cmpstr(ListWave2[0][i],"") == 0 )
					test2 = i
					break
				endif
			endfor
			indexLast = test2 - 1
			nrImages = indexLast-indexFirst + 1
			
			test1 = -1 
			for(i = 0; i < counter1 ; i += 1)
				name2 = titles2[indexFirst]
				name1 = ListWave1[i][1]
				if( cmpstr(name1,name2) == 0 )
					test1 = i 
					break
				endif
			endfor
			
			if(test1 == -1)
				break
			endif
			
			Variable La,Ra,Lke,Hke,deltaA,deltaE
			Setdatafolder root:Multiple_Panel
			//Setdatafolder root:Specs:$titles2[indexFirst]
			Wave Angle_2D = $titles2[indexFirst]
		
			La = DimOffset(Angle_2D,1)
			Ra = DimOffset(Angle_2D,1) + (DimSize(Angle_2D,1) - 1)*DimDelta(Angle_2D,1)
			Lke = DimOffset(Angle_2D,0)
			Hke = DimOffset(Angle_2D,0) + (DimSize(Angle_2D,0) - 1)*DimDelta(Angle_2D,0)
			deltaA = DimDelta(Angle_2D,1)
			deltaE = DimDelta(Angle_2D,0)
			
			Variable help1, help2,help3,help4,help5,help6
			for(i =indexFirst+1;i<(indexLast+1);i+=1)
				//Setdatafolder root:Specs:$titles2[i]
				Wave Angle_2D = $titles2[i]
				help1 = DimOffset(Angle_2D,1)
				help2 = DimOffset(Angle_2D,1) + (DimSize(Angle_2D,1) - 1)*DimDelta(Angle_2D,1)
				help3 = DimOffset(Angle_2D,0)
				help4 = DimOffset(Angle_2D,0) + (DimSize(Angle_2D,0) - 1)*DimDelta(Angle_2D,0)	
				help5 = DimDelta(Angle_2D,1)
				help6 = DimDelta(Angle_2D,0)
				if(La>help1)
					La = help1
				endif
				if(Ra<help2)
					Ra = help2
				endif
				if(Lke>help3)
					Lke = help3
				endif
				if(Hke<help4)
					Hke = help4
				endif
				if(deltaA>help5)
					deltaA = help5
				endif
				if(deltaE>help6)
					deltaA = help6
				endif
			endfor
			
			Variable flag_1
			String win_name , win_name2
			String message = "ENTER THE NAME OF THE NEW WINDOW"
			String temp_string , temp_string2
			String ending
			win_name = titles2[indexFirst]
			sscanf win_name, "%[^.]", win_name
			do
				//win_name = titles2[indexFirst]
				Prompt win_name, "Names must start with a letter and contain letters, digits or \'_\'"
				DoPrompt message,win_name
				if (V_Flag)
					return -1		// Canceled
				endif
				//temp_string = GetDataFolder(1)
				temp_string = "root:Final_Blends:"+win_name+":"
				if( DataFolderExists( temp_string ) )
					win_name2 = win_name
					message = "NAME EXISTS. IF YOU CONTINUE IT WILL OVERWRITE"	
					Prompt win_name2, "Names must start with a letter and contain letters, digits or \'_\'"
					DoPrompt message,win_name2
					if (V_Flag)
						return -1		// Canceled
					endif
					if( cmpstr( win_name, win_name2 ) == 0)
						KillWindow $(win_name2)	
						NewDataFolder/O root:$"Final_Blends"
						NewDataFolder root:Final_Blends:$(win_name2)	
						break
					else
						temp_string2 = "root:Final_Blends:"+win_name2+":"
						if( DataFolderExists( temp_string2 ) )
							message = "NAME EXISTS, CHOOSE ANOTHER NAME."		
						else
							Display/W=(18,58,560,540) /N=$(win_name2) /HIDE=1
							DoWindow $win_name2
							flag_1 = V_flag
							KillWindow $(win_name)
							if(flag_1 != 0)
								KillWindow $(win_name2)
								NewDataFolder/O root:$"Final_Blends"
								NewDataFolder root:Final_Blends:$(win_name2)
								if( DataFolderExists( temp_string2 ) )	
									break
								else 
									message = "WRONG NAME, CHOOSE ANOTHER NAME"	
								endif
							else	
								message = "WRONG NAME, CHOOSE ANOTHER NAME"		
							endif
						endif
					endif
				else
					Display/W=(18,58,560,540) /N=$(win_name) /HIDE=1
					DoWindow $win_name
					flag_1 = V_flag
					KillWindow $(win_name)
					if(flag_1 != 0)
						//KillWindow $(win_name)
						NewDataFolder/O root:$"Final_Blends"
						NewDataFolder root:Final_Blends:$(win_name)
						if( DataFolderExists( temp_string ) )	
							break
						else 
							message = "WRONG NAME, CHOOSE ANOTHER NAME"	
						endif
					else	
						message = "WRONG NAME, CHOOSE ANOTHER NAME"		
					endif
				endif
			while(1)
			
			//NewDataFolder/O root:Final_Blend
			//Setdatafolder root:Final_Blend
			Setdatafolder root:Final_Blends:$(win_name)
			Variable/G KineticFermi = 0
			Variable/G PhotonEnergy = 0
			Variable/G WorkFunction = 0
			
			if( str2num(ListWave1[test1][13]) != 0 ) 
				KineticFermi = str2num(ListWave1[test1][13])
			endif
			
			if( str2num(ListWave1[test1][11]) != 0 ) 
				PhotonEnergy  = str2num(ListWave1[test1][11])
			endif
			
			if( str2num(ListWave1[test1][12]) != 0 ) 
				WorkFunction  = str2num(ListWave1[test1][12])
			endif
			
			Variable doFermi = 2
			Prompt doFermi,"Do you know Kinetic Energy of Fermi level?",popup "No;Yes"
			DoPrompt "Choose",doFermi
			if (V_Flag)
				return -1		// Canceled
			endif
			doFermi -= 1

			Variable/G AngleOffset
			//Variable/G Multiplier
			//NVAR Multiplier
			Variable FactorA
			AngleOffset = 0
			Variable PE, WF , KF , SF
			SF = 5
			PE = PhotonEnergy
			WF = WorkFunction
			if(KineticFermi == 0 )
				KF = PhotonEnergy - WorkFunction
			else
				KF = KineticFermi
			endif
			if(doFermi)
				Prompt PE, "Photon Energy [eV]"
				Prompt WF, "Work Function [eV]"
				Prompt KF, "Kinetic Energy of Fermi level [eV]"
				Prompt SF, "Smoothing factor for 2nd Derivative (for angular axis):best 1-10"	
				DoPrompt "ENTER THE PARAMETERS",PE,WF, KF,SF
				
				PhotonEnergy = PE
				WorkFunction = WF
				KineticFermi = KF
				if (V_Flag)
					return -1		// Canceled
				endif
				
			else
				Prompt PE, "Photon Energy in eV"
				Prompt WF, "Work Function in eV"	
				Prompt SF, "Smoothing factor for 2nd Derivative (for angular axis):best 1-10"	
				DoPrompt "ENTER THE PARAMETERS",PE,WF,SF
				
				PhotonEnergy = PE
				WorkFunction = WF
				KineticFermi = 0
				if (V_Flag)
					return -1		// Canceled
				endif
				
			endif
			
			DoWindow/F $"Final_Blend"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Final_Blend"
			endif
			
			DoUpdate
			
			DoWindow/F $"Display_and_Extract2"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Display_and_Extract2"
			endif
			
			DoWindow/F $"Spectrum"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Spectrum"
			endif
			
			Variable progress , limit1
			progress = 0
			
			counter1 = nrImages
			limit1 = (nrImages -1)*3 + 11
			DoWindow ProgressPanel
			if(V_flag == 1)
				DoWindow/K ProgressPanel
			endif
				 
			NewPanel /N=ProgressPanel /W=(285,111,739,193)
			ValDisplay valdisp0,pos={18,32},size={342,18},limits={0,limit1,0},barmisc={0,0}
			ValDisplay valdisp0,value=_NUM:progress
			ValDisplay valdisp0,mode= 3,highColor=(0,65535,0)
			DoUpdate /W=ProgressPanel /E=1
			
			Variable totalNrPixA , totalNrPixE
			totalNrPixA = round((Ra - La)/deltaA) + 1
			totalNrPixE = round((Hke - Lke)/deltaE) + 1
			
			Make/O/N=(totalNrPixE,totalNrPixA) FinalBlendKE
			FinalBlendKE = 0
			SetScale/P x, Lke, deltaE,"" FinalBlendKE
           		SetScale/P y, La, deltaA, "" FinalBlendKE
           		Duplicate/FREE FinalBlendKE , TemporaryHoldKE
           		Duplicate/O FinalBlendKE , FinalBlendKE2
           		Duplicate/FREE FinalBlendKE , TemporaryHoldKE2
           		
           		progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
				
			WAVE L_image
			WAVE R_image
			STRUCT file_header fh1
			STRUCT file_header fh2
			
			Variable La1,Ra1
			Variable La2,Ra2
			Variable He1,Le1
			Variable He2,Le2
			Variable aNumber1, aNumber2
			Variable deltaA1, deltaA2
			Variable deltaE1, deltaE2
	
			Variable LaNew, RaNew
			Variable LeNew, HeNew
			Variable aNumberNew
			Variable eNumberNew
			Variable eNumber1, eNumber2
			Variable overlapN , eShift1 , eShift2
			
			Variable x1,x2,x3,x4
			Variable y1,y2,y3,y4
			
			Variable multiplierE1, multiplierE2
			Variable multiplierA1,multiplierA2
			
			Variable deltaAn , deltaEn
			Variable overlapNe ,overlapNa
			
			//Ustawianie parametrow lewego obrazu.	
			//Setdatafolder root:Specs:$titles2[indexFirst]
			//WAVE Angle_2D
			Setdatafolder root:Multiple_Panel
			Wave Angle_2D = $titles2[indexFirst]
			
			Setdatafolder root:Final_Blends:$(win_name)
			Duplicate/O titles2, titlesF
			//Setdatafolder root:Final_Blend
			Duplicate/O Angle_2D,L_image
			Duplicate/O Angle_2D,L_image2
			Variable index_inListbox , val1, val2 , nPointsX , nPointsY
			index_inListbox = NrinListbox(titles2[indexFirst])
			val1 =  str2num( ListWave1[index_inListbox][14] ) 
			val2 =  str2num( ListWave1[index_inListbox][15] ) 
			
			Smooth_2D(L_image, 0, val1)
			Smooth_2D(L_image2, 1, val2)	
			
			//Smooth_2D(L_image, 1, val2)
			//Smooth_2D(L_image, 0, val1)
			//Smooth_2D(L_image2, 0, val1)
			//Smooth_2D(L_image2, 1, val2)	
				
			La1 = DimOffset(L_Image,1)
			Ra1 = DimOffset(L_image,1) + (DimSize(L_image,1)-1)*DimDelta(L_image,1)
			He1 = DimOffset(L_image,0) + (DimSize(L_image,0)-1)*DimDelta(L_image,0)
			Le1 = DimOffset(L_image,0)
			
			Variable index1A,index2A,index3A,index4A
			Variable index1E,index2E,index3E,index4E
			index1A = round ( ( La1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
			index3A = round ( ( Ra1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) 
			index1E = round ( ( Le1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
			index3E = round ( ( He1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
			
			FinalBlendKE[index1E,index3E][index1A,Index3A] = L_Image(x)(y)
			FinalBlendKE2[index1E,index3E][index1A,Index3A] = L_Image2(x)(y)
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
			
			//Variable nrLines = (nrImages -1)*2  + 2
			Variable nrLines = nrImages*2 
			if(nrLines > 0)
				Make/O /N =(nrLines ) Lines	
			endif
			Wave ImageLRmK
			Lines[0] = 0
			for(k = 1 ; k < nrImages ; k+=1)
				
				//Ustawianie parametrow prawego obrazu.	
				//Setdatafolder root:Specs:$titles2[indexFirst+ k]
				//WAVE Angle_2D
				Setdatafolder root:Multiple_Panel
				Wave Angle_2D = $titles2[indexFirst+ k]
				//WAVE R_Image = Angle_2D
				//Setdatafolder root:Final_Blend
				Setdatafolder root:Final_Blends:$(win_name)
				Duplicate/O Angle_2D,R_image
				Duplicate/O Angle_2D,R_image2
				
				index_inListbox = NrinListbox(titles2[indexFirst+ k])
				val1 =  str2num( ListWave1[index_inListbox][14] ) 
				val2 =  str2num( ListWave1[index_inListbox][15] ) 
				
				Smooth_2D(R_image, 0, val1)
				Smooth_2D(R_image2, 1, val2)		
			
				//Duplicate/O Angle_2D,R_image
				La2 = DimOffset(R_image,1)
				Ra2 = DimOffset(R_image,1) + (DimSize(R_image,1)-1)*DimDelta(R_image,1)
				He2 = DimOffset(R_image,0) + (DimSize(R_image,0)-1)*DimDelta(R_image,0)
				Le2 = DimOffset(R_image,0)
				
				index1A = round ( ( La1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
				index3A = round ( ( Ra1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) 
				index2A = round ( ( La2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
				index4A = round ( ( Ra2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
				
				index1E = round ( ( Le1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
				index3E = round ( ( He1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
				index2E = round ( ( Le2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
				index4E = round ( ( He2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
				
				//Lines[0] = 0
				if( index2A >= index1A )
					Lines[2*k-1] = index2A
					Lines[2*k] = index3A
				else
					if(index1A > index4A)
						Lines[2*k-1] = index1A
						Lines[2*k] = index4A	
					endif
				endif
				
				TemporaryHoldKE[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
				TemporaryHoldKE2[index2E,index4E][index2A,Index4A] = R_Image2(x)(y)
				
				progress = progress + 1
				ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
				DoUpdate /W=ProgressPanel
				
				Variable Average1, Average2 , Normalization
				Variable Average1b, Average2b , NormalizationB
				Variable help1b, help2b
				
				if( index3A >= index2A )
					if( index2A >= index1A )
						Average1 = 0
						Average2 = 0
						Average1b = 0
						Average2b = 0
						for(j=index2A;j<=index3A;j+=1)
							for(i=0;i<totalNrPixE;i+=1)
								help2 = TemporaryHoldKE[i][j]
								help1 = FinalBlendKE[i][j]
								help2b = TemporaryHoldKE2[i][j]
								help1b = FinalBlendKE2[i][j]
								if( help1!= 0 && help2!=0 )
									Average1+=help1
									Average2+=help2
								endif
								
								if( help1b!= 0 && help2b!=0 )
									Average1b+=help1b
									Average2b+=help2b
								endif
							endfor
						endfor
						Normalization=Average1/Average2
						TemporaryHoldKE = TemporaryHoldKE*Normalization
						FinalBlendKE[][index3A+1,index4A] = TemporaryHoldKE[p][q]
						
						NormalizationB=Average1b/Average2b
						TemporaryHoldKE2 = TemporaryHoldKE2*NormalizationB
						FinalBlendKE2[][index3A+1,index4A] = TemporaryHoldKE2[p][q]
					else
						if(index1A > index4A)
							Average1 = 1
							Average2 = 1	
							Average1b = 1
							Average2b = 1	
						else
							for(j=index1A;j<=index4A;j+=1)
								for(i=0;i<totalNrPixE;i+=1)
									help2 = TemporaryHoldKE[i][j]
									help1 = FinalBlendKE[i][j]
									help2b = TemporaryHoldKE2[i][j]
									help1b = FinalBlendKE2[i][j]
									if( help1!= 0 && help2!=0 )
										Average1+=help1
										Average2+=help2
									endif
									if( help1b!= 0 && help2b!=0 )
										Average1b+=help1b
										Average2b+=help2b
									endif
								endfor
							endfor	
							Normalization=Average1/Average2
							TemporaryHoldKE = TemporaryHoldKE*Normalization
							FinalBlendKE[][index2A+1,index4A] = TemporaryHoldKE[p][q]	
							
							NormalizationB=Average1b/Average2b
							TemporaryHoldKE2 = TemporaryHoldKE2*NormalizationB
							FinalBlendKE2[][index2A+1,index4A] = TemporaryHoldKE2[p][q]	
						endif
					endif
				else
					Average1 = 1
					Average2 = 1	
					Normalization=Average1/Average2
					TemporaryHoldKE = TemporaryHoldKE*Normalization
					FinalBlendKE[][index2A+1,index4A] = TemporaryHoldKE[p][q]
					
					Average1b = 1
					Average2b = 1	
					NormalizationB=Average1b/Average2b
					TemporaryHoldKE2 = TemporaryHoldKE2*NormalizationB
					FinalBlendKE2[][index2A+1,index4A] = TemporaryHoldKE2[p][q]
				endif
				
				//Normalization=Average1/Average2
				//TemporaryHoldKE = TemporaryHoldKE*Normalization
				//FinalBlendKE[][index3A+1,index4A] = TemporaryHoldKE[p][q]
				
				progress = progress + 1
				ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
				DoUpdate /W=ProgressPanel
				Variable modPi = Pi/2
				Variable numberPix1 , weight1, weight2 
				
				if( index3A >= index2A )
					if( index2A >= index1A )
						numberPix1 = index3A - index2A +1
						for(j = index2A ; j <= index3A ; j+=1)
							weight1 = (index3A-j)/ numberPix1
							weight2 = 1 - weight1
							//weight1 = cos(modPi*((index3A-j)/ numberPix1-1))
							//weight2 = sqrt(1 - weight1*weight1)
							for(i = 0 ; i < totalNrPixE ; i+=1)
								help1 = FinalBlendKE[i][j]
								help2 = TemporaryHoldKE[i][j]
								help1b = FinalBlendKE2[i][j]
								help2b = TemporaryHoldKE2[i][j]
								if( help1!= 0 )
									if( help2!=0 )
										//weight1 = (index3A-j)/ numberPix1
										//weight2 = 1 - weight1
										FinalBlendKE[i][j] = help1*weight1 + help2*weight2
									else
										FinalBlendKE[i][j] = help1
									endif
								else
								 	if( help2!=0 )
										FinalBlendKE[i][j] = help2
									endif
								endif
								
								if( help1b!= 0 )
									if( help2b!=0 )
										//weight1 = (index3A-j)/ numberPix1
										//weight2 = 1 - weight1
										FinalBlendKE2[i][j] = help1b*weight1 + help2b*weight2
									else
										FinalBlendKE2[i][j] = help1b
									endif
								else
								 	if( help2!=0 )
										FinalBlendKE2[i][j] = help2b
									endif
								endif
							endfor
						endfor	
					else
						if(index1A > index4A)
							
						else
							numberPix1 = index2A - index1A + 1
							for(j = index1A ; j <= index4A ; j+=1)
								weight1 = (index4A-j)/ numberPix1
								weight2 = 1 - weight1
								//weight1 = cos(modPi*((index3A-j)/ numberPix1-1))
								//weight2 = sqrt(1 - weight1*weight1)
								for(i = 0 ; i < totalNrPixE ; i+=1)
									help1 = FinalBlendKE[i][j]
									help2 = TemporaryHoldKE[i][j]
									help1b = FinalBlendKE2[i][j]
									help2b = TemporaryHoldKE2[i][j]
									if( help1!= 0 )
										if( help2!=0 )
											//weight1 = (index3A-j)/ numberPix1
											//weight2 = 1 - weight1
											FinalBlendKE[i][j] = help1*weight1 + help2*weight2
										else
											FinalBlendKE[i][j] = help1
										endif
									else
									 	if( help2!=0 )
											FinalBlendKE[i][j] = help2
										endif
									endif
									
									if( help1b!= 0 )
										if( help2b!=0 )
											//weight1 = (index3A-j)/ numberPix1
											//weight2 = 1 - weight1
											FinalBlendKE2[i][j] = help1b*weight1 + help2b*weight2
										else
											FinalBlendKE2[i][j] = help1b
										endif
									else
									 	if( help2b!=0 )
											FinalBlendKE2[i][j] = help2b
										endif
									endif
									
								endfor
							endfor			
						endif
					endif
				endif
				
				Variable j1,j2,j3 , k1,k2,k3
				Variable factor
				Make/FREE /N=(totalNrPixA)  v1

				progress = progress + 1
				ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
				DoUpdate /W=ProgressPanel
				
				Ra1 = Ra2
			endfor
			
			if(k>1)
				Lines[nrLines-1] = index4A
			else
				Lines[nrLines-1] = index3A
			endif
			//return 0
			//Setdatafolder root:Final_Blend
			Setdatafolder root:Final_Blends:$(win_name)
			Duplicate/O FinalBlendKE , FinalBlendBE
			Duplicate/O FinalBlendKE2 , FinalBlendBE2
			
			WAVE Amatrix=FinalBlendBE
			Variable Ymin,Ymax
			
			if(doFermi)
				Ymin=DimOffset( Amatrix,0 ) 
				Ymax=DimOffset( Amatrix , 0 ) + ( Dimsize(Amatrix , 0) - 1 ) * DimDelta( Amatrix , 0 )
				SetScale/I x,Ymin-KineticFermi,Ymax-KineticFermi, "" FinalBlendBE
				SetScale/I x,Ymin-KineticFermi,Ymax-KineticFermi, "" FinalBlendBE2
			else
				Ymin=DimOffset( Amatrix,0 ) 
				Ymax=DimOffset( Amatrix , 0 ) + ( Dimsize(Amatrix , 0) - 1 ) * DimDelta( Amatrix , 0 )
				SetScale/I x,Ymin-PhotonEnergy + WF,Ymax-PhotonEnergy + WF, "" FinalBlendBE	
				SetScale/I x,Ymin-PhotonEnergy + WF,Ymax-PhotonEnergy + WF, "" FinalBlendBE2	
			endif
			
			Duplicate/O FinalBlendBE, FinalBlendBE2dif
			Duplicate/O FinalBlendBE2, FinalBlendBE2dif_b
			
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
				
			Wave v1
			Make/FREE /N=(totalNrPixE)  v1 
			
			FinalBlendBE2dif = 0
			for(i = 0; i <totalNrPixA;i+=1)	// Initialize variables;continue test
				v1 =  FinalBlendBE[p][i]
				Differentiate/METH=0/EP=0 v1
				Differentiate/METH=0/EP=0 v1
				FinalBlendBE2dif[][i] = -v1[p]
			endfor
			Duplicate/O  FinalBlendBE2dif, FinalBlendBE2dif_a
			Duplicate/O  FinalBlendBE2dif, FinalBlendBE2dif_b
			KillWaves v1
			
			//Make/FREE /N=(totalNrPixA)  v1 
			//FinalBlendBE2dif_b = 0
			//for(i = 0; i <totalNrPixE;i+=1)	// Initialize variables;continue test
			//	v1 =  FinalBlendBE[i][p]
				//Smooth 1 , v1
			//	Differentiate/METH=0/EP=0 v1
				//Smooth 1 , v1
			//	Differentiate/METH=0/EP=0 v1
			//	FinalBlendBE2dif_b[i][] = -v1[q]
			//endfor
			//KillWaves v1
			help1 = nrLines - 1
			FinalBlendBE2dif_b = 0
			Variable helpT 
			for(i = 0; i <totalNrPixE;i+=1)
				for(k = 0 ; k < help1 ; k+=1)
					help2 = Lines[k]
					help3 = Lines[k+1]
					helpT = (help3 - help2 -1)
					if(helpT >0) 
						Make/FREE /N=(helpT)  v1
						v1 = FinalBlendBE2[i][p + help2 + 1]
						Differentiate/METH=0/EP=0 v1
						//v1[0] = v1[1]
						//v1[help3 - help2 -2] = v1[help3 - help2 - 3]
						Differentiate/METH=0/EP=0 v1
						v1[0] = v1[1]
						v1[help3 - help2 -2] = v1[help3 - help2 - 3]
						FinalBlendBE2dif_b[i][help2 + 1,help3 - 1] = -v1[q-help2]
						KillWaves v1
					endif
				endfor
			endfor
			
			//for(i = 0; i <totalNrPixA;i+=1)	// Initialize variables;continue test
			//	for(j = 0; j <totalNrPixE;j+=1)
			//		if(FinalBlendBE2dif_b[j][i] < 0)
			//			FinalBlendBE2dif_b[j][i] = 0
			//		endif
			//	endfor
			//endfor
			
			help1 = DimSize(Lines,0) - 1
			Wave v1
			Make/FREE /N=(totalNrPixE)  v1
			Make/FREE /N=(totalNrPixE)  v2
			Make/FREE /N=(totalNrPixE)  v3
			v1 =  FinalBlendBE2dif_b[p][1]
			FinalBlendBE2dif_b[][0] = v1[p]
			v1 =  FinalBlendBE2dif_b[p][totalNrPixA-2]
			FinalBlendBE2dif_b[][totalNrPixA-1] = v1[p]
			for(k = 1 ; k < help1 ; k+=1)
				v1 = FinalBlendBE2dif_b[p][Lines[k] -1]
				v3 = FinalBlendBE2dif_b[p][Lines[k]+1]
				v2 = (v1[p] + v3[p])/2
				FinalBlendBE2dif_b[][Lines[k]] = v3[p]
			endfor
			KillWaves v1,v2,v3
			
			Make/FREE /N=(totalNrPixA)  v1
			for(i = 0; i <totalNrPixE;i+=1)
				v1 = FinalBlendBE2dif_b[i][p]
				if(SF)
					Smooth SF, v1
				endif
				FinalBlendBE2dif_b[i][] = v1[q]
			endfor
			KillWaves v1
			
			for(i = 0; i <totalNrPixA;i+=1)	// Initialize variables;continue test
				for(j = 0; j <totalNrPixE;j+=1)
					if(FinalBlendBE2dif_b[j][i] < 0)
						FinalBlendBE2dif_b[j][i] = 0
					endif
				endfor
			endfor
			
			Duplicate/O  FinalBlendBE2dif_b, FinalBlendBE2dif_c
			//FinalBlendBE2dif_c = FinalBlendBE2dif/2 + FinalBlendBE2dif_b/2
			
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
			
			WAVE Amatrix = FinalBlendBE
			WAVE Amatrix2Dif = FinalBlendBE2dif
			WAVE Amatrix2Dif_b = FinalBlendBE2dif_b
			WAVE Amatrix2Dif_c = FinalBlendBE2dif_c
				
			NVAR PhotonEnergy
			NVAR WorkFunction
			PE = PhotonEnergy
			WF = WorkFunction
			Variable Xmin,Xmax
			
			Xmin=DimOffset(Amatrix,1) 
			Ymin=DimOffset(Amatrix,0) 
			Xmax=DimOffset(Amatrix,1) + (Dimsize(Amatrix,1)-1) *DimDelta(Amatrix,1)
			Ymax=DimOffset(Amatrix,0) + (Dimsize(Amatrix,0)-1) *DimDelta(Amatrix,0)
				
			Duplicate/O FinalBlendBE , KparFinalBlendBE
			Duplicate/O FinalBlendBE2dif , KparFinalBlendBE2dif
			KparFinalBlendBE = 0
			KparFinalBlendBE2dif = 0
			
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
			
			WAVE Kmatrix=KparFinalBlendBE
			WAVE Kmatrix2Dif=KparFinalBlendBE2dif
				
			for(i = 0; i <totalNrPixA;i+=1)	// Initialize variables;continue test
				for(j = 0; j <totalNrPixE;j+=1)
					if(FinalBlendBE2dif[j][i] < 0)
						FinalBlendBE2dif[j][i] = 0
					endif
				endfor
			endfor
			Duplicate/O  FinalBlendBE2dif, FinalBlendBE2dif_a
			
			FinalBlendBE2dif_c = FinalBlendBE2dif_a/2 + FinalBlendBE2dif_b/2
			
			//for(i = 0; i <totalNrPixA;i+=1)	// Initialize variables;continue test
			//	for(j = 0; j <totalNrPixE;j+=1)
			//		if(FinalBlendBE2dif_b[j][i] < 0)
			//			FinalBlendBE2dif_b[j][i] = 0
			//		endif
			//	endfor
			//endfor
			
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel	
			
			FactorA = 4
			Redimension/N=(-1,Dimsize(Amatrix,1) * FactorA) Kmatrix
			Redimension/N=(-1,Dimsize(Amatrix,1) * FactorA) Kmatrix2Dif
			
			Variable YL=SelectNumber(sign(Xmin)==+1,Ymax,Ymin)
			Variable YR=SelectNumber(sign(Xmax)==+1,Ymin,Ymax)
			
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
				
			Setscale/I y,0.512*sqrt(PE-WF+YL)*sin(Xmin*Pi/180),0.512*sqrt(PE-WF+YR)*sin(Xmax*Pi/180),"" Kmatrix
			//Kmatrix=(y>0.512*sqrt(PE-WF+x)*sin(Xmax*Pi/180) || y<0.512*sqrt(PE-WF+x)*sin(Xmin*Pi/180)) ? Nan : Amatrix(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
			
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
				
			SetScale/I y,0.512*sqrt(PE-WF+YL)*sin(Xmin*Pi/180),0.512*sqrt(PE-WF+YR)*sin(Xmax*Pi/180),"" Kmatrix2Dif
			//KmatrixDif=(y>0.512*sqrt(PE-WF+x)*sin(Xmax*Pi/180) || y<0.512*sqrt(PE-WF+x)*sin(Xmin*Pi/180)) ? Nan : AmatrixDif(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
			
			Duplicate/O Kmatrix2Dif , KparFinalBlendBE2dif_a
			Duplicate/O Kmatrix2Dif , KparFinalBlendBE2dif_b
			Duplicate/O Kmatrix2Dif , KparFinalBlendBE2dif_c
			WAVE Kmatrix2Dif_b=KparFinalBlendBE2dif_b
			WAVE Kmatrix2Dif_c=KparFinalBlendBE2dif_c
			
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
			
			Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
			Variable delta_k_n , delta_k_m , delta_phi , delta_theta
			Variable k_n0 , k_m0 , phi0 , theta0
			Variable phi1 , phi2 , theta1 , theta2
			Variable i_n , j_m 
			Variable n_max , m_max
			Variable i_max , j_max
			Variable i_1 , i_2 , j_1 , j_2
			Variable wL , wR , wU , wD 
			Variable o , o_max , E_o0 , delta_E , E_o
						
			Variable C1,C2
			//C1 = 1/(0.512*sqrt(Energy))
			C2 = 180/Pi
						
			n_max = DimSize (Kmatrix,1)
			m_max = DimSize (Kmatrix,1)
			o_max = DimSize (Kmatrix,0)
						
			k_n0 = DimOffset (Kmatrix,1)
			k_m0 = DimOffset (Kmatrix,1)
			E_o0 = DimOffset (Kmatrix,0)
						
			delta_k_n = DimDelta (Kmatrix,1)
			delta_k_m = DimDelta (Kmatrix,1)
			delta_E = DimDelta (Kmatrix,0)
						
			i_max = DimSize (Amatrix,1) - 1
			j_max = DimSize (Amatrix,1) - 1
						
			phi0 = DimOffset (Amatrix,1)
			theta0 = DimOffset (Amatrix,1)
			theta0 = 0
						
			delta_phi = DimDelta (Amatrix,1)
			delta_theta = DimDelta (Amatrix,1)
						
			k_n = k_n0
			k_m = 0
			E_o = PE-WF+E_o0
						
			for(o=0;o<o_max;o=o+1)
				C1 = 1/(0.512*sqrt(E_o))
				for( n=0;n<n_max;n=n+1)
					phi_n_rad = asin( k_n * C1 )
					phi_n = phi_n_rad * C2
					i_n = (phi_n - phi0)/delta_phi
					if(i_n>=0 && i_n<=i_max)
						//for( m=0;m<m_max;m=m+1)
						theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
						j_m = (theta_m - theta0)/delta_theta
						if(j_m>=0 && j_m<=j_max)
							i_1 = round(i_n)	
							//i_1 = floor(i_n)
							//i_2 = ceil(i_n)
							//j_1 = floor(j_m)
							//j_2 = ceil(j_m)
							//wR = i_n - i_1
							//wL = 1 - wR
							//wU = j_m - j_1
							//wD = 1 - wU
							Kmatrix[o][n] = Amatrix[o][i_1]  //*wL*wD + Amatrix[o][i_2]*wR*wD + Amatrix[o][i_1]*wL*wU + Amatrix[o][i_2]*wR*wU
						else
							Kmatrix[o][n] = Nan
						endif
						//k_m = k_m + delta_k_m
						//endfor
					else
						Kmatrix[o][n] = Nan
					endif
					//k_m = k_m0
					k_n = k_n + delta_k_n
				endfor
				k_n = k_n0
				E_o = E_o + delta_E
			endfor
			
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
				
			k_n = k_n0
			k_m = 0
			E_o = PE-WF+E_o0
			
			for(o=0;o<o_max;o=o+1)
				C1 = 1/(0.512*sqrt(E_o))
				for( n=0;n<n_max;n=n+1)
					phi_n_rad = asin( k_n * C1 )
					phi_n = phi_n_rad * C2
					i_n = (phi_n - phi0)/delta_phi
					if(i_n>=0 && i_n<=i_max)
						//for( m=0;m<m_max;m=m+1)
						theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
						j_m = (theta_m - theta0)/delta_theta
						if(j_m>=0 && j_m<=j_max)	
							i_1 = round(i_n)
							//i_1 = floor(i_n)
							//i_2 = ceil(i_n)
							//j_1 = floor(j_m)
							//j_2 = ceil(j_m)
							//wR = i_n - i_1
							//wL = 1 - wR
							//wU = j_m - j_1
							//wD = 1 - wU
							Kmatrix2Dif[o][n] = Amatrix2Dif[o][i_1] //*wL*wD + Amatrix2Dif[o][i_2]*wR*wD + Amatrix2Dif[o][i_1]*wL*wU + Amatrix2Dif[o][i_2]*wR*wU
							Kmatrix2Dif_b[o][n] = Amatrix2Dif_b[o][i_1]
							Kmatrix2Dif_c[o][n] = Amatrix2Dif_c[o][i_1]
						else
							Kmatrix2Dif[o][n] = Nan
							Kmatrix2Dif_b[o][n] = Nan
							Kmatrix2Dif_c[o][n] = Nan
						endif
						//k_m = k_m + delta_k_m
						//endfor
					else
						Kmatrix2Dif[o][n] = Nan
						Kmatrix2Dif_b[o][n] = Nan
						Kmatrix2Dif_c[o][n] = Nan
					endif
					//k_m = k_m0
					k_n = k_n + delta_k_n
				endfor
				k_n = k_n0
				E_o = E_o + delta_E
			endfor
			
			KparFinalBlendBE2dif_a = Kmatrix2Dif
			
			progress = progress + 1
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
			
			Duplicate/O FinalBlendBE, FinalBlendBE1
			Duplicate/O KparFinalBlendBE, KparFinalBlendBE1
			
			Duplicate/O FinalBlendBE2dif, FinalBlendBE2dif1			
			Duplicate/O KparFinalBlendBE2dif, KparFinalBlendBE2dif1
			
			ValDisplay valdisp0,value= _NUM:progress,win=ProgressPanel
			DoUpdate /W=ProgressPanel
			KillWindow ProgressPanel
			
			Display/W=(18,58,560,540) /N=$win_name /K=0
			//Dowindow/C $"Final_Blend"
			AppendImage FinalBlendBE
			//ModifyGraph lblMargin(left)=3
			//ModifyGraph axOffset(left)=-1.42857
			ModifyGraph  swapXY=1
			ModifyGraph margin =40
			ModifyGraph margin(right) =20
			ModifyGraph margin(top) =20
			
			SetVariable SetMarginUp,pos={555,5},size={110,20},proc=SetMargin,title="Upper \rMargin"
			SetVariable SetMarginUp,fSize=14,limits={0,inf,1},value= _NUM:20
			
			ModifyGraph manTick(bottom)={0,5,0,1},manMinor(bottom)={1,5}
			ModifyGraph tick(bottom)=2,mirror(bottom)=1
			ModifyGraph manTick(left)={0,1,0,0},manMinor(left)={1,2}
			ModifyGraph tick(left)=2,mirror(left)=1
			
			ModifyGraph grid(bottom)=1,gridRGB(bottom)=(0,0,0)
			ModifyGraph grid(left)=1,gridRGB(left)=(0,0,0)
			
			Controlbar 100
			ControlBar /L 100
			Button change_toKbutton,pos={5,110},size={80,40},proc=change_toK,title="Change to\rk Parallel" , anchor=MC
			
			Button derivative,pos={5,155},size={80,40},proc=displayDer,title="Change to\r 2nd Derivative"
			
			//Button Recalculate,pos={5,230},size={80,40},proc=recalculateA,title="Recalculate" , disable=2
			Button ShowM,pos={5,230},size={80,40},proc=ShowMultiple,title="ReInsert"
			
			//Button removedefects,pos={5,275},size={80,40},proc=RemoveDefects,title="Remove\r defects" , disable=2
			
			Button changeE , pos={5,350} , size={80,35} , proc=ChangeEmissions , title="Change\rEmissons"
			ValDisplay AngleShift  , pos={10,390} , size={60,35} , value= _NUM: 0 , disable=2
			
			Button buttonDisplayExtract,pos={5,450},size={80,39},proc=DisplayExtractPanel2,title="Display\r& Extract" , disable=2
			Button buttonDisplayExtract,fSize=13
			
			Wavestats/Q/Z FinalBlendBE
			Variable/G varMin = V_Min
			Variable/G varMax = V_max
			
			TitleBox zminimo title="zMin ",pos={5,25}
			
			Slider contrastmin,vert= 0,pos={41,27},size={290,16},proc=contrast
			Slider contrastmin,limits={V_min,V_max,0},variable=varMin,ticks= 0
			
			TitleBox zmax title="zMax",pos={5,3}
			
			Slider contrastmax,vert= 0,pos={41,7},size={290,16},proc=contrast
			Slider contrastmax,limits={V_min,V_max,0},variable=varMax,ticks= 0
			
			Button profiles,pos={300,50},size={60,40},proc=Profiles1,title="Profiles"
			
			Button ExportImage,pos={230,50},size={60,40},proc=ExportImages,title="Export\r Image"
			
			Button InverseImage,pos={115,50},size={30,20},proc=InverseImages,title="Inv"
			
			Button Reset,pos={480,40},size={60,20},proc=ResetScale,title="Reset" ,fSize=16
			
			SetVariable gamma1,pos={10,50},size={100,20},proc=GammaImage2,title="Gamma"
			SetVariable gamma1,labelBack=(43520,43520,43520),fSize=14
			SetVariable gamma1,limits={-inf,inf,0.1},value= _NUM:1
			
			String listColors 
			listColors = CTabList()
			PopupMenu popup0,pos={10,75},size={40,20},proc=ChangeColor2
			//PopupMenu popup0,mode=1,popvalue="Grays",value= #"\"Grays;VioletOrangeYellow\""
			PopupMenu popup0,mode=1,popvalue="Grays",value= "*COLORTABLEPOP*"
			PopupMenu popup0,size={40,20}
				
			SetVariable SetLeftUpper,pos={355,5},size={110,20},proc=SetAllAxis,title="Upper"
			SetVariable SetLeftUpper,fSize=14,limits={-inf,inf,0.01},value= _NUM:Ymax
			
			SetVariable SetLeftLower,pos={355,30},size={110,20},proc=SetAllAxis,title="Lower"
			SetVariable SetLeftLower,fSize=14,limits={-inf,inf,0.01},value= _NUM:Ymin
			
			SetVariable SetBottomLeft,pos={365,70},size={100,20},proc=SetAllAxis,title="Left"
			SetVariable SetBottomLeft,fSize=14,limits={-inf,inf,0.01},value= _NUM:Xmin
			
			SetVariable SetBottomRight,pos={475,70},size={100,20},proc=SetAllAxis,title="Right"
			SetVariable SetBottomRight,fSize=14,limits={-inf,inf,0.01},value= _NUM:Xmax
			
			CheckBox check2,pos={480,5},size={104,16},title="Tools"
			CheckBox check2,labelBack=(47872,47872,47872),fSize=16,value= 0
			CheckBox check2,proc=ShowTools1
			
			CheckBox check1 title="Grid",pos={152,50},size={50,20},proc=CheckProc_Grid,value=1,labelBack=(52224,52224,52224)
			
			//CheckBox check3 title="A/E Diff.",pos={5,200},size={50,20},proc=CheckProc_AE,value=0
			
			PopupMenu popup1,pos={5,200},size={100,30},proc=PopupProc_AE
			//PopupMenu popup0,mode=1,popvalue="Grays",value= #"\"Grays;VioletOrangeYellow\""
			PopupMenu popup1,mode=1,popvalue="dI/dE",value= #"\"dI/dE;dI/dA;dI/dE+dI/dA\"",disable=2
			
			Variable /G LeftUpper = Ymax
			Variable /G LeftLower = Ymin
			Variable /G BottomLeft = Xmin
			Variable /G BottomRight = Xmax
			//FinalBlendKE = FinalBlendKE1
			DoWindow/F Multiple_Panel					//pulls the window to the front
			if(V_flag != 0)	
				STRUCT WMButtonAction ba2
				ba2.eventCode = 2
				ButtonProc_RemoveAll(ba2)
			endif
			
			DoWindow/F $win_name
			
		break
	endswitch

	return 0
End



Function GammaImage(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			String name1, name2
			Setdatafolder root:Final_Blend:
				
			name2 = ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			
			name1 = name2 + num2istr(1)
			Duplicate/O $(name2 + num2istr(1)), $name2 
			
			WAVE Image = $name2
			Image = Image^dval
			
			Wavestats/Q/Z $name2
			Slider contrastmin,limits={V_min,V_max,0}
			Slider contrastmax,limits={V_min,V_max,0}
			
			NVAR varMin,varMax
			if(varMin < varMax)
				varMin  = V_min
				varMax = V_max
			else
				varMin  = V_max
				varMax = V_min
			endif	
			//varMin  = V_min
			//varMax = V_max
			ModifyImage $name2, ctab= {varMIN,varMAX,,0}	
			break
	endswitch

	return 0
End

Function GammaImage2(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			String name1, name2
			Setdatafolder root:Final_Blends:$sva.win
			WAVE FinalBlendBE2dif
			WAVE KparFinalBlendBE2dif
			
			WAVE FinalBlendBE2dif_a
			WAVE FinalBlendBE2dif_b
			WAVE FinalBlendBE2dif_c
			WAVE KparFinalBlendBE2dif_a
			WAVE KparFinalBlendBE2dif_b
			WAVE KparFinalBlendBE2dif_c
			Variable help1
			
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			
			
			strswitch(name1)
				case "FinalBlendBE":
					name2 = ImageNameList("", "" )
					name2 = StringFromList (0, name2  , ";")
			
					name1 = name2 + num2istr(1)
					Duplicate/O $(name2 + num2istr(1)), $name2 
			
					WAVE Image = $name2
					Image = Image^dval
					
					Wavestats/Q/Z $name2
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					
					NVAR varMin,varMax
					if(varMin < varMax)
						varMin  = V_min
						varMax = V_max
					else
						varMin  = V_max
						varMax = V_min
					endif	
					//varMin  = V_min
					//varMax = V_max
					ModifyImage $name2, ctab= {varMIN,varMAX,,0}	
					DoUpdate 
					break
				case "ImageLRmK":
					break
				case "FinalBlendBE2dif":
					ControlInfo popup1
					help1 = V_Value
					switch(help1)
						case 1:
							name2 = ImageNameList("", "" )
							name2 = StringFromList (0, name2  , ";")
			
							Duplicate/O $(name2 + "_a"), $name2 
				
							WAVE Image = $name2
							Image = Image^dval
							
							Wavestats/Q/Z $name2
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							//varMin  = V_min
							//varMax = V_max
							ModifyImage $name2, ctab= {varMIN,varMAX,,0}	
							DoUpdate
							break
						case 2:
							name2 = ImageNameList("", "" )
							name2 = StringFromList (0, name2  , ";")
			
							Duplicate/O $(name2 + "_b"), $name2
				
							WAVE Image = $name2
							Image = Image^dval
							
							Wavestats/Q/Z $name2
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							//varMin  = V_min
							//varMax = V_max
							ModifyImage $name2, ctab= {varMIN,varMAX,,0}	
							DoUpdate
							break
						case 3:
							name2 = ImageNameList("", "" )
							name2 = StringFromList (0, name2  , ";")
			
							Duplicate/O $(name2 + "_c"), $name2
				
							WAVE Image = $name2
							Image = Image^dval
							
							Wavestats/Q/Z $name2
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							//varMin  = V_min
							//varMax = V_max
							ModifyImage $name2, ctab= {varMIN,varMAX,,0}	
							DoUpdate
							break
						break
					endswitch
					DoUpdate 
					break
				case "KparFinalBlendBE":
					name2 = ImageNameList("", "" )
					name2 = StringFromList (0, name2  , ";")
			
					name1 = name2 + num2istr(1)
					Duplicate/O $(name2 + num2istr(1)), $name2 
			
					WAVE Image = $name2
					Image = Image^dval
					
					Wavestats/Q/Z $name2
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					
					NVAR varMin,varMax
					if(varMin < varMax)
						varMin  = V_min
						varMax = V_max
					else
						varMin  = V_max
						varMax = V_min
					endif	
					//varMin  = V_min
					//varMax = V_max
					ModifyImage $name2, ctab= {varMIN,varMAX,,0}	
					DoUpdate 
					break
				case "KparFinalBlendBE2dif":
					ControlInfo popup1
					help1 = V_Value
					switch(help1)
						case 1:
							name2 = ImageNameList("", "" )
							name2 = StringFromList (0, name2  , ";")
			
							Duplicate/O $(name2 + "_a"), $name2 
				
							WAVE Image = $name2
							Image = Image^dval
							
							Wavestats/Q/Z $name2
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							//varMin  = V_min
							//varMax = V_max
							ModifyImage $name2, ctab= {varMIN,varMAX,,0}	
							DoUpdate
							break
						case 2:
							name2 = ImageNameList("", "" )
							name2 = StringFromList (0, name2  , ";")
			
							Duplicate/O $(name2 + "_b"), $name2 
				
							WAVE Image = $name2
							Image = Image^dval
							
							Wavestats/Q/Z $name2
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							//varMin  = V_min
							//varMax = V_max
							ModifyImage $name2, ctab= {varMIN,varMAX,,0}	
							DoUpdate
							break
						case 3:
							name2 = ImageNameList("", "" )
							name2 = StringFromList (0, name2  , ";")
			
							Duplicate/O $(name2 + "_c"), $name2 
				
							WAVE Image = $name2
							Image = Image^dval
							
							Wavestats/Q/Z $name2
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							//varMin  = V_min
							//varMax = V_max
							ModifyImage $name2, ctab= {varMIN,varMAX,,0}	
							DoUpdate
							break
						break
					endswitch
					DoUpdate 
					break
			endswitch
			
		break
				
	endswitch

	return 0
End


Function ButtonProc_Blend1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			WAVE ijmin = root:Specs:ijmin
			WAVE dividers =  root:Specs:dividers
			Variable counter1,counter2
			SVAR list_graphs = root:Specs:list_graphs
			WAVE/T list_names = root:Specs:list_names
			STRUCT file_header fh 
			STRING name1, name2
			Variable i , imax, jmax
			
			counter1 	=	ItemsInList(list_graphs)
			//here checking if all images have the same number of pixels ... in x and y directions ... will not work if they have different
			name1 = "root:Specs:" + ReplaceString(".xy", List_names[0], "") + ":header"
			StructGet /B=0 fh, $name1
			jmax  = fh.nCurves
			imax  = fh.nValues
			for(i = 1 ; i < counter1 ; i+=1)
				name1 = "root:Specs:" + ReplaceString(".xy", List_names[i], "") + ":header"
				StructGet /B=0 fh, $name1
				if( (imax != fh.nValues) && (jmax != fh.nCurves))
					break
				endif
			endfor
			
			//building 2 matrices for storing the results of following calculations
			WAVE All2Blend
			MAKE /O /N = (imax, jmax, counter1) All2Blend
			WAVE AllDif2Blend
			MAKE /O /N = (imax, jmax, counter1) AllDif2Blend
			
			//writing values to the matrices from the data files
			for(i = 0 ; i < counter1 ; i+=1)
				name1 = "root:Specs:" + ReplaceString(".xy", List_names[i], "") + ":Angle_dif_2D_smoothed"
				name2 = "root:Specs:" + ReplaceString(".xy", List_names[i], "") + ":Angle_2D_smoothed"
				WAVE v1 = $name1 		//
				WAVE v2 = $name2
				AllDif2Blend[][][i] = v1[p][q]
				All2Blend[][][i] = v2[p][q]
			endfor
			
			WAVE test
			Duplicate/O v1, test
			
			Variable k, j 
			Variable jmax1 = jmax // here value determines where to stop horizontal shift for checking the minimum
			
			NVAR shift1 = root:Specs:shift1
			Variable shift2 , shift3
			Variable  j1, j2, i1,i2
			Variable sum1
			Variable n,m
			Variable max1
			Variable help1,help2,help3 ,help4,help5, help6,help7,help8
			Variable imin, jmin
			String name3,name4
			
			//shift1 is the value of shifts in vertical direction both up and down separatelly
			shift1 = 20
			shift2 = shift1 * 2
			shift3 = shift2 + 1
			
			
			if(WaveExists(Matrix) == 1)
				KillWaves Matrix
			endif  
			//building the matrix which keeps the image of the shifts and subtractions
			Make /O/N=(shift3,jmax1) Matrix
			
			counter2 	=	ItemsInList(list_graphs)
			counter2 	= 	counter2 -1
			
			//here is the lookup for the position of the minimum, works ok
			//tutaj mozna jeszcze ulepszyc dzialanie tej petli, poprzez sprawdzanie w ktorym kierunku pojawia sie minimum i kiedy przewac 
			//dzialanie ..... mozna usprawnic dzialanie tak ze bedzie ta petla skrocona o wiele
			for(k = 0; k< counter2  ; k += 1)
				help6 = 100000
				name1 = "root:Specs:" + ReplaceString(".xy", List_names[k], "")
				name2 = "root:Specs:" + ReplaceString(".xy", List_names[(k + 1)], "")
				name3 = name1 + ":Angle_dif_2D_smoothed"
				name4 = name2 + ":Angle_dif_2D_smoothed"
				
				WAVE L_image_dif = $name3
				WAVE R_image_dif = $name4
				
				for(j = 0; j <jmax1;j+=1)
					help8 = j + 1 - jmax
					for(i = 0; i <shift3;i+=1)
						sum1 = 0
						counter1= 0
						help1 = imax - abs ( shift1 - i ) 
						help2 = i - shift1
						if(i < shift1)
							for ( j1 = jmax - j - 1; j1<jmax ; j1+=1)
								j2 = j1 + help8
								//j2 = j1 - jmax + 1 + j
								//help1 = imax - abs ( shift1 - i ) 
								//help2 = i - shift1
								for(i1 = 0 ; i1 < help1; i1 +=1)
									i2 = i1 - help2
									help4 = L_image_dif[i1][j1]
									help5 = R_image_dif[i2][j2]
									sum1 = sum1 + abs(help4 - help5)
									counter1 += 1
								endfor
							endfor
						else
							for ( j1 = jmax - j - 1; j1<jmax ; j1+=1)
								j2 = j1 + help8
								//j2 = j1 - jmax + 1 + j
								//help1 = imax - abs ( shift1 - i ) 
								//help2 = i - shift1
								for(i2 = 0 ; i2 < help1; i2 +=1)
									i1 = i2 + help2
									help4 = L_image_dif[i1][j1]
									help5 = R_image_dif[i2][j2]
									sum1 = sum1 + abs(help4 - help5)
									counter1 += 1
								endfor	
							endfor	
						endif
						help7 = sum1/counter1
						if(  help7 < help6 )
							help6 = help7
							imin = i
							jmin = j
						endif
						help7 = sum1/counter1
						Matrix[i][j] = sum1/counter1	
					endfor
				endfor
				ijmin[k][0] = imin
				ijmin[k][1] = jmin
			endfor
			
			KillWaves Matrix
			
			Variable divide1
			Variable counter3
			Variable w
			
			counter3    = counter2 + 1
			for(i = 0 ; i < counter2; i+= 1)
				dividers[i] = 0
			endfor
			
			//here the dividers are found , which will "equalize" the images
			for(k = 0; k< counter2  ; k += 1)
				name1 = "root:Specs:" + ReplaceString(".xy", List_names[k], "")
				name2 = "root:Specs:" + ReplaceString(".xy", List_names[(k + 1)], "")
				name3 = name1 + ":Angle_2D_smoothed"
				name4 = name2 + ":Angle_2D_smoothed"
				WAVE L_image = $name3
				WAVE R_image = $name4
				
				i = ijmin[k][0]
				j = ijmin[k][1]
				divide1 = 0
				counter1= 0
				//this loop is calculating the average dividers
				for ( j1 = jmax - j - 1; j1<jmax ; j1+=1)
					j2 = j1 - jmax + 1 + j
					help1 = imax - abs ( shift1 - i ) 
					help2 = i - shift1
					if(i < shift1)
						for(i1 = 0 ; i1 < help1; i1 +=1)
							i2 = i1 - help2
							help4 = L_image[i1][j1]
							help5 = R_image[i2][j2]
							divide1 = help4/help5
							dividers[k] = dividers[k] + divide1
							counter1 += 1
						endfor
					else
						for(i2 = 0 ; i2 < help1; i2 +=1)
							i1 = i2 + help2
							help4 = L_image[i1][j1]
							help5 = R_image[i2][j2]
							divide1 = help4/help5
							dividers[k] = dividers[k] + divide1
							counter1 += 1
						endfor	
					endif	
				endfor
				dividers[k] = dividers[k]/counter1
			endfor
			
			//test[][] = All2Blend[p][q][0]
			//test[][] = All2Blend[p][q][1]
			//test[][] = All2Blend[p][q][2]
			//test[][] = All2Blend[p][q][3]
			
			Variable divider = 1
			for( i = 0 ; i <counter2;i+=1)
				divider = divider *dividers[i]
				All2Blend[][][(i + 1)] =  divider * All2Blend[p][q][(i + 1)]
			endfor
			
			test[][] = All2Blend[p][q][0]
			test[][] = All2Blend[p][q][1]
			test[][] = All2Blend[p][q][2]
			//test[][] = All2Blend[p][q][3]
			
			Variable k2  
			
			//here the images are corrected to match with adjacent images
			for(k = 0; k< counter2  ; k += 1)
				k2 = k + 1
				j = ijmin[k][1]
				i = ijmin[k][0]
				divide1 = 0
				counter1= 0
				//this loop is setting the ratio of the values in common area
				for ( j1 = jmax - j - 1; j1<jmax ; j1+=1)
					j2 = j1 - jmax + 1 + j
					help1 = imax - abs ( shift1 - i ) 
					help2 = i - shift1
					help7 = j2 / j
					help6 = 1 - help7
					if(i < shift1)
						for(i1 = 0 ; i1 < help1; i1 +=1)
							i2 = i1 - help2
							help4 = All2Blend[i1][j1][k]
							help5 = All2Blend[i2][j2][k2]
							All2Blend[i2][j2][k2] = help4 * help6 + help5 * help7
						endfor
					else
						for(i2 = 0 ; i2 < help1; i2 +=1)
							i1 = i2 + help2
							help4 = All2Blend[i1][j1][k]
							help5 = All2Blend[i2][j2][k2]
							All2Blend[i2][j2][k2] = help4 * help6 + help5 * help7
						endfor	
					endif	
				endfor
			endfor
			
			test[][] = All2Blend[p][q][0]
			test[][] = All2Blend[p][q][1]
			test[][] = All2Blend[p][q][2]
			//test[][] = All2Blend[p][q][3]
			
			//here look for the dimensions of the new image
			Variable wayx, up, down
			up = 0
			down = 0
			wayx = 0
			for(k = 0; k< counter2  ; k += 1)
				wayx = wayx - shift1 + ijmin[k][0] //change1
				if(wayx > up)
					up = wayx
				endif	
				if(wayx < down)
					down = wayx
				endif	
			endfor
			
			Variable xmax , ymax
			xmax = imax + up - down
			ymax = counter3 * jmax
			
			for(k = 0; k< counter2  ; k += 1)
				ymax = ymax - ijmin[k][1] -1
			endfor
			
			//Wave/T W_WaveList
			//GetWindow $"Multiple_Panel#Final" wavelist
			//name1 = W_WaveList[0][0]
			//if( cmpstr(name1, "") != 0 )
			//	RemoveImage /W=$"Multiple_Panel#Final" FinalBlend
			//endif
			
			if(WaveExists(FinalBlend) == 1)
				KillWaves FinalBlend
			endif  
			if(WaveExists(FinalBlendDif2) == 1)
				KillWaves FinalBlendDif2
			endif  
			Make /O /N = (xmax, ymax) FinalBlend
			Make /O /N = (xmax, ymax) FinalBlendDif2
			i1 = -down
			j1 = 0
			
			//here building new image
			for(k = 0; k< counter3  ; k += 1)
				i2 = i1 + imax
				j2 = j1 + jmax
				
				for( i = i1 ; i < i2 ; i += 1)	
					for( j = j1 ; j < j2 ; j += 1)	
						FinalBlend[i][j] = All2Blend[(i-i1)][(j-j1)][k]	
					endfor
				endfor
				i1 = i1 - shift1 + ijmin[k][0]
				j1 = j1 + jmax - ijmin[k][1] - 1
			endfor
			
			//Wave/T W_WaveList
			GetWindow $"Multiple_Panel#Final"   active
			GetWindow $"Multiple_Panel#Final"activeSW 
			GetWindow $"Multiple_Panel#Final" wavelist
			//name1 = W_WaveList[0][0]
			//if( cmpstr(name1, "") != 0 )
			//	RemoveImage /W=$"Multiple_Panel#Final" FinalBlend
			//endif
			AppendImage /W=$"Multiple_Panel#Final" FinalBlend
			ModifyGraph  /W=$"Multiple_Panel#Final" swapXY=1
			//Display/W=(50,270,1350,620)/HOST=Multiple_Panel
			//ModifyGraph margin=-1
			//RenameWindow #, $"Final"
			//SetActiveSubwindow ##
			
			Make/O/N =(imax)  v1 
			Wave/D v1
			Wave/D v2
			Duplicate/O/O v1,v2
			Variable Smoothing1, smoothing2
			
			for(k = 0 ; k< counter3 ; k+=1)
				//smoothing1 = str2num (listWave[row][2])
				//smoothing2 = str2num (listWave[row][3])
				for(j = 0; j <jmax;j+=1)	// Initialize variables;continue test
					v1 =  All2Blend[p][j][k]
					v2 = v1
					Differentiate v2
					//AllDif2Blend[][j][k] = v2[p]
					//if(smoothing2 > 0)
					//Smooth smoothing2 , v2
					//endif
					//Angle_dif_2D_smoothed[][i] = v2[p]
					Differentiate v2
					AllDif2Blend[][j][k]  = v2[p]
				endfor
			endfor
			KillWaves v2,v1
			SetDataFolder root:Specs:
			
			i1 = -down
			j1 = 0
			
			//here building new diff image
			for(k = 0; k< counter3  ; k += 1)
				i2 = i1 + imax
				j2 = j1 + jmax
				
				for( i = i1 ; i < i2 ; i += 1)	
					for( j = j1 ; j < j2 ; j += 1)	
						FinalBlendDif2[i][j] = AllDif2Blend[(i-i1)][(j-j1)][k]
					endfor
				endfor
				i1 = i1 - shift1 + ijmin[k][0]
				j1 = j1 + jmax - ijmin[k][1] - 1
			endfor
			
			
			break
	endswitch

	return 0
End

Function ButtonProc_Display(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Wave /T W_WaveList
			String name1
			Variable number
			
			SetActiveSubwindow $"Multiple_Panel#Final"
			GetWindow $"Multiple_Panel#Final" wavelist
			number = WaveExists(W_WaveList)
			//if(number == 0 )
			//	number = 1
			//else
			GetWindow $"Multiple_Panel#Final" wavelist
			name1 = W_WaveList[0][0]
			number = exists(name1)
			//endif
			
			if( number != 0 )
				RemoveImage /W=$"Multiple_Panel#Final" $name1
			endif
			number = cmpstr (name1 , "FinalBlend")
			
			if( number == 0 )
				AppendImage /W=$"Multiple_Panel#Final" FinalBlendDif2
				ModifyGraph swapXY=1
				ModifyImage FinalBlendDif2 ctab= {*,*,Grays,1}
				ModifyImage FinalBlendDif2 ctab= {*,*,BrownViolet,1}
				Button button4,title="Display Image"
			else
				AppendImage /W=$"Multiple_Panel#Final" FinalBlend
				ModifyGraph  /W=$"Multiple_Panel#Final" swapXY=1
				Button button4,title="Display 2nd Derivative"
			endif
			
			//KillWaves W_WaveList
			break
	endswitch

	return 0
End

static Function getNoteTiTime(wv,tiTime)
	Wave wv
	Variable &tiTime
	
	string value
	value = "total_integration_time"
	string myNote,val
	myNote = note(wv)
	val = StringByKey(value,myNote,":","\r")
	sscanf  val, "%f", tiTime 
end

static Function getNoteEvalues(wv,Lower, Higher)
	Wave wv
	Variable &Lower, &Higher
	
	string value
	value =  "ERange"
	string myNote,val
	myNote = note(wv)
	val = StringByKey(value,myNote,":","\r")
	sscanf  val, "%f %f", Lower , Higher
end

static Function getNoteAvalues(wv,Lower, Higher)
	Wave wv
	Variable &Lower, &Higher
	
	string value
	value = "aRange"
	string myNote,val
	myNote = note(wv)
	val = StringByKey(value,myNote,":","\r")
	sscanf  val, "%f %f", Lower , Higher
end

static Function changeNoteAvalues(wv,Lower, Higher)
	Wave &wv
	Variable Lower, Higher
	
	string value
	string newvalues
	
	newvalues = num2str(Lower) + " " + num2str(Higher)
	value = "aRange"
	string myNote,val
	myNote = note(wv)
	
	myNote = ReplaceStringByKey(value, myNote,newvalues, ":","\r")
	Note/K wv, myNote
end

Function change_toK(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up

			Setdatafolder root:Final_Blends:$ba.win
			SetVariable gamma1,value= _NUM:1
			
			Duplicate/O/O FinalBlendBE1, FinalBlendBE
			Duplicate/O/O KparFinalBlendBE1, KparFinalBlendBE
			Duplicate/O/O FinalBlendBE2dif1, FinalBlendBE2dif		
			Duplicate/O/O KparFinalBlendBE2dif1, KparFinalBlendBE2dif
			
			String name1 , name2
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			NVAR varMin 
			NVAR varMax
			
			NVAR LeftUpper 
			NVAR  LeftLower 
			NVAR  BottomLeft 
			NVAR  BottomRight
			
			strswitch(name1)
				case "FinalBlendBE":
					//PopupMenu popup0,popvalue="Grays"
					RemoveImage $name1
					AppendImage KparFinalBlendBE
					ModifyGraph  swapXY=1
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					
					ModifyGraph manTick(bottom)={0,0.2,0,1},manMinor(bottom)={1,2}
					ModifyGraph tick(bottom)=2,mirror(bottom)=1
					ModifyGraph manTick(left)={0,1,0,0},manMinor(left)={1,2}
					ModifyGraph tick(left)=2,mirror(left)=1
					
					ModifyGraph grid(bottom)=1,gridRGB(bottom)=(0,0,0)
					ModifyGraph grid(left)=1,gridRGB(left)=(0,0,0)
					
					Button change_toKbutton, title="Change to\rAngles"
					
					Wavestats/Q/Z KparFinalBlendBE
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					
					Controlinfo  popup0
					name2 = S_value
					ModifyImage KparFinalBlendBE, ctab= {V_min,V_max,$name2,0}
					
					varMin  = V_min
					varMax = V_max
					DoUpdate 
					GetAxis left
					
					LeftUpper = V_max
					LeftLower = V_min
					
					SetVariable SetLeftUpper,value= _NUM:LeftUpper
					SetVariable SetLeftLower,value= _NUM:LeftLower
					GetAxis bottom
					
					BottomLeft = V_min
					BottomRight = V_max
					
					SetVariable SetBottomLeft,value= _NUM:BottomLeft
					SetVariable SetBottomRight,value= _NUM:BottomRight
					
					DoWindow/HIDE=? Profiles_FinalBlend						//pulls the window to the front
					If(V_flag != 0)									//checks if there is a window....
						Button shiftA, disable=2 , win=Profiles_FinalBlend
					endif
			
					DoUpdate 
					break
				case "ImageLRmK":
					break
				case "FinalBlendBE2dif":
					//PopupMenu popup0,popvalue="Grays"
					RemoveImage $name1
					AppendImage KparFinalBlendBE2dif
					ModifyGraph swapXY=1
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					
					ModifyGraph manTick(bottom)={0,0.2,0,1},manMinor(bottom)={1,2}
					ModifyGraph tick(bottom)=2,mirror(bottom)=1
					ModifyGraph manTick(left)={0,1,0,0},manMinor(left)={1,2}
					ModifyGraph tick(left)=2,mirror(left)=1
					
					ModifyGraph grid(bottom)=1,gridRGB(bottom)=(0,0,0)
					ModifyGraph grid(left)=1,gridRGB(left)=(0,0,0)
					
					Button change_toKbutton, title="Change to\rAngles"
					
					Wavestats/Q/Z KparFinalBlendBE2dif
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					
					Controlinfo  popup0
					name2 = S_value
					ModifyImage KparFinalBlendBE2dif, ctab= {V_min,V_max,$name2,0}
					
					varMin  = V_min
					varMax = V_max
					DoUpdate 
					GetAxis left
					
					LeftUpper = V_max
					LeftLower = V_min
					
					SetVariable SetLeftUpper,value= _NUM:LeftUpper
					SetVariable SetLeftLower,value= _NUM:LeftLower
					GetAxis bottom
					
					BottomLeft = V_min
					BottomRight = V_max
					
					SetVariable SetBottomLeft,value= _NUM:BottomLeft
					SetVariable SetBottomRight,value= _NUM:BottomRight
					
					DoWindow/HIDE=? Profiles_FinalBlend						//pulls the window to the front
					If(V_flag != 0)									//checks if there is a window....
						Button shiftA, disable=2 , win=Profiles_FinalBlend
					endif
					
					DoUpdate 
					
					break
				case "KparFinalBlendBE":
					//PopupMenu popup0,popvalue="Grays"
					RemoveImage $name1
					AppendImage FinalBlendBE
					ModifyGraph  swapXY=1
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					
					ModifyGraph manTick(bottom)={0,5,0,1},manMinor(bottom)={1,5}
					ModifyGraph tick(bottom)=2,mirror(bottom)=1
					ModifyGraph manTick(left)={0,1,0,0},manMinor(left)={1,2}
					ModifyGraph tick(left)=2,mirror(left)=1
					
					ModifyGraph grid(bottom)=1,gridRGB(bottom)=(0,0,0)
					ModifyGraph grid(left)=1,gridRGB(left)=(0,0,0)
					
					Button change_toKbutton, title="Change to\rK parallel"
					
					Wavestats/Q/Z FinalBlendBE
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					
					Controlinfo  popup0
					name2 = S_value
					ModifyImage FinalBlendBE, ctab= {V_min,V_max,$name2,0}
					
					varMin  = V_min
					varMax = V_max
					DoUpdate 
					GetAxis left
					
					LeftUpper = V_max
					LeftLower = V_min
					
					SetVariable SetLeftUpper,value= _NUM:LeftUpper
					SetVariable SetLeftLower,value= _NUM:LeftLower
					GetAxis bottom
					
					BottomLeft = V_min
					BottomRight = V_max
					
					SetVariable SetBottomLeft,value= _NUM:BottomLeft
					SetVariable SetBottomRight,value= _NUM:BottomRight
					
					DoWindow/HIDE=? Profiles_FinalBlend					//pulls the window to the front
					If(V_flag != 0)									//checks if there is a window....
						Button shiftA, disable=2 , win=Profiles_FinalBlend
					endif
					DoUpdate 
					
					break
				case "KparFinalBlendBE2dif":
					//PopupMenu popup0,popvalue="Grays"
					RemoveImage $name1
					AppendImage FinalBlendBE2dif
					ModifyGraph  swapXY=1
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					
					ModifyGraph manTick(bottom)={0,5,0,1},manMinor(bottom)={1,5}
					ModifyGraph tick(bottom)=2,mirror(bottom)=1
					ModifyGraph manTick(left)={0,1,0,0},manMinor(left)={1,2}
					ModifyGraph tick(left)=2,mirror(left)=1
					
					ModifyGraph grid(bottom)=1,gridRGB(bottom)=(0,0,0)
					ModifyGraph grid(left)=1,gridRGB(left)=(0,0,0)
					
					Button change_toKbutton, title="Change to\rK parallel"

					Wavestats/Q/Z FinalBlendBE2dif
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					
					Controlinfo  popup0
					name2 = S_value
					ModifyImage FinalBlendBE2dif, ctab= {V_min,V_max,$name2,0}
					
					varMin  = V_min
					varMax = V_max
					DoUpdate 
					GetAxis left
					
					LeftUpper = V_max
					LeftLower = V_min
					
					SetVariable SetLeftUpper,value= _NUM:LeftUpper
					SetVariable SetLeftLower,value= _NUM:LeftLower
					GetAxis bottom
					
					BottomLeft = V_min
					BottomRight = V_max
					
					SetVariable SetBottomLeft,value= _NUM:BottomLeft
					SetVariable SetBottomRight,value= _NUM:BottomRight
					
					DoWindow/HIDE=? Profiles_FinalBlend					//pulls the window to the front
					If(V_flag != 0)									//checks if there is a window....
						Button shiftA, disable=2 , win=Profiles_FinalBlend	
					endif
					DoUpdate 
					
					break
			endswitch
	
		break
	endswitch

	return 0
End

Function recalculateA(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:Specs:
			SetVariable gamma1,value= _NUM:1
			//Duplicate/O ImageLRmK FinalBlendBE
			Variable/G PhotonEnergy, WorkFunction
			Variable/G Multiplier, AngleOffset
			
			Variable PE, WF ,AS
			AS = AngleOffset
			
			PE = PhotonEnergy
			WF = WorkFunction
			Variable Resolution
			Resolution = Multiplier
			
			Prompt PE, "Photon Energy in eV"
			Prompt WF, "Work Function in eV"
			Prompt AS, "Shift the Angle Axis by"	
			Prompt Resolution, "Multiplication factor"	
			//Resolution = 1
			DoPrompt "PARAMETERS TO PUT",PE,WF,AS,Resolution
			
			if (V_Flag)
				return -1		// Canceled
			endif
			
			Duplicate/O ImageLRmK FinalBlendBE
			PhotonEnergy = PE
			WorkFunction = WF
			Multiplier = Resolution
			AngleOffset = AS
			
			WAVE Amatrix=FinalBlendBE
			Variable Ymin,Ymax , Xmin, Xmax
			
			Xmin=DimOffset(Amatrix,1) 
			Ymin=DimOffset(Amatrix,0) 
			Xmax=DimOffset(Amatrix,1) + (dimsize(Amatrix,1)-1) *DimDelta(Amatrix,1)
			Ymax=DimOffset(Amatrix,0) + (dimsize(Amatrix,0)-1) *DimDelta(Amatrix,0)
			
			//Ymin=DimOffset(Amatrix,0) 
			//Ymax=DimOffset(Amatrix,0) + (dimsize(Amatrix,0)-1) *DimDelta(Amatrix,0)
			SetScale/I x,Ymin-PhotonEnergy + WF,Ymax-PhotonEnergy + WF, "Binding Energy [eV]" FinalBlendBE
			SetScale/I y,Xmin - AS,Xmax - AS, "Angle [deg]" FinalBlendBE
			
			Duplicate/O FinalBlendBE, FinalBlendBE2dif
			
			Variable Rows, Columns
			Rows = DimSize(FinalBlendBE, 0 )
			Columns = DimSize(FinalBlendBE, 1 )
					
			Wave v1
			Make/O/N =(Rows)  v1 
			WAVE AmatrixDif = FinalBlendBE2dif
			Variable i,j
			for(i = 0; i <Columns;i+=1)	// Initialize variables;continue test
				v1 =  Amatrix[p][i]
				Differentiate v1
				Differentiate v1
				AmatrixDif [][i] = -v1[p]
			endfor
			KillWaves v1
			
			WAVE Amatrix=FinalBlendBE
			WAVE AmatrixDif = FinalBlendBE2dif
				
			NVAR PhotonEnergy
			NVAR WorkFunction
			PE = PhotonEnergy
			WF = WorkFunction
			
			Xmin=DimOffset(Amatrix,1) 
			Ymin=DimOffset(Amatrix,0) 
			Xmax=DimOffset(Amatrix,1) + (dimsize(Amatrix,1)-1) *DimDelta(Amatrix,1)
			Ymax=DimOffset(Amatrix,0) + (dimsize(Amatrix,0)-1) *DimDelta(Amatrix,0)
				
			Duplicate/O/O FinalBlendBE,KparFinalBlendBE
			Duplicate/O/O FinalBlendBE2dif,KparFinalBlendBE2dif	
			
			WAVE Kmatrix=KparFinalBlendBE
			WAVE KmatrixDif=KparFinalBlendBE2dif
			
			for(i = 0; i <Columns;i+=1)	// Initialize variables;continue test
				for(j = 0; j <Rows;j+=1)
					if(FinalBlendBE2dif[j][i] < 0)
						FinalBlendBE2dif[j][i] = 0
					endif
				endfor
			endfor
			
			//Variable size
			//size = dimsize(Amatrix,1) * Resolution
			Redimension/N=(-1,dimsize(Amatrix,1) * Resolution) Kmatrix
			Redimension/N=(-1,dimsize(Amatrix,1) * Resolution) KmatrixDif
				
			variable YL=SelectNumber(sign(Xmin)==+1,Ymax,Ymin)
			variable YR=SelectNumber(sign(Xmax)==+1,Ymin,Ymax)
			setscale/I y,0.512*sqrt(PE-WF+YL)*sin(Xmin*Pi/180),0.512*sqrt(PE-WF+YR)*sin(Xmax*Pi/180),"k\B||\M [Å]" Kmatrix
			Kmatrix=(y>0.512*sqrt(PE-WF+x)*sin(Xmax*Pi/180) || y<0.512*sqrt(PE-WF+x)*sin(Xmin*Pi/180)) ? Nan : Amatrix(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
				
			setscale/I y,0.512*sqrt(PE-WF+YL)*sin(Xmin*Pi/180),0.512*sqrt(PE-WF+YR)*sin(Xmax*Pi/180),"k\B||\M [Å]" KmatrixDif
			KmatrixDif=(y>0.512*sqrt(PE-WF+x)*sin(Xmax*Pi/180) || y<0.512*sqrt(PE-WF+x)*sin(Xmin*Pi/180)) ? Nan : AmatrixDif(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
		
			String name1
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			Wavestats/Q/Z $name1
			NVAR varMin = V_Min
			NVAR varMax = V_max
			Slider contrastmin,limits={V_min,V_max,0}
			Slider contrastmax,limits={V_min,V_max,0}
			
			Duplicate/O/O FinalBlendBE, FinalBlendBE1
			Duplicate/O/O KparFinalBlendBE, KparFinalBlendBE1
			Duplicate/O/O FinalBlendBE2dif, FinalBlendBE2dif1			
			Duplicate/O/O KparFinalBlendBE2dif, KparFinalBlendBE2dif1
			
			DoUpdate
			GetAxis left
			DoUpdate
			SetVariable SetLeftUpper,value= _NUM:V_max
			SetVariable SetLeftLower,value= _NUM:V_min
			GetAxis bottom
			DoUpdate
			SetVariable SetBottomLeft,value= _NUM:V_min
			SetVariable SetBottomRight,value= _NUM:V_max
			DoUpdate
		break
	endswitch

	return 0
End

Function contrast(sa) : SliderControl
	STRUCT WMSliderAction &sa
	
	switch( sa.eventCode )
		case -1: // kill
			DoWindow/F $"Display_and_Extract2"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Display_and_Extract2"
			endif
			
			DoWindow/F $"Spectrum"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Spectrum"
			endif
			
			break
		default:
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1, name2
				NVAR varMIN
				NVAR varMAX
				Setdatafolder root:Final_Blends:$sa.win
				//SetDataFolder root:Final_Blend
				name1 = sa.ctrlName
				
				name2 = ImageNameList("", "" )
				name2 = StringFromList (0, name2  , ";")
				if( cmpstr (name1 , "contrastmin") == 0 )
					ModifyImage /W=$sa.win $name2, ctab= {curval,varMAX,,0}
				else
					ModifyImage /W=$sa.win $name2, ctab= {varMIN, curval,,0}
				endif
	
			endif
			break
	endswitch

	return 0
End

Function displayDer(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			String name1 , name2
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			
			Setdatafolder root:Final_Blends:$ba.win
			//Setdatafolder root:Final_Blend:
			WAVE FinalBlendBE1
			WAVE KparFinalBlendBE1
			WAVE FinalBlendBE2dif1
			WAVE KparFinalBlendBE2dif1
			
			Duplicate/O FinalBlendBE1, FinalBlendBE
			Duplicate/O KparFinalBlendBE1, KparFinalBlendBE
			Duplicate/O FinalBlendBE2dif1, FinalBlendBE2dif		
			Duplicate/O KparFinalBlendBE2dif1, KparFinalBlendBE2dif
			
			SetVariable gamma1,value= _NUM:1
			
			NVAR LeftUpper 
			NVAR  LeftLower 
			NVAR  BottomLeft 
			NVAR  BottomRight
			
			NVAR varMin 
			NVAR varMax
			strswitch(name1)
				case "FinalBlendBE":
					//PopupMenu popup0,popvalue="Grays"
					RemoveImage $name1
					AppendImage FinalBlendBE2dif
					ModifyGraph  swapXY=1
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					
					ModifyGraph manTick(bottom)={0,5,0,0},manMinor(bottom)={1,5}
					ModifyGraph manTick(left)={0,1,0,0},manMinor(left)={1,2}
					
					ModifyGraph tick(bottom)=2,mirror(bottom)=1
					ModifyGraph tick(left)=2,mirror(left)=1
					
					ModifyGraph grid(bottom)=1,gridRGB(bottom)=(0,0,0)
					ModifyGraph grid(left)=1,gridRGB(left)=(0,0,0)
					
					Button derivative, title="Change to\rImage"
					
					Wavestats/Q/Z FinalBlendBE2dif
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					
					Controlinfo  popup0
					name2 = S_value
					ModifyImage FinalBlendBE2dif, ctab= {V_min,V_max,$name2,0}
					
					varMin  = V_min
					varMax = V_max
					DoUpdate 
					GetAxis left
					
					LeftUpper = V_max
					LeftLower = V_min
					
					SetVariable SetLeftUpper,value= _NUM:LeftUpper
					SetVariable SetLeftLower,value= _NUM:LeftLower
					GetAxis bottom
					
					BottomLeft = V_min
					BottomRight = V_max
					
					SetVariable SetBottomLeft,value= _NUM:BottomLeft
					SetVariable SetBottomRight,value= _NUM:BottomRight
					PopupMenu popup1,disable=0
					DoUpdate 
		
					break
				case "ImageLRmK":
					break
				case "FinalBlendBE2dif":
					//PopupMenu popup0,popvalue="Grays"
					RemoveImage $name1
					AppendImage FinalBlendBE
					ModifyGraph  swapXY=1
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					
					ModifyGraph manTick(bottom)={0,5,0,0},manMinor(bottom)={1,5}
					ModifyGraph manTick(left)={0,1,0,0},manMinor(left)={1,2}
					
					ModifyGraph tick(bottom)=2,mirror(bottom)=1
					ModifyGraph tick(left)=2,mirror(left)=1
					
					ModifyGraph grid(bottom)=1,gridRGB(bottom)=(0,0,0)
					ModifyGraph grid(left)=1,gridRGB(left)=(0,0,0)
					
					Button derivative, title="Change to\r 2nd Derivative"
					
					Wavestats/Q/Z FinalBlendBE
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					
					Controlinfo  popup0
					name2 = S_value
					ModifyImage FinalBlendBE, ctab= {V_min,V_max,$name2,0}
					
					varMin  = V_min
					varMax = V_max
					DoUpdate 
					GetAxis left
					
					LeftUpper = V_max
					LeftLower = V_min
					
					SetVariable SetLeftUpper,value= _NUM:LeftUpper
					SetVariable SetLeftLower,value= _NUM:LeftLower
					GetAxis bottom
					
					BottomLeft = V_min
					BottomRight = V_max
					
					SetVariable SetBottomLeft,value= _NUM:BottomLeft
					SetVariable SetBottomRight,value= _NUM:BottomRight
					PopupMenu popup1,disable=2
					DoUpdate 
					
					break
				case "KparFinalBlendBE":
					//PopupMenu popup0,popvalue="Grays"
					RemoveImage $name1
					AppendImage KparFinalBlendBE2dif
					ModifyGraph  swapXY=1
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					
					ModifyGraph manTick(bottom)={0,0.2,0,1},manMinor(bottom)={1,2}
					ModifyGraph manTick(left)={0,1,0,0},manMinor(left)={1,2}
					
					ModifyGraph tick(bottom)=2,mirror(bottom)=1
					ModifyGraph tick(left)=2,mirror(left)=1
					
					ModifyGraph grid(bottom)=1,gridRGB(bottom)=(0,0,0)
					ModifyGraph grid(left)=1,gridRGB(left)=(0,0,0)
					
					Button derivative, title="Change to\rImage"
					
					Wavestats/Q/Z KparFinalBlendBE2dif
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					
					Controlinfo  popup0
					name2 = S_value
					ModifyImage KparFinalBlendBE2dif, ctab= {V_min,V_max,$name2,0}
					
					varMin  = V_min
					varMax = V_max
					DoUpdate 
					GetAxis left
					
					LeftUpper = V_max
					LeftLower = V_min
					
					SetVariable SetLeftUpper,value= _NUM:LeftUpper
					SetVariable SetLeftLower,value= _NUM:LeftLower
					GetAxis bottom
					
					BottomLeft = V_min
					BottomRight = V_max
					
					SetVariable SetBottomLeft,value= _NUM:BottomLeft
					SetVariable SetBottomRight,value= _NUM:BottomRight
					PopupMenu popup1,disable=0
					DoUpdate 
					
					break
				case "KparFinalBlendBE2dif":
					//PopupMenu popup0,popvalue="Grays"
					RemoveImage $name1
					AppendImage KparFinalBlendBE
					ModifyGraph  swapXY=1
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					
					ModifyGraph manTick(bottom)={0,0.2,0,1},manMinor(bottom)={1,2}
					ModifyGraph manTick(left)={0,1,0,0},manMinor(left)={1,2}
					
					ModifyGraph tick(bottom)=2,mirror(bottom)=1
					ModifyGraph tick(left)=2,mirror(left)=1
					
					ModifyGraph grid(bottom)=1,gridRGB(bottom)=(0,0,0)
					ModifyGraph grid(left)=1,gridRGB(left)=(0,0,0)
					
					Button derivative, title="Change to\r 2nd Derivative"

					Wavestats/Q/Z KparFinalBlendBE
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					
					Controlinfo  popup0
					name2 = S_value
					ModifyImage KparFinalBlendBE, ctab= {V_min,V_max,$name2,0}
					
					varMin  = V_min
					varMax = V_max
					DoUpdate 
					GetAxis left
					
					LeftUpper = V_max
					LeftLower = V_min
					
					SetVariable SetLeftUpper,value= _NUM:LeftUpper
					SetVariable SetLeftLower,value= _NUM:LeftLower
					GetAxis bottom
					
					BottomLeft = V_min
					BottomRight = V_max
					
					SetVariable SetBottomLeft,value= _NUM:BottomLeft
					SetVariable SetBottomRight,value= _NUM:BottomRight
					PopupMenu popup1,disable=2
					DoUpdate 
					
					break
			endswitch
		break
	endswitch

	return 0
End

//---------------------------------------------------------------------------------------------------

Function Profiles1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			SetDataFolder root:Final_Blends:$ba.win
			String name1 , name2
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			NVAR varMin 
			NVAR varMax
			WAVE matrix = $name1
			Variable Xmin,Ymin,Xmax,Ymax
			NVAR AngleOffset = root:Specs:AngleOffset
			
			Xmin=DimOffset(matrix,0) + 0 * DimDelta(matrix,0)
			Ymin=DimOffset(matrix,1) + 0 * DimDelta(matrix,1)
			Xmax=DimOffset(matrix,0) + ( Dimsize(matrix,0) - 1 ) * DimDelta(matrix,0)
			Ymax=DimOffset(matrix,1) + ( Dimsize(matrix,1) - 1 ) * DimDelta(matrix,1)
			
			
			Make/o/n=(dimsize(matrix,0)) MDC
			Make/o/n=(dimsize(matrix,1)) EDC
			SetScale/I x,xmin,xmax,MDC
			SetScale/I x,ymin,ymax,EDC
			
			name2 = ba.win+"_profiles"
			DoWindow/F $name2				//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow $"Profiles_FinalBlend"
			//endif
			//------------display the results
			if (V_Flag==1)	
				Dowindow/F $name2
				//Slider moveMDC1,pos={25,5},size={400,13},proc=SliderDC1
				//Slider moveMDC1,limits={0,DimSize(matrix,1)-1,0},value= 0,side= 0,vert= 0,ticks= 0
				//Slider moveEDC1,pos={6,41},size={13,350},proc=SliderDC1
				//Slider moveEDC1,limits={0,DimSize(matrix,0)-1,0},value= 0,side= 0,ticks= 0
			else
				Display/K=1 /W=(338.25,70.25,710,417.5)/L=leftEDC/B=bottomEDC EDC
				Dowindow/C $name2	
				AppendToGraph/L=leftMDC/B=bottomMDC MDC
				ModifyGraph lblPos(leftEDC)=52,lblPos(leftMDC)=51
				ModifyGraph lblLatPos(leftMDC)=-1
				ModifyGraph freePos(leftEDC)={0.16,kwFraction}
				ModifyGraph freePos(bottomEDC)={0.6,kwFraction}
				ModifyGraph freePos(leftMDC)={0.16,kwFraction}
				ModifyGraph freePos(bottomMDC)={0.1,kwFraction}
				ModifyGraph axisEnab(leftEDC)={0.6,1}
				ModifyGraph axisEnab(bottomEDC)={0.16,1}
				ModifyGraph axisEnab(leftMDC)={0.1,0.5}
				ModifyGraph axisEnab(bottomMDC)={0.16,1}
				Label leftEDC "EDC"
				Label leftMDC "MDC"
				ControlBar 50
				ControlBar/L 60
				Slider moveMDC1,pos={15,10},size={400,13},proc=SliderDC1
				Slider moveMDC1,limits = { 0 , dimsize(matrix,1) - 1 , 0 },value= 0,side= 0,vert= 0,ticks= 0
				Slider moveEDC1,pos={20,55},size={13,380},proc=SliderDC1
				Slider moveEDC1,limits = { 0 , dimsize(matrix,0) - 1 , 0 },value= 0,side= 0,ticks= 0
				ValDisplay valdisp0 pos = {425,5} , size = {55,30},value=_NUM:AngleOffset
				ValDisplay valdisp1 pos = {5,440} , size = {50,20},value=0
				
				Button shiftA, pos = {430,25}, size = {60,20}, proc = AcceptShift, title = "Accept" , disable=0
				Button shiftA, fSize=14 
				
				ControlInfo/W=$ba.win $"change_toKbutton"
				if( strsearch(S_recreation, "Angles",0) != -1 )
					Button shiftA, disable=2	
				endif
			endif
			
			break
		endswitch
	return 0
End

Function SliderDC1(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1
				String name2
				String name3
				String name4
				String name5
				//SetDataFolder root:$sa.win
				name2 = sa.win
				name2 = RemoveEnding(name2 , "_profiles")
				name1 = ImageNameList(name2, "" )
				name1 = StringFromList (0, name1  , ";")
				name3 = GetWavesDataFolder($name1, 1 )
				WAVE matrix= $(name3+name1)
				WAVE MDC= $(name3+"MDC")
				WAVE EDC= $(name3+"EDC")
				name4 = name2+"#"+name1
				//name5 = "Cursor/W="+name2+ " /P/I/H=1/C=(65280,0,0) A "+name1+" "+ num2str(pcsr(A,name2))+","+num2str(curval) 
				if (strlen(csrinfo(A,name2))==0)
					execute/Z/Q "Cursor/W="+name2+ " /P/I/H=1/C=(65280,0,0) A "+name1+" 0,0"
					ValDisplay valdisp0,value=_NUM:hcsr(A,name2)
				endif
				if (cmpstr(sa.ctrlName,"moveMDC1")==0)
					MDC = matrix[p][curval]
					name5 = "Cursor/W="+name2+ " /P/I/H=1/C=(65280,0,0) A "+name1+" "+ num2str(pcsr(A,name2))+","+num2str(curval) 
					execute/Z/Q name5
					ValDisplay valdisp0,value=_NUM:vcsr(A,name2)
				endif
				if (cmpstr(sa.ctrlName,"moveEDC1")==0)
					EDC = matrix[curval][p]
					name5 = "Cursor/W="+name2+ " /P/I/H=1/C=(65280,0,0) A "+name1+" "+num2str(curval)+","+num2str( qcsr(A,name2) )
					execute/Z/Q name5
					ValDisplay valdisp1,value=_NUM:hcsr(A,name2)
				endif		
			endif
			//ValDisplay cross2,value=_NUM:hcsr(B,"Blended_Panel#G0")
			//ValDisplay cross1,value=_NUM:vcsr(B,"Blended_Panel#G0")
		
			break
	endswitch

	return 0
End

Function ButtonProc(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			SetActiveSubwindow Blended_Panel
			ControlInfo /W=# $ba.ctrlName
			Variable num2
			num2 = strsearch(S_recreation,"Up",0)
			Setdatafolder root:Load_and_Set_Panel:
			SVAR title_left1 =  title_left1
			SVAR title_right1 =  title_right1
			
			SetDataFolder root:Blending_Panel
			SVAR K1
			Variable help1,help2,help3
			WAVE FinalBlendKE
			WAVE FinalBlendKEori
			Duplicate/O FinalBlendKEori, FinalBlendKE
			WAVE TemporaryHoldKE_L
			WAVE TemporaryHoldKE_R
			
			Variable La1, Ra1
			Variable La2, Ra2
			Variable Le1,Le2,He1,He2
					
			Variable index1A,index2A,index3A,index4A
			Variable index1E,index2E,index3E,index4E
			Variable deltaA , deltaE
			Variable n1,n2
			Variable i,j
			
			Variable aShift
			ControlInfo setvar1
			aShift = V_value
			
			Variable eShift
			ControlInfo setvar0
			eShift = V_value
							
			n1 = DimSize(FinalBlendKE,0) 
			n2 = DimSize(FinalBlendKE,1) + aShift
			deltaA = DimDelta(FinalBlendKE,1)
			deltaE = DimDelta(FinalBlendKE,0)
			Redimension /N=(n1 , n2 ) FinalBlendKE
			Redimension /N=(n1 , n2 ) TemporaryHoldKE_L
			Redimension /N=(n1 , n2 ) TemporaryHoldKE_R
			
			Setdatafolder root:Load_and_Set_Panel:
			Wave Angle_2D = L_image1		
			Duplicate/FREE Angle_2D, L_Image
			La1 = DimOffset(L_Image,1)
			Ra1 = DimOffset(L_image,1) + (DimSize(L_image,1)-1)*DimDelta(L_image,1)
			He1 = DimOffset(L_image,0) + (DimSize(L_image,0)-1)*DimDelta(L_image,0)
			Le1 = DimOffset(L_image,0)
			
			Setdatafolder root:Load_and_Set_Panel:
			Wave Angle_2D = R_image1		
			Duplicate/FREE Angle_2D, R_Image
			La2 = DimOffset(R_image,1)
			Ra2 = DimOffset(R_image,1) + (DimSize(R_image,1)-1)*DimDelta(R_image,1)
			He2 = DimOffset(R_image,0) + (DimSize(R_image,0)-1)*DimDelta(R_image,0)
			Le2 = DimOffset(R_image,0)
					
			index1A = round ( ( La1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
			index3A = round ( ( Ra1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) 
			index2A = round ( ( La2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) + aShift
			index4A = round ( ( Ra2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) + aShift
			
			index1E = round ( ( Le1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
			index3E = round ( ( He1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
			index2E = round ( ( Le2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) + eShift
			index4E = round ( ( He2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) + eShift
					
			Slider slider1,limits={0,(n2 - 1),1}
					
			TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image(x)(y)
			SetScale/P y, La2 + aShift*deltaA, deltaA, "" R_Image
			SetScale/P x, Le2 + eShift*deltaE, deltaE, "" R_Image
			
			SetDataFolder root:Blending_Panel
			Variable /G Normalization

			Variable totalNrPixE
			totalNrPixE = DimSize(TemporaryHoldKE_R,0)
			TemporaryHoldKE_R = 0
			TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
			Variable Average1, Average2
			help1 = 0
			help2 = 0
			if( index3A >= index2A )
				if( index2A >= index1A )
					Average1 = 0
					Average2 = 0
					for(j=index2A;j<=index3A;j+=1)
						for(i=0;i<totalNrPixE;i+=1)
							help2 = TemporaryHoldKE_R[i][j]
							help1 = TemporaryHoldKE_L[i][j]
							if( help1!= 0 && help2!=0 )
								Average1+=help1
								Average2+=help2
							endif
						endfor
					endfor
					Normalization=Average1/Average2
					TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
					//FinalBlendKE[][index3A+1,index4A] = TemporaryHoldKE_R[p][q]
				else
					if(index1A > index4A)
						Average1 = 1
						Average2 = 1	
					else
						for(j=index1A;j<=index4A;j+=1)
								for(i=0;i<totalNrPixE;i+=1)
								help2 = TemporaryHoldKE_R[i][j]
								help1 = TemporaryHoldKE_L[i][j]
								if( help1!= 0 && help2!=0 )
									Average1+=help1
									Average2+=help2
								endif
							endfor
						endfor	
						Normalization=Average1/Average2
						TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
						//FinalBlendKE[][index2A+1,index4A] = TemporaryHoldKE_R[p][q]	
					endif
				endif
			else
				Average1 = 1
				Average2 = 1	
				Normalization=Average1/Average2
				TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
				//FinalBlendKE[][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
			endif
			//SetScale/P x, Lke, deltaE,"" FinalBlendKE
           		//SetScale/P y, La1 + dval*deltaA, deltaA, "" TemporaryHoldKE_R
           		SetDataFolder root:Blending_Panel
  	
  			Variable index3Ehalf
  			index3Ehalf = round(index3E/2)
			if(num2 != -1)
				Button buttonUD,title="Down"
				FinalBlendKE[index2E,index4E][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
				FinalBlendKE[index1E,index3E][index1A,Index3A] = TemporaryHoldKE_L[p][q]
				execute/Z/Q "Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE "+num2str(index3Ehalf)+"," +num2str(index3A)
				//Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0, index3A 
			else
				Button buttonUD,title="Up"
				FinalBlendKE[index1E,index3E][index1A,Index3A] = TemporaryHoldKE_L[p][q]
				FinalBlendKE[index2E,index4E][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
				execute/Z/Q "Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE " +num2str(index3Ehalf)+"," +num2str(index2A)				
				//Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0,index2A 
			endif	
			DoUpdate
			
			// click code here
			break
	endswitch

	return 0
End

Function ButtonProc_Blend2(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1:
			KillDataFolder root:WinGlobals
		break
		case 2: // mouse up
			// click code here
			Variable numberY1, numberY2,numberY3
			SetDataFolder root:Specs:	
			NVAR AngleShift
			NVAR EnergyShift
			
			Variable La1, Ra1
			Variable La2, Ra2
			Variable x1,x2,x3,x4
			Variable Le1,Le2,He1,He2
			Variable y1,y2,y3,y4
			WAVE L_image1
			WAVE R_image1
			WAVE tImageLR
			WAVE tImageLR1
			WAVE tImageLR2
			
			Variable eNumber1
			eNumber1 = DimSize(tImageLR,0)

			Le1 =   DimOffset(L_image1, 0)
			He1 = ( DimSize(L_image1,0) - 1 ) * DimDelta(L_image1,0) + Le1
			Le2 =   DimOffset(R_image1,0)
			He2 = ( DimSize(R_image1,0) - 1 ) * DimDelta(R_image1,0) + Le2
			
			x1 = round ( ( Le1 - DimOffset(tImageLR, 0) ) / DimDelta(tImageLR,0) )
			x2 = round ( ( He1 - DimOffset(tImageLR, 0) ) / DimDelta(tImageLR,0)  )
			x3 = round ( ( Le2 - DimOffset(tImageLR, 0) ) / DimDelta(tImageLR,0) + EnergyShift)
			x4 = round ( ( He2 - DimOffset(tImageLR, 0) ) / DimDelta(tImageLR,0) + EnergyShift )
					
			La1 =   DimOffset(L_image1, 1)
			Ra1 = ( DimSize(L_image1,1) - 1 ) * DimDelta(L_image1,1) + La1
			La2 =   DimOffset(R_image1, 1)
			Ra2 = ( DimSize(R_image1,1) - 1 ) * DimDelta(R_image1,1) + La2
			
			y1 = round ( ( La1 - DimOffset(tImageLR, 1) ) / DimDelta(tImageLR,1) )
			y2 = round ( ( Ra1 - DimOffset(tImageLR, 1) ) / DimDelta(tImageLR,1) )
			y3 = round ( ( La2 - DimOffset(tImageLR, 1) ) / DimDelta(tImageLR,1)  + AngleShift ) 
			y4 = round ( ( Ra2 - DimOffset(tImageLR, 1) ) / DimDelta(tImageLR,1)  + AngleShift )
			
			numberY1 = y2 - y3 + 1
			//tImageLR[y3,y4][x3,x4] =   tImageLR2[p - dval][q - AngleShift]
			//tImageLR[y1 ,y2][x3,x2 - 2] =  (q - x3 )/numberx1*tImageLR1[p][q]    +  (1 - (q-x3)/numberx1) *tImageLR2[p - EnergyShift][q - AngleShift]
			Variable i, j , k1 , k2 ,check1,check2
			//tImageLR = 0
			for(i = y3 ; i <= y2 ; i += 1)
				k2 = i - AngleShift
				for(j = 0; j < eNumber1 ; j += 1)
					numberY2 = ( i - Y3 ) / ( numberY1 )
					numberY3 = 1 - numberY2
					k1 = j - EnergyShift
					if( k1 > 0 && k1 < eNumber1 )
						check1 = numberY3 * tImageLR1 [j] [i]
						check2 = numberY2 * tImageLR2 [j - EnergyShift] [k2]
						check1 = check1 + check2
						tImageLR[j][i] = check1
					endif 
				endfor
			endfor
			break
	endswitch

	return 0
End


Function SPECS_Load_XYnew(path,[clipboard])
    string path
    variable clipboard
   
    variable file
    open/R/F="SPECS XY Files (*.xy):.xy;All Files:.*;" file as path
 
    variable  j, n_wave =1
    variable startx,  stepx, num, scanNum,  datacounter = 0, aquedist, numLinesLoaded=0, cnt=0,line=0, cmtLine, cntExtData
    variable hasCycle=0,hasChannel=0, hasScan=0 // variables used as references for grepDataTitle
    variable col1,col2,col3,col4,col5
    variable numPoints=100
    variable lastRound=0
    
    variable eps=1e-6
    
    string suffix=".new" // string to append to an already existing folders/waves
    string str, group="", fname="", newfname="", oldgroup="", tmp=""
    string method="", lens="", slit="", analyzer="", mode="", curvesPerScan="", valuesPerCurve="",dwellTime="", excEnergy="", passEnergy="", biasVoltage="", creator="", ordinateRange=""
    string detVoltage="", effWorkfunction="", source="", numberOfScan="", binEnergy="", kinEnergy="", remote="", comment="", region="", headerComment="", remoteInfo="",extName=""
    string SLVersion="", option=""
    
    // data from the settings dialog in SL2
     string DialogData_sepChanData="", DialogData_extChanData="", DialogData_cps="", DialogData_interpolation="", DialogData_asymFunc="", DialogData_sepScanData="", DialogData_Ekin="", DialogData_transFunc="", DialogData_errorBar=""
     
    variable columnsHoldGainData=0,columnsHoldTransData=0,columnsHoldErrorData=0
    // wave names
    string energy="", spectrum="", gain="",trans="",error=""
    
    Wave xw, yw, gainw, transw, errorw  
    variable cycle, scan, curve, channel

    SetDataFolder root:
      
    if( ParamIsDefault(clipboard) )
      FStatus file
      fname = S_fileName
      newfname = S_fileName
      // print "Opening file: ", fname
    else
      fname = "Clipboard"
      newfname = "Clipboard"
      // print "Reading data from clipboard"
    endif
    
    if(DataFolderExists(newfname))
      fname += suffix
      do
        newfname = fname + num2str(cnt)
        cnt+=1
      while(DataFolderExists(newfname))
    endif
      
    NewDataFolder/s $newfname
    
    string transList = "No;Yes"
    string gainList  = "No;Yes"
    string transWaveDlg, gainWaveDlg
    //Prompt transWaveDlg, "Create waves for transmission data (if available)", popup transList
    //Prompt gainWaveDlg, "Create waves for gain data (if available)", popup gainList
    //DoPrompt /HELP="Choose 'No' for both options to use the Display Bandstructures Procedure from SPECS" "Loading xy data", transWaveDlg, gainWaveDlg

    //if (V_Flag) // evaluate prompt settings
    //  return -1
    //else
    //  Debugprint("tansWaveDlg is " + transWaveDlg)
    //  Debugprint("gainWaveDlg is " + gainWaveDlg)
    //endif
    transWaveDlg = "no"
    gainWaveDlg = "no"
    Debugprint("tansWaveDlg is " + transWaveDlg)
    Debugprint("gainWaveDlg is " + gainWaveDlg)
    
    do
        FReadLine file, str
        line+=1
        if(strlen(str) == 0) // hit EOF
          lastRound=1
          str=""
        endif
            
        str = stripwhitespace(str)
        str = removetrailingCR(str)
        
        if(isDataLine(str,col1,col2,col3,col4,col5))

          if(numLinesLoaded == 0) // new block begins
          
            if(cmpstr(group,"") != 0 && cmpstr(oldgroup,group) != 0) // new group
              oldgroup = group
              NewDataFolder/s root:$(newfname):$(group)
            endif
            
            if( cmpstr(region,"") == 0 ) // take save default name
              datacounter+=1
              spectrum = "data" + num2str(datacounter)
            elseif(cntExtData > 0)
              spectrum = "extData" + num2str(cntExtData) + "_" + region
            else
              spectrum = region
            endif
            
            if( cycle > 0)
              spectrum += "Cy" + num2str(cycle)
            endif

            if( str2num(numberOfScan) > 1 && hasScan ) // we have separate data for each scan
              spectrum += "Sc" + num2str(scan)
            endif
            
            if ( str2num(curvesPerScan) > 1 )
              spectrum += "Cu" + num2str(curve)
            endif
            
            if ( hasChannel ) // separate data for each channel
              spectrum += "Ch" + num2str(channel)
            endif
            
            if(WaveExists($spectrum)) // we want  to never overwrite spectra
              cnt=0
              spectrum += suffix
              do
                tmp = spectrum + num2str(cnt)
                cnt+=1
              while(WaveExists($tmp))
              spectrum = tmp
            endif            
            
            if( strlen(spectrum) >= 27 )
              datacounter +=1
              if( cmpstr(headerComment,"" ) == 0 )
                comment = "Original name was " + spectrum  
              else
                comment = headerComment + "\r" + "Original name was " + spectrum
              endif
              print "Spectrum name shortend due to Igor Pro limitations"
              print "from:", spectrum
              spectrum = "data" + num2str(datacounter)
              print "to:", spectrum
            endif
              energy =  "En_" + spectrum
              gain = "Gn_" + spectrum
              trans = "Tr_" + spectrum
              error = "Er_" + spectrum
                      
            make/D/N=(numPoints) $energy, $spectrum, $gain, $trans, $error
            Wave xw = $energy
            Wave yw = $spectrum
            Wave gainw = $gain
            Wave transw = $trans
            Wave errorw = $error
            
          elseif (numLinesLoaded >= numPoints)
            numPoints *= 2
            Redimension/N=(numPoints) xw, yw, gainw,transw,errorw
          endif // endif new block
          
           fillWaves(SLVersion,xw,yw,errorw,gainw,transw,numLinesLoaded,col1,col2,col3,col4,col5,columnsHoldErrorData,columnsHoldGainData,columnsHoldTransData,gainWaveDlg,transWaveDlg)
          numLinesLoaded+=1
        else
          if(numLinesLoaded != 0)
            Redimension/N=(numLinesLoaded) xw, yw, gainw,transw,errorw
            aquedist = checkEnergyScale(xw,numLinesLoaded,eps)
            numLinesLoaded=0
                    
            if(aquedist == 1)
              startx = xw[0]
              stepx = xw[1] - xw[0]
              SetScale/P  x,startx,stepx,"eV" yw
              KillWaves xw
            endif
            
            WaveStats/Q gainw
            if ( V_min == 0 && V_max == 0) // no gain data
              KillWaves gainw
            elseif( aquedist == 1)
              SetScale/P x,startx,stepx,"" gainw
            endif

            WaveStats/Q transw
            if ( V_min == 0 && V_max == 0) // no trans data
              KillWaves transw
            elseif( aquedist == 1)
              SetScale/P x,startx,stepx,"" transw
            endif
            
            WaveStats/Q errorw
            if ( V_min == 0 && V_max == 0) // no error data
              KillWaves errorw
            elseif( aquedist == 1)
              SetScale/P x,startx,stepx,"" errorw
            endif
            
            Note yw, "Created by:" + creator
            if( currentIsNewerOrEqual(SLVersion,"2.34-r13267") )
              Note yw, "Counts Per Second:" + DialogData_cps
              Note yw, "Kinetic Energy Axis:" + DialogData_Ekin
              Note yw, "Separate Scan Data:" + DialogData_sepScanData
              Note yw, "Separate Channel Data:" + DialogData_sepChanData
              Note yw, "External Channel Data:" + DialogData_extChanData
              Note yw, "Transmission Function:" + DialogData_transFunc
              Note yw, "Asymmetry Recalculation:"  + DialogData_asymFunc
              Note yw, "Interpolation:" + DialogData_interpolation
            endif
            if( currentIsNewerOrEqual(SLVersion,"2.41-r14987") )
              Note yw, "ErrorBar:" + DialogData_errorBar
            endif
            Note yw, "Cycle:" + num2str(cycle)
            Note yw, "Scan:" + num2str(scan)
            Note yw, "Curve:" + num2str(curve)
            Note yw, "Channel:" + num2str(channel)
            Note yw,"Method:" + method
            Note yw,"Analyzer:" + analyzer
            Note yw,"Analyzer Lens:" + lens
            Note yw,"Analyzer Slit:" + slit
            Note yw,"Scan Mode:" + mode
            Note yw,"Dwell time:" + dwellTime
            Note yw,"Excitation energy:" + excEnergy
            Note yw,"Kinetic energy:" + kinEnergy
            Note yw,"Binding energy:" + binEnergy
            Note yw,"Pass energy:" + passEnergy
            Note yw,"Bias Voltage:" + biasVoltage
            Note yw,"Detector Voltage:" + detVoltage
            Note yw,"Effective Workfunction:" + effWorkfunction
            if( cmpstr(ordinateRange,"") != 0 )
              Note yw, "Ordinate Range:" + ordinateRange
            endif
            Note yw,"Source:" + source
            Note yw,"Remote:" + remote
            Note yw,"RemoteInfo:" + remoteInfo
            if( strlen(extName) )
              Note yw,"External Data Channel Name:" + extName
            endif
            Note yw, "Comment:" + comment
                 
            print "Wave number " + num2str(n_wave) + " created" 
            n_wave  += 1  
        endif
        
        grepDataTitle(str,hasCycle,hasChannel,hasScan,cycle,curve,scan,channel)
      
        str = grepLine(str,option)
        
        strswitch(str)
          case "Created by:":
            creator = option
            variable length = strlen(option)
            string findStr = "Version "
            SLversion = option[strsearch(option,findStr,Inf,1)+strlen(findStr),length]
            DebugPrint("SL Version is " + SLVersion)
          break
          case "Group:":
            group=option
          break
          case "Counts Per Second:":
            DialogData_cps=option
          break
          case "Kinetic Energy Axis:":
            DialogData_Ekin=option
          break
          case "Separate Scan Data:":
            DialogData_sepScanData=option
          break
          case "Separate Channel Data:":
            DialogData_sepChanData=option
          break
          case "External Channel Data:":
            DialogData_extChanData=option
          break
          case "Transmission Function:":
            DialogData_transFunc=option
          break
          case "Asymmetry Recalculation:":
            DialogData_asymFunc=option
          break
          case "Interpolation:":
            DialogData_interpolation=option
          break
          case "ErrorBar:":
            DialogData_errorBar=option
          break        
          case "Region:":
            region = option
            cntExtData=0
          break
          case "Anylsis Method:":
            method = option
          break
          case "Analysis Method:":
            method = option
          break
          case "Analyzer:":
            analyzer = option
          break
          case "Analyzer Lens:":
            lens = option
          break
          case "Analyzer Slit:":
            slit = option
          break
          case "Scan Mode:":
            mode = option
          break
          case "Number of Scans:":
            numberOfScan = option
          break
          case "Curves/Scan:":
            curvesPerScan = option
          break
          case "Values/Curve:":
            valuesPerCurve= option
          break
          case "Dwell Time:":
            dwelltime = option
          break
          case "Excitation Energy:":
            excEnergy = option
          break
          case "Kinetic Energy:":
            kinEnergy = option
          break
          case "Binding Energy:":
            binEnergy = option
          break
          case "Pass Energy:":
            passEnergy = option
          break
          case "Bias Voltage:":
            biasVoltage = option
          break
          case "Detector Voltage:":
            detVoltage = option
          break
          case "Eff. Workfunction:":
            effWorkfunction = option
          break
          case "Source:":
            source = option
          break
          case "RemoteInfo:":
            remoteInfo = option
          break
          case "Remote:":
            remote = option
          break
          case "Comment:":
            cmtLine = line
            headerComment = option
          break
          case "OrdinateRange:":
            ordinateRange=option
          break
          case "ColumnLabels:":
            if(strsearch(option,"scaling",0) != -1 )
              columnsHoldGainData=1
              DebugPrint("columnsHoldGainData=1")
            else 
              columnsHoldGainData=0
            endif
            if (strsearch(option,"transmission",0) != -1 )
              columnsHoldTransData=1
              DebugPrint("columnsHoldTransData=1")
            else
              columnsHoldTransData=0
            endif
            if ( strsearch(option,"ErrorBar",0) != -1 )
              columnsHoldErrorData=1
              DebugPrint("columnsHoldErrorData=1")
            else
              columnsHoldErrorData=0
            endif
          break
          case "External Channel Data Cycle:": 
            option = option[strsearch(option,",",0)+1,strlen(option)]
            option = stripwhitespace(option)
            cntExtData +=1
            extName = option
          break
          default:
            if( ( cmtLine + 1 ) == line && cmpstr(option,"") != 0 )
              cmtLine +=1
              headerComment  = headerComment + "\r" + option
            else
              cmtLine=-1
            endif
          break
        endswitch
      endif
        
    while(lastRound != 1)

  Close file
  return 0 
end

static Function fillWaves(SLVersion,xw,yw,errorw,gainw,transw,index,col1,col2,col3,col4,col5,columnsHoldErrorData,columnsHoldGainData,columnsHoldTransData,gainWaveDlg,transWaveDlg)
  variable col1,col2,col3,col4,col5,index,columnsHoldGainData,columnsHoldTransData,columnsHoldErrorData
  string SLVersion,gainWaveDlg, transWaveDlg
  Wave xw,yw,gainw,transw,errorw
  
  xw[index]=col1 // 1
  yw[index]=col2 // 1
  
  if( currentIsNewerOrEqual(SLVersion,"2.41-r14987") )
    // data header possibilities are
    // 1 "energy counts"
    // 2 "energy counts scaling"
    // 3 "energy counts scaling transmission"
    // 4 "energy counts transmission"
    //
    // 5 "energy counts Error bar"
    // 6 "energy counts Error bar scaling"
    // 7 "energy counts Error bar scaling transmission"
    // 8 "energy counts Error bar transmission"
    //
    if( columnsHoldErrorData ) // 5
      errorw[index]=col3
      if( columnsHoldGainData ) // 6
        gainw[index]=col4
        if( columnsHoldTransData ) // 7
          transw[index]=col5
        endif
      elseif( columnsHoldTransData ) // 8
          transw[index]=col4
      endif
    elseif( columnsHoldGainData ) // 2
      gainw[index]=col3
      if( columnsHoldTransData ) // 3
        transw[index]=col4
      endif
    elseif( columnsHoldTransData ) // 4
      transw[index]=col3
    endif
  elseif( currentIsNewerOrEqual(SLVersion,"2.32-r10374") )
    // data header possibilities are
    // - "energy counts"
    // - "energy counts scaling transmission"
    // - "energy counts scaling"
    // - "energy counts transmission"
    if( columnsHoldGainData && columnsHoldTransData)
      gainw[index]=col3
      transw[index]=col4
    elseif( columnsHoldGainData )
      gainw[index]=col3
    elseif( columnsHoldTransData )
      transw[index]=col3
    endif
  else
         // default handler for old versions
          // we have definitly no transmission data, but perhaps gain data
    gainw[index]=col3
  endif
  
  // user choose perhaps no, so we set the corresponding data points to zero, the deletion is later
  if(cmpstr(gainWaveDlg,"No") == 0)
    gainw[index]=0
  endif    
  
  if(cmpstr(transWaveDlg,"No") == 0)
    transw[index]=0
  endif    
  
end

static Function grepDataTitle(str,hasCycle,hasChannel,hasScan,cycle,curve,scan,channel)
    string str
    variable &hasCycle,&hasChannel,&hasScan,&cycle,&curve,&scan,&channel

    variable posspace,i, num
    string out, substring
    
    Debugprintf("grepDataTitle in: %s\r",str)

    posspace = strsearch(str," ",0)
    
    if( posspace != -1 )
      str = str[posspace,strlen(str)] // remove comment chars
    endif
    str = stripWhiteSpace(str)
    
    if( strsearch(str,",",0) != -1 )
  //    Debugprint("resetting bool values")
      hasCycle=0 // reset them
      hasChannel=0
      hasScan=0
    endif
        
    for( i=0 ; i < ItemsInList(str,",") ; i+=1)        
        substring = StringFromList(i,str,",")
        substring = stripWhiteSpace(substring)
        num = str2num(StringFromList(1,substring," "))
        DebugPrintf("num is %s\r",num2str(num))
        if( stringmatch(substring,"Cycle:*") )
          hasCycle=1
          cycle = num
        elseif( stringmatch(substring,"Curve:*") )
          curve = num
        elseif( stringmatch(substring,"Scan:*") )
          hasScan=1
          scan = num
        elseif( stringmatch(substring,"Channel:*") )
          hasChannel=1
          channel = num
        endif
    endfor

     sprintf out, "Cycles=%d, Curves=%d, Scans=%d,Channels=%d", cycle, curve, scan,channel
    Debugprintf ("grepDataTitle out: %s\r", out)
end

static Function/S grepLine(str,option)
    string str, &option
    
    variable posdp,posspace, length
    
  //  Debugprintf("grepLine: %s\r", str)
    length=strlen(str)
    posdp = strsearch(str,":",0)
    posspace = strsearch(str," ",0)
    
    if( posspace == -1)
      option=""
      return ""
    endif
    
    if( posdp == -1) // needed to support multiline comments
      option = str[posspace,length-1]
    else  
      option = str[posdp+1,length-1]
    endif
    
    option = stripwhitespace(option)
    str = str[posspace+1,posdp]
    str = stripwhitespace(str)
    Debugprintf("Type is _%s_\r",str)
    Debugprintf("Option is _%s_\r",option)
    return str
end

static Function/S stripwhitespace(str)
    string str
    
    variable i=0,j=0, length=strlen(str)
  //  Debugprintf("before is %s\r",str)
    for( i=0 ; i< length; i+=1)
      if(cmpstr(str[i]," ") != 0 && cmpstr(str[i],"\t") != 0)
        break
      endif
    endfor
    
    for( j=length-1 ; j != 0; j-=1)
      if(cmpstr(str[j]," ") != 0 && cmpstr(str[i],"\t") != 0)
        break
      endif
    endfor  
    
    str=str[i,j]
//    Debugprintf("after is %s\r",str)
    return str
    
end

static Function isDataLine(str,col1,col2,col3,col4,col5)
    string str
    variable &col1,&col2,&col3,&col4,&col5
    
    col1 = 0
    col2 = 0
    col3 = 0
    col4 = 0
    col5 = 0
    
    variable tmp1, tmp2, tmp3, tmp4, tmp5, valRead
    
    sscanf str, "%g \t%g \t%g \t%g\t%g", tmp1, tmp2, tmp3, tmp4, tmp5
    valRead = V_flag
    
    if( valRead < 2  )
      return 0
    elseif(valRead == 2)
      col1 = tmp1
      col2 = tmp2
    elseif(valRead == 3)
      col1 = tmp1
      col2 = tmp2
      col3 = tmp3
    elseif(valRead == 4)
      col1 = tmp1
      col2 = tmp2
      col3 = tmp3
      col4 = tmp4
    elseif(valRead == 5)
      col1 = tmp1
      col2 = tmp2
      col3 = tmp3
      col4 = tmp4
      col5 = tmp5
    endif
    
    return 1    
end

static Function/S removeTrailingCR(str)
    string str
    
    if(cmpstr(str[strlen(str)-1],"\r") == 0)
      str = str[0,strlen(str)-2]
    endif
    return str
end

static Function checkEnergyScale(w, num,eps)
    Wave w
    variable num,eps

    variable j
    for( j = 1 ; j < num ; j+=1 ) // check to see if we have aquidistante energy scale
      if( abs( w[1] - w[0] - ( w[j] - w[j-1]) )  >= eps) 
        return 0
      endif
    endfor
    return 1
end

static Function currentIsNewerOrEqual(currentVersion,version)
    string version,currentVersion
    
    variable minorVer,majorVer,revision=0,currentMinorVer,currentMajorVer,currentRevision=0
    
    sscanf currentVersion, "%d%*[.]%d%*[-r]%d", currentMajorVer, currentMinorVer, currentRevision
    sscanf version, "%d%*[.]%d%*[-r]%d", majorVer, minorVer, revision
    
    if(currentMajorVer >= majorVer && currentMinorVer >= minorVer && currentRevision >= revision)
//      DebugPrint("Yes it is newer or equal")
      return 1
    else
      return 0
    endif
end

static Function DebugPrint(str)
	string str
//	print str
end

static Function Debugprintf(format, out)
		String format, out
//		printf format, out
end


Function ButtonProc_SetScale(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Variable newWidth
			VAriable aLow
			
			WAVE sw1 = root:Load_and_Set_Panel:sw1	
			//WAVE ListWave = root:Load_and_Set_Panel:ListWave	
			Setdatafolder root:Specs:
			SVAR list_folder 	= 	root:Specs:list_folder
			SVAR list_file_path 	= 	root:Specs:list_file_path
			SVAR list_file_name  	= 	root:Specs:list_file_name 
			STRING name1,name2
			Variable i,j,k, number
			SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
			SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
			
			ControlInfo /W=Load_and_Set_Panel list0
			name1 = S_DataFolder  + S_Value
			WAVE/T ListWave = $name1
			
			Variable number1
			number1 = ItemsInList( list_folder ) 
			
			Variable delta
			Variable offset
			Variable deltaA = 0.14881
			Variable startingN = 1
			Variable endAt =number1
			Variable correction = 0
			
			Prompt deltaA, "Delta:"
			Prompt startingN, "Start From:"
			Prompt endAt,"End At:"
			DoPrompt "Choose:  Delta, Starting Number and End Number",deltaA,startingN,endAt
			if (V_Flag)
				return 0									// user canceled
			endif
			
			DoWindow/F Blended_Panel					//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow Blended_Panel
			endif
			
			for( i = startingN -1 ; i<(endAt) ; i = i +1 )
				name2 =  ListWave[i][1]
				if(	 cmpstr ( name2, "") == 0  )
				
				else
					SetDataFolder root:Specs:$name2
					WAVE wave1 = $listWave[i][1]
					WAVE Angle_2D
					
					newWidth = DimSize(wave1,1) *deltaA
					listWave[i][4] = num2str(newWidth)
					aLow = (deltaA - newWidth )/2
					
           			 	SetScale/P y, aLow , deltaA, "Angle [deg]" $name2

           			 	//Set_Angle_2D( i )
				endif
				
			endfor
			
			break
	endswitch

	return 0
End

Function RemoveDefects(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:Specs:
			//SetVariable gamma1,value= _NUM:1
			
			Variable/G PhotonEnergy, WorkFunction
			Variable/G Multiplier, AngleOffset
			Variable/G KineticFermi
			
			Variable PE, WF ,AS , KF
			
			Controlinfo /W=Profiles_FinalBlend valdisp0
			Variable status
			status = cmpstr ( ba.ctrlName , "shiftA" )
			if ( status  == 0 )
				if( abs ( V_value ) < 0.01 )
					return 0
				endif
				//ValDisplay valdisp0,value= _NUM: ( AngleOffset - V_value )
				AS =  V_value + AngleOffset
				//ValDisplay valdisp0,value= _NUM: ( AngleOffset - V_value )
			else
				AS = 0
			endif
			
			DoWindow/F Final_Blend					//pulls the window to the front
			If(V_flag == 0)									//checks if there is a window....
				return 0
			endif
			
			PE = PhotonEnergy
			WF = WorkFunction
			Variable Resolution 
			Resolution = Multiplier
			
			if(KineticFermi == 0 )
				KF = PhotonEnergy - WorkFunction
				Prompt PE, "Photon Energy in eV"
				Prompt WF, "Work Function in eV"
				Prompt Resolution, "Multiplication factor"		
				DoPrompt "PARAMETERS TO PUT",PE,WF, Resolution
				
				PhotonEnergy = PE
				WorkFunction = WF
				Multiplier = Resolution
				KineticFermi = 0
				if (V_Flag)
					return -1		// Canceled
				endif
			else
				KF = KineticFermi
				Prompt PE, "Photon Energy in eV"
				Prompt WF, "Work Function in eV"
				Prompt KF, "Kinetic Energy of Fermi level in eV"
				Prompt Resolution, "Multiplication factor"		
				DoPrompt "PARAMETERS TO PUT",PE,WF, KF, Resolution
				
				PhotonEnergy = PE
				WorkFunction = WF
				KineticFermi = KF
				Multiplier = Resolution
				if (V_Flag)
					return -1		// Canceled
				endif
			endif
			
			WAVE ImageLRmK1
			Duplicate/O/O ImageLRmK1 FinalBlendBE
			PhotonEnergy = PE
			WorkFunction = WF
			Multiplier = Resolution
			
			if ( status  == 0 )
				AngleOffset = AS
			else
				AngleOffset = AngleOffset + AS
			endif
			
			AS = AngleOffset
			
			WAVE Amatrix=FinalBlendBE
			Variable Ymin,Ymax , Xmin, Xmax
			
			Xmin = DimOffset(Amatrix,1) 
			Ymin = DimOffset(Amatrix,0) 
			Xmax = DimOffset(Amatrix,1) + ( Dimsize(Amatrix,1) - 1 ) * DimDelta(Amatrix,1)
			Ymax = DimOffset(Amatrix,0) + ( Dimsize(Amatrix,0) - 1 ) * DimDelta(Amatrix,0)
			
			//Ymin=DimOffset(Amatrix,0) 
			//Ymax=DimOffset(Amatrix,0) + (dimsize(Amatrix,0)-1) *DimDelta(Amatrix,0)
			if(KineticFermi == 0 )
				SetScale/I x,Ymin-PhotonEnergy + WF,Ymax-PhotonEnergy + WF, "Binding Energy [eV]" FinalBlendBE		
			else
				SetScale/I x,Ymin-KineticFermi,Ymax-KineticFermi, "Binding Energy [eV]" FinalBlendBE	
			endif
			//SetScale/I x , Ymin - PhotonEnergy + WF , Ymax - PhotonEnergy + WF, "Binding Energy [eV]" FinalBlendBE
			SetScale/I y , Xmin - AS , Xmax - AS , "Angle [deg]" FinalBlendBE
			
			Duplicate/O/O FinalBlendBE, FinalBlendBE2dif
			FinalBlendBE2dif = 0
		
			Variable Rows, Columns
			Rows = DimSize(FinalBlendBE, 0 )
			Columns = DimSize(FinalBlendBE, 1 )
					
			Wave v1, v2
			Make/O/N =(Rows)  v1 
			Make/O/N =(Rows)  v2 
			Make/O/N =(Rows)  v3
			
			WAVE AmatrixDif = FinalBlendBE2dif
			//WAVE AmatrixDif1 = FinalBlendBE2dif1
			Variable i,j
			Variable Average1,Average2
			Variable help1 , Columns1
			
			Columns1 = Columns -1
			//for(i = 0 ; i < Columns1 ; i+= 1)	// Initialize variables;continue test
			//	v1 =  Amatrix[p][i]
			//	v2 =  Amatrix[p][i+1]
				
				//WaveStats /M=1 v1
			//	Average1 = 0
			//	for(j = 0 ; j < Rows ; j+=1)	// Initialize variables;continue test
			//		Average1 =  v1[j] + Average1
			//	endfor 
			//	Average1 = Average1/Rows
				
				//WaveStats /M=1 v1
				//Average1 = V_avg
				
				//WaveStats /M=1 v2
				//Average2 = V_avg
				
			//	Average2 = 0
			//	for(j = 0 ; j <Rows ; j+=1)	// Initialize variables;continue test
			//		Average2 =  v2[j] + Average2
			//	endfor 
			//	Average2 = Average2/Rows
				
			//	help1 = Average1/Average2
			//	Amatrix[][i+1] = v2[p] * help1
					
				//if(Average1 > Average2)
				//	help1 = Average1/Average2
				//	Amatrix[p][i+1] = v2 * help1
					//v2 = Amatrix[p][i+1]
				//else
				//	help1 = Average2/Average1
				//	Amatrix[p][i] = v1 * help1
					//v1 = Amatrix[p][i]
				//endif
			//endfor
			for(i = 0; i <Columns;i+=1)	// Initialize variables;continue test
				Redimension/N =(Rows)  v1
				v1 =  FinalBlendBE[p][i]
				Differentiate/METH=0/EP=1 v1
				Differentiate/METH=0/EP=1 v1
				FinalBlendBE2dif[][i] = -v1[p]
			endfor
			
			//for(i = 0; i <Rows;i+=1)	// Initialize variables;continue test
			//	v1 =  AmatrixDif1 [i][p]
			//	Integrate v1 /D=v2
			//	FinalBlendBEx [i][] = v2[q]// + FinalBlendBE[0][q]
			//endfor
			KillWaves v1,v2,v3
			
			//Wave v1
			//Make/O/N =(Columns)  v1 
			//WAVE AmatrixDifx = FinalBlendBE2difx	
			//for(i = 0; i <Rows;i+=1)	// Initialize variables;continue test
			//	v1 =  Amatrix[i][p]
			//	Differentiate v1
			//	AmatrixDifx [i][] = v1[q]
			//	Differentiate v1
				//AmatrixDifx [i][] = -v1[q]
			//endfor
			//KillWaves v1
			
			//AmatrixDifx = AmatrixDifx - AmatrixDif1
			WAVE Amatrix = FinalBlendBE
			WAVE AmatrixDif = FinalBlendBE2dif
				
			NVAR PhotonEnergy
			NVAR WorkFunction
			PE = PhotonEnergy
			WF = WorkFunction
			
			Xmin=DimOffset(Amatrix,1) 
			Ymin=DimOffset(Amatrix,0) 
			Xmax=DimOffset(Amatrix,1) + (dimsize(Amatrix,1)-1) *DimDelta(Amatrix,1)
			Ymax=DimOffset(Amatrix,0) + (dimsize(Amatrix,0)-1) *DimDelta(Amatrix,0)
				
			Duplicate/O/O FinalBlendBE , KparFinalBlendBE
			Duplicate/O/O FinalBlendBE2dif , KparFinalBlendBE2dif	
			
			WAVE Kmatrix = KparFinalBlendBE
			WAVE KmatrixDif = KparFinalBlendBE2dif
			KparFinalBlendBE = 0
			KparFinalBlendBE2dif = 0
			
			for(i = 0; i <Columns;i+=1)	// Initialize variables;continue test
				for(j = 0; j <Rows;j+=1)
					if(FinalBlendBE2dif[j][i] < 0)
						FinalBlendBE2dif[j][i] = 0
					endif
				endfor
			endfor
			
			//Variable size
			//size = dimsize(Amatrix,1) * Resolution
			Redimension/N=(-1 , Dimsize( Amatrix,1 ) * Resolution) Kmatrix
			Redimension/N=(-1 , Dimsize( Amatrix,1 ) * Resolution) KmatrixDif
				
			variable YL=SelectNumber(sign(Xmin)==+1,Ymax,Ymin)
			variable YR=SelectNumber(sign(Xmax)==+1,Ymin,Ymax)
			setscale/I y,0.512*sqrt(PE-WF+YL)*sin(Xmin*Pi/180),0.512*sqrt(PE-WF+YR)*sin(Xmax*Pi/180),"k\B||\M [Å]" Kmatrix
			//Kmatrix=(y>0.512*sqrt(PE-WF+x)*sin(Xmax*Pi/180) || y<0.512*sqrt(PE-WF+x)*sin(Xmin*Pi/180)) ? Nan : Amatrix(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
				
			setscale/I y,0.512*sqrt(PE-WF+YL)*sin(Xmin*Pi/180),0.512*sqrt(PE-WF+YR)*sin(Xmax*Pi/180),"k\B||\M [Å]" KmatrixDif
			//KmatrixDif=(y>0.512*sqrt(PE-WF+x)*sin(Xmax*Pi/180) || y<0.512*sqrt(PE-WF+x)*sin(Xmin*Pi/180)) ? Nan : AmatrixDif(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
			
			Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
			Variable delta_k_n , delta_k_m , delta_phi , delta_theta
			Variable k_n0 , k_m0 , phi0 , theta0
			Variable phi1 , phi2 , theta1 , theta2
			Variable i_n , j_m 
			Variable n_max , m_max
			Variable i_max , j_max
			Variable i_1 , i_2 , j_1 , j_2
			Variable wL , wR , wU , wD 
			Variable o , o_max , E_o0 , delta_E , E_o
						
			Variable C1,C2
			//C1 = 1/(0.512*sqrt(Energy))
			C2 = 180/Pi
						
			n_max = DimSize (Kmatrix,1)
			m_max = DimSize (Kmatrix,1)
			o_max = DimSize (Kmatrix,0)
						
			k_n0 = DimOffset (Kmatrix,1)
			k_m0 = DimOffset (Kmatrix,1)
			E_o0 = DimOffset (Kmatrix,0)
						
			delta_k_n = DimDelta (Kmatrix,1)
			delta_k_m = DimDelta (Kmatrix,1)
			delta_E = DimDelta (Kmatrix,0)
						
			i_max = DimSize (Amatrix,1) - 1
			j_max = DimSize (Amatrix,1) - 1
						
			phi0 = DimOffset (Amatrix,1)
			theta0 = DimOffset (Amatrix,1)
			theta0 = 0
						
			delta_phi = DimDelta (Amatrix,1)
			delta_theta = DimDelta (Amatrix,1)
						
			k_n = k_n0
			k_m = 0
			E_o = PE-WF+E_o0
						
			for(o=0;o<o_max;o=o+1)
				C1 = 1/(0.512*sqrt(E_o))
				for( n=0;n<n_max;n=n+1)
					phi_n_rad = asin( k_n * C1 )
					phi_n = phi_n_rad * C2
					i_n = (phi_n - phi0)/delta_phi
					if(i_n>=0 && i_n<=i_max)
						//for( m=0;m<m_max;m=m+1)
						theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
						j_m = (theta_m - theta0)/delta_theta
						if(j_m>=0 && j_m<=j_max)	
							i_1 = floor(i_n)
							i_2 = ceil(i_n)
							j_1 = floor(j_m)
							j_2 = ceil(j_m)
							wR = i_n - i_1
							wL = 1 - wR
							wU = j_m - j_1
							wD = 1 - wU
							Kmatrix[o][n] = Amatrix[o][i_1]*wL*wD + Amatrix[o][i_2]*wR*wD + Amatrix[o][i_1]*wL*wU + Amatrix[o][i_2]*wR*wU
						else
							Kmatrix[o][n] = Nan
						endif
						//k_m = k_m + delta_k_m
						//endfor
					else
						Kmatrix[o][n] = Nan
					endif
					//k_m = k_m0
					k_n = k_n + delta_k_n
				endfor
				k_n = k_n0
				E_o = E_o + delta_E
			endfor
				
			k_n = k_n0
			k_m = 0
			E_o = PE-WF+E_o0
			
			for(o=0;o<o_max;o=o+1)
				C1 = 1/(0.512*sqrt(E_o))
				for( n=0;n<n_max;n=n+1)
					phi_n_rad = asin( k_n * C1 )
					phi_n = phi_n_rad * C2
					i_n = (phi_n - phi0)/delta_phi
					if(i_n>=0 && i_n<=i_max)
						//for( m=0;m<m_max;m=m+1)
						theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
						j_m = (theta_m - theta0)/delta_theta
						if(j_m>=0 && j_m<=j_max)	
							i_1 = floor(i_n)
							i_2 = ceil(i_n)
							j_1 = floor(j_m)
							j_2 = ceil(j_m)
							wR = i_n - i_1
							wL = 1 - wR
							wU = j_m - j_1
							wD = 1 - wU
							KmatrixDif[o][n] = AmatrixDif[o][i_1]*wL*wD + AmatrixDif[o][i_2]*wR*wD + AmatrixDif[o][i_1]*wL*wU + AmatrixDif[o][i_2]*wR*wU
						else
							KmatrixDif[o][n] = Nan
						endif
						//k_m = k_m + delta_k_m
						//endfor
					else
						KmatrixDif[o][n] = Nan
					endif
					//k_m = k_m0
					k_n = k_n + delta_k_n
				endfor
				k_n = k_n0
				E_o = E_o + delta_E
			endfor
			
			String name1
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			Wavestats/Q/Z $name1
			NVAR varMin = V_Min
			NVAR varMax = V_max
			Slider contrastmin , limits = {V_min,V_max,0}
			Slider contrastmax ,limits = {V_min,V_max,0}
			
			Duplicate/O/O FinalBlendBE , FinalBlendBE1
			Duplicate/O/O KparFinalBlendBE , KparFinalBlendBE1
			Duplicate/O/O FinalBlendBE2dif , FinalBlendBE2dif1			
			Duplicate/O/O KparFinalBlendBE2dif, KparFinalBlendBE2dif1
			
			DoUpdate
			GetAxis left
			DoUpdate
			SetVariable SetLeftUpper,value= _NUM:V_max
			SetVariable SetLeftLower,value= _NUM:V_min
			GetAxis bottom
			DoUpdate
			SetVariable SetBottomLeft,value= _NUM:V_min
			SetVariable SetBottomRight,value= _NUM:V_max
			DoUpdate
			SetVariable gamma1,value= _NUM:1
			
			name1 = ImageNameList("Final_Blend", "" )
			name1 = StringFromList (0, name1  , ";")
			name1 = "Final_Blend#" + name1
		break
	endswitch

	return 0
End

Function RemoveDefects1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:Specs:
			//Duplicate/O ImageLRmK FinalBlendBE
			Variable/G PhotonEnergy, WorkFunction
			Variable PE, WF ,AS
			
			PE = PhotonEnergy
			WF = WorkFunction
			Variable Resolution
			Prompt PE, "Photon Energy in eV"
			Prompt WF, "Work Function in eV"
			Prompt AS, "Shift the Angle Axis by"	
			Prompt Resolution, "Multiplication factor"	
			Resolution = 1
			DoPrompt "PARAMETERS TO PUT",PE,WF,AS,Resolution
			
			Duplicate/O ImageLRmK FinalBlendBE
			PhotonEnergy = PE
			WorkFunction = WF
			
			if (V_Flag)
				return -1		// Canceled
			endif
			
			WAVE Amatrix=FinalBlendBE
			Variable Ymin,Ymax , Xmin, Xmax
			
			Xmin=DimOffset(Amatrix,1) 
			Ymin=DimOffset(Amatrix,0) 
			Xmax=DimOffset(Amatrix,1) + (dimsize(Amatrix,1)-1) *DimDelta(Amatrix,1)
			Ymax=DimOffset(Amatrix,0) + (dimsize(Amatrix,0)-1) *DimDelta(Amatrix,0)
			
			//Ymin=DimOffset(Amatrix,0) 
			//Ymax=DimOffset(Amatrix,0) + (dimsize(Amatrix,0)-1) *DimDelta(Amatrix,0)
			SetScale/I x,Ymin-PhotonEnergy + WF,Ymax-PhotonEnergy + WF, "Binding Energy [eV]" FinalBlendBE
			SetScale/I y,Xmin - AS,Xmax - AS, "Angle [deg]" FinalBlendBE
			
			Duplicate/O FinalBlendBE, FinalBlendBE2dif
			
			Variable Rows, Columns
			Rows = DimSize(FinalBlendBE, 0 )
			Columns = DimSize(FinalBlendBE, 1 )
					
			Wave v1
			Make/O/N =(Rows)  v1 
			WAVE AmatrixDif = FinalBlendBE2dif
			Variable i	
			for(i = 0; i <Columns;i+=1)	// Initialize variables;continue test
				v1 =  Amatrix[p][i]
				Differentiate v1
				Differentiate v1
				AmatrixDif [][i] = -v1[p]
			endfor
			KillWaves v1
			
			WAVE Amatrix=FinalBlendBE
			WAVE AmatrixDif = FinalBlendBE2dif
				
			NVAR PhotonEnergy
			NVAR WorkFunction
			PE = PhotonEnergy
			WF = WorkFunction
			
			Xmin=DimOffset(Amatrix,1) 
			Ymin=DimOffset(Amatrix,0) 
			Xmax=DimOffset(Amatrix,1) + (dimsize(Amatrix,1)-1) *DimDelta(Amatrix,1)
			Ymax=DimOffset(Amatrix,0) + (dimsize(Amatrix,0)-1) *DimDelta(Amatrix,0)
				
			Duplicate/O/O FinalBlendBE,KparFinalBlendBE
			Duplicate/O/O FinalBlendBE2dif,KparFinalBlendBE2dif	
			
			WAVE Kmatrix=KparFinalBlendBE
			WAVE KmatrixDif=KparFinalBlendBE2dif
			
			//Variable size
			//size = dimsize(Amatrix,1) * Resolution
			Redimension/N=(-1,dimsize(Amatrix,1) * Resolution) Kmatrix
			Redimension/N=(-1,dimsize(Amatrix,1) * Resolution) KmatrixDif
				
			variable YL=SelectNumber(sign(Xmin)==+1,Ymax,Ymin)
			variable YR=SelectNumber(sign(Xmax)==+1,Ymin,Ymax)
			setscale/I y,0.512*sqrt(PE-WF+YL)*sin(Xmin*Pi/180),0.512*sqrt(PE-WF+YR)*sin(Xmax*Pi/180),Kmatrix
			Kmatrix=(y>0.512*sqrt(PE-WF+x)*sin(Xmax*Pi/180) || y<0.512*sqrt(PE-WF+x)*sin(Xmin*Pi/180)) ? Nan : Amatrix(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
				
			setscale/I y,0.512*sqrt(PE-WF+YL)*sin(Xmin*Pi/180),0.512*sqrt(PE-WF+YR)*sin(Xmax*Pi/180),KmatrixDif
			KmatrixDif=(y>0.512*sqrt(PE-WF+x)*sin(Xmax*Pi/180) || y<0.512*sqrt(PE-WF+x)*sin(Xmin*Pi/180)) ? Nan : AmatrixDif(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
		
			String name1
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			Wavestats/Q/Z $name1
			NVAR varMin = V_Min
			NVAR varMax = V_max
			Slider contrastmin,limits={V_min,V_max,0}
			Slider contrastmax,limits={V_min,V_max,0}
					
		break
	endswitch

	return 0
End

Function RemoveDefects2(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Variable i,j
			Variable Rows, Columns
			Variable Average1,Average2
			Variable help1 , Columns1
			Wave v1,v2
			Variable number
			WAVE/T ListWave 	= 	root:Load_and_Set_Panel:ListWave1	
			WAVE sw1			=	root:Load_and_Set_Panel:sw1		
			String name2
			Variable counter1, counter2
			Variable test2
			
			number = DimSize(ListWave,0) 
			number = DimSize(ListWave,0) 
			counter2 = DimSize(ListWave,1) 
			test2 = 0
			for(i = 0; i < number ; i += 1)
				for(j = 0; j < counter2 ; j += 1)
					if( (sw1[i][j] & 2^0) != 0 )
						test2 = i 
						break
					endif
				endfor
				if( test2 != 0 )
					break
				endif
			endfor
			
			i = test2
				
			name2 =  ListWave[i][1]
			if(	 cmpstr ( name2, "") == 0  )
				return 0
			endif
			
			NewDataFolder/O root:Defect_Removal_Tool
			SetDataFolder  root:Defect_Removal_Tool
			
			String name3 = "root:Defect_Removal_Tool:'Angle_2D_'"
			Cut_Frame_2D( i, name3 )
			SetDataFolder  root:Defect_Removal_Tool
			WAVE Angle_2D_
			
			//SetDataFolder root:Specs:$name2
			Rows = DimSize(Angle_2D_, 0 )
			Columns = DimSize(Angle_2D_, 1 )
			Columns1 = Columns -1
			Make/O/N =(Rows)  v1 
			Make/O/N =(Rows)  v2 
			Make/O/N =(Rows)  Crossection1
			
			KillWaves v1,v2
			
			//NewDataFolder/O root:Defect_Removal_Tool
			//SetDataFolder  root:Defect_Removal_Tool
			
			Make/O/N =(Rows)  Crossection1
			Duplicate/O Angle_2D_ , Angle_2D
			
			//Variable nPointsX , nPointsY 
			//Variable val1, val2 
			//WAVE w0 = Angle_2D_
			//WAVE w1 = Angle_2D_smoothed
			//WAVE w2 = Angle_dif_2D
			//WAVE w3 = Angle_dif_2D_smoothed
			//WAVE w4 = Angle_dif2_2D
			
			//val1 =  str2num( ListWave[i][7] ) 
			//val2 =  str2num( ListWave[i][8] ) 
			//nPointsX = DimSize(Angle_2D_,0)
			//nPointsY = DimSize(Angle_2D_,1)
			//Make/O/N =(nPointsX)  v1 
			//Make/O/N =(nPointsY)  v2 
					
			//if(val1 > 0 )
			//	for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
			//		v1 =  w1[p][i]
			//		Smooth val1 , v1
			//		w1[][i] = v1[p]
			//	endfor
			//endif
					
			//if(val2 > 0 )
			//	for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
			//		v2 =  w1[i][p]
			//		Smooth val2 , v2
			//		w1[i][] = v2[q]
			//	endfor
			//endif
			//KillWaves v1,v2
			
			String /G Memory1 
			Variable 	/G start1
			Variable 	/G end1
			Memory1 = "root:Specs:" + name2
			DoWindow/F $"Defect_Removal_Tool"			//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow $"Profiles_FinalBlend"
			//endif
			//------------display the results
			if (V_Flag==1)	
				
			else
				Display/K=1 /W=(400,80,1000,550)
				Dowindow/C $"Defect_Removal_Tool"	
				
				AppendImage /L=bottomImage /B=leftImage Angle_2D
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				
				ControlBar/L 160
				ControlBar/T 105
				
				DoUpdate 
				ModifyGraph margin =40
				ModifyGraph margin(right) =20
				ModifyGraph margin(top) =10
				ModifyGraph margin(bottom)=20
				ModifyGraph mode=2,rgb=(0,0,0)
				DoUpdate 
				//ModifyGraph freePos(leftImage)={0.1,kwFraction}
				//ModifyGraph freePos(bottomImage)={0.1,kwFraction}
				ModifyGraph freePos(leftImage)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage)={0.1,0.6}
				ModifyGraph axisEnab(leftImage)={0.1,1}
				
				DoUpdate 	
				
				AppendToGraph /L=bottomC /B=leftC Crossection1
				ModifyGraph freePos(leftC)={0.1,kwFraction}
				ModifyGraph freePos(bottomC)={0.75,kwFraction}
				ModifyGraph axisEnab(bottomC)={0.1,1}
				ModifyGraph axisEnab(leftC)={0.75,1}
				
				//GetAxis bottomImage
				
				//SetVariable SetBottomLeft,pos={35,5},size={80,20},proc=SetAxis3,title="L" ,disable=2
				//SetVariable SetBottomLeft,fSize=14,limits={-inf,inf,0.01},value= _NUM: V_min
				
				//SetVariable SetBottomRight,pos={35,30},size={80,20},proc=SetAxis3,title="R" ,disable=2
				//SetVariable SetBottomRight,fSize=14,limits={-inf,inf,0.01},value= _NUM:V_max
				
				//GetAxis leftImage
				//DoUpdate 
				//SetVariable SetLeftUpper,pos={25,55},size={90,20},proc=SetAxis3,title="Up" ,disable=2
				//SetVariable SetLeftUpper,fSize=14,limits={-inf,inf,0.01},value= _NUM:V_max
				
				//SetVariable SetLeftLower,pos={20,80},size={100,20},proc=SetAxis3,title="Low" ,disable=2
				//SetVariable SetLeftLower,fSize=14,limits={-inf,inf,0.01},value= _NUM:V_min
				
				//SetVariable Param1,pos={540,10},size={100,20},live=1,title="Gamma" , proc=SetVarProc_Gamma
				//SetVariable Param1,fSize=14,limits={0,inf,0.1},value= _NUM:1
				
				Slider Line1 , pos={100,120} , size={10,400} , proc=moveLine1def , live=1
				Slider Line1 , limits = { 0 , ( DimSize(Angle_2D_,0) - 1 ) , 1 } , value= 0 , side= 0 , vert= 1 , ticks= 0
				
				Slider Line2 , pos={135,120} , size={10,400} , proc=moveLine2def , live=1
				Slider Line2 , limits = { 0 , ( DimSize(Angle_2D_,0) - 1 ) , 1 } , value= 0 , side= 0 , vert= 1 , ticks= 0
				
				Slider Line3 , pos={250,85} , size={300,13} , proc=moveLine3def , live=1
				Slider Line3 , limits = { 0 , ( DimSize(Angle_2D_,1) - 1 ) , 1 } , value= 0 , side= 0 , vert= 0 , ticks= 0
				
				ValDisplay Position1, pos={5,120} , value=0,   title="Pos.",size={80,20},value=0,frame=1,fSize=14
				ValDisplay Position2, pos={5,140} , value=0,  title="unit", size={80,20},value=0,frame=1,fSize=14
				ValDisplay Position3, pos={5,160} , value=0,   title="Pos.",size={80,20},value=0,frame=1,fSize=14
				ValDisplay Position4, pos={5,180} , value=0,  title="unit", size={80,20},value=0,frame=1,fSize=14
				
				Wavestats/Q/Z Angle_2D
				
				TitleBox zmin title="Min",pos={185,35}
				Slider contrastmin,vert= 0,pos={220,35},size={290,16},proc=contrast0
				Slider contrastmin,limits={V_min,V_max,0},ticks= 0,value=V_min
			
				TitleBox zmax title="Max",pos={185,5}
				Slider contrastmax,vert= 0,pos={220,5},size={290,16},proc=contrast0
				Slider contrastmax,limits={V_min,V_max,0},ticks= 0,value=V_max
				
				String listColors 
				listColors = CTabList()
				PopupMenu popup0,pos={10,70},size={45,20},proc=ChangeColor2
				PopupMenu popup0,mode=1,popvalue="Grays",value= "*COLORTABLEPOP*"
				//PopupMenu popup0,mode=1,popvalue="Grays",value= #"\"Grays;VioletOrangeYellow\""
				
				Button RemoveB,pos={5,220},size={85,40},proc=RemoveBackground,title="Remove\r Background"
				Button RemoveB,fSize=14
				
				Button Edge,pos={5,280},size={85,40},proc=FindEdge,title="Find\r Edge"
				Button Edge,fSize=14
				
				Button Straight,pos={5,340},size={85,40},proc=MakeStraight,title="Make\r Straight"
				Button Straight,fSize=14
				
				Button StraightAll,pos={5,400},size={85,40},proc=ApplyStraight,title="Make All\r Straight"
				Button StraightAll,fSize=14 , disable=2
				
				Button RemoveBAll,pos={5,460},size={85,60},proc=ApplyForBackground,title="Remove\r Background\rfor All"
				Button RemoveBAll,fSize=14,disable=2
				
				DoUpdate 
				GetWindow $"Defect_Removal_Tool" wavelist
			endif
		break
	endswitch

	return 0
End

Function MakeStraightAll(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			WAVE/T ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
			SetDataFolder root:Specs:
			WAVE nwave
			SVAR list_folder //= root:Specs:list_folder
			Variable number1
			number1 = ItemsInList( list_folder ) 
			STRING name1, name2
			Variable j , k
			SetDataFolder root:Defect_Removal_Tool:
			WAVE nwave
			if(!WaveExists(nwave ))
				return 0
			endif
			Variable startingN = 1
			Variable endAt =number1
			
			Prompt startingN, "Start From:"
			Prompt endAt,"End At:"
			DoPrompt "Choose:  Starting Number and End Number",startingN,endAt
			if (V_Flag)
				return 0									// user canceled
			endif
			
			for( k = startingN -1; k<(endAt) ;k =k +1 )
			
			//for( k = 0 ; k<(number1) ;k =k +1 )
				//ListWave1[j][column]  = num2str (offset + delta*j)
				//help1 =  str2num (listWave[row][2])
				//if( abs ( Smooth1 - help1 ) > 0.01 )
				//	Smooth1 = str2num (listWave[row][2])
				name1 = listWave1[k][1]
				name2 = "root:Specs:" + name1 
				SetDataFolder root:Specs:$listWave1[k][1]
				WAVE Angle_2D
				WAVE Image =  Angle_2D
				WAVE Image2 = $listWave1[k][1]
				Variable rows, columns
				rows = DimSize(Image,0)
				columns = DimSize(Image,1)
				//SetDataFolder root:Defect_Removal_Tool:
				//WAVE nwave
				//if(!WaveExists(nwave ))
				//	return 0
				//endif
				WAVE wave0 = nwave
				Variable i, i1, i2 , v_min , jmin
				Variable help1,help2 , help3
				for(i=0;i<columns;i=i+1)
					help1 = wave0[i]
					for(j=rows-1;j>=help1;j=j-1)
						Image[j][i] = Image[j-help1][i]
					endfor
					help3 = Image[help1+1][i]
					for(j=help1-1;j>=0;j=j-1)
						Image[j][i] = help3
					endfor
				endfor
			endfor
		break
	endswitch

	return 0
End

Function RemoveBackgroundAll(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			SetDataFolder root:Specs:
			SVAR list_folder //= root:Specs:list_folder
			SetDataFolder root:Defect_Removal_Tool:
			//WAVE temporary1
			NVAR start1 = root:Defect_Removal_Tool:start1
			NVAR end1 = root:Defect_Removal_Tool:end1
			WAVE/T ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
			WAVE nwave
			Variable number1
			number1 = ItemsInList( list_folder ) 
			STRING name1, name2
			Variable j , k
			
			Variable startingN = 1
			Variable endAt =number1
			
			Prompt startingN, "Start From:"
			Prompt endAt,"End At:"
			DoPrompt "Choose:  Starting Number and End Number",startingN,endAt
			if (V_Flag)
				return 0									// user canceled
			endif
			
			for( k = startingN -1; k<(endAt) ;k =k +1 )
			//for( k = 0 ; k<(number1) ;k =k +1 )
				//ListWave1[j][column]  = num2str (offset + delta*j)
				//help1 =  str2num (listWave[row][2])
				//if( abs ( Smooth1 - help1 ) > 0.01 )
				//	Smooth1 = str2num (listWave[row][2])
				name1 = listWave1[k][1]
				name2 = "root:Specs:" + name1 
				SetDataFolder root:Specs:$listWave1[k][1]
				WAVE Angle_2D
				Variable rows, columns
				rows = DimSize(Angle_2D,0)
				columns = DimSize(Angle_2D,1)
				Make/O/N =(rows)  v1 
				Make/O/N =(columns)  v2 
				Wave/D v1
				Wave/D v2
				Variable Smoothing1, smoothing2
				//name1 = TraceNameList("#",";",1)
				//name1 = StringFromList (1, name1  , ";")
				
				Variable i, i1, i2 , v_min , jmin
				Variable help1,help2
				NVAR start1 = root:Defect_Removal_Tool:start1
				NVAR end1 = root:Defect_Removal_Tool:end1
				//start1 = vcsr(A,"")
				//end1 = vcsr(B,"")
				i1 = start1
				i2 = end1
				
				Variable val1, val2
				val1 = str2num (listWave1[k][7])
				val2 = str2num (listWave1[k][8])
	
				WAVE Image =  Angle_2D
				//Duplicate Image, Image2
				for(i=0;i<columns;i=i+1)
					V_min = Image[i1][i]
					for(j=i1;j<i2;j=j+1)
						help1 = Image[j][i]
						if(help1 < V_min)
							V_min = help1
						endif		
					endfor
					for(j=0;j<rows;j=j+1)
						help1 = Image[j][i]
						if(help1 >= 0)
							help2 = help1 - V_min
							if(help2<0)
								Image[j][i] = 0
							else
								Image[j][i] = help2
							endif	
						endif
					endfor
				endfor
			endfor
			
		break
	endswitch

	return 0
End

Function ApplyStraight(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			NVAR flag_straight = root:Load_and_Set_Panel:flag_straight
			WAVE wave1 = root:Defect_Removal_Tool:nwave
			WAVE wave2 = root:Load_and_Set_Panel:nwave
			Redimension /N=(DimSize(wave1,0)) wave2
			wave2 = wave1
			 flag_straight = 1
		break
	endswitch
	
	return 0
End

Function ApplyForBackground(ba)
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			String name4
			name4 = ImageNameList("#",";")
			name4 = StringFromList (0, name4,";")

			WAVE Image =  ImageNameToWaveRef("", name4 )
			
			NVAR start1 = root:Defect_Removal_Tool:start1
			NVAR end1 = root:Defect_Removal_Tool:end1
			NVAR energy1 = root:Load_and_Set_Panel:energy1
			NVAR energy2 = root:Load_and_Set_Panel:energy2
			NVAR flag_back = root:Load_and_Set_Panel:flag_back
			energy1 = DimOffset(Image,0) + DimDelta(Image,0)*start1
			energy2 = DimOffset(Image,0) + DimDelta(Image,0)*end1
			flag_back = 1
			Button RemoveBAll,disable=2
		break
	endswitch

	return 0
End

Function MakeStraight(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			String name1,name2,name3, name4
			Setdatafolder root:Specs:
			WAVE /T W_WaveList
			name3 = ba.win
			name2 = TraceNameList("#",";",1)
			name2 = StringFromList (0, name2, ";")
			name4 = ImageNameList("#",";")
			name4 = StringFromList (0, name4,";")
			WAVE Crossection =TraceNameToWaveRef("", name2 )
			WAVE Image =  ImageNameToWaveRef("", name4 )
			SetDataFolder root:Defect_Removal_Tool:
			if(!WaveExists(nwave ))
				return 0
			endif
			WAVE Wave0 = nwave
			Variable rows, columns
			Variable i, i1, i2 ,j , v_min , k , jmin
			rows = DimSize(Image,0)
			columns = DimSize(Image,1)
			Variable help1,help2
			for(i=0;i<columns;i=i+1)
				help1 = wave0[i]
				for(j=rows-1;j>=help1;j=j-1)
					Image[j][i] = Image[j-help1][i]
				endfor
				//for(j=help1-1;j>=0;j=j-1)
				//	Image[j][i] = 0
				//endfor
			endfor
			name1 = TraceNameList("#",";",1)
			name1 = StringFromList (1, name1  , ";")
			if(cmpstr(name1,"")!=0)
				RemoveFromGraph $name1
			endif
			Crossection[] = Image[p][qcsr(B,"#")]
			DoUpdate
			break
	endswitch

	return 0
End

Function FindEdge(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			String name1,name2,name3, name4
			Setdatafolder root:Specs:
			WAVE /T W_WaveList
			name3 = ba.win
			name2 = TraceNameList("#",";",1)
			name2 = StringFromList (0, name2, ";")
			name4 = ImageNameList("#",";")
			name4 = StringFromList (0, name4,";")
			WAVE Crossection =TraceNameToWaveRef("", name2 )
			WAVE Image =  ImageNameToWaveRef("", name4 )
			Variable rows, columns
			Variable i, i1, i2 ,j , v_min , k , jmin
			rows = DimSize(Image,0)
			columns = DimSize(Image,1)
			if (strlen(csrinfo(A,""))==0)
				break
			endif
			if (strlen(csrinfo(B,""))==0)
				break
			endif
			i1 = pcsr(A,"#")
			i2 = pcsr(B,"#")
			if(i1>i2)
				i2 = pcsr(A,"#")
				i1 = pcsr(B,"#")
			endif
			Variable help1,help2
			Variable points
			points = i2-i1
			SetDataFolder root:Defect_Removal_Tool:
			Make/O/N=(points) Short
			Make/O/N=(columns) xWave
			Make/O/N=(columns) yWave
			Make/O/N=(columns) nWave
			//Make/O/N=columns 
			//Duplicate Image, Image2
			for(i=0;i<columns;i=i+1)
				Short[] = Image[p+i1][i]
				Smooth 200 , short
				Differentiate Short
				V_min = Short[0]
				for(j=1;j<points;j=j+1)
					help1 = Short[j]
					if(help1 < V_min)
						V_min = help1
						jmin = j
					endif		
				endfor
				nwave[i] = jmin 
				xwave[i] = DimOffset(Image,0)  + (i1 + jmin)*DimDelta(Image,0)
				ywave[i] = DimOffset(Image,1)  + i*DimDelta(Image,1)
			endfor
			Variable imax, v_max
			imax = numpnts(nwave)
			v_max = 0
			for(i=0;i<imax;i=i+1)
				help1 = nwave[i]
				if( v_max < help1)
					v_max = help1
				endif
			endfor
			for(i=0;i<imax;i=i+1)
				help1 = nwave[i]
				nwave[i] = v_max - help1
			endfor
			name1 = TraceNameList("#",";",1)
			name1 = StringFromList (1, name1  , ";")
			if(cmpstr(name1,"")!=0)
				RemoveFromGraph $name1
			endif
			AppendToGraph /W=$name3 /B=bottomImage /L=leftImage ywave vs xwave
			Crossection[] = Image[p][qcsr(B,"#")]
			Button StraightAll,disable=0
			DoUpdate
			break
	endswitch

	return 0
End

Function Background(e1,e2)
	Variable e1,e2
	return 0
End

Function RemoveBackground(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	
	switch( ba.eventCode )
		case -1: // control being killed
			DoWindow/F Defect_Removal_Tool				//pulls the window to the front
			If(V_flag != 0)	
				String name1
				RemoveImage /W=Defect_Removal_Tool Angle_2D	
				RemoveFromGraph /W=Defect_Removal_Tool Crossection1
				if(WaveExists(ywave))
					name1 = TraceNameList("#",";",1)
					name1 = StringFromList (0, name1  , ";")
					if(cmpstr(name1,"")!=0)
						RemoveFromGraph $name1
					endif
				endif
				//RemoveFromGraph /W=Defect_Removal_Tool Crossection1
				
				//KillWindow Defect_Removal_Tool	
				KillDataFolder root:Defect_Removal_Tool
				//KillDataFolder root:Defect_Removal_Tool
			endif
			
		break
	
		case 2: // mouse up
			// click code here
			String name2,name3, name4
			Setdatafolder root:Load_and_Set_Panel:
			WAVE /T W_WaveList
			name3 = ba.win
			GetWindow $name3 , wavelist
			//name2 = W_WaveList[1][0]
			//name4 = W_WaveList[0][0]
			name2 = TraceNameList("#",";",1)
			name2 = StringFromList (0, name2, ";")
			name4 = ImageNameList("#",";")
			name4 = StringFromList (0, name4,";")
			WAVE Crossection =TraceNameToWaveRef("", name2 )
			WAVE Image =  ImageNameToWaveRef("", name4 )
			Variable rows, columns
			Variable i, i1, i2 ,j , v_min , k
			rows = DimSize(Image,0)
			columns = DimSize(Image,1)
			if (strlen(csrinfo(A,""))==0)
				break
			endif
			if (strlen(csrinfo(B,""))==0)
				break
			endif
			i1 = pcsr(A,"#")
			i2 = pcsr(B,"#")
			if(i1>i2)
				i2 = pcsr(A,"#")
				i1 = pcsr(B,"#")
			endif
			Variable help1,help2
			NVAR start1 = root:Defect_Removal_Tool:start1
			NVAR end1 = root:Defect_Removal_Tool:end1
			//NVAR energy1 = root:Load_and_Set_Panel:energy1
			//NVAR energy2 = root:Load_and_Set_Panel:energy2
			//energy1 = DimOffset(Image,0) + DimDelta(Image,0)*start1
			//energy2 = DimOffset(Image,0) + DimDelta(Image,0)*end1
			Setdatafolder root:Defect_Removal_Tool:
			WAVE Angle_2D_
			Image = Angle_2D_
			start1 = i1
			end1  = i2
			//Duplicate Image, Image2
			for(i=0;i<columns;i=i+1)
				V_min = Image[i1][i]
				for(j=i1;j<i2;j=j+1)
					help1 = Image[j][i]
					if(help1 < V_min)
						V_min = help1
					endif		
				endfor
				for(k=0;k<rows;k=k+1)
					help1 = Image[k][i]
					if(help1 >= 0)
						help2 = help1 - V_min
						if(help2<0)
							Image[k][i] = 0
						else
							Image[k][i] = help2
						endif	
					endif
				endfor
			endfor
			Crossection[] = Image[p][qcsr(B,"#")]
			Button RemoveBAll,disable=0
			DoUpdate
			break
	endswitch

	return 0
End

Function moveLine1def(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			//Print sa
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1
				String name2 , name3
				
				name1 = ImageNameList("", "" )
				name1 = StringFromList (0, name1  , ";")
				DoUpdate
				Setdatafolder root:Specs:
				
				if (strlen(csrinfo(A,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 A "+name1+" 0,0"
					ValDisplay Position2,value=_NUM:vcsr(A,"")
					SetVariable Position1,value=_NUM:curval
				endif
				if (cmpstr(sa.ctrlName,"Line1")==0)
					//VCS = Image1[p][curval]
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 A "+ name1+ " " + num2str(curval) +",qcsr(A,\"\")"
					ValDisplay Position4,value=_NUM:hcsr(A,"")
					ValDisplay Position3,value=_NUM:curval
					
				endif
				
			endif
			
			if( sa.eventCode  == 4 ) // mouse up
				Setdatafolder root:Specs:
				
				
			
			endif
		break
	endswitch

	return 0
End

Function moveLine2def(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			//Print sa
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1
				String name2 , name3
				
				name1 = ImageNameList("", "" )
				name1 = StringFromList (0, name1  , ";")
				DoUpdate
				Setdatafolder root:Specs:
				
				//WAVE EDC=EDC
				
				
				if (strlen(csrinfo(B,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 B "+name1+" 0,0"
					ValDisplay Position2,value=_NUM:vcsr(A,"")
					SetVariable Position1,value=_NUM:curval
				endif
				if (cmpstr(sa.ctrlName,"Line2")==0)
					//VCS = Image1[p][curval]
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 B "+ name1+ " " + num2str(curval) +",qcsr(B,\"\")"
					ValDisplay Position2,value=_NUM:hcsr(B,"")
					SetVariable Position1,value=_NUM:curval
					
				endif
				
			endif
			
			if( sa.eventCode  == 4 ) // mouse up
				Setdatafolder root:Specs:
				
				
			
			endif
		break
	endswitch

	return 0
End

Function moveLine3def(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			//Print sa
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1
				String name2 , name3 , name4
				WAVE /T W_WaveList
				//WAVE Crossection1
				
				name1 = ImageNameList("", "" )
				name1 = StringFromList (0, name1  , ";")
				
				name3 = sa.win
				GetWindow $name3 , wavelist
				//name2 = W_WaveList[1][0]
				//name4 = W_WaveList[0][0]
				name2 = TraceNameList("#",";",1)
				name2 = StringFromList (0, name2, ";")
				name4 = ImageNameList("#",";")
				name4 = StringFromList (0, name4,";")
				//name4 = GetWavesDataFolder($name2, 1 )
				WAVE Crossection =TraceNameToWaveRef("", name2 )
				WAVE Image =  ImageNameToWaveRef("", name4 )
				//name2 = TraceNameList("",";",0)
				
				DoUpdate
				//Setdatafolder root:Specs:
				
				//WAVE EDC=EDC
				
				
				if (strlen(csrinfo(A,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 A "+name1+" 0,0"
					//ValDisplay Position2,value=_NUM:vcsr(A,"")
					//ValDisplay Position1,value=_NUM:curval
				endif
				if (strlen(csrinfo(B,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 B "+name1+" 0,0"
					//ValDisplay Position2,value=_NUM:vcsr(A,"")
					//ValDisplay Position1,value=_NUM:curval
				endif
				
				if (cmpstr(sa.ctrlName,"Line3")==0)
					//VCS = Image1[p][curval]
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 A "+name1+" pcsr(A,\"\"),"+num2str(curval)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 B "+name1+" pcsr(B,\"\"),"+num2str(curval)
					
					//Crossection[] = Image[p][curval]
					//ValDisplay Position1,value=_NUM:curval
					//ValDisplay Position2,value=_NUM:vcsr(A,"")
					
				endif
				
			endif
			
			if( sa.eventCode  == 4 ) // mouse up
				Setdatafolder root:Specs:
				WAVE /T W_WaveList
				name3 = sa.win
				GetWindow $name3 , wavelist
				//name2 = W_WaveList[1][0]
				//name4 = W_WaveList[0][0]
				name2 = TraceNameList("#",";",1)
				name2 = StringFromList (0, name2, ";")
				name4 = ImageNameList("#",";")
				name4 = StringFromList (0, name4,";")
				WAVE Crossection =TraceNameToWaveRef("", name2 )
				WAVE Image =  ImageNameToWaveRef("", name4 )
				
				if (strlen(csrinfo(A,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 A "+name1+" 0,0"
					//ValDisplay Position2,value=_NUM:vcsr(A,"")
					//ValDisplay Position1,value=_NUM:curval
				endif
				if (strlen(csrinfo(B,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0)/S=2 B "+name1+" 0,0"
					//ValDisplay Position2,value=_NUM:vcsr(A,"")
					//ValDisplay Position1,value=_NUM:curval
				endif
				Crossection[] = Image[p][qcsr(B,"#")]
				DoUpdate
			
			endif
		break
	endswitch

	return 0
End

Function SaveGraph(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			//Save 
			
		break
	endswitch

	return 0
End

Function CursorMoved(info)
	String info
	//Variable isB 					// 0 if A cursor, nonzero if B cursor
	
	Variable result= NaN			// error result
	// Check that the top graph is the one in the info string.
	String topGraph= "G0"
	String graphName= StringByKey("GRAPH", info)
	if( CmpStr(graphName, topGraph) == 0 )
		// If the cursor is being turned off
		// the trace name will be zero length.
		String tName= StringByKey("TNAME", info)
		if( strlen(tName) )			// cursor still on
			String cn
			Variable xVal, yVal
			Variable num2
			
			Setdatafolder root:Load_and_Set_Panel:
			SVAR title_left1 =  title_left1
			SVAR title_right1 =  title_right1
			
			SetDataFolder root:Blending_Panel
			SVAR K1
			Variable help1
			Wave FinalBlendKE
			Wave FinalBlendKE_ori
			
			WAVE TemporaryHoldKE_L
			WAVE TemporaryHoldKE_R
			Variable La1,Ra1
			Variable La2,Ra2
			Variable He1,Le1
			Variable He2,Le2
			Variable index1A,index2A,index3A,index4A
			Variable index1E,index2E,index3E,index4E
			
			//Duplicate/O FinalBlendKEori, FinalBlendKE
			
			Variable aShift
			ControlInfo setvar1
			aShift = V_value
			
			Variable eShift
			ControlInfo setvar0
			eShift = V_value
			
			Variable checked
			ControlInfo check0
			checked = V_value
			
			Variable n1, n2
			Variable deltaA
			Variable deltaE
			
			n1 = DimSize(FinalBlendKEori,0) 
			n2 = DimSize(FinalBlendKEori,1) + aShift
			deltaA = DimDelta(FinalBlendKEori,1)
			deltaE = DimDelta(FinalBlendKEori,0)
			//Redimension /N=(n1,n2) FinalBlendKE
			Redimension /N=(n1,n2) TemporaryHoldKE_L
			Redimension /N=(n1,n2) TemporaryHoldKE_R
			
			Setdatafolder root:Load_and_Set_Panel:
			Wave Angle_2D = L_image1		
			
			SetDataFolder root:$"Blending_Panel"
			Duplicate/O Angle_2D, L_Image
			
			WAVE L_Image_dif
			
			La1 = DimOffset(L_Image,1)
			Ra1 = DimOffset(L_image,1) + (DimSize(L_image,1)-1)*DimDelta(L_image,1)
			He1 = DimOffset(L_image,0) + (DimSize(L_image,0)-1)*DimDelta(L_image,0)
			Le1 = DimOffset(L_image,0)
			
			Setdatafolder root:Load_and_Set_Panel:
			Wave Angle_2D = R_image1		
			
			SetDataFolder root:$"Blending_Panel"
			Duplicate/O Angle_2D, R_Image
			
			WAVE R_Image_dif
			
			La2 = DimOffset(R_image,1)
			Ra2 = DimOffset(R_image,1) + (DimSize(R_image,1)-1)*DimDelta(R_image,1)
			He2 = DimOffset(R_image,0) + (DimSize(R_image,0)-1)*DimDelta(R_image,0)
			Le2 = DimOffset(R_image,0)
			
			index1A = round ( ( La1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
			index3A = round ( ( Ra1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) 
			index2A = round ( ( La2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )+aShift
			index4A = round ( ( Ra2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )+aShift
			
			index1E = round ( ( Le1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
			index3E = round ( ( He1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
			index2E = round ( ( Le2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )+eShift
			index4E = round ( ( He2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )+eShift
			
			if(checked)
				TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image_dif(x)(y)
			else
				TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image(x)(y)
			endif
			
			//TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image(x)(y)
			
			SetScale/P y, La2 + aShift*deltaA, deltaA, "" R_Image
			SetScale/P x, Le2 + eShift*deltaE, deltaE, "" R_Image
			
			SetScale/P y, La2 + aShift*deltaA, deltaA, "" R_Image_dif
			SetScale/P x, Le2 + eShift*deltaE, deltaE, "" R_Image_dif
			
			if(checked)
				TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image_dif(x)(y)
			else
				TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
			endif
			
			//if( isB )
			//	xVal= hcsr(B)
			//	cn= "Cursor B"
			//else
			yVal = hcsr ( A , "Blended_Panel#G0" )
			xVal = vcsr ( A , "Blended_Panel#G0" )
			cn= "Cursor A"
			//execute /Z/Q "Cursor /A=0 /W=Blended_Panel#G0 B tImageLR "
			execute/Z/Q "Cursor /W=Blended_Panel#G0 /K B"
			
			SetDataFolder root:Blending_Panel
			NVAR Normalization
			TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
			
			Variable index3Anew
			index3Anew = (xVal - DimOffset(FinalBlendKE, 1)) / DimDelta(FinalBlendKE,1)
			if(index3Anew >= index2A && index3Anew <= index3A)	
				Duplicate/O FinalBlendKEori, FinalBlendKE
				Redimension /N=(n1,n2) FinalBlendKE
				
				ControlInfo /W=Blended_Panel buttonUD
				num2 = strsearch(S_recreation,"Down",0)
				//if(num2 != -1)
					FinalBlendKE[index2E,index4E][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
					FinalBlendKE[index1E,index3E][index1A,Index3Anew] = TemporaryHoldKE_L[p][q]
					
				//else
				//	FinalBlendKE[index1E,index3E][index1A,Index3Anew] = TemporaryHoldKE_L[p][q]
				//	FinalBlendKE[index2E,index4E][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
					
				//endif
			
			endif
			Print cn+" on "+tName+" moved to x= ",xVal,"y= ",yVal
		endif
	endif
	return result
End

Function CursorDependencyForGraph()
	//String graphName= "Blended_Panel#G0"
	String graphName= "G0"
	//String graphName=WinName(0,1)
	if( strlen(graphName) )
		String df= GetDataFolder(1);
		NewDataFolder/O root:WinGlobals
		NewDataFolder/O/S root:WinGlobals:$graphName
 		String/G S_CursorAInfo//, S_CursorBInfo
		Variable/G dependentA
		SetFormula dependentA, "CursorMoved(S_CursorAInfo)"
 		//Variable/G dependentB
		//SetFormula dependentB,"CursorMoved(S_CursorBInfo, 1)"
		SetDataFolder df
	endif
End

Function ButtonProc_Fit(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			String name1 = ba.ctrlName
			
			SetDataFolder root:Specs:	
			WAVE Crossection6
			WAVE Crossection7
			WAVE Crossection8
			WAVE Crossection9
			Variable num1,num2
			ControlInfo /W=Blended_Panel buttonUD
			num2 = strsearch(S_recreation,"Down",0)
			//Print S_recreation
			Variable La1, Ra1
			Variable La2, Ra2
			Variable x1,x2,x3,x4
			Variable Le1,Le2,He1,He2
			Variable y1,y2,y3,y4
	
			WAVE L_image1
			WAVE R_image1
			WAVE tImageLR
			WAVE tImageLR1
			WAVE tImageLR2
	
			Variable n1, n2
			NVAR AngleShift
			NVAR EnergyShift
			Variable AS = AngleShift
			Variable ES = EnergyShift
			Variable value
			
			strswitch(name1)
				case "buttonFit2":
					num1 = - EnergyShift
					n1 = DimSize(tImageLR,0) - EnergyShift
					n2 = DimSize(tImageLR,1) 
					//Redimension /N=(n1 , n2 ) tImageLR
					Le1 = DimOffset(L_image1, 0)
					He1 = DimSize(L_image1,0)* DimDelta(L_image1,0) + Le1
					Le2 = DimOffset(R_image1, 0)
					He2 = DimSize(R_image1,0) * DimDelta(R_image1,0) + Le2
					y1 = 0
					y2 = (He1 - DimOffset(tImageLR, 0))/DimDelta(tImageLR,0) 
					y3 = (Le2 - DimOffset(tImageLR, 0))/DimDelta(tImageLR,0) 
					y4 = (He2 - DimOffset(tImageLR, 0))/DimDelta(tImageLR,0) 
					
					La1 = DimOffset(L_image1, 1)
					Ra1 = DimSize(L_image1,1)* DimDelta(L_image1,1) + La1
					La2 = DimOffset(R_image1, 1)
					Ra2 = DimSize(R_image1,1) * DimDelta(R_image1,1) + La2
					x1 = 0
					x2 = (Ra1 - DimOffset(tImageLR, 1))/DimDelta(tImageLR,1) 
					x3 = (La2 - DimOffset(tImageLR, 1))/DimDelta(tImageLR,1)  + AngleShift
					x4 = (Ra2 - DimOffset(tImageLR, 1))/DimDelta(tImageLR,1)  + AngleShift
					

					if(num2 != -1)
						tImageLR[y3,y4][x3,x4] =   tImageLR2[p - EnergyShift][q - AngleShift]
						tImageLR[y1 ,y2][x1,x2] =  tImageLR1[p][q]
						ValDisplay valdisp1,value=_NUM:EnergyShift *DimDelta(tImageLR,0)
					else
						tImageLR[y1,y2][x1,x2] =  tImageLR1[p][q]
						tImageLR[y3,y4][x3,x4] =   tImageLR2[p - EnergyShift][q - AngleShift]
						ValDisplay valdisp1,value=_NUM:EnergyShift *DimDelta(tImageLR,0)
					endif
					
					NVAR shift1 = root:Specs:shift1
					Variable shift2 , shift3
					Variable  j1, j2, i1,i2, jmax, imax
					Variable sum1
					Variable n,m
					Variable max1
					Variable help1,help2,help3 ,help4,help5, help6,help7,help8
					Variable counter1
					NVAR imin = root:Specs:imin
					NVAR jmin = root:Specs:jmin
					Variable jmax1
					NVAR val_slider4 = root:Specs:val_slider4
					Variable i, j
					WAVE L_image
					WAVE R_image
					//shift1 = 20
					//shift2 = shift1 * 2
					//shift3 = shift2 + 1
			
					jmax1 = n2
					//jmax  = fh1.nCurves
					//imax  = fh1.nValues
					Make /O/N=(jmax1) Matrix
					help6 = 10000
					//i and j are the index numbers of the Matrix ... formed by the differnce of the 2 window_images
					//this loop is looking for minimum of 2 differentiated window_images
			
					for(j = 0; j <jmax1;j+=1)
						help8 = j + 1 - jmax
						for(i = 0; i <shift3;i+=1)
							sum1 = 0
							counter1= 0
							help1 = imax - abs ( shift1 - i ) 
							help2 = i - shift1
						if(i < shift1)
							for ( j1 = jmax - j - 1; j1<jmax ; j1+=1)
								j2 = j1 + help8
								//j2 = j1 - jmax + 1 + j
								//help1 = imax - abs ( shift1 - i ) 
								//help2 = i - shift1
								for(i1 = 0 ; i1 < help1; i1 +=1)
									i2 = i1 - help2
									help4 = L_image[i1][j1]
									help5 = R_image[i2][j2]
									sum1 = sum1 + abs(help4 - help5)
									counter1 += 1
								endfor
							endfor
						else
							for ( j1 = jmax - j - 1; j1<jmax ; j1+=1)
								j2 = j1 + help8
								//j2 = j1 - jmax + 1 + j
								//help1 = imax - abs ( shift1 - i ) 
								//help2 = i - shift1
								for(i2 = 0 ; i2 < help1; i2 +=1)
									i1 = i2 + help2
									help4 = L_image[i1][j1]
									help5 = R_image[i2][j2]
									sum1 = sum1 + abs(help4 - help5)
									counter1 += 1
								endfor	
							endfor	
						endif
						help7 = sum1/counter1
						if(  help7 < help6 )
							help6 = help7
							imin = i
							jmin = j
						endif
						help7 = sum1/counter1
						Matrix[i][j] = sum1/counter1	
					endfor
				endfor
			
				print imin
				print jmin
				Killwaves v2,v1
					
					break
				case "buttonFit1":
					num1 = - AngleShift 
					n1 = DimSize(tImageLR,0)
					n2 = DimSize(tImageLR,1) - AngleShift
					Redimension /N=(n1 , n2 ) tImageLR
					Le1 = DimOffset(L_image1, 0)
					He1 = DimSize(L_image1,0)* DimDelta(L_image1,0) + Le1
					Le2 = DimOffset(R_image1, 0)
					He2 = DimSize(R_image1,0) * DimDelta(R_image1,0) + Le2
					y1 = 0
					y2 = (He1 - DimOffset(tImageLR, 0))/DimDelta(tImageLR,0) 
					y3 = (Le2 - DimOffset(tImageLR, 0))/DimDelta(tImageLR,0) 
					y4 = (He2 - DimOffset(tImageLR, 0))/DimDelta(tImageLR,0) 
					
					La1 = DimOffset(L_image1, 1)
					Ra1 = DimSize(L_image1,1)* DimDelta(L_image1,1) + La1
					La2 = DimOffset(R_image1, 1)
					Ra2 = DimSize(R_image1,1) * DimDelta(R_image1,1) + La2
					x1 = 0
					x2 = (Ra1 - DimOffset(tImageLR, 1))/DimDelta(tImageLR,1)
					x3 = (La2 - DimOffset(tImageLR, 1))/DimDelta(tImageLR,1)  
					x4 = (Ra2 - DimOffset(tImageLR, 1))/DimDelta(tImageLR,1)  
					
					
					if(num2 != -1)
						tImageLR[y3,y4][x3,x4] =   tImageLR2[p - EnergyShift][q - AngleShift]
						tImageLR[y1,y2][x1 ,x2] =  tImageLR1[p][q]
						ValDisplay valdisp0,value=_NUM:AngleShift *DimDelta(tImageLR,1)
					else
						tImageLR[y1,y2][x1 ,x2] =  tImageLR1[p][q]
						tImageLR[y3,y4][x3,x4] =   tImageLR2[p - EnergyShift][q - AngleShift]
						ValDisplay valdisp0,value=_NUM:AngleShift *DimDelta(tImageLR,1)
					endif
				
				break
			endswitch
			
			break
	endswitch

	return 0
End

Function Mirror_Image(wave_source)
	WAVE wave_source
	ImageRotate /O/V wave_source
	return 0
End

Function Mirror_Image2(wave_name )
	WAVE wave_name
	
	WAVE wave1 = wave_name
	//WAVE wave2
	Variable nop
	Duplicate/FREE wave1, wave2
	nop = DimSize(wave1,1)
	Variable i ,j
	for (i = 0 , j = nop -1; i<nop; i = i+1 , j = j -1)
		wave1[][i] = wave2[p][j]
	endfor
	return 0
End

Function ButtonProc_SaveExperiment(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			SetDataFolder root:Load_and_Set_Panel:
			WAVE/T ListWave1 
			WAVE/T ListWave2
			WAVE sw1
			WAVE sw2
			Duplicate/O/T ListWave1, ListWave2
			Duplicate/O sw1, sw2
			
			Variable number2
			SetDataFolder root:Specs:
			SVAR list_folder //= root:Specs:list_folder
			number2 = ItemsInList(list_folder)
			
			//Redimension /N=( -1 , DimSize(ListWave1,1) + 1) ListWave2
			Variable i
			Variable number1
			
			number1 = DimSize(ListWave1,0)
			String list_of_waves=""
			String name1
			list_of_waves=AddListItem("ListWave2", list_of_waves, ";", Inf)
			list_of_waves=AddListItem("sw2", list_of_waves, ";", Inf)
			
			for(i = 0; i < number2; i = i +1)
				SetDataFolder root:Specs:$ListWave1[i][1]
				Wave nwave
				SetDataFolder root:Load_and_Set_Panel:
				name1 = "wave" + num2str(i)
				Duplicate nwave , $name1	
				list_of_waves=AddListItem(name1, list_of_waves, ";", Inf)
			endfor
			Save/J /T /B list_of_waves as "experiment.txt"
			
			SetDataFolder root:Load_and_Set_Panel:
			KillWaves ListWave2,sw2
			for(i = 0; i < number2; i = i +1)
				name1 = "wave" + num2str(i)
				Wave waveL = $name1
				KillWaves waveL
			endfor
			SetDataFolder root:
			break
	endswitch

	return 0
End

Function ButtonProc_LoadExperiment(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			SetDataFolder root:Load_and_Set_Panel:
			WAVE/T ListWave1 

			//WAVE/T ListWave2
			WAVE sw1	
			String name1
			variable extension, help1
			String file_name2
			Variable i
			Variable numberCol = DimSize(ListWave1,1)
			
			LoadWave  /J /T /K=0 /Q " "

			file_name2 	= 	S_path	
			If(V_flag == 0)
				file_name2 	= 	S_fileName	
				extension = 0
				help1  = strsearch(file_name2,".sr",0)
				if( help1 > -1 )
					name1 = file_name2
				else
					return 0
				endif
				NewPath /Q /O path1 S_path
				//PathInfo /SHOW path1
				if(waveexists (i4table0) != 0 )
					KillWaves i4table0 
				endif
				LoadWave  /A=i4table /J /M /K=2/O /P=path1 /M name1
				If(V_flag == 0)
					return 0
				endif
				Wave/T i4table0
				variable size1
				size1 = DimSize( i4table0,0) 
				Make /T/O /N=(size1-2,20) ListWave2 
				Make /O /N=(size1-2,20) sw2 
				ListWave2[][0] = num2str(p+1)
				ListWave2[][1] = i4table0[p+1][1]
				ListWave2[][2] = num2str(0)
				ListWave2[][3] = i4table0[p+1][3]
				ListWave2[][7] = num2str(0)
				ListWave2[][9] = num2str(1)
				ListWave2[][10] = num2str(str2num(i4table0[p+1][7])*  str2num(i4table0[p+1][8])/1000)
				ListWave2[][11] = i4table0[p+1][2]
				ListWave2[][12] = num2str(4.5)
				ListWave2[][13] =  num2str(str2num(i4table0[p+1][2]) -  4.5)
				ListWave2[][14] = num2str(0)
				ListWave2[][15] = num2str(0)
				ListWave2[][16] = num2str(0)
				ListWave2[][17] = num2str(0)
				ListWave2[][18] = num2str(0)
				ListWave2[][19] = num2str(0)
				sw2[][] = 2
				sw2[][1] =0
				sw2[][16] = 32
				sw2[][17] = 32
				sw2[][18] = 32
				sw2[][19] = 32
				
				Load_Files(S_path, ListWave2 , sw2)
				KillWaves ListWave2,sw2,i4table0
				return 0
			endif
			
			name1 = StringFromList(0, S_WaveNames)
			if( cmpstr(name1, "ListWave2") != 0 )
				break
			endif
			WAVE/T ListWave2
			name1 = StringFromList(1, S_WaveNames)
			if( cmpstr(name1, "sw2") != 0 )
				break
			endif
			WAVE sw2 = $name1  
			
			Load_Files(file_name2, ListWave2 , sw2)
			
			SetDataFolder root:Specs:
			Variable number2 
			SVAR list_folder //= root:Specs:list_folder
			number2 = ItemsInList(list_folder)
			
			SetDataFolder root:Load_and_Set_Panel:
			KillWaves ListWave2,sw2
			for(i = 0; i < number2; i = i +1)
				name1 = "wave" + num2str(i)
				Wave waveL = $name1
				KillWaves waveL
			endfor
			SetDataFolder root:
		break
	endswitch

	return 0
End

Function Load_Files( file_name2, ListWave2,sw2)
	String file_name2
	WAVE/T &ListWave2
	WAVE sw2
	
	Struct file_header set
	SetDataFolder root:Load_and_Set_Panel:
	Variable j
	WAVE/T ListWave1
	WAVE sw1
	SVAR Title_left1
	SVAR Title_right1

	//KillDataFolder root:Specs:
	If( cmpstr ( Title_left1, "") != 0 )
		RemoveImage /W=Load_and_Set_Panel#G0 L_image1
	endif
	If( cmpstr ( Title_right1, "") != 0 )
		RemoveImage /W=Load_and_Set_Panel#G1 R_image1
	endif
	DoWindow/F Blended_Panel					//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		KillWindow Blended_Panel
	endif
			
	DoWindow/F Profiles_FinalBlend					//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		KillWindow Profiles_FinalBlend	
	endif
			
	DoWindow/F Final_Blend				//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		KillWindow Final_Blend		
	endif
			
	DoWindow/F Multiple_Panel					//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		KillWindow Multiple_Panel	
	endif
	
	DoWindow/F $"Display_and_Extract2"				//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		KillWindow $"Display_and_Extract2"
	endif
			
	DoWindow/F $"Display_and_Extract"				//pulls the window to the front
	If(V_flag != 0)									//checks if there is a window....
		KillWindow $"Display_and_Extract"
	endif
			
	String nameA
	//SetWindow Load_and_Set_Panel#G3
	nameA = ImageNameList("Load_and_Set_Panel#G3", "" )
	nameA = StringFromList(0, nameA)
	if( cmpstr (nameA, "")  == 1 ||  cmpstr (nameA, "")  == -1)
		RemoveImage /W=Load_and_Set_Panel#G3 $nameA
	endif
	
	nameA = ImageNameList("Load_and_Set_Panel#G2", "" )
	nameA = StringFromList(0, nameA)
	if( cmpstr (nameA, "")  == 1 ||  cmpstr (nameA, "")  == -1)
		RemoveImage /W=Load_and_Set_Panel#G2 $nameA
	endif
	
	DoWindow/F $"Angle_Energy"			//pulls the window to the front
	if (V_Flag==1)	
		DoWindow/K $"Angle_Energy"	
	endif
			
	DoWindow/F $"k_Space_2D"			//pulls the window to the front
	if (V_Flag==1)	
		DoWindow/K $"k_Space_2D"	
	endif
	
	if(DataFolderExists("root:folder3D"))
		KillDataFolder root:$"folder3D"
	endif
	if(DataFolderExists("root:Display_and_Extract:"))
		KillDataFolder root:$"Display_and_Extract"
	endif
	if(DataFolderExists("root:Multiple_Panel"))
		KillDataFolder root:$"Multiple_Panel"
	endif
	if(DataFolderExists("root:Final_Blend"))
		KillDataFolder root:$"Final_Blend"
	endif
	if(DataFolderExists("root:Blending_Panel"))
		KillDataFolder root:$"Blending_Panel"
	endif
	if(DataFolderExists("root:WinGlobals:"))
		KillDataFolder root:$"WinGlobals"
	endif
																			
	KillDataFolder root:Specs:
	String data_folder1
	data_folder1 = "root:Specs"						//makes the main folder
	NewDataFolder/O $data_folder1
	SetDataFolder $data_folder1
	
	DFREF dfr = GetDataFolderDFR()
	String 	/G list_file_path = ""
	String 	/G list_file_name =""
	String 	/G list_folder =""
	Variable 	/G val_slider1 = 0
	Variable 	/G val_slider2 = 0
	Variable 	/G val_slider3 = 0
	Variable 	/G root:Specs:val_slider4 = 0
	Variable 	/G root:Specs:val_slider5 = 0
	
	Variable 	/G imin =	0
	Variable 	/G jmin =	0
	Variable 	/G shift1 =	20
	Variable /G root:Specs:divide = 0
	Variable /G Multiplier = 1
	Variable /G  Smooth1
	Variable number1
	
	//KillWaves titles1
	//KillVariables deltaA
	//KillWaves ListWaves1, sw1
	SetDataFolder root:Load_and_Set_Panel:
	WAVE/T ListWave1
	WAVE sw1
	ListWave1 = ""
	sw1		=   	sw1 & ~(2^1)
	sw1		=   	sw1 & ~(2^4)
	sw1		=   	sw1 & ~(2^5)
	Title_left1 = ""
	Title_right1 = ""
	
	//KillVariables deltaA
	
	//Display_Load_and_Set_Panel()
	//ListWave1[][0] = ListWave2[p][0]
	number1 = DimSize(ListWave2,0)
	
	for( j = 0 ; j <number1 ; j = j +1)
		if( cmpstr(ListWave2[j][1], "") == 0)
			break
		endif
		//sw1[j][1]			=   	sw1[j][1] & ~(2^1)
		//sw1[j][2]			=   	sw1[j][2] & ~(2^1)
		//sw1[j][3]			=   	sw1[j][3] & ~(2^1)
		//sw1[j][4]			=   	sw1[j][4] & ~(2^1)
	endfor
	NewPath data file_name2
	String path_name2 = "data"
	
	String  	curve_list 							//list of all curves in the given folder
	String 	path_list								//list of all paths, witchout name of the file
	String 	name_file_list						//name of the file
	String	data_folder 
	
	Variable ref_file								//Variable keeps refernce to the flie
	Variable position1								//Varaible used to keep position in the file
	Variable nCurves						//Varaible used to keep number of curves in the file
	Variable number_folders						//keeps number of folders in a given folder
	Variable counter1
	Variable extension
	Variable help1
	Variable Rows, Columns
	Variable i
	Variable Lower, Higher
	String wave_name
	Variable Status
	Variable aSpan
	
	Variable nValues
	Variable deltaE
	Variable aLow
	Variable aHigh
	Variable eLow
	Variable eHigh
	Variable tiTime
	Variable keithley
	Variable eAngle
	Variable deltaA	
	
	String 	message		= 	"Select a file"
	String	full_path
	String 	file_path
	String 	file_name
	SVAR 	list_file_path 		= 	root:Specs:list_file_path	
	SVAR 	list_file_name	= 	root:Specs:list_file_name	
	SVAR 	list_folder 		= 	root:Specs:list_folder
	NVAR 	val1 			=	root:Specs:val_slider1
	NVAR 	val2 			=	root:Specs:val_slider2
	NVAR 	val3 			=	root:Specs:val_slider3
	String 	name1,name2,name3,name4
	Variable Low1 
	Variable High1
	String nameW
				
	for( j = 0 ; j <number1 ; j= j +1)
		SetDataFolder root:Load_and_Set_Panel:
		nameW = "wave" + num2str(j)
		Wave waveL =$nameW
		if( cmpstr(ListWave2[j][1], "") == 0)
			break
		endif
	
		String 	file_filters = "Data Files (*.xy,*.sp2):.xy,.sp2;"		//filter for Open
		String 	buffer1, buffer2
		DFREF 	dfr
		
		Variable Smoothing1, smoothing2
		//String path_name2 = "data"
		
		//path_name2 = file_name2 + ListWave1[j][0]
		//path_name2 = ParseFilePath(5, path_name2, "*", 0, 0)
		//path_name2 = ParseFilePath(5, file_name2, "*", 0, 0)
		//NewPath data file_name2
		name1 = ListWave2[j][1]
		Open /R /P=data ref_file as name1
		FStatus ref_file	
		If(V_flag == 0)
			//Open /D/F=file_filters /R /P=data /M = "Look for file " + ListWave1[j][0] ref_file as ListWave1[j][0]
			//Open /C = S_fileName ref_file
			//FStatus ref_file
			//If(V_flag == 0)
			//	return 0
			//endif
			return 0
		endif
		
		file_path 	= 	S_path						//contains path to the computer folder						
		file_name 	= 	S_fileName					//contains name of the file with extension
		full_path		= 	file_path + file_name
			
		// here checking file extension and removing extension
		help1  = strsearch(file_name,".xy",0)
		if( help1 > -1 )
			name1 = file_name
			extension = 0
		endif
		help1  = strsearch(file_name,".sp2",0)
		if( help1 > -1 )
			name1 = file_name
			extension = 1
		endif
		help1  = strsearch(file_name,".txt",0)
		if( help1 > -1 )
			name1 = file_name
			extension = 2
		endif		
		help1  = strsearch(file_name,".sh5",0)
		if( help1 > -1 )
			name1 = file_name
			extension = 3
		endif			
		help1  = strsearch(file_name,".itx",0)
		if( help1 > -1 )
			name1 = file_name
			extension = 4
		endif			
									
		//name1 		= 	ReplaceString(".xy", file_name, "")		//contains name of the flie without extension
			
		data_folder = "root:Specs:"
		data_folder = data_folder + ListWave2[j][1]
			
		if(strsearch(list_file_name,file_name,0) == -1 )
		
			switch(extension)
				case 0:
					SPECS_Load_XYnew (full_path)
					//name2 = file_name + " [corrected]"
					//name3 = "root:Specs:" + file_name
					//RemoveImage /W=# $name2
					//KillWindow  #
					MoveDataFolder root:$(file_name) , root:Specs
				
					WAVE Angle_2D
					
					//WAVE Angle_dif2_2D_smoothed
					
					curve_list = WaveList("*",";","")
					
					curve_list = WaveList("*",";","")
					nCurves = ItemsInList(curve_list)
					name2 = StringFromList(1, curve_list)
					nValues = numpnts($name2)
					deltaE = deltax($name2)
					
					deltaA = str2num ( ListWave2[j][15] ) 
					eAngle = str2num ( ListWave2[j][2] ) 
					aSpan = nCurves * deltaA
					aLow = (deltaA - aSpan )/2
					aHigh = aLow  + (nCurves -1) * deltaA
					eLow  = leftx($name2)
					eHigh = rightx($name2)
					
					tiTime = 1
					Keithley = 1
								
					Make/O/N=(nValues,nCurves) Angle_2D
						
					SetScale/P x, eLow, deltaE,"Kinetic Energy [eV]" Angle_2D
           				SetScale/P y, aLow , deltaA, "Angle [deg]" Angle_2D
					
					for(i = 0; i <nCurves;i+=1)	// Initialize variables;continue test
						name1 = StringFromList(i, curve_list)
						Wave v1 = $name1
						Angle_2D[][i] = v1	[p]	
						KillWaves v1						// Condition;update loop variables
					endfor
								
					wave_name = "Angle_2D"
					Mirror_Image($wave_name)
					Duplicate /O Angle_2D , $file_name
								
					list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
					list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
					list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
					counter1 				=	ItemsInList(list_file_name)
					counter1					= 	counter1 - 1
					name1 					=	StringFromList(counter1, list_file_name)
					ListWave1[j][] = ListWave2[j][q]
								
					sw1[j][0]			=   	sw1[j][1] | (2^1)
					sw1[j][2]			=   	sw1[j][2] | (2^1)
					sw1[j][3]			=   	sw1[j][3] | (2^1)
					sw1[j][4]			=   	sw1[j][4] | (2^1)
					sw1[j][5]			=   	sw1[j][5] | (2^1)
					sw1[j][6]			=   	sw1[j][6] | (2^1)
					sw1[j][7]			=   	sw1[j][7] | (2^1)
					sw1[j][8]			=   	sw1[j][8] | (2^1)
					sw1[j][9]			=   	sw1[j][9] | (2^1)
					sw1[j][10]		=   	sw1[j][10] | (2^1)
					sw1[j][12]		=   	sw1[j][12] | (2^1)
					sw1[j][13]		=   	sw1[j][13] | (2^1)
					sw1[j][14]		=   	sw1[j][14] | (2^1)
								
					Set_Angle_2D(j)			
					Close ref_file
					SetDataFolder root:Specs		
					break
				case 1:				
					name3 = "root:Specs:" + ListWave1[j][1]
					name1 = GetDataFolder(1)
					name1 = "root:'" + file_name + "':"
					Status = DataFolderExists ( name1 ) 
					if ( status == 1 )
 						KillDataFolder ( name1 )
 					endif
 							
 					status = SPECS_Load_SP2_WithOptions(full_path, 0, 1, 1)
					if(status != 0)
						return 0
					endif
					name2 = file_name + " [corrected]"
					RemoveImage /W=# $name2
					KillWindow  #
					Wave WaveLoaded = $name2
					Rename $name2 , $file_name
								
					//RemoveImage /W=# $file_name
					//KillWindow  #
							
					status = WaveExists (WaveLoaded)
					if(status == 0)
						return 0
					endif
					MoveDataFolder root:$(file_name) , root:Specs
							
					Variable tiT
					getNoteTiTime(WaveLoaded, tiT)
					if( tiT == 0)
						tiTime = 1
					else 
						tiTime = tiT
					endif
							
					keithley = 1	
					Mirror_Image(WaveLoaded)
						
					list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
					list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
					list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
					counter1 				=	ItemsInList(list_file_name)
					counter1					= 	counter1 - 1
					name1 					=	StringFromList(counter1, list_file_name)
					ListWave1[j][] = ListWave2[j][q]
					sw1[j][] = sw2[j][q]
					SetDataFolder root:Specs:$(file_name)
					WAVE nwave
					Duplicate/O waveL, nwave
					if( cmpstr(ListWave1[j][4], "") == 0 )
						ListWave1[j][4] =  num2str( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) )
					endif
					if( cmpstr(ListWave1[j][5], "") == 0 )
						ListWave1[j][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
					endif
					if( cmpstr(ListWave1[j][6], "") == 0 )
						ListWave1[j][6] = num2str( DimOffset(WaveLoaded,0) )
					endif
					if( cmpstr(ListWave1[j][8], "") == 0 )
						ListWave1[j][8] =  num2str(DimDelta(WaveLoaded,1) )
					endif				
					Close ref_file
					SetDataFolder root:Specs		
					break
				case 2:
 					status = Read_xyScientaFile (full_path,file_name,set)
					if(status == 0)
						return 0
					endif
								
					name2 = "Matrix0"
					Wave WaveLoaded = $name2
							
					status = WaveExists (WaveLoaded)
					if(status == 0)
						return 0
					endif
							
					tiTime = 1
					keithley = 1
							
					Rows = DimSize(WaveLoaded, 0 )
					Columns = DimSize(WaveLoaded, 1 )
					deltaA =  DimDelta(WaveLoaded,1)
					deltaE =  DimDelta(WaveLoaded,0)
					
					//Angle jest unsingned
					
					Mirror_Image(wave_name)
					
					list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
					list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
					list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
					counter1 				=	ItemsInList(list_file_name)
					counter1					= 	counter1 - 1
					name1 					=	StringFromList(counter1, list_file_name)
					ListWave1[j][] = ListWave2[j][q]
					sw1[j][] = sw2[j][q]
					SetDataFolder root:Specs:$(file_name)
					WAVE nwave
					Duplicate/O waveL, nwave

					Make/O /N=(DimSize(WaveLoaded,1)) nwave
 					Rename  Matrix0  , $file_name
					
					SetDataFolder root:Specs		
				break
				
				case 3:
					name3 = "root:Specs:" + file_name
					name1 = GetDataFolder(1)
					name1 = "root:'" + file_name + "':"
					Status = DataFolderExists ( name1 ) 
					if ( status == 1 )
 						KillDataFolder ( name1 )
 					endif
 								
					status = MY_SPECS_Load_SH5(full_path)
					if(status != 0)
						 return 0
					endif
							
					name2 = file_name + "-trans"
					KillWaves $file_name
					Wave WaveLoaded = $name2
					Rename $name2 , $file_name
							
					RemoveImage /W=# $file_name
					KillWindow  #
							
					status = WaveExists (WaveLoaded)
					if(status == 0)
					 	return 0
					endif
					MoveDataFolder root:$(file_name) , root:Specs
						
					//getNoteTiTime(WaveLoaded, tiT)
					if( tiT == 0)
						tiTime = 1
					else 
						tiTime = tiT
					endif
						
					keithley = 1
						
					Rows = DimSize(WaveLoaded, 0 )
					Columns = DimSize(WaveLoaded, 1 )
					
					// zostawic matryca jest floating point
					Make/O/N=(Rows,Columns) Angle_2D
								
					Mirror_Image(WaveLoaded)
					Angle_2D  = WaveLoaded
					Angle_2D = Angle_2D / tiTime / keithley

		           		SetScale/P x, DimOffset(WaveLoaded,0) , DimDelta(WaveLoaded,0),"Kinetic Energy [eV]" Angle_2D
		           		SetScale/P y, DimOffset(WaveLoaded,1) , DimDelta(WaveLoaded,1), "Angle [deg]" Angle_2D

					Set_Angle_2D(j)	
					
					list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
					list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
					list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
					counter1 				=	ItemsInList(list_file_name)
					counter1					= 	counter1 - 1
					name1 					=	StringFromList(counter1, list_file_name)
					ListWave1[j][] = ListWave2[j][q]
					sw1[j][] = sw2[j][q]
					
					SetDataFolder root:Specs:$(file_name)
					WAVE nwave
					Duplicate/O waveL, nwave
					Close ref_file
					SetDataFolder root:Specs		
				break
			case 4:
				name3 = "root:Specs:" + file_name
				name1 = GetDataFolder(1)
				name1 = "root:'" + file_name + "':"
				Status = DataFolderExists ( name1 ) 
				if ( status == 1 )
 					KillDataFolder ( name1 )
 				endif	
				//LoadWave /A=Matrix /G /K=0 /M  /O path
							
				NewDataFolder/O root:Specs:$file_name
				SetDataFolder root:Specs:$file_name
							
				LoadWave /T /M  /O full_path
				if(status != 0)
					 return 0
				endif
							
				name2 = StringFromList(0, S_waveNames)
				Wave WaveLoaded = $name2
								
				status = WaveExists (WaveLoaded)
				if(status == 0)
					return 0
				endif
								
				Rows = DimSize(WaveLoaded, 0 )
				Columns = DimSize(WaveLoaded, 1 )
				deltaA =  DimDelta(WaveLoaded,1)
				deltaE =  DimDelta(WaveLoaded,0)
								
				//Variable emission ,left , right
				Variable emission , left, right
				emission = 0
				left = emission - (( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) ) - deltaA )/ 2
				right = emission + (( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) ) - deltaA )/ 2
				SetScale/P y, left , deltaA, "Angle [deg]" WaveLoaded
							
				Mirror_Image(WaveLoaded)
							
				tiTime = 1
				keithley = 1
				list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
				list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
				list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
				counter1 				=	ItemsInList(list_file_name)
				counter1					= 	counter1 - 1
				name1 					=	StringFromList(counter1, list_file_name)
				ListWave1[j][] = ListWave2[j][q]
				sw1[j][] = sw2[j][q]
				Rename  $name2  , $file_name
				
				Close ref_file
				SetDataFolder root:Specs		
								
				break
			case 5:
				
				break
			
				
			endswitch
		endif
	endfor
	//NewPath data file_name2
	KillPath data
	return 0
End

Function ExportImages(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			DoWindow/F Profiles_FinalBlend				//pulls the window to the front
			if(V_flag != 0)									//checks if there is a window....
				KillWindow Profiles_FinalBlend
			endif
			DoWindow $ba.win
			if(V_flag == 1)
			String wTo_remove									//checks if there is a window....
				wTo_remove = ImageNameList("", "" )
				wTo_remove = StringFromList (0, wTo_remove  , ";")
				RemoveImage $wTo_remove
				KillDataFolder root:Final_blends:$ba.win
			endif
		break
		
		case 2: // mouse up
			// click code here
			Setdatafolder root:Specs:
			Variable resolutionX = 0.5
			Variable resolutionY = 0.2
			Variable ScrRes, ScrResCm
			Variable PixelWidthInCm
			ScrRes = ScreenResolution
			//ScrResCm = ScrRes/2.54
			PixelWidthInCm = 2.54/ScrRes
			
			Prompt resolutionX, "Scale of the Energy axis in (eV / cm)"
			Prompt resolutionY, "Scale of the other axis (unit / cm)"
			
			DoPrompt "INPUT SCALING PARAMETERS",resolutionX,resolutionY
			
			if (V_Flag)
				return -1		// Canceled
			endif
			
			Variable x1,x2,x3,x4
			Variable y1,y2,y3,y4
	
			String name1
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			
			GetWindow $ba.win gsizeDC
			DoUpdate 
			x1 = V_top
			x2 = V_bottom
			y1 = V_left
			y2 = V_right
			GetWindow $ba.win psizeDC
			DoUpdate 
			x3 = V_top
			x4 = V_bottom
			y3 = V_left
			y4 = V_right
			
			GetWindow $ba.win logicalpapersize
			
			Variable spanX
			Variable spanY
			Variable Lower, Higher
			
			WAVE Image = $name1
			Lower = DimOffset($name1,0)
			Higher = DimSize($name1,0) * DimDelta($name1,0) + Lower
			
			GetAxis left
			DoUpdate 
			//spanX = abs (Higher - Lower)		
			spanX = V_max - V_min
			Lower = DimOffset($name1,1)
			Higher = DimSize($name1,1) * DimDelta($name1,1) + Lower
			
			GetAxis bottom
			DoUpdate 
			//spanY = abs (Higher - Lower)	
			spanY = V_max - V_min
			DoUpdate 
			Variable lengthX, lengthY
			Variable ratioX
			Variable ratioY
			ratioX = spanX/resolutionX
			ratioY = spanY/resolutionY
			lengthX = ratioX+ ((x3 - x1) + (x2 - x4))*PixelWidthInCm
			lengthY = ratioY + ((y3 - y1) + (y2 - y4))*PixelWidthInCm
			SavePICT/O/E=-6/RES=300/M/W=(0,0,lengthY,lengthX)
			//SavePICT/E=-6/RES=300/M/W=(0,0,9.98361,5.00944)
			//SavePICT/EF=1/E=-3/M/W=(0,0,lengthY,lengthX)
		break
	endswitch

	return 0
End

Function ExportImages4(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			//DoWindow/F $ba.win			//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//7	KillWindow $ba.win	
			//endif
			
		break
		
		case 2: // mouse up
			// click code here
			String name1
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			Wave w = $name1
			SetDataFolder GetWavesDataFolder(w,1)
	
			Variable resolutionX = 0.5
			Variable resolutionY = 0.1
			Variable ScrRes, ScrResCm
			Variable PixelWidthInCm
			ScrRes = ScreenResolution
			//ScrResCm = ScrRes/2.54
			PixelWidthInCm = 2.54/ScrRes
			
			Prompt resolutionX, "Scale of the Energy axis in (eV / cm)"
			Prompt resolutionY, "Scale of the other axis (unit / cm)"
			
			DoPrompt "INPUT SCALING PARAMETERS",resolutionX,resolutionY
			
			if (V_Flag)
				return -1		// Canceled
			endif
			
			Variable x1,x2,x3,x4
			Variable y1,y2,y3,y4
			
			GetWindow $ba.win gsizeDC
			DoUpdate 
			x1 = V_top
			x2 = V_bottom
			y1 = V_left
			y2 = V_right
			GetWindow $ba.win psizeDC
			DoUpdate 
			x3 = V_top
			x4 = V_bottom
			y3 = V_left
			y4 = V_right
			
			GetWindow $ba.win logicalpapersize
			
			Variable spanX
			Variable spanY
			Variable Lower, Higher
			
			WAVE Image = $name1
			Lower = DimOffset($name1,0)
			Higher = DimSize($name1,0) * DimDelta($name1,0) + Lower
			
			GetAxis left
			DoUpdate 
			//spanX = abs (Higher - Lower)		
			spanX = V_max - V_min
			Lower = DimOffset($name1,1)
			Higher = DimSize($name1,1) * DimDelta($name1,1) + Lower
			
			GetAxis bottom
			DoUpdate 
			//spanY = abs (Higher - Lower)	
			spanY = V_max - V_min
			DoUpdate 
			Variable lengthX, lengthY
			Variable ratioX
			Variable ratioY
			ratioX = spanX/resolutionX
			ratioY = spanY/resolutionY
			lengthX = ratioX+ ((x3 - x1) + (x2 - x4))*PixelWidthInCm
			lengthY = ratioY + ((y3 - y1) + (y2 - y4))*PixelWidthInCm
			SavePICT/O/E=-6/RES=300/M/W=(0,0,lengthY,lengthX)
			//SavePICT/E=-6/RES=300/M/W=(0,0,9.98361,5.00944)
			//SavePICT/EF=1/E=-3/M/W=(0,0,lengthY,lengthX)
		break
	endswitch

	return 0
End

Function SetMargin(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			String name1, name2
			ModifyGraph margin(top) = dval
					
			break
	endswitch

	return 0
End

Function SetAllAxis(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			String name1, name2
			Setdatafolder root:Specs:
				
			name2 = ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			
			//Duplicate/O $(name2 + num2istr(1)), $name2 
			
			WAVE Image = $name2
			name1 = sva.ctrlName
			strswitch(name1)
				case "SetLeftUpper":
					ControlInfo /W=FinalBlend SetLeftLower
					GetAxis left
					SetAxis left V_min,dval
					break
				case "SetLeftLower":
					ControlInfo /W=FinalBlend SetLeftUpper
					GetAxis left
					SetAxis left dval,V_max
					break
				case "SetBottomLeft":
					ControlInfo /W=FinalBlend SetBottomRight
					GetAxis bottom
					SetAxis bottom dval,V_max
					break
				case "SetBottomRight":
					ControlInfo /W=FinalBlend SetBottomLeft
					GetAxis bottom
					SetAxis bottom V_min,dval
					break
				case "default":

					break
			endswitch
			
					
			break
	endswitch

	return 0
End

Function ChangeColor(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa

	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			
			Setdatafolder root:Specs:
			NVAR varMin,varMax
			String name2
			name2 = ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			WAVE Image = $name2
			//ModifyImage  $name2  ctab= {*,*,$popStr,0}
			Wavestats/Q/Z $name2
			//if(varMin < varMax)
			//	varMin  = V_min
			//	varMax = V_max
			//else
			//	varMin  = V_max
			//	varMax = V_min
			//endif	
			ModifyImage $name2, ctab= {varMIN,varMAX,$popStr,0}	
			break
	endswitch

	return 0
End

Function ChangeColor2(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa

	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			
			//Setdatafolder root:Defect_Removal_Tool:
			String name1
			name1 =  ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			
			Wavestats/Q/Z $name1
			Slider contrastmin,limits={V_min,V_max,0},value=V_min
			Slider contrastmax,limits={V_min,V_max,0},value=V_max

			ModifyImage $name1, ctab= {V_min,V_max,$popStr,0}	
			break
	endswitch

	return 0
End

Function InverseImages(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:Final_Blends:$ba.win
			String name2
			name2 = ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			
			WAVE Image = $name2
			NVAR varMin,varMax
			
			Wavestats/Q/Z $name2
			if(varMin < varMax)
				varMin  = V_max
				varMax = V_min
			else
				varMin  = V_min
				varMax = V_max
			endif	
			ModifyImage $name2, ctab= {varMIN,varMAX,,0}	
		break
	endswitch

	return 0
End

Function CheckProc_Grid(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			if(checked == 1)
				ModifyGraph grid(bottom)=1
				ModifyGraph grid(left)=1
				//CheckBox check1 title="Grid",pos={650,10},size={51,21},proc=CheckProc_Grid,value=1
			else
				ModifyGraph grid(bottom)=0
				ModifyGraph grid(left)=0
			endif
			
			break
	endswitch

	return 0
End

Function PopupProc_AE(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa

	switch( pa.eventCode )
		case 2: // mouse up
			Variable number1 = pa.popNum
			Setdatafolder root:Final_Blends:$pa.win
			WAVE FinalBlendBE2dif
			WAVE KparFinalBlendBE2dif
			
			WAVE FinalBlendBE2dif_a
			WAVE FinalBlendBE2dif_b
			WAVE FinalBlendBE2dif_c
			WAVE KparFinalBlendBE2dif_a
			WAVE KparFinalBlendBE2dif_b
			WAVE KparFinalBlendBE2dif_c
			Variable help1
			
			String name1 , name2
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			//STRUCT WMSetVariableAction sva
			
			switch(number1)
				//change_toKbutton
				//Button derivative
				case 2:
					strswitch(name1)
						case "FinalBlendBE":
							DoUpdate 
							break
						case "ImageLRmK":
							break
						case "FinalBlendBE2dif":
							FinalBlendBE2dif = FinalBlendBE2dif_b
							ControlInfo gamma1
							help1 = V_value
							WAVE Image = $name1
							Image = Image^help1
							Wavestats/Q/Z $name1
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							ModifyImage $name1, ctab= {varMIN,varMAX,,0}	
							DoUpdate 
							break
						case "KparFinalBlendBE":
							DoUpdate 
							break
						case "KparFinalBlendBE2dif":
							KparFinalBlendBE2dif = KparFinalBlendBE2dif_b
							ControlInfo gamma1
							help1 = V_value
							WAVE Image = $name1
							Image = Image^help1
							Wavestats/Q/Z $name1
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							ModifyImage $name1, ctab= {varMIN,varMAX,,0}	
							DoUpdate 
							break
					endswitch	
					break
				case 1:
					strswitch(name1)
						case "FinalBlendBE":
							//PopupMenu popup0,popvalue="Grays"
							DoUpdate 
							break
						case "ImageLRmK":
							break
						case "FinalBlendBE2dif":
							FinalBlendBE2dif = FinalBlendBE2dif_a
							ControlInfo gamma1
							help1 = V_value
							WAVE Image = $name1
							Image = Image^help1
							Wavestats/Q/Z $name1
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							ModifyImage $name1, ctab= {varMIN,varMAX,,0}	
							//PopupMenu popup0,popvalue="Grays"
							DoUpdate 
							break
						case "KparFinalBlendBE":
							//PopupMenu popup0,popvalue="Grays"
							DoUpdate 
							break
						case "KparFinalBlendBE2dif":
							KparFinalBlendBE2dif = KparFinalBlendBE2dif_a
							ControlInfo gamma1
							help1 = V_value
							WAVE Image = $name1
							Image = Image^help1
							Wavestats/Q/Z $name1
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							ModifyImage $name1, ctab= {varMIN,varMAX,,0}	
							//PopupMenu popup0,popvalue="Grays"
							DoUpdate 
							break
					endswitch
					break
				case 3:
					strswitch(name1)
						case "FinalBlendBE":
							//PopupMenu popup0,popvalue="Grays"
							DoUpdate 
							break
						case "ImageLRmK":
							break
						case "FinalBlendBE2dif":
							FinalBlendBE2dif = FinalBlendBE2dif_c
							ControlInfo gamma1
							help1 = V_value
							WAVE Image = $name1
							Image = Image^help1
							Wavestats/Q/Z $name1
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							ModifyImage $name1, ctab= {varMIN,varMAX,,0}	
							//PopupMenu popup0,popvalue="Grays"
							DoUpdate 
							break
						case "KparFinalBlendBE":
							//PopupMenu popup0,popvalue="Grays"
							DoUpdate 
							break
						case "KparFinalBlendBE2dif":
							KparFinalBlendBE2dif = KparFinalBlendBE2dif_c
							ControlInfo gamma1
							help1 = V_value
							WAVE Image = $name1
							Image = Image^help1
							Wavestats/Q/Z $name1
							Slider contrastmin,limits={V_min,V_max,0}
							Slider contrastmax,limits={V_min,V_max,0}
							NVAR varMin,varMax
							if(varMin < varMax)
								varMin  = V_min
								varMax = V_max
							else
								varMin  = V_max
								varMax = V_min
							endif	
							ModifyImage $name1, ctab= {varMIN,varMAX,,0}	
							//PopupMenu popup0,popvalue="Grays"
							DoUpdate 
							break
					endswitch
					break
				break
			endswitch
		break
	endswitch

	return 0
End


Function ShowMultiple(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:Final_Blends:$(ba.win)
			WAVE/T titles = titlesF
			Variable i, nr1 , nrImages , index_inListbox
			String name1 , newName
			nrImages = 0
			nr1 = DimSize(titles,0)
			for(i = 0; i < nr1 ; i += 1)
				if( cmpstr(titles[i],"") == 0 )
					break
				endif
				nrImages +=1 
			endfor
			
			Wave/T ListWave2		
			DoWindow/F Multiple_Panel					//pulls the window to the front
			
			if(V_flag != 0)	
				STRUCT WMButtonAction ba2
				ba2.eventCode = 2
				ButtonProc_RemoveAll(ba2)
				
				for(i = 0 ; i < nrImages; i+=1)		
					name1 = titles[i]
					Setdatafolder root:Specs:$titles[i]
					WAVE wave1 = $name1
					SetDataFolder root:Multiple_Panel
					Duplicate/O titles, titles2
					Duplicate/O titles, list_names
					WAVE/T ListWave2
					newName = "Nr"+num2str(i+1)
					Wave wave2 
					Duplicate/O wave1 , wave2
					if( waveExists($name1) )
						KillWaves $name1
					endif
					WAVE/T ListWave2
					index_inListbox = NrinListbox(titles[i])
					Final_2D(index_inListbox, wave2)
					Rename wave2, $name1
					DoWindow $newName
					if(V_flag)
						DoWindow/K $newName
					endif
					Display/W=(100,100,500,500) /HIDE=1 /K=3 /N=$newName 
					//RenameWindow # , $newName
					AppendImage /W=# wave2
					ModifyGraph margin=0 , swapXY=1 ,noLabel=0
					ModifyGraph width=400, height=400
					ListWave2[0][i] = newName
					DoUpdate
				endfor
				return 0
			else	
				Display_Multiple_Panel()
				for(i = 0 ; i < nrImages; i+=1)	
					name1 = titles[i]
					Setdatafolder root:Specs:$titles[i]
					WAVE wave1 = $name1
					SetDataFolder root:Multiple_Panel
					Duplicate/O titles, titles2
					Duplicate/O titles, list_names
					WAVE/T ListWave2
					newName = "Nr"+num2str(i+1)
					Wave wave2 
					Duplicate/O wave1 , wave2
					if( waveExists($name1) )
						KillWaves $name1
					endif
					index_inListbox = NrinListbox(titles[i])
					Final_2D(index_inListbox, wave2)
					Rename wave2, $name1
					DoWindow $newName
					if(V_flag)
						DoWindow/K $newName
					endif
					Display/W=(100,100,500,500) /HIDE=1 /K=3 /N=$newName 
					//RenameWindow # , $newName
					AppendImage /W=# wave2
					ModifyGraph margin=0 , swapXY=1 ,noLabel=0
					ModifyGraph width=400, height=400
					ListWave2[0][i] = newName
					DoUpdate
				endfor
			endif
		break
	endswitch

	return 0
End

Function ResetScale(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:Final_Blends:$ba.win
			String name2
			name2 = ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			
			WAVE Image = $name2
			Variable x1,x2,y1,y2
			x1 = DimOffset(Image, 1) - ( 0.5  * DimDelta(Image,1) )
			x2 =  ( DimSize(Image,1) - 0 ) * DimDelta(Image,1) + x1
			
			y1 = DimOffset(Image, 0) - ( 0.5  * DimDelta(Image,0) )
			y2 =  ( DimSize(Image,0) - 0 ) * DimDelta(Image,0) + y1
			
			SetAxis left y1,y2
			SetAxis bottom x1,x2
			
			SetVariable SetLeftUpper,value= _NUM:y2
			SetVariable SetLeftLower,value= _NUM:y1
			SetVariable SetBottomLeft,value= _NUM:x1
			SetVariable SetBottomRight,value= _NUM:x2
			
		break
	endswitch

	return 0
End

Function ButtonProc_AcceptR(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			String name1
			SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
			SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
			WAVE FinalBlendKE = root:Blending_Panel:FinalBlendKE		
			ControlInfo /W=Load_and_Set_Panel list0
			name1 = S_DataFolder  + S_Value
			WAVE/T  ListWave = $name1
			
			Variable test1 , i , nrRows
			nrRows = DimSize(ListWave,0)
			test1 = -1
			for(i =0;i<nrRows;i+=1)
				if(cmpstr(ListWave[i][1],Title_right1)==0)
					 break
				endif
			endfor
			
			Variable ShiftPixelsA
			Variable ShiftPixelsE
			Variable ShiftA
			Variable ShiftE
			Variable deltaA 
			Variable deltaE
			
			Controlinfo setvar1
			ShiftPixelsA = V_value
			Controlinfo setvar0
			ShiftPixelsE = V_value
			
			If( ShiftPixelsA == 0 && ShiftPixelsE == 0 )
				return 0
			endif
			deltaA = DimDelta(FinalBlendKE,1)
			deltaE = DimDelta(FinalBlendKE,0)
			
			ShiftA = ShiftPixelsA * deltaA 
			ShiftE = ShiftPixelsE * deltaE
			
			ListWave[i][2] = num2str( str2num(ListWave[i][2]) + ShiftA)
			ListWave[i][7] = num2str( str2num(ListWave[i][7]) + ShiftE)
			
			//Set_Angle_2D( i )
			SetVariable setvar1,value= _NUM:0
			SetVariable setvar0,value= _NUM:0
			Blend_button(ba)
			break
		endswitch
	return 0
End

Function ButtonProc_AcceptL(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			String name1
			SVAR Title_left1 = root:Load_and_Set_Panel:Title_left1
			SVAR Title_right1 = root:Load_and_Set_Panel:Title_right1
			WAVE FinalBlendKE = root:Blending_Panel:FinalBlendKE		
			ControlInfo /W=Load_and_Set_Panel list0
			name1 = S_DataFolder  + S_Value
			WAVE/T  ListWave = $name1
			
			Variable test1 , i , nrRows
			nrRows = DimSize(ListWave,0)
			test1 = -1
			for(i =0;i<nrRows;i+=1)
				if(cmpstr(ListWave[i][1],Title_left1)==0)
					 break
				endif
			endfor
			
			Variable ShiftPixelsA
			Variable ShiftPixelsE
			Variable ShiftA
			Variable ShiftE
			Variable deltaA 
			Variable deltaE
			
			Controlinfo setvar1
			ShiftPixelsA = V_value
			Controlinfo setvar0
			ShiftPixelsE = V_value
			
			If( ShiftPixelsA == 0 && ShiftPixelsE == 0 )
				return 0
			endif
		
			deltaA = DimDelta(FinalBlendKE,1)
			deltaE = DimDelta(FinalBlendKE,0)
					
			ShiftA = - ShiftPixelsA * deltaA 
			ShiftE = - ShiftPixelsE * deltaE
			Variable help1
			help1= str2num(ListWave[i][2]) + ShiftA
			ListWave[i][2] = num2str( help1)
			ListWave[i][7] = num2str( str2num(ListWave[i][7]) + ShiftE)
			
			//Set_Angle_2D( i )
			SetVariable setvar1,value= _NUM:0
			SetVariable setvar0,value= _NUM:0
			//Blend_button(ba)
			break
			
		endswitch
	return 0
End

Function AcceptShift(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			
			STRUCT WMButtonAction ba1
			ba1 = ba
			//RemoveDefects(ba1)
			NVAR AngleOffset = root:Final_Blend:AngleOffset
			DoWindow/F Profiles_FinalBlend					//pulls the window to the front
			If(V_flag == 0)									//checks if there is a window....
				return 0
			endif
			Variable position
			position = vcsr ( A , "Final_Blend" )
			ValDisplay valdisp0, value= _NUM: vcsr ( A , "Final_Blend" )
			DoWindow/F Final_Blend					//pulls the window to the front
			If(V_flag == 0)									//checks if there is a window....
				return 0
			endif
			ValDisplay AngleShift , value= _NUM: AngleOffset 
			break
		endswitch
		
	return 0
End

Function ChangeEmissions(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			STRUCT WMListboxAction lba
			Variable i , j
			WAVE/T/Z lba.listWave = root:ListWave1
			WAVE/Z lba.selWave = root:sw1
			Variable size1 
			Variable value1
			NVAR AngleOffset = root:Specs:AngleOffset
			Variable value2
			String name1
			WAVE/T list_names = root:Specs:list_names
			
			if( AngleOffset  == 0 )
				return 0
			endif
			
			WAVE/T list_names = root:Specs:list_names
			Variable size2
			size2 = DimSize( list_names , 0 )
			size1 = DimSize( lba.listWave , 0 )
			for ( j = 0 ; j < size2 ; j = j + 1 )
				if( cmpstr ( list_names[j][0] , "" ) != 0 )
					for ( i = 0 ; i < size1 ; i = i + 1 )
						if( cmpstr ( lba.listWave[i][0] ,  list_names[j][0] ) == 0 )
							lba.eventCode = 7
							lba.row = i
			 				lba.col = 1
	 						value2 = str2num ( lba.listWave[i][1] )
	 						value1 = value2 - AngleOffset
	 						lba.listWave[i][1] = num2str ( value1 )
							ListBoxProc(lba)
						endif
					endfor	
				endif
			endfor
			AngleOffset = 0
			ValDisplay AngleShift , value= _NUM: AngleOffset 
			//ValDisplay AngleShift , value= _NUM: vcsr ( A , "Final_Blend" )
			break
		endswitch
		
	return 0
End

static Function getNotePhotonEvalue(wv,Lower, Higher)
	Wave wv
	Variable &Lower, &Higher
	
	string value
	value =  "ERange"
	string myNote,val
	myNote = note(wv)
	val = StringByKey(value,myNote,":","\r")
	sscanf  val, "%f %f", Lower , Higher
end

Function DisplayExtractPanel(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			SetDataFolder root:Specs:
			WAVE sw1 = root:Load_and_Set_Panel:sw1
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			Variable i , j , k
			Variable size1 , size2
			size1 = DimSize ( sw1 , 1)
			size2 = DimSize ( sw1 , 0)
			
			Variable counter1, counter2
			Variable test2
			Variable number
			number = DimSize(ListWave1,0) 
			//counter1 = ItemsInList(list_folder)
			counter2 = DimSize(ListWave1,1) 
			test2 = -1
			for(i = 0; i < number ; i += 1)
				for(j = 0; j < counter2 ; j += 1)
					if( (sw1[i][j] & 2^0) != 0 )
						test2 = i 
						break
					endif
				endfor
				if( test2 != -1 )
					break
				endif
			endfor
			
			if(test2==-1)
				return 0
			endif
			i = test2
			
			if ( cmpstr ( ListWave1[i][1] , "" ) == 0 )
				return 0
			endif

			Setdatafolder root:Load_and_Set_Panel:
			WAVE Display2
			Wave Angle_2D = Display2
			
			NewDataFolder/O/S root:$"Display_and_Extract"
			Duplicate/O Angle_2D, Image1
			String /G nameFolder = ListWave1[i][1]
			
			Variable Xmin,Ymin,Xmax,Ymax
			
			Xmin=DimOffset( Image1 , 0 ) + 0 * DimDelta( Image1 , 0 )
			Ymin=DimOffset( Image1 , 1 ) + 0 * DimDelta( Image1 , 1 )
			Xmax=DimOffset( Image1 , 0 ) + ( dimsize(  Image1 , 0 ) - 1 ) * DimDelta(  Image1 , 0 )
			Ymax=DimOffset( Image1 , 1 ) + ( dimsize(  Image1 , 1 ) - 1 ) * DimDelta(  Image1 , 1 )
			
			
			Make/O/N=( DimSize(Image1,0) ) VCS
			Make/O/N=( DimSize(Image1,1) ) HCS
			SetScale/I x,xmin,xmax,"" VCS
			SetScale/I x,ymin,ymax,"" HCS
			
			DoWindow/F $"Display_and_Extract"			//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWiandow $"Profiles_FinalBlend"
			//endif
			//------------display the results
			if (V_Flag==1)	
				//Dowindow/F $"Display_and_Extract"
				//Slider moveMDC1,pos={25,5},size={400,13},proc=SliderDC1
				//Slider moveMDC1,limits={0,DimSize(matrix,1)-1,0},value= 0,side= 0,vert= 0,ticks= 0
				//Slider moveEDC1,pos={6,41},size={13,350},proc=SliderDC1
				//Slider moveEDC1,limits={0,DimSize(matrix,0)-1,0},value= 0,side= 0,ticks= 0
			else
				Display/K=1 /W=(338.25,70.25,710,417.5)
				Dowindow/C $"Display_and_Extract"	
				AppendImage /L=leftImage1 /B=bottomImage1 Image1
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				
				ModifyGraph freePos(leftImage1)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage1)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage1)={0.1,1}
				ModifyGraph axisEnab(leftImage1)={0.1,0.6}
				ModifyGraph margin(bottom)=20
				
				AppendToGraph/L=leftVCS /B=bottomVCS VCS
			
				ModifyGraph freePos(leftVCS)={0.7,kwFraction}
				ModifyGraph freePos(bottomVCS)={0.1,kwFraction}
				ModifyGraph axisEnab(leftVCS)={0.1,1}
				ModifyGraph axisEnab(bottomVCS)={0.7,1}
				
				ControlBar 60
			
				Slider moveVCS , pos={35,7} , size={300,13} , proc=moveVCS
				Slider moveVCS , limits = { 0 , ( DimSize(Image1,1) - 1 ) , 0 } , value= 0 , side= 0 , vert= 0 , ticks= 0
				
				SetVariable setvar0 title="NA",pos={25,35} ,fSize=14
				SetVariable setvar0  size={80,20},bodyWidth=60;DelayUpdate
				SetVariable setvar0 proc=SetVarProc_Average,value= _NUM: 1 ,limits={1,40,1}

				ValDisplay valdisp0 pos = {350,10} , size = {55,30},value=_NUM:0 , fSize=15
				
				ValDisplay valdisp1 pos = {120,35} , size = {75,30},value=_NUM:DimDelta(Image1,1) ,fSize=15 ,  title="deg"
			
				//PopupMenu popup0,pos={220,35},size={55,20},proc=ChangeImage
				//PopupMenu popup0,mode=1,popvalue="Raw Image",value= #"\"Raw Image;Smoothed Image;\""
			
			endif
			
			break
		endswitch
	return 0
End

Function moveVCS(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1
				String name2 , name3
				
				name1 = ImageNameList("", "" )
				name1 = StringFromList (0, name1  , ";")
				DoUpdate
				SetDataFolder root:Display_and_Extract:
				WAVE M_InterpolatedImage
				WAVE Image1 = $name1
				WAVE VCS = VCS
				//WAVE EDC=EDC
				
				if (strlen(csrinfo(A,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=2/C=(65280,0,0) A "+name1+" 0,0"
					ValDisplay valdisp0,value=_NUM:hcsr(A,"")
				endif
				if (cmpstr(sa.ctrlName,"moveVCS")==0)
					VCS = Image1[p][curval]
					execute/Z/Q "Cursor/W=# /P/I/H=2/C=(65280,0,0) A "+name1+" pcsr(A,\"\"),"+num2str(curval)
					ValDisplay valdisp0,value=_NUM:vcsr(A,"")
				endif
				//if (cmpstr(sa.ctrlName,"moveEDC1")==0)
				//	VCS = Image1[curval][p]
				//	execute/Z/Q "Cursor/W=# /P/I/H=2/C=(65280,0,0) A "+name1+" "+num2str(curval)+",qcsr(A,\"\")"
				//	ValDisplay valdisp1,value=_NUM:hcsr(A,"")
				//endif		
			endif
			//ValDisplay cross2,value=_NUM:hcsr(B,"Blended_Panel#G0")
			//ValDisplay cross1,value=_NUM:vcsr(B,"Blended_Panel#G0")
			
			break
	endswitch

	return 0
End

Function SetVarProc_Average(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			
			String name1
			String name2
			String name3
			//SetDataFolder root:Specs:
			//WAVE VCS = VCS
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			DoUpdate
			SetDataFolder root:Display_and_Extract:
			WAVE Image1
			WAVE VCS = VCS
			Variable x0,dx,xn,y0,dy,yn
			WAVE M_InterpolatedImage
			SVAR nameFolder
			SetDataFolder root:Specs:$nameFolder
			WAVE Angle_2D
			ValDisplay valdisp1 ,value=_NUM:DimDelta(Angle_2D,1) * dval
			x0 = DimOffset( Angle_2D , 0 )
			xn = DimOffset( Angle_2D , 0 ) + ( DimSize( Angle_2D , 0 ) - 1 ) * DimDelta( Angle_2D, 0 )
			dx = DimDelta( Angle_2D, 0 )
			y0 = DimOffset( Angle_2D , 1 ) 
			yn = DimOffset( Angle_2D , 1 ) + ( DimSize( Angle_2D , 1 ) - 1 ) * DimDelta( Angle_2D, 1 )
			dy = DimDelta( Angle_2D, 1 ) * ( DimSize( Angle_2D , 1 ) - 1 ) / ( dval - 1 )
			//SetDataFolder root:Specs:$sva.win
			//ControlInfo popup0
			//name2 = S_value
			AverageImage(Angle_2D,Image1,dval)

			break
	endswitch

	return 0
End

Function ChangeImage(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa

	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			
			ControlInfo setvar0
			strswitch(popStr)
				case "Raw Image":
					Duplicate/O /O Angle_2D , Image1 
					//AverageImage("Angle_2D","Image1",V_value)
					break
				case "Smoothed Image":
					Duplicate/O /O Angle_2D_smoothed , Image1 
					//AverageImage("Angle_2D_smoothed","Image1",V_value)
					break
				case "2nd derivative":
					Duplicate/O /O Angle_dif2_2D , Image1 
					//AverageImage("Angle_dif2_2D","Image1",V_value)
					break
			endswitch 
			
			break
	endswitch

	return 0
End

Static Function AverageImage(name1,name2,number1)
	WAVE name1
	WAVE name2
	Variable number1
	
	WAVE Matrix1 = name1
	WAVE Matrix2 = name2
	Variable i , j , k , help1
	Variable	size1
	Variable size2
	 
	Matrix2 = 0
	k = trunc( (number1 - 1) / 2 )
	size1 = DimSize( Matrix1, 1 )
	for ( i = 0 ; i < size1 ; i = i + 1 )
		//help1 = i - k
		for ( j = 0 ; j < number1 ; j = j + 1 )
			Matrix2[][i] = Matrix2[p][i] + Matrix1[p][ i + j - k ] 
		endfor	
	endfor

	return 0
End

Function DisplayExtractPanel2(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			SetDataFolder root:Specs:
			
			String name1
			String name2
				
			name1 = ImageNameList("Final_blend", "" )
			name1 = StringFromList (0, name1  , ";")
				
			Duplicate/O $name1 Image2
			
			Variable Xmin,Ymin,Xmax,Ymax
		
			Xmin=DimOffset( Image2 , 0 ) + 0 * DimDelta( Image2 , 0 )
			Ymin=DimOffset( Image2 , 1 ) + 0 * DimDelta( Image2 , 1 )
			Xmax=DimOffset( Image2 , 0 ) + ( dimsize(  Image2 , 0 ) - 1 ) * DimDelta(  Image2 , 0 )
			Ymax=DimOffset( Image2 , 1 ) + ( dimsize(  Image2 , 1 ) - 1 ) * DimDelta(  Image2 , 1 )
			
			
			Make/O/N=( DimSize(Image2,0) ) VCS2
			Make/O/N=( DimSize(Image2,1) ) HCS2
			SetScale/I x,xmin,xmax,"" VCS2
			SetScale/I x,ymin,ymax,"" HCS2
			
			DoWindow/F $"Display_and_Extract2"			//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow $"Profiles_FinalBlend"
			//endif
			//------------display the results
			if (V_Flag==1)	
				//Dowindow/F $"Display_and_Extract"
				//Slider moveMDC1,pos={25,5},size={400,13},proc=SliderDC1
				//Slider moveMDC1,limits={0,DimSize(matrix,1)-1,0},value= 0,side= 0,vert= 0,ticks= 0
				//Slider moveEDC1,pos={6,41},size={13,350},proc=SliderDC1
				//Slider moveEDC1,limits={0,DimSize(matrix,0)-1,0},value= 0,side= 0,ticks= 0
			else
				Display/K=1 /W=(338.25,70.25,710,417.5)
				Dowindow/C $"Display_and_Extract2"	
				AppendImage /L=leftImage1 /B=bottomImage1 Image2
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				
				//ModifyGraph lblPos(left)=52,lblPos(left)=51
				//ModifyGraph lblLatPos(left)=-1
				ModifyGraph freePos(leftImage1)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage1)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage1)={0.1,1}
				ModifyGraph axisEnab(leftImage1)={0.1,0.6}
				ModifyGraph margin(bottom)=20
				
				AppendToGraph/L=leftVCS /B=bottomVCS VCS2
				//ModifyGraph  swapXY=1
				ModifyGraph freePos(leftVCS)={0.7,kwFraction}
				ModifyGraph freePos(bottomVCS)={0.1,kwFraction}
				ModifyGraph axisEnab(leftVCS)={0.1,1}
				ModifyGraph axisEnab(bottomVCS)={0.7,1}
				
				ControlBar 60
				
				Slider moveVCS2 , pos={35,7} , size={300,13} , proc=moveVCS2
				Slider moveVCS2 , limits = { 0 , ( DimSize(Image2,1) - 1 ) , 0 } , value= 0 , side= 0 , vert= 0 , ticks= 0
				
				SetVariable setvar0 title="NA",pos={25,35} ,fSize=14
				SetVariable setvar0  size={80,20},bodyWidth=60;DelayUpdate
				SetVariable setvar0 proc=SetVarProc_Average2,value= _NUM: 1 ,limits={1,40,1}

				ValDisplay valdisp0 pos = {240,35} , size = {65,30},value=_NUM:0 , fSize=15 
				
				ValDisplay valdisp1 pos = {120,35} , size = {75,30},value=_NUM:DimDelta(Image2,1) ,fSize=15 ,  title="deg"
				
				Button Display1,pos={375,10},size={100,40},proc=DisplayAddSpectrum,title="Display or Add \rSpectrum"
				Button Display1,fSize=14
	
				//PopupMenu popup0,pos={220,35},size={55,20},proc=ChangeImage2
				//PopupMenu popup0,mode=1,popvalue="Image",value= #"\"Image;2nd der.;K par.;K par. 2nd der.;\""
			
			endif
			
			break
		endswitch
	return 0
End

Function SetVarProc_Average2(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case -1: // control being killed
			DoWindow/F $"Spectrum"				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow $"Spectrum"
			endif
			break
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			
			String name1
			String name2
			String name3

			name1 = ImageNameList("Final_blend", "" )
			name1 = StringFromList (0, name1  , ";")
			DoUpdate
			name3 = GetWavesDataFolder($name1,1)
			SetDataFolder GetWavesDataFolder($name1,1)
			WAVE Image1
			WAVE VCS1 = VCS1
			
			ValDisplay valdisp1 ,value=_NUM:DimDelta($name1,1) * dval
			
			
			Duplicate/O $name1 , Image2 
			//AverageImage(name1,"Image2",dval)
					
			break
	endswitch

	return 0
End

Function ChangeImage2(pa) : PopupMenuControl
	STRUCT WMPopupAction &pa

	switch( pa.eventCode )
		case 2: // mouse up
			Variable popNum = pa.popNum
			String popStr = pa.popStr
			String name1
			name1 = ImageNameList("Final_blend", "" )
			name1 = StringFromList (0, name1  , ";")
			SetDataFolder root:Specs:
			ControlInfo setvar0
			strswitch(popStr)
				case "Image":
					Duplicate/O  $name1 , Image2 
					//AverageImage(name1,"Image2",V_value)
					break
				case "2nd der.":
					Duplicate/O  $name1 , Image2 
					//AverageImage(name1,"Image2",V_value)
					break
				case "K par.":
					Duplicate/O  $name1 , Image2 
					//AverageImage(name1,"Image2",V_value)
					break
				case "K par. 2nd der.":
					Duplicate/O  $name1 , Image2 
					//AverageImage(name1,"Image2",V_value)
					break
			endswitch 
			
			break
	endswitch

	return 0
End

Function moveVCS2(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1
				String name2 , name3
				
				name1 = ImageNameList("Final_blend", "" )
				name1 = StringFromList (0, name1  , ";")
				DoUpdate
				name3 = GetWavesDataFolder($name1,1)
				SetDataFolder GetWavesDataFolder($name1,1)
				WAVE Image2 //= $name1
				WAVE VCS2 = VCS2
				
				if (strlen(csrinfo(A,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=2/C=(65280,0,0) A "+"Image2"+" 0,0"
					ValDisplay valdisp0,value=_NUM:hcsr(A,"")
				endif
				if (cmpstr(sa.ctrlName,"moveVCS2")==0)
					VCS2 = Image2[p][curval]
					execute/Z/Q "Cursor/W=# /P/I/H=2/C=(65280,0,0) A "+"Image2"+" pcsr(A,\"\"),"+num2str(curval)
					ValDisplay valdisp0,value=_NUM:vcsr(A,"")
				endif
				//if (cmpstr(sa.ctrlName,"moveEDC1")==0)
				//	VCS = Image1[curval][p]
				//	execute/Z/Q "Cursor/W=# /P/I/H=2/C=(65280,0,0) A "+name1+" "+num2str(curval)+",qcsr(A,\"\")"
				//	ValDisplay valdisp1,value=_NUM:hcsr(A,"")
				//endif		
			endif
			
			break
	endswitch

	return 0
End

Function DisplayAddSpectrum(ba) : ButtonControl
	STRUCT WMButtonAction &ba
	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			SetDataFolder root:Specs:
			WAVE VCS2 = VCS2
			DoWindow/F $"Spectrum"			//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow $"Profiles_FinalBlend"
			//endif
			//------------display the results
			if (V_Flag==1)	
				
			else
				Display/K=1 /W=(400,80,1000,500)
				Dowindow/C $"Spectrum"	
				
				AppendToGraph/L=leftVCS /B=bottomVCS VCS2
				DoUpdate 
				ModifyGraph freePos(leftVCS)={0.1,kwFraction}
				ModifyGraph freePos(bottomVCS)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomVCS)={0.1,1}
				ModifyGraph axisEnab(leftVCS)={0.1,1}
				
				ControlBar/L 100
				
				ModifyGraph margin =40
				ModifyGraph margin(right) =20
				ModifyGraph margin(top) =10
				ModifyGraph mode=2,rgb=(0,0,0)
					
				ModifyGraph tick(leftVCS)=3,tick(bottomVCS)=2,mirror=1,noLabel(leftVCS)=2;DelayUpdate
				ModifyGraph notation(leftVCS)=1;DelayUpdate
				ModifyGraph manTick(bottomVCS)={0,2,0,1},manMinor(bottomVCS)={1,0}
				
				SetVariable SetBottomLeft,pos={5,10},size={80,20},proc=SetAllAxis2,title="L"
				SetVariable SetBottomLeft,fSize=14,limits={-inf,inf,0.01},value= _NUM: leftx(VCS2)
				
				SetVariable SetBottomRight,pos={5,40},size={80,20},proc=SetAllAxis2,title="R"
				SetVariable SetBottomRight,fSize=14,limits={-inf,inf,0.01},value= _NUM:rightx(VCS2)
				
				GetAxis leftVCS
				SetAxis leftVCS V_min, (V_max*10/9)
				GetAxis leftVCS
				SetVariable SetLeftUpper,pos={5,70},size={80,20},proc=SetAllAxis2,title="Up"
				SetVariable SetLeftUpper,fSize=14,limits={-inf,inf,0.01},value= _NUM:V_max
				
				GetAxis leftVCS
				SetVariable SetLeftLower,pos={5,100},size={80,20},proc=SetAllAxis2,title="Low"
				SetVariable SetLeftLower,fSize=14,limits={-inf,inf,0.01},value= _NUM:V_min
				
				Button Export2,pos={15,130},size={70,20},proc=ExportImages2,title="Export"
				Button Export2,fSize=14
				
				//Slider moveVCS2 , pos={35,7} , size={300,13} , proc=moveVCS2
				//Slider moveVCS2 , limits = { 0 , ( DimSize(Image2,1) - 1 ) , 0 } , value= 0 , side= 0 , vert= 0 , ticks= 0
				
				//SetVariable setvar0 title="NA",pos={25,35} ,fSize=14
				//SetVariable setvar0  size={80,20},bodyWidth=60;DelayUpdate
				//SetVariable setvar0 proc=SetVarProc_Average2,value= _NUM: 1 ,limits={1,40,1}

				//ValDisplay valdisp0 pos = {240,35} , size = {65,30},value=_NUM:0 , fSize=15 
				
				//ValDisplay valdisp1 pos = {120,35} , size = {75,30},value=_NUM:DimDelta(Image2,1) ,fSize=15 ,  title="deg"
				
				//Button Display1,pos={375,10},size={100,40},proc=DisplayAddSpectrum,title="Display or Add \rSpectrum"
				//Button Display1,fSize=14
	
				//PopupMenu popup0,pos={220,35},size={55,20},proc=ChangeImage2
				//PopupMenu popup0,mode=1,popvalue="Image",value= #"\"Image;2nd der.;K par.;K par. 2nd der.;\""
			
			endif
			
			break
		endswitch
	return 0
End

Function SetAllAxis2(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			String name1, name2
			Setdatafolder root:Specs:
			
				
			name2 =  ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			
			//Duplicate/O $(name2 + num2istr(1)), $name2 
			
			WAVE Image = $name2
			name1 = sva.ctrlName
			strswitch(name1)
				case "SetLeftUpper":
					ControlInfo /W=Spectrum SetLeftLower
					GetAxis leftVCS
					SetAxis leftVCS V_min,dval
					break
				case "SetLeftLower":
					ControlInfo /W=Spectrum SetLeftUpper
					GetAxis leftVCS
					SetAxis leftVCS dval,V_max
					break
				case "SetBottomLeft":
					ControlInfo /W=Spectrum SetBottomRight
					GetAxis bottomVCS
					SetAxis bottomVCS dval,V_max
					break
				case "SetBottomRight":
					ControlInfo /W=Spectrum SetBottomLeft
					GetAxis bottomVCS
					SetAxis bottomVCS V_min,dval
					break
				case "default":

					break
			endswitch
			
					
			break
	endswitch

	return 0
End

Function ExportImages3(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			//DoWindow/F Profiles_FinalBlend				//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow Profiles_FinalBlend
			//endif
			
		break
		
		case 2: // mouse up
			// click code here
			Setdatafolder root:Specs:
			Variable resolutionX = 0.5
			Variable resolutionY = 10
			Variable ScrRes, ScrResCm
			Variable PixelWidthInCm
			ScrRes = ScreenResolution
			//ScrResCm = ScrRes/2.54
			PixelWidthInCm = 2.54/ScrRes
			
			Prompt resolutionY, "Set the height of the Intensity axis in cm"
			Prompt resolutionX, "Scale of the Energy axis in (eV / cm)"
			
			DoPrompt "INPUT SCALING PARAMETERS",resolutionY,resolutionX
			
			if (V_Flag)
				return -1		// Canceled
			endif
			
			Variable x1,x2,x3,x4
			Variable y1,y2,y3,y4
	
			
			
			GetWindow $ba.win gsizeDC
			DoUpdate 
			y1 = V_top
			y2 = V_bottom
			x1 = V_left
			x2 = V_right
			GetWindow $ba.win psizeDC
			DoUpdate 
			y3 = V_top
			y4 = V_bottom
			x3 = V_left
			x4 = V_right
			
			GetWindow $ba.win logicalpapersize
			
			Variable spanX
			Variable spanY
			
			GetAxis bottomVCS
			DoUpdate 
			//spanX = abs (Higher - Lower)		
			spanX = V_max - V_min
			
			
			//GetAxis bottom
			//DoUpdate 
			//spanY = abs (Higher - Lower)	
			//spanY = V_max - V_min
			DoUpdate 
			Variable lengthX, lengthY
			Variable ratioX
			Variable ratioY
			ratioX = spanX/resolutionX
			//ratioY = spanY/resolutionY
			lengthX = ratioX + ( (x3 - x1) + (x2 - x4) ) * PixelWidthInCm
			lengthY = resolutionY + ( (y3 - y1) + (y2 - y4) ) * PixelWidthInCm
			SavePICT/O/E=-6/RES=300/M/W=(0,0,lengthX,resolutionY)
			//SavePICT/E=-6/RES=300/M/W=(0,0,9.98361,5.00944)
			//SavePICT/EF=1/E=-3/M/W=(0,0,lengthY,lengthX)
		break
	endswitch

	return 0
End

Function ExportImages2(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			DoWindow/F Profiles_FinalBlend				//pulls the window to the front
			If(V_flag != 0)									//checks if there is a window....
				KillWindow Profiles_FinalBlend
			endif
			
		break
		
		case 2: // mouse up
			// click code here
			Setdatafolder root:folder3D:
			Variable resolutionX = 1
			Variable resolutionY = 1
			Variable ScrRes, ScrResCm
			Variable PixelWidthInCm
			ScrRes = ScreenResolution
			//ScrResCm = ScrRes/2.54
			PixelWidthInCm = 2.54/ScrRes
			
			Prompt resolutionY, "Scale of the vertical axis in (unit / cm)"
			Prompt resolutionX, "Scale of the horizontal axis (unit / cm)"
			
			DoPrompt "INPUT SCALING PARAMETERS",resolutionX,resolutionY
			
			if (V_Flag)
				return -1		// Canceled
			endif
			
			Variable x1,x2,x3,x4
			Variable y1,y2,y3,y4
	
			String name1
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			
			GetWindow $ba.win gsizeDC
			DoUpdate 
			y1 = V_top
			y2 = V_bottom
			x1 = V_left
			x2 = V_right
			GetWindow $ba.win psizeDC
			DoUpdate 
			y3 = V_top
			y4 = V_bottom
			x3 = V_left
			x4 = V_right
			
			GetWindow $ba.win logicalpapersize
			
			Variable spanX
			Variable spanY
			Variable Lower, Higher
			
			WAVE Image = $name1
			Lower = DimOffset($name1,0)
			Higher = DimSize($name1,0) * DimDelta($name1,0) + Lower
			
			GetAxis leftImage3
			DoUpdate 
			//spanX = abs (Higher - Lower)		
			spanY = V_max - V_min
			Lower = DimOffset($name1,1)
			Higher = DimSize($name1,1) * DimDelta($name1,1) + Lower
			
			GetAxis bottomImage3
			DoUpdate 
			//spanY = abs (Higher - Lower)	
			spanX = V_max - V_min
			DoUpdate 
			Variable lengthX, lengthY
			Variable ratioX
			Variable ratioY
			Variable deltaX1, deltay1
			deltaX1 = ((x3 - x1) + (x2 - x4))
			deltaY1 = ((y3 - y1) + (y2 - y4))
			ratioX = spanX/resolutionX
			ratioY = spanY/resolutionY
			lengthX = ratioX+ deltaX1*PixelWidthInCm
			lengthY = ratioY + deltaY1*PixelWidthInCm
			SavePICT/O/E=-6/RES=300/M/W=(0,0,lengthX,lengthY)
			//SavePICT/E=-6/RES=300/M/W=(0,0,9.98361,5.00944)
			//SavePICT/EF=1/E=-3/M/W=(0,0,lengthY,lengthX)
		break
	endswitch

	return 0
End

Function ButtonProc_Build3D(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here

			WAVE/T ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
			WAVE 		sw1			=	root:Load_and_Set_Panel:sw1	
			Variable number1 , number2, number3 
			Variable leftAngle , rightAngle , deltaAngle , numberFrames
			Variable position
			Variable help1 ,help2,help3,help4
			Variable i ,j ,k
			Variable tiltAngle
			Variable lowAngle
			STRUCT file_header fh
			Variable eShift
			
			DoWindow/F $"Angle_Energy"			//pulls the window to the front
			if (V_Flag==1)	
				DoWindow/K $"Angle_Energy"	
			endif
			
			DoWindow/F $"k_Space_2D"			//pulls the window to the front
			if (V_Flag==1)	
				DoWindow/K $"k_Space_2D"	
			endif
			
			NewDatafolder/O root:folder3D
			SetDataFolder root:folder3D
			Variable/G KineticFermi = 0
			Variable/G PhotonEnergy = 0
			Variable/G WorkFunction = 0
			Variable/G ifDerivative
			
			Variable counter1,test1
			counter1=DimSize(ListWave1,0)
			test1=-1
			for(i = 0; i < counter1 ; i += 1)
				if( cmpstr(ListWave1[i][1],"") == 0 )
					test1 = i 
					break
				endif
			endfor
			if(test1==-1)
				return 0
			endif
			
			number1 = test1 
			
			Variable deltaAngle1 = 0.5
			Variable startingN = 1
			Variable endAt = number1
			
			Prompt deltaAngle1, "Angular Separation between Frames:"
			Prompt startingN, "Start From:"
			Prompt endAt,"End At:"
			DoPrompt "SET PARMETERS FOR 3D BUILD",deltaAngle1, startingN,endAt
			
			if (V_Flag)
				return 0									// user canceled
			endif
			
			if(startingN>endAt)
				return 0 
			endif
			
			help1 = str2num(ListWave1[startingN-1][13])
			if( help1 != 0 ) 
				KineticFermi = help1
			endif
			help1 = str2num(ListWave1[startingN-1][11])
			if( help1 != 0 ) 
				PhotonEnergy  = help1
			endif
			help1 = str2num(ListWave1[startingN-1][12])
			if( help1 != 0 ) 
				WorkFunction  = help1
			endif
			
			Variable doFermi = 2
			Variable doDerivative = 1
			Variable SF = 2
			Prompt doFermi,"Do you know Kinetic Energy for Fermi level?",popup "No;Yes"
			Prompt doDerivative,"Make 2nd Derivative as well? (takes double memory)",popup "No;Derivative along Energy axis;Derivative along Angular axis;composite derivative (dI/dE) + (dI/dA)"
			DoPrompt "Choose",doFermi,doDerivative
			if (V_Flag)
				return -1		// Canceled
			endif
			doFermi -= 1
			doDerivative -= 1
			ifDerivative = doDerivative
			Variable PE, WF , KF
			PE = PhotonEnergy
			WF = WorkFunction
			if(KineticFermi == 0 )
				KF = PhotonEnergy - WorkFunction
			else
				KF = KineticFermi
			endif
			if(doFermi)
				Prompt PE, "Photon Energy [eV]"
				Prompt WF, "Work Function [eV]"
				Prompt KF, "Kinetic Energy of Fermi level [eV]"
				if(doDerivative)
					//Prompt SF, "Smoothing factor for 2nd Derivative"	
					DoPrompt "ENTER THE PARAMETERS",PE,WF, KF
				else
					DoPrompt "ENTER THE PARAMETERS",PE,WF, KF
				endif
				PhotonEnergy = PE
				WorkFunction = WF
				KineticFermi = KF
				if (V_Flag)
					return -1		// Canceled
				endif
				
			else
				Prompt PE, "Photon Energy in eV"
				Prompt WF, "Work Function in eV"	
				if(doDerivative)
					//Prompt SF,"Smoothing factor for 2nd Derivative"	
					DoPrompt "ENTER THE PARAMETERS",PE,WF
				else
					DoPrompt "ENTER THE PARAMETERS",PE,WF
				endif
				PhotonEnergy = PE
				WorkFunction = WF
				KineticFermi = PE - WF
				if (V_Flag)
					return -1		// Canceled
				endif
				
			endif
			
			Variable deltaAngle2
			Variable deltaEnergy
			Variable lowEnergy
			Variable upEnergy
			Variable minAngle
			Variable maxAngle
			
			leftAngle=0
			rightAngle=0
			deltaAngle2=0
			minAngle=str2num(ListWave1[startingN-1][3])
			maxAngle=minAngle
			
			Setdatafolder root:Specs:$ListWave1[startingN-1][1]
			WAVE waveX = $ListWave1[startingN-1][1]
			SetDataFolder root:folder3D
			Duplicate/O waveX, Angle_2D
			Cut_SetEmission( startingN-1 , Angle_2D )
			deltaAngle2=DimDelta(Angle_2D,1)
			leftAngle=DimOffset(Angle_2D,1)
			rightAngle=leftAngle + (DimSize(Angle_2D,1)-1)*deltaAngle2
			
			deltaEnergy=DimDelta(Angle_2D,0)
			lowEnergy=DimOffset(Angle_2D,0)
			upEnergy=lowEnergy + (DimSize(Angle_2D,0)-1)*deltaEnergy

			for(i=startingN;i<endAt;i+=1)
				help1=str2num(ListWave1[i][3])
				Setdatafolder root:Specs:$ListWave1[i][1]
				WAVE waveX = $ListWave1[i][1]
				SetDataFolder root:folder3D
				Duplicate/O waveX, Angle_2D
				Cut_SetEmission( i , Angle_2D )
				
				help2=DimDelta(Angle_2D,1) 
				help3=DimOffset(Angle_2D,1)
				help4=help3 + (DimSize(Angle_2D,1)-1)*help2
				
				if(help1<minAngle)
					minAngle=help1
				else
					if(help1>maxAngle)
						maxAngle=help1
					endif
				endif
				
				if(help2<deltaAngle2)
					deltaAngle2=help2	
				endif
				
				if(help3<leftAngle)
					leftAngle=help3
				endif
				
				if(help4>rightAngle)
					rightAngle=help4
				endif
				
				help2=DimDelta(Angle_2D,0) 
				help3=DimOffset(Angle_2D,0)
				help4=help3 + (DimSize(Angle_2D,0)-1)*help2
				
				if(help2<deltaEnergy)
					deltaAngle2=help2	
				endif
				
				if(help3<lowEnergy)
					lowEnergy=help3
				endif
				
				if(help4>upEnergy)
					upEnergy=help4
				endif
				KillWaves Angle_2D
			endfor
			
			numberFrames = endAt-startingN+1
			
			Variable nrPix1,nrPix2	
			SetDataFolder root:folder3D
			nrPix2=round((rightAngle-leftAngle)/deltaAngle2)+1
			nrPix1=round((upEnergy-lowEnergy)/deltaEnergy)+1
			
			Make/O/N=(nrPix1,nrPix2,numberFrames) Images3D
			Make/O/N=(numberFrames) Multipliers
			Multipliers = 1
			
			SetScale /P x, lowEnergy, deltaEnergy , "" , Images3D
			SetScale /P y, leftAngle, deltaAngle2 , "" , Images3D
			SetScale /P z, minAngle, deltaAngle1 , "" , Images3D
			Make /FREE /N=(nrPix1) v1
			Make /FREE /N=(nrPix2) v2
			
			Variable La
			Variable Ra
			Variable He
			Variable Le
			Variable indexE1
			Variable indexE2
			Variable indexA1
			Variable indexA2
			Variable indexF
			
			Variable temp1,temp2
			if(doDerivative)
				switch(doDerivative)
					case 1:
						Duplicate/O Images3D, Images3Dder
						break
					case 2:
						Duplicate/O Images3D, Images3Dder	
						break
					case 3:
						Duplicate/O Images3D, Images3Dder
						break	
				endswitch
			endif
			
			
			for(i=startingN-1;i<endAt;i+=1)
				Setdatafolder root:Specs:$ListWave1[i][1]
				WAVE waveX = $ListWave1[i][1]
				SetDataFolder root:folder3D
				Duplicate/O waveX, Angle_2D
				Final_2D( i , Angle_2D )
				Duplicate/O Angle_2D, Angle_2D_1
				Smooth_2D(Angle_2D, 0, str2num(ListWave1[i][14]))
				Smooth_2D(Angle_2D, 1, str2num(ListWave1[i][15]))
				
				Smooth_2D(Angle_2D_1, 0, str2num(ListWave1[i][14]))
				Smooth_2D(Angle_2D_1, 1, str2num(ListWave1[i][15]))
				
				La = DimOffset(Angle_2D,1)
				Ra = DimOffset(Angle_2D,1) + (DimSize(Angle_2D,1)-1)*DimDelta(Angle_2D,1)
				He = DimOffset(Angle_2D,0) + (DimSize(Angle_2D,0)-1)*DimDelta(Angle_2D,0)
				Le = DimOffset(Angle_2D,0)
				
				indexE1 = round ( ( Le - DimOffset(Images3D,0) ) / DimDelta(Images3D,0) )
				indexE2 = round ( ( He - DimOffset(Images3D,0) ) / DimDelta(Images3D,0) ) 
				indexA1 = round ( ( La - DimOffset(Images3D,1) ) / DimDelta(Images3D,1) )
				indexA2 = round ( ( Ra - DimOffset(Images3D,1) ) / DimDelta(Images3D,1) ) 
				help1 = str2num(ListWave1[i][3])
				help2 = DimOffset(Images3D,2)
				help3 = DimDelta(Images3D,2)
				indexF = round ( ( str2num(ListWave1[i][3]) - DimOffset(Images3D,2) ) / DimDelta(Images3D,2) )
				
				Images3D[indexE1,indexE2][indexA1,IndexA2][indexF] = Angle_2D(x)(y)
				if(doDerivative)
					switch(doDerivative)
						case 1:
							Diff_2D(Angle_2D, 0)
							Cut_Negative_2D(Angle_2D)
							Images3Dder[indexE1,indexE2][indexA1,IndexA2][indexF] = Angle_2D(x)(y)
							break
						case 2:
							Diff_2D(Angle_2D_1, 1)
							Cut_Negative_2D(Angle_2D_1)
							Images3Dder[indexE1,indexE2][indexA1,IndexA2][indexF] = Angle_2D_1(x)(y)
							break
						case 3:
							Diff_2D(Angle_2D, 0)
							Cut_Negative_2D(Angle_2D)
							Diff_2D(Angle_2D_1, 1)
							Cut_Negative_2D(Angle_2D_1)
							Images3Dder[indexE1,indexE2][indexA1,IndexA2][indexF] = Angle_2D_1(x)(y) + Angle_2D(x)(y)
							break	
					endswitch
				endif
				
			endfor
			
			KillWaves Angle_2D
			if( waveExists (Angle_2D1) )
				KillWaves Angle_2D1
			endif
			if( waveExists (Angle_2D_1) )
				KillWaves Angle_2D_1
			endif
			SetDataFolder root:folder3D
			Make/O/N=(DimSize(Images3D,1),numberFrames) Image3
			
			Make/O/N=(DimSize(Images3D,0),DimSize(Images3D,1)) ImageX
			Make/O/N=(DimSize(Images3D,0),numberFrames) ImageY
			
			SetScale /P x, DimOffset(Images3D,1), DimDelta(Images3D,1) , "" , Image3
			SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "" , Image3
			
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , ImageX
			SetScale /P y, DimOffset(Images3D,1), DimDelta(Images3D,1) , "" , ImageX
			
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , ImageY
			SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "" , ImageY
			
			Image3[][] = Images3D[0][p][q]
			
			ImageX[][] = Images3D[p][q][0]
			ImageY[][] = Images3D[p][0][q]
			Duplicate/O ImageX , ImageX_B
			Duplicate/O ImageY , ImageY_B
			
			DoWindow/F $"Angle_Energy"			//pulls the window to the front
			if (V_Flag==1)	
				DoWindow/K $"Angle_Energy"	
				DoUpdate
				Display/K=1 /W=(10,70,450,417)
				Dowindow/C $"Angle_Energy"	
				ControlBar/T 70
				AppendImage /L=leftImageX /B=bottomImageX ImageX
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph freePos(leftImageX)={0.1,kwFraction}
				ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImageX)={0.1,1}
				ModifyGraph axisEnab(leftImageX)={0.1,0.50}

				AppendImage /L=leftImageY /B=bottomImageY ImageY
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph freePos(leftImageY)={0.6,kwFraction}
				ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
				ModifyGraph axisEnab(leftImageY)={0.1,1}
				ModifyGraph axisEnab(bottomImageY)={0.6,1}
				
				Wavestats/Q/Z ImageX
				
				TitleBox zmin1 title="Min",pos={10,10}
				Slider contrastmin1,vert= 0,pos={40,10},size={200,16},proc=contrast2
				Slider contrastmin1,limits={V_min,V_max,0},ticks= 0,value=V_min
			
				TitleBox zmax1 title="Max",pos={10,40}
				Slider contrastmax1,vert= 0,pos={40,40},size={200,16},proc=contrast2
				Slider contrastmax1,limits={V_min,V_max,0},ticks= 0,value=V_max
				
				Wavestats/Q/Z ImageY
				
				TitleBox zmin2 title="Min",pos={270,10}
				Slider contrastmin2,vert= 0,pos={300,10},size={200,16},proc=contrast3
				Slider contrastmin2,limits={V_min,V_max,0},ticks= 0,value=V_min
			
				TitleBox zmax2 title="Max",pos={270,40}
				Slider contrastmax2,vert= 0,pos={300,40},size={200,16},proc=contrast3
				Slider contrastmax2,limits={V_min,V_max,0},ticks= 0,value=V_max
				
				CheckBox check1,pos={520,10},size={104,16},title="B/K"
				CheckBox check1,labelBack=(47872,47872,47872),fSize=16,value= 0
				CheckBox check1,proc=ChangeKB
					
			else
				Display/K=1 /W=(10,70,450,417)
				Dowindow/C $"Angle_Energy"	
				ControlBar/T 70
				AppendImage /L=leftImageX /B=bottomImageX ImageX
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph freePos(leftImageX)={0.1,kwFraction}
				ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImageX)={0.1,1}
				ModifyGraph axisEnab(leftImageX)={0.1,0.5}
				
				AppendImage  /L=leftImageY /B=bottomImageY ImageY
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph freePos(leftImageY)={0.6,kwFraction}
				ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
				ModifyGraph axisEnab(leftImageY)={0.1,1}
				ModifyGraph axisEnab(bottomImageY)={0.6,1}
				
				Wavestats/Q/Z ImageX
				DoUpdate
				TitleBox zmin1 title="Min",pos={10,10}
				Slider contrastmin1,vert= 0,pos={40,10},size={200,16},proc=contrast2
				Slider contrastmin1,limits={V_min,V_max,0},ticks= 0,value=V_min
			
				TitleBox zmax1 title="Max",pos={10,40}
				Slider contrastmax1,vert= 0,pos={40,40},size={200,16},proc=contrast2
				Slider contrastmax1,limits={V_min,V_max,0},ticks= 0,value=V_max
				
				Wavestats/Q/Z ImageY
				DoUpdate
				TitleBox zmin2 title="Min",pos={270,10}
				Slider contrastmin2,vert= 0,pos={300,10},size={200,16},proc=contrast3
				Slider contrastmin2,limits={V_min,V_max,0},ticks= 0,value=V_min
			
				TitleBox zmax2 title="Max",pos={270,40}
				Slider contrastmax2,vert= 0,pos={300,40},size={200,16},proc=contrast3
				Slider contrastmax2,limits={V_min,V_max,0},ticks= 0,value=V_max
				
				CheckBox check1,pos={520,10},size={104,16},title="B/K"
				CheckBox check1,labelBack=(47872,47872,47872),fSize=16,value= 0
				CheckBox check1,proc=ChangeKB
				
			endif
			
			DoWindow/F $"k_Space_2D"			//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow $"Profiles_FinalBlend"
			//endif
			//------------display the results
			if (V_Flag==1)	
				
			else
				Display/K=1 /W=(350,80,850,550)
				Dowindow/C $"k_Space_2D"		
	
				AppendImage /L=bottomImage3 /B=leftImage3 Image3
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				
				ControlBar/L 190
				ControlBar/T 100
				
				DoUpdate 
				ModifyGraph margin =40
				ModifyGraph margin(right) =20
				ModifyGraph margin(top) =10
				ModifyGraph mode=2,rgb=(0,0,0)
				DoUpdate 
				ModifyGraph freePos(leftImage3)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage3)={0.1,1}
				ModifyGraph axisEnab(leftImage3)={0.1,1}
				ModifyGraph margin(bottom)=20	
				DoUpdate 	
				
				GetAxis bottomImage3
				DoUpdate 
				SetVariable SetBottomLeft,pos={5,105},size={80,20},proc=SetAxis3,title="L"
				SetVariable SetBottomLeft,fSize=15,limits={-inf,inf,0.01},value= _NUM: V_min
				
				SetVariable SetBottomRight,pos={90,105},size={80,20},proc=SetAxis3,title="R"
				SetVariable SetBottomRight,fSize=15,limits={-inf,inf,0.01},value= _NUM:V_max
				
				GetAxis leftImage3
				DoUpdate 
				SetVariable SetLeftUpper,pos={25,140},size={100,20},proc=SetAxis3,title="   Up"
				SetVariable SetLeftUpper,fSize=15,limits={-inf,inf,0.01},value= _NUM:V_max
				
				SetVariable SetLeftLower,pos={20,170},size={100,20},proc=SetAxis3,title="Down"
				SetVariable SetLeftLower,fSize=15,limits={-inf,inf,0.01},value= _NUM:V_min
				
				GetAxis /W=Angle_Energy bottomImageX
				SetVariable SetHigher,pos={10,205},size={140,20},proc=SetAxis3,title="  High"
				SetVariable SetHigher,fSize=15,limits={-inf,inf,0.01},value= _NUM:V_max
				
				SetVariable SetBottom,pos={10,235},size={140,20},proc=SetAxis3,title="Bottom"
				SetVariable SetBottom,fSize=15,limits={-inf,inf,0.01},value= _NUM:V_min
				
				
				SetVariable SetLayers,pos={20,320},size={110,30},proc=SetLayer,live=1,title="Nr."
				SetVariable SetLayers,fSize=24,limits={0,DimSize(Images3D,0),1},value= _NUM:0
				
				ValDisplay Energy1, pos={30,360} , value=_NUM:(DimOffset( Images3D,0 )),   title="[eV]",size={100,30},value=0,frame=1,fSize=16
				DelayUpdate
				
				ValDisplay Energy1, value=_NUM:(DimOffset( Images3D,0 ))
				
				ValDisplay Energy2, pos={30,390} ,   title="[eV]",size={100,30},value=0,frame=1,fSize=16
				DelayUpdate
				
				if(doFermi)
					//Ymin=DimOffset( Amatrix,0 ) 
					ValDisplay Energy2, value=_NUM:(DimOffset( Images3D,0 )-KineticFermi)
					SetScale /P x, (DimOffset( Images3D,0 )-KineticFermi), DimDelta(Images3D,0) , "" , ImageX_B
					SetScale /P x, (DimOffset( Images3D,0 )-KineticFermi), DimDelta(Images3D,0) , "" , ImageY_B
				else
					//Ymin=DimOffset( Amatrix,0 ) 
					ValDisplay Energy2, value=_NUM:(DimOffset( Images3D,0 )-PhotonEnergy + WF)
					SetScale /P x, (DimOffset( Images3D,0 )-PhotonEnergy + WF), DimDelta(Images3D,0) , "" , ImageX_B
					SetScale /P x, (DimOffset( Images3D,0 )-PhotonEnergy + WF), DimDelta(Images3D,0) , "" , ImageY_B
				endif
			
				DoUpdate 
				Button Export2,pos={35,660},size={100,50},proc=ExportImages2,title="Export"
				Button Export2,fSize=14
				DoUpdate 
				Button Equalize,pos={35,480},size={100,50},proc=Equalize1,title="Equalize"
				Button Equalize,fSize=14
			
				Button Equalize2,pos={35,540},size={100,50},proc=Equalize2,title="Equalize\rto plane"
				Button Equalize2,fSize=14
				
				Button Double,pos={35,600},size={100,50},proc=DoubleSlices,title="Double\rSlices"
				Button Double,fSize=14
				
				//SetVariable Smooth1,pos={15,545},size={100,20},proc=SmoothX,title="SmoothX"
				//SetVariable Smooth1,fSize=15,limits={0,1000,1},value= _NUM:0
				
				//Button D3Dd,pos={15,5},size={70,40},proc=Display3Dder,title="Go to\r2nd Der."
				//Button D3Dd,fSize=14
				
				SetVariable Param1,pos={30,265},size={100,20},live=1,title="Gamma" , proc=SetVarProc_Gamma
				SetVariable Param1,fSize=16,limits={0,inf,0.1},value= _NUM:1
				
				Slider Line1 , pos={210,5} , size={350,13} , proc=moveLine1 , live=1
				Slider Line1 , limits = { 0 , ( DimSize(Image3,1) - 1 ) , 1 } , value= 0 , side= 0 , vert= 0 , ticks= 0
				
				Slider Line2 , pos={160,140} , size={10,400} , proc=moveLine2 , live=1
				Slider Line2 , limits = { 0 , ( DimSize(Image3,0) - 1 ) , 1 } , value= 0 , side= 0 , vert= 1 , ticks= 0
			
				//ValDisplay Position1, pos={100,5} , value=0,   title="Position",size={100,20},value=0,frame=1,fSize=14
				SetVariable Position1,pos={100,5},size={100,30},proc=moveLine1Btn,title="Position"
				SetVariable Position1,fSize=14,limits={0, inf,1},value= _NUM:0
				
				ValDisplay Position2, pos={120,25} , value=0,  title="unit", size={80,20},value=0,frame=1,fSize=14
				
				//ValDisplay Position3, pos={5,50} , value=0,   title="Position",size={100,20},value=0,frame=1,fSize=14
				SetVariable Position3,pos={5,50},size={100,30},proc=moveLine2Btn,title="Position"
				SetVariable Position3,fSize=14,limits={0, inf,1},value= _NUM:0
				
				ValDisplay Position4, pos={5,70} , value=0,  title="unit", size={80,20},value=0,frame=1,fSize=14
				
				SetVariable Multiplier,pos={580,5},size={110,20},proc=SetMultiplier,live=1,title="Multiplier"
				SetVariable Multiplier,fSize=14,limits={0,100,0.01},value= _NUM:1
				
				Button Reset1,pos={575,28},size={55,20},proc=ResetMultipliers,title="Reset"
				Button Reset1,fSize=14
				
				Button Accept1,pos={635,28},size={55,20},proc=AcceptMultipliers,title="Accept"
				Button Accept1,fSize=14
				
				//Button cut1,pos={5,70},size={40,20},proc=Cut3D,title="Cut"
				//Button cut1,fSize=14
				
				SetVariable ShiftX,pos={330,25},size={100,30},title="Set_X"
				SetVariable ShiftX,fSize=14,limits={-inf,inf,0.1},value= _NUM:0
				
				SetVariable ShiftY,pos={450,25},size={100,30},title="Set_Y"
				SetVariable ShiftY,fSize=14,limits={-inf,inf,0.1},value= _NUM:0
			
				Button SetOffset,pos={230,23},size={90,25},proc=ShiftAxis3D,title="Set Axis"
				Button SetOffset,fSize=14

				//Button kPar,pos={15,570},size={70,40},proc=toKpar,title="Change\rto K par."
				//Button kPar,fSize=14
				
				CheckBox check2,pos={90,290},size={104,16},title="kx ky"
				CheckBox check2,proc=CheckProcToKpar
				CheckBox check2,labelBack=(47872,47872,47872),fSize=18,value= 0
				
				CheckBox check1,pos={10,290},size={104,16},title="Equ."
				CheckBox check1,labelBack=(47872,47872,47872),fSize=18,value= 0
				
				CheckBox check3,pos={2,2},size={104,16},title="Cursors"
				CheckBox check3,labelBack=(47872,47872,47872),fSize=16,value= 0
				CheckBox check3,proc=ShowHideCursor , disable = 2
				
				CheckBox check4,pos={2,20},size={104,16},title="Tools"
				CheckBox check4,labelBack=(47872,47872,47872),fSize=16,value= 0
				CheckBox check4,proc=ShowTools1
				
				CheckBox check5,pos={110,70},size={100,20},title="Der."
				CheckBox check5,labelBack=(47872,47872,47872),fSize=18,value= 0
				CheckBox check5,proc=CheckProcToDer
				
				SetVariable rotation,pos={5,420},size={140,30},proc=rotateImage,live=1,title="rotate\rby x deg"
				SetVariable rotation,fSize=16,limits={-inf, inf,1},value= _NUM:0,disable=2
				
				if(!doDerivative)
					CheckBox check5,disable = 2
				endif
				Wavestats/Q/Z Image3
				
				TitleBox zmin title="Min",pos={185,75}
				Slider contrastmin,vert= 0,pos={220,75},size={290,16},proc=contrast1
				Slider contrastmin,limits={V_min,V_max,0},ticks= 0,value=V_min
			
				TitleBox zmax title="Max",pos={185,55}
				Slider contrastmax,vert= 0,pos={220,55},size={290,16},proc=contrast1
				Slider contrastmax,limits={V_min,V_max,0},ticks= 0,value=V_max
				
				String listColors 
				listColors = CTabList()
				PopupMenu popup0,pos={555,65},size={65,20},proc=ChangeColor2
				PopupMenu popup0,mode=1,popvalue="Grays",value= "*COLORTABLEPOP*"
				//PopupMenu popup0,mode=1,popvalue="Grays",value= #"\"Grays;VioletOrangeYellow\""
				
				Button Button_MakeMovie,pos={10,720},size={70,40},proc=ButtonProc_MakeMovie,title="Movie"
				Button Button_MakeMovie,fSize=14
				Button Button_MakeMovie,disable = 2
				
				Button Button_Average,pos={100,720},size={80,40},proc=ButtonProc_MakeMovie,title="Avarage"
				Button Button_Average,fSize=14
				Button Button_Average,disable = 2
				
				DoUpdate 
				GetWindow $"k_Space_2D" wavelist
				
			endif
			
		break
	endswitch

	return 0
End

Function Cut3D(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			//DoWindow/F Profiles_FinalBlend				//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow Profiles_FinalBlend
			//endif
			
		break
		
		case 2: // mouse up
			// click code here
			STRING name1, name2
			
			Setdatafolder root:Specs:
			WAVE Images3D
			WAVE Images3Dder
			WAVE Multipliers
			WAVE ImageX
			WAVE ImageY
			WAVE Image3
			
			Variable x1,x2,y1,y2,z1,z2
			ControlInfo /W=k_Space_2D SetBottomLeft
			y1 = V_value
			ControlInfo /W=k_Space_2D SetBottomRight
			y2 = V_value
			ControlInfo /W=k_Space_2D SetLeftUpper
			x2 = V_value
			ControlInfo /W=k_Space_2D SetLeftLower
			x1 = V_value
			ControlInfo /W=k_Space_2D SetHigher
			z2 = V_value
			ControlInfo /W=k_Space_2D SetBottom
			z1 = V_value
			
			Variable numberX , numberY , numberZ
			Variable offsetX , offsetY, offsetZ
			numberX =  floor( (z2 - z1) / DimDelta (Images3D,0) ) + 1
			numberY = floor( (x2 - x1) / DimDelta (Images3D,1) ) + 1
			numberZ =  floor( (y2 - y1) / DimDelta (Images3D,2) ) + 1 
			Variable help1 = DimOffset( Images3D,0 )
			offsetX = floor ( abs(DimOffset( Images3D,0 ) - z1) / DimDelta(Images3D,0) ) 
			offsetY = floor ( abs(DimOffset( Images3D,1 ) - x1) / DimDelta(Images3D,1) ) 
			offsetZ = floor ( abs(DimOffset( Images3D,2 ) - y1) / DimDelta(Images3D,2) ) 
			
			SetDataFolder root:Specs:
			Make/O/N=(numberX, numberY, numberZ) MatrixCut
			
			SetScale /P x, DimOffset( Images3D,0 )+offsetX*DimDelta (Images3D,0), DimDelta (Images3D,0) , "Energy" ,MatrixCut
			SetScale /P y, DimOffset( Images3D,1 )+offsetY*DimDelta (Images3D,1), DimDelta (Images3D,1) , "Angle" , MatrixCut
			SetScale /P z, DimOffset( Images3D,2 )+offsetZ*DimDelta (Images3D,2), DimDelta (Images3D,2) , "Angle" , MatrixCut
			
			MatrixCut[][][] = Images3D[p + offsetX][q + offsetY][r + offsetZ]
			KillWaves Images3D
			Duplicate/O MatrixCut , Images3D
			
			MatrixCut[][][] = Images3Dder[p + offsetX][q + offsetY][r + offsetZ]
			KillWaves Images3Dder
			Duplicate/O MatrixCut , Images3Dder
			KillWaves MatrixCut
			
			Make/O/N=(DimSize(Images3D,0),DimSize(Images3D,1)) ImageX
			Make/O/N=(DimSize(Images3D,0),DimSize(Images3D,2)) ImageY
			Make/O/N=(DimSize(Images3D,1),DimSize(Images3D,2)) Image3
			Make/O/N=(DimSize(Images3D,1),DimSize(Images3D,2)) Image3der
			
			SetScale /P x, DimOffset(Images3D,1), DimDelta(Images3D,1) , "Angle" , Image3
			SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "Angle" , Image3
			
			SetScale /P x, DimOffset(Images3D,1), DimDelta(Images3D,1) , "Angle" , Image3der
			SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "Angle" , Image3der
			
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , ImageX
			SetScale /P y, DimOffset(Images3D,1), DimDelta(Images3D,1) , "Angle" , ImageX
			
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , ImageY
			SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "Angle" , ImageY
			
			Image3[][] = Images3D[0][p][q]
			ImageX[][] = Images3D[p][q][0]
			ImageY[][] = Images3D[p][0][q]
			
			SetVariable SetLayers,fSize=18,limits={0,DimSize(Images3D,0),1} , value = _NUM:0
			Slider Line1 , limits = { 0 , ( DimSize(Image3,1) - 1 ) , 1 } , value = 0
			Slider Line2 , limits = { 0 , ( DimSize(Image3,0) - 1 ) , 1 } , value = 0
			
			DoUpdate	
			GetAxis bottomImage3
			SetVariable SetBottomLeft,value= _NUM: V_min
			SetVariable SetBottomRight,value= _NUM:V_max
			
			GetAxis leftImage3
			SetVariable SetLeftUpper,value= _NUM:V_max
			SetVariable SetLeftLower,value= _NUM:V_min
			
			DoUpdate

		break
	endswitch
	return 0
End


Function SmoothX(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			String name1, name2
			
			Setdatafolder root:Specs:
			WAVE Images3D
			WAVE Images3Dori
			
			name2 =  ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			
			Variable Rows, Columns , Layers
			Variable Layers1
			Variable i, j , k, i0
			Variable Average1 , Average2
			Variable help1
			
			Rows 	= DimSize( Images3D, 0 )
			Columns	= DimSize( Images3D, 1 )
			Layers 	= DimSize( Images3D, 2 )
			Layers1 = Layers - 1
			Make/O/N =(Rows,Columns)  v1 
			Make/O/N =(Rows,Columns)  v2 
			Make/O/N =(Columns)  L1 
			Make/O/N =(Columns)  L2 
			
			for( i = 0 ; i < Rows ; i = i + 1 )
				for( j = 0 ; j < Columns ; j = j + 1 )
					L1 = Images3D[i][j][p]
					Smooth dval , L1
					Images3D[i][j][] = L1[r]
				endfor
			endfor	
			KillWaves v1,v2,L1,L2	
		break
	endswitch

	return 0
End


Function SetLayer(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			
			String name1, name2
			Wave /T W_WaveList
			Variable number
			
			Setdatafolder root:folder3D:
			NVAR KineticFermi
			NVAR PhotonEnergy
			NVAR WorkFunction
			Variable KF = KineticFermi
			Variable PE = PhotonEnergy
			Variable WF = WorkFunction
			
			Variable help5
			ControlInfo /W=k_Space_2D check5
			help5 = V_value
			if(help5)
				WAVE Images3D = Images3Dder
			else
				WAVE Images3D = Images3D
			endif
			
			WAVE Image3
			//WAVE Images3Dder
			WAVE M_ImageHistEq
			WAVE W_ImageHis
			WAVE Multipliers
			WAVE ImageX
			WAVE ImageY
			WAVE LayerN_K
			WAVE CutX_K
			WAVE CutY_K
			
			Variable deltaE
			Variable x0
			Variable Energy
			Variable help1,help2,help3,help4  ,help6,help7
			Variable positionY
			Variable positionZ
			
			ControlInfo /W=k_Space_2D check1
			help1 = V_value
			ControlInfo /W=k_Space_2D Param1
			help2 = V_value
			ControlInfo /W=k_Space_2D check2
			help3 = V_value
			ControlInfo /W=k_Space_2D Energy1
			help4 = V_value
			ControlInfo /W=k_Space_2D rotation
			help6 = V_value
			ControlInfo /W=k_Space_2D SetLayers
			help7 = V_value
			
			String nameI
			nameI = ImageNameList("", "" )
			nameI = StringFromList (0, nameI  , ";")
				
			Make/O/N=(256) W_ImageHis
			Wave /T W_WaveList
			Variable i , number2,j
			
			switch(help3)
				case 0:
					number2 = DimSize (Images3D, 2)
					
					Image3[][] = Images3D[dval][p][q]
			
					for( i = 0 ; i < number2 ; i = i +1)
						Image3[][i] = 	Image3[p][i]*Multipliers[i]
					endfor
			
					Image3 = Image3^help2
			
					x0 = DimOffset (Images3D,0)
					deltaE = DimDelta (Images3D,0)
					Energy = x0 + dval*deltaE
			
					ValDisplay Energy1, value=_NUM:Energy
			
					ValDisplay Energy2, value=_NUM:(x0-KineticFermi + dval*deltaE)
				
					if(help1 == 1)
						ImageHistModification Image3
						Image3 = M_ImageHistEq	
					endif
			
					Wavestats/Q/Z Image3
					Slider contrastmin,limits={V_min,V_max,0} 
					Slider contrastmax,limits={V_min,V_max,0}

					break

				case 1:
					Variable kx1,kx2,ky1,ky2
			
					x0 = DimOffset (Images3D,0)
					deltaE = DimDelta (Images3D,0)
					Energy = x0 + dval*deltaE
			
					ValDisplay Energy1, value=_NUM:Energy
					ValDisplay Energy2, value=_NUM:(x0 + dval*deltaE-KineticFermi)
					
					if(help1 == 1)
						ImageHistModification Image3
						Image3 = M_ImageHistEq	
					endif
					
					Variable C2
					C2 = 180/Pi
					
					Variable Xmin, Xmax, Ymin, Ymax, Zmin , Zmax
					Xmin = DimOffset(Images3D,1)
					Xmax = DimOffset(Images3D,1) + (Dimsize(Images3D,1)-1) *DimDelta(Images3D,1)
					Ymin = DimOffset(Images3D,2)
					Ymax = DimOffset(Images3D,2) + (Dimsize(Images3D,2)-1) *DimDelta(Images3D,2)
					Zmin = DimOffset(Images3D,0)
					Zmax = DimOffset(Images3D,0) + (Dimsize(Images3D,0)-1) *DimDelta(Images3D,0)
					
					Variable Xzero1
					if(Xmin>0)
						Xzero1 = Xmin
					else
						if(Xmax<0)
							Xzero1 = Xmax
						else
							Xzero1 = 0
						endif
					endif
					
					Variable Xzero2
					if(Xmin>=0)
						Xzero2 = Xmax
					else
						if(Xmax<0)
							Xzero2 = Xmin
						else
							if(Xmax>(-Xmin))
								Xzero2 = Xmax
							else
								Xzero2 = Xmin
							endif
						endif
					endif
					
					kx1 = 0.512*sqrt(Zmax)*sin(Xmin*Pi/180)
					kx2 = 0.512*sqrt(Zmax)*sin(Xmax*Pi/180)
					if(Ymax >=0 )
						ky2 = 0.512*sqrt(Zmax)*sin(Ymax*Pi/180)*cos(Xzero1*Pi/180)
					else
						ky2 = 0.512*sqrt(Zmin)*sin(Ymax*Pi/180)*cos(Xzero2*Pi/180)
					endif
					
					if(Ymin >=0 )
						ky1 = 0.512*sqrt(Zmin)*sin(Ymin*Pi/180)*cos(Xzero1*Pi/180)
					else
						ky1 = 0.512*sqrt(Zmax)*sin(Ymin*Pi/180)*cos(Xzero2*Pi/180)
					endif					
					
					Variable ResolutionX, ResolutionY 
					Variable delta_k_n , delta_k_m
					
					ResolutionX = Dimsize(Images3D,1)
					ResolutionY = Dimsize(Images3D,2)*4
					//Make/O/N=(ResolutionY, ResolutionX) LayerN_K
					//Setscale/I x,kx1,kx2,"" LayerN_K
					//Setscale/I y,ky1,ky2,"" LayerN_K
					delta_k_n = (kx2 - kx1)/(ResolutionX-1)
					delta_k_m = (ky2 - ky1)/(ResolutionY-1)
					
					Variable C3
					C3 = Pi/180
					Variable sinAlfa
					Variable cosAlfa
					sinAlfa = sin(help6*C3)
					cosAlfa = cos(help6*C3)
					
					Make/O /N=(2,4) coordinates1
					Make/O /N=(2,4) coordinates2
					coordinates1[0][0] = kx1
					coordinates1[0][1] = kx1
					coordinates1[0][2] = kx2
					coordinates1[0][3] = kx2
					coordinates1[1][0] = ky1
					coordinates1[1][1] = ky2
					coordinates1[1][2] = ky1
					coordinates1[1][3] = ky2
					for(i=0;i<2;i+=1)
						for(j=0;j<4;j+=1)
							coordinates2[0][j] = coordinates1[0][j]*cosAlfa + coordinates1[1][j]*sinAlfa
							coordinates2[1][j] = -coordinates1[0][j]*sinAlfa + coordinates1[1][j]*cosAlfa
						endfor
					endfor
					
					Variable x1Prime , x2Prime , y1Prime , y2Prime
					x1Prime = coordinates2[0][0]
					x2Prime = coordinates2[0][0]
					y1Prime = coordinates2[1][0]
					y2Prime = coordinates2[1][0]
					Variable temp1,temp2
					for(j=1;j<4;j+=1)
						temp1 = coordinates2[0][j]
						if(temp1<x1Prime)
							x1Prime = temp1
						endif
						if(temp1>x2Prime)
							x2Prime = temp1
						endif
						temp2 = coordinates2[1][j]
						if(temp2<y1Prime)
							y1Prime = temp2
						endif
						if(temp2>y2Prime)
							y2Prime = temp2
						endif
					endfor
					kx1 = x1Prime
					kx2 = x2Prime
					ky1 = y1Prime
					ky2 = y2Prime
					
					Variable sizeXprime , sizeYprime
					sizeXprime = DimSize(Images3D,1)*abs(cosAlfa) + DimSize(Images3D,2)*4*abs(sinAlfa)
					sizeYprime = DimSize(Images3D,1)*abs(sinAlfa) + DimSize(Images3D,2)*4*abs(cosAlfa)
					ResolutionX = round(sizeXprime)
					ResolutionY = round(sizeYprime)
					//Prompt ResolutionX, "Number of pixels along X axis"
					//Prompt ResolutionY, "Number of pixels along Y axis"			
					//DoPrompt "SET THE PARAMETERS",ResolutionX,ResolutionY
					
					Make/O/N=(ResolutionX, ResolutionY) LayerN_K
					Make/O/N=(Dimsize(Images3D,0), ResolutionX) CutX_K
					Make/O/N=(Dimsize(Images3D,0), ResolutionY) CutY_K
				
					Setscale/I y,ky1,ky2,"" LayerN_K
					Setscale/I x,kx1,kx2,"" LayerN_K
					
					SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , CutX_K
					SetScale /I y, kx1, kx2 , "" , CutX_K
			
					SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , CutY_K
					SetScale /I y, ky1, ky2 , "" , CutY_K
					
					Variable x1,y1, x2, x2p, y2
					Variable imax , jmax , deltai, deltaj , y0

					
					Variable C1 ,C4
					Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
					Variable delta_phi , delta_theta
					Variable k_n0 , k_m0 , phi0 , theta0
					Variable phi1 , phi2 , theta1 , theta2
					Variable i_n , j_m 
					Variable n_max , m_max
					Variable i_max , j_max
					Variable i_1 , i_2 , j_1 , j_2
					Variable wL , wR , wU , wD 
					
					Variable energy2
					energy2 = PE-WF+ energy - KF
					C1 = 1/(0.512*sqrt(energy2))
					C2 = 180/Pi
					C3 = Pi/180
					
					n_max = DimSize (LayerN_K,0)
					m_max = DimSize (LayerN_K,1)
					
					//k_n0 = DimOffset (LayerN_K,0)
					//k_m0 = DimOffset (LayerN_K,1)
					
					delta_k_n = DimDelta (LayerN_K,0)
					delta_k_m = DimDelta (LayerN_K,1)
					
					SetAxis bottomImage3 ky1-delta_k_m,ky2+delta_k_m
					SetAxis leftImage3 kx1-delta_k_n,kx2+delta_k_n
					
					//Variable delta_kn_prime
					//Variable delta_km_prime
					
					//delta_kn_prime = delta_k_n*cosAlfa + delta_k_m*sinAlfa
					//delta_km_prime = -delta_k_n*sinAlfa + delta_k_m*cosAlfa
					//delta_k_n = delta_kn_prime
					//delta_k_m = delta_km_prime
					
					i_max = DimSize (Images3D,1)
					j_max = DimSize (Images3D,2)
					
					phi0 = DimOffset (Images3D,1)
					theta0 = DimOffset (Images3D,2)
					
					delta_phi = DimDelta (Images3D,1)
					delta_theta = DimDelta (Images3D,2)
					
					k_n = kx1
					k_m = ky1
					
					//Variable sinFiPrime, FiPrime_rad  ,FiPrime
					//Variable sinThetaPrime, ThetaPrime_rad ,ThetaPrime
					Variable sinPhi
					Variable cosPhi
					Variable sinTheta
					Variable deltaFiPrime
					Variable deltaThetaPrime
					sinAlfa = sin(help6*C3)
					cosAlfa = cos(help6*C3)
					LayerN_K = NaN
					for( n=0;n<n_max;n=n+1)
						for( m=0;m<m_max;m=m+1)
							sinPhi = C1*(cosAlfa*k_n - sinAlfa*k_m)
							phi_n_rad = asin( sinPhi )
							phi_n = phi_n_rad * C2
							i_n = (phi_n - phi0)/delta_phi
							if(i_n>=0 && i_n<=i_max)
								cosPhi = sqrt(1-sinPhi*sinPhi)
								C4 = C1/ cosPhi
								sinTheta = C4*(sinAlfa*k_n + cosAlfa*k_m)
								theta_m = asin( sinTheta ) * C2
								j_m = (theta_m - theta0)/delta_theta
								if(j_m>=0 && j_m<=j_max)	
									i_1 = floor(i_n)
									i_2 = ceil(i_n)
									j_1 = floor(j_m)
									j_2 = ceil(j_m)
									wR = i_n - i_1
									wL = 1 - wR
									wU = j_m - j_1
									wD = 1 - wU
									LayerN_K[n][m] = Images3D(energy)[i_1][j_1]*wL*wD + Images3D(energy)[i_2][j_1]*wR*wD + Images3D(Energy)[i_1][j_2]*wL*wU + Images3D(Energy)[i_2][j_2]*wR*wU
								else
									LayerN_K[n][m] = Nan
								endif
								
							else
								LayerN_K[n][m] = Nan
							endif
							k_m = k_m + delta_k_m
						endfor
						k_m = ky1
						k_n = k_n + delta_k_n
					endfor
					
					if( help2 != 1)
						if(help2 !=1)
							LayerN_K = LayerN_K^help2
						endif
					endif
					
					if(help1 == 1)
						ImageHistModification LayerN_K
						LayerN_K = M_ImageHistEq		
					endif
					
					Wavestats/Q/Z LayerN_K
					DoUpdate
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					DoUpdate
				break
				
			endswitch
			
		break
	endswitch

	return 0
End

Function rotateImage(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			
			String name1, name2
			Wave /T W_WaveList
			Variable number
			
			Setdatafolder root:folder3D:
			NVAR KineticFermi
			NVAR PhotonEnergy
			NVAR WorkFunction
			Variable KF = KineticFermi
			Variable PE = PhotonEnergy
			Variable WF = WorkFunction
			
			Variable help5
			ControlInfo /W=k_Space_2D check5
			help5 = V_value
			if(help5)
				WAVE Images3D = Images3Dder
			else
				WAVE Images3D = Images3D
			endif
			
			WAVE Image3
			//WAVE Images3Dder
			WAVE M_ImageHistEq
			WAVE W_ImageHis
			WAVE Multipliers
			WAVE ImageX
			WAVE ImageY
			WAVE LayerN_K
			WAVE CutX_K
			WAVE CutY_K
			
			Variable deltaE
			Variable x0
			Variable Energy
			Variable help1,help2,help3,help4 ,help6,help7
			Variable positionY
			Variable positionZ
			
			ControlInfo /W=k_Space_2D check1
			help1 = V_value
			ControlInfo /W=k_Space_2D Param1
			help2 = V_value
			ControlInfo /W=k_Space_2D check2
			help3 = V_value
			ControlInfo /W=k_Space_2D Energy1
			help4 = V_value
			ControlInfo /W=k_Space_2D rotation
			help6 = V_value
			ControlInfo /W=k_Space_2D SetLayers
			help7 = V_value
					
			String nameI
			nameI = ImageNameList("", "" )
			nameI = StringFromList (0, nameI  , ";")
				
			Make/O/N=(256) W_ImageHis
			Wave /T W_WaveList
			Variable i , number2 ,j
			
			switch(help3)
				case 0:
					
					break

				case 1:
					Variable kx1,kx2,ky1,ky2
			
					x0 = DimOffset (Images3D,0)
					deltaE = DimDelta (Images3D,0)
					Energy = x0 + help7*deltaE
			
					//ValDisplay Energy1, value=_NUM:Energy
					//ValDisplay Energy2, value=_NUM:(x0 + help4*deltaE-KineticFermi)
					
					if(help1 == 1)
						ImageHistModification Image3
						Image3 = M_ImageHistEq	
					endif
					
					Variable C2
					C2 = 180/Pi
					//Variable layers
					//layers = DimSize (Images3D, 0)
			
					Variable Xmin, Xmax, Ymin, Ymax, Zmin , Zmax
					Xmin = DimOffset(Images3D,1)
					Xmax = DimOffset(Images3D,1) + (Dimsize(Images3D,1)-1) *DimDelta(Images3D,1)
					Ymin = DimOffset(Images3D,2)
					Ymax = DimOffset(Images3D,2) + (Dimsize(Images3D,2)-1) *DimDelta(Images3D,2)
					Zmin = DimOffset(Images3D,0)
					Zmax = DimOffset(Images3D,0) + (Dimsize(Images3D,0)-1) *DimDelta(Images3D,0)
					
					Variable Xzero1
					if(Xmin>0)
						Xzero1 = Xmin
					else
						if(Xmax<0)
							Xzero1 = Xmax
						else
							Xzero1 = 0
						endif
					endif
					
					Variable Xzero2
					if(Xmin>=0)
						Xzero2 = Xmax
					else
						if(Xmax<0)
							Xzero2 = Xmin
						else
							if(Xmax>(-Xmin))
								Xzero2 = Xmax
							else
								Xzero2 = Xmin
							endif
						endif
					endif
					
					kx1 = 0.512*sqrt(Zmax)*sin(Xmin*Pi/180)
					kx2 = 0.512*sqrt(Zmax)*sin(Xmax*Pi/180)
					if(Ymax >=0 )
						ky2 = 0.512*sqrt(Zmax)*sin(Ymax*Pi/180)*cos(Xzero1*Pi/180)
					else
						ky2 = 0.512*sqrt(Zmin)*sin(Ymax*Pi/180)*cos(Xzero2*Pi/180)
					endif
					
					if(Ymin >=0 )
						ky1 = 0.512*sqrt(Zmin)*sin(Ymin*Pi/180)*cos(Xzero1*Pi/180)
					else
						ky1 = 0.512*sqrt(Zmax)*sin(Ymin*Pi/180)*cos(Xzero2*Pi/180)
					endif					
					
					Variable ResolutionX, ResolutionY 
					Variable delta_k_n , delta_k_m
					
					ResolutionX = Dimsize(Images3D,1)
					ResolutionY = Dimsize(Images3D,2)*4
					//Make/O/N=(ResolutionY, ResolutionX) LayerN_K
					//Setscale/I x,kx1,kx2,"" LayerN_K
					//Setscale/I y,ky1,ky2,"" LayerN_K
					delta_k_n = (kx2 - kx1)/(ResolutionX-1)
					delta_k_m = (ky2 - ky1)/(ResolutionY-1)
					
					Variable C3
					C3 = Pi/180
					Variable sinAlfa
					Variable cosAlfa
					sinAlfa = sin(help6*C3)
					cosAlfa = cos(help6*C3)
					
					Make/O /N=(2,4) coordinates1
					Make/O /N=(2,4) coordinates2
					coordinates1[0][0] = kx1
					coordinates1[0][1] = kx1
					coordinates1[0][2] = kx2
					coordinates1[0][3] = kx2
					coordinates1[1][0] = ky1
					coordinates1[1][1] = ky2
					coordinates1[1][2] = ky1
					coordinates1[1][3] = ky2
					for(i=0;i<2;i+=1)
						for(j=0;j<4;j+=1)
							coordinates2[0][j] = coordinates1[0][j]*cosAlfa + coordinates1[1][j]*sinAlfa
							coordinates2[1][j] = -coordinates1[0][j]*sinAlfa + coordinates1[1][j]*cosAlfa
						endfor
					endfor
					
					Variable x1Prime , x2Prime , y1Prime , y2Prime
					x1Prime = coordinates2[0][0]
					x2Prime = coordinates2[0][0]
					y1Prime = coordinates2[1][0]
					y2Prime = coordinates2[1][0]
					Variable temp1,temp2
					for(j=1;j<4;j+=1)
						temp1 = coordinates2[0][j]
						if(temp1<x1Prime)
							x1Prime = temp1
						endif
						if(temp1>x2Prime)
							x2Prime = temp1
						endif
						temp2 = coordinates2[1][j]
						if(temp2<y1Prime)
							y1Prime = temp2
						endif
						if(temp2>y2Prime)
							y2Prime = temp2
						endif
					endfor
					kx1 = x1Prime
					kx2 = x2Prime
					ky1 = y1Prime
					ky2 = y2Prime
					
					Variable sizeXprime , sizeYprime
					sizeXprime = DimSize(Images3D,1)*abs(cosAlfa) + DimSize(Images3D,2)*4*abs(sinAlfa)
					sizeYprime = DimSize(Images3D,1)*abs(sinAlfa) + DimSize(Images3D,2)*4*abs(cosAlfa)
					ResolutionX = round(sizeXprime)
					ResolutionY = round(sizeYprime)
					Prompt ResolutionX, "Number of pixels along X axis"
					Prompt ResolutionY, "Number of pixels along Y axis"			
					//DoPrompt "SET THE PARAMETERS",ResolutionX,ResolutionY
					
					Make/O/N=(ResolutionX, ResolutionY) LayerN_K
					Make/O/N=(Dimsize(Images3D,0), ResolutionX) CutX_K
					Make/O/N=(Dimsize(Images3D,0), ResolutionY) CutY_K
				
					Setscale/I y,ky1,ky2,"" LayerN_K
					Setscale/I x,kx1,kx2,"" LayerN_K
					
					SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , CutX_K
					SetScale /I y, kx1, kx2 , "" , CutX_K
			
					SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , CutY_K
					SetScale /I y, ky1, ky2 , "" , CutY_K
					
					Slider Line1 , limits = { 0 , ResolutionY  , 1 } 
					Slider Line2 , limits = { 0 , ResolutionX , 1 } 
					//LayerN_K = Images3D(Energy)( asin( x/C1 )*C2 )( asin( y/( C1 * cos( asin( x/C1 ) ) ))*C2 )
					//CutX_K = Images3D(x)( asin(y/(0.512*sqrt(x)))*C2 )( asin( positionY/( 0.512*sqrt(x) *cos(asin(y/(0.512*sqrt(x))))))*C2 )
					//CutY_K = Images3D(x)( asin(positionZ/(0.512*sqrt(x)))*C2 )( asin( y/( 0.512*sqrt(x) *cos(asin(positionZ/(0.512*sqrt(x))))))*C2 )
					
					Variable x1,y1, x2, x2p, y2
					Variable imax , jmax , deltai, deltaj , y0

					
					Variable C1 ,C4
					Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
					Variable delta_phi , delta_theta
					Variable k_n0 , k_m0 , phi0 , theta0
					Variable phi1 , phi2 , theta1 , theta2
					Variable i_n , j_m 
					Variable n_max , m_max
					Variable i_max , j_max
					Variable i_1 , i_2 , j_1 , j_2
					Variable wL , wR , wU , wD 
					
					Variable energy2
					energy2 = PE-WF+ energy - KF
					C1 = 1/(0.512*sqrt(energy2))
					C2 = 180/Pi
					C3 = Pi/180
					
					n_max = DimSize (LayerN_K,0)
					m_max = DimSize (LayerN_K,1)
					
					//k_n0 = DimOffset (LayerN_K,0)
					//k_m0 = DimOffset (LayerN_K,1)
					
					delta_k_n = DimDelta (LayerN_K,0)
					delta_k_m = DimDelta (LayerN_K,1)
					
					SetAxis bottomImage3 ky1-delta_k_m,ky2+delta_k_m
					SetAxis leftImage3 kx1-delta_k_n,kx2+delta_k_n
					
					//Variable delta_kn_prime
					//Variable delta_km_prime
					
					//delta_kn_prime = delta_k_n*cosAlfa + delta_k_m*sinAlfa
					//delta_km_prime = -delta_k_n*sinAlfa + delta_k_m*cosAlfa
					//delta_k_n = delta_kn_prime
					//delta_k_m = delta_km_prime
					
					i_max = DimSize (Images3D,1)
					j_max = DimSize (Images3D,2)
					
					phi0 = DimOffset (Images3D,1)
					theta0 = DimOffset (Images3D,2)
					
					delta_phi = DimDelta (Images3D,1)
					delta_theta = DimDelta (Images3D,2)
					
					k_n = kx1
					k_m = ky1
					
					//Variable sinFiPrime, FiPrime_rad  ,FiPrime
					//Variable sinThetaPrime, ThetaPrime_rad ,ThetaPrime
					Variable sinPhi
					Variable cosPhi
					Variable sinTheta
					Variable deltaFiPrime
					Variable deltaThetaPrime
					sinAlfa = sin(help6*C3)
					cosAlfa = cos(help6*C3)
					LayerN_K = NaN
					for( n=0;n<n_max;n=n+1)
						for( m=0;m<m_max;m=m+1)
							sinPhi = C1*(cosAlfa*k_n - sinAlfa*k_m)
							phi_n_rad = asin( sinPhi )
							phi_n = phi_n_rad * C2
							i_n = (phi_n - phi0)/delta_phi
							if(i_n>=0 && i_n<=i_max)
								cosPhi = sqrt(1-sinPhi*sinPhi)
								C4 = C1/ cosPhi
								sinTheta = C4*(sinAlfa*k_n + cosAlfa*k_m)
								theta_m = asin( sinTheta ) * C2
								j_m = (theta_m - theta0)/delta_theta
								if(j_m>=0 && j_m<=j_max)	
									i_1 = floor(i_n)
									i_2 = ceil(i_n)
									j_1 = floor(j_m)
									j_2 = ceil(j_m)
									wR = i_n - i_1
									wL = 1 - wR
									wU = j_m - j_1
									wD = 1 - wU
									LayerN_K[n][m] = Images3D(energy)[i_1][j_1]*wL*wD + Images3D(energy)[i_2][j_1]*wR*wD + Images3D(Energy)[i_1][j_2]*wL*wU + Images3D(Energy)[i_2][j_2]*wR*wU
								else
									LayerN_K[n][m] = Nan
								endif
								
							else
								LayerN_K[n][m] = Nan
							endif
							k_m = k_m + delta_k_m
						endfor
						k_m = ky1
						k_n = k_n + delta_k_n
					endfor
					
					//Duplicate/ LayerN_K,LayerN_K1
					//Duplicate CutX_K,CutX_K1
					//Duplicate CutY_K,CutY_K1
					if( help2 != 1)
						LayerN_K = LayerN_K^help2
					endif
					
					if(help1 == 1)
						ImageHistModification LayerN_K
						LayerN_K = M_ImageHistEq		
					endif
					
					Wavestats/Q/Z LayerN_K
					DoUpdate
					Slider contrastmin,limits={V_min,V_max,0}
					Slider contrastmax,limits={V_min,V_max,0}
					DoUpdate
				break
				
			endswitch
			
		break
	endswitch

	return 0
End

Function SetLayer2(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			
			String name1, name2
			Wave /T W_WaveList
			Variable number
			
			Setdatafolder root:Specs:
			WAVE Image3
			WAVE Image3der
			WAVE Images3D
			WAVE Images3Dder
			WAVE M_ImageHistEq
			WAVE W_ImageHis
			WAVE Multipliers
			WAVE ImageX
			WAVE ImageY
			
			Variable deltaE
			Variable x0
			Variable Energy
			
			Make/O/N=(256) W_ImageHis
			
			Wave /T W_WaveList
			
			SetActiveSubwindow $"Electron_Density"
			GetWindow $"Electron_Density" wavelist
			number = WaveExists(W_WaveList)
			//if(number == 0 )
			//	number = 1
			//else
			GetWindow $"Electron_Density" wavelist
			name1 = W_WaveList[0][0]
			number = exists(name1)
			//endif
			
			if( number != 0 )
				RemoveImage /W=$"Electron_Density" $name1
			endif
			
	
			AppendImage /L=leftImage3 /B=bottomImage3 Image3
			
			ModifyGraph  swapXY=1 ,lblPosMode= 2
			ModifyGraph margin =40
			ModifyGraph margin(right) =20
			ModifyGraph margin(top) =10
			ModifyGraph mode=2,rgb=(0,0,0)
			ModifyGraph freePos(leftImage3)={0.1,kwFraction}
			ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
			ModifyGraph axisEnab(bottomImage3)={0.1,1}
			ModifyGraph axisEnab(leftImage3)={0.1,1}
			ModifyGraph margin(bottom)=20	
			
			ModifyGraph swapXY=1
			//ModifyImage Image3der ctab= {*,*,Grays,1}
			//ModifyImage Image3der ctab= {*,*,BrownViolet,1}
			//Button D3Dd,title="Go to\rImage"
			
			Variable help1
			Variable help2
			
			ControlInfo /W=Electron_Density check1
			help1 = V_value
			ControlInfo /W=Electron_Density Param1
			help2 = V_value
			
			Variable i , number2
			number2 = DimSize (Images3D, 2)
			
			Image3[][] = Images3D[dval][p][q]
			//Image3der[][] = Images3Dder[dval][p][q]
			
			Image3 = Image3^help2
			//Image3der[][] = Images3Dder[dval][p][q]^help2	
			
			x0 = DimOffset (Images3D,0)
			deltaE = DimDelta (Images3D,0)
			Energy = x0 + dval*deltaE
			
			ValDisplay Energy1, value=_NUM:Energy
			
			if(help1 == 1)
				ImageHistModification Image3
				Image3 = M_ImageHistEq	
				
				//ImageHistModification Image3der
				//Image3der = M_ImageHistEq	
			else
				//Image3[][] = Images3D[dval][p][q]^help2
				//Image3der[][] = Images3Dder[dval][p][q]^help2	
			endif
		
		break
	endswitch

	return 0
End

Function ResetMultipliers(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Wave /T W_WaveList
			String name1
			Variable number
			Setdatafolder root:Specs:
			WAVE Multipliers
			Multipliers = 1
			//KillWaves W_WaveList
		break
	endswitch
	DoUpdate 
	return 0
End

Function AcceptMultipliers(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Wave /T W_WaveList
			String name1
			Variable number
			Setdatafolder root:folder3D:
			WAVE Multipliers
			Variable i , number2
			WAVE Images3D
			number2 = DimSize (Images3D, 2)
			
			for( i = 0 ; i < number2 ; i = i +1)
				if(Multipliers[i] != 1)
					Images3D[][][i] = Images3D[p][q][i]*Multipliers[i]
				endif
			endfor
			Multipliers = 1
			//KillWaves W_WaveList
		break
	endswitch
	DoUpdate 
	return 0
End

Function SetAxis3(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			String name1, name2
			Setdatafolder root:folder3D:
			
				
			name2 =  ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			
			//Duplicate/O $(name2 + num2istr(1)), $name2 
			
			WAVE Image = $name2
			name1 = sva.ctrlName
			strswitch(name1)
				case "SetLeftUpper":
					ControlInfo /W=k_Space_2D SetLeftLower
					GetAxis leftImage3
					SetAxis leftImage3 V_min,dval
					
					ControlInfo /W=Angle_Energy SetLeftLower
					GetAxis /W=Angle_Energy leftImageX
					SetAxis /W=Angle_Energy leftImageX V_min,dval
					break
				case "SetLeftLower":
					ControlInfo /W=k_Space_2D SetLeftUpper
					GetAxis leftImage3
					SetAxis leftImage3 dval,V_max
					
					ControlInfo /W=Angle_Energy SetLeftUpper
					GetAxis /W=Angle_Energy leftImageX
					SetAxis /W=Angle_Energy leftImageX dval,V_max
					break
				case "SetBottomLeft":
					ControlInfo /W=k_Space_2D SetBottomRight
					GetAxis bottomImage3
					SetAxis bottomImage3 dval,V_max
					
					ControlInfo /W=Angle_Energy SetBottomRight
					GetAxis /W=Angle_Energy bottomImageY
					SetAxis /W=Angle_Energy bottomImageY dval,V_max
					break
				case "SetBottomRight":
					ControlInfo /W=k_Space_2D SetBottomLeft
					GetAxis bottomImage3
					SetAxis bottomImage3 V_min,dval
					
					ControlInfo /W=Angle_Energy SetBottomLeft
					GetAxis /W=Angle_Energy bottomImageY
					SetAxis /W=Angle_Energy bottomImageY V_min,dval
					break
				case "SetHigher":
					//ControlInfo /W=k_Space_2D SetBottomRight
					GetAxis /W=Angle_Energy bottomImageX
					SetAxis /W=Angle_Energy bottomImageX V_min,dval
					
					GetAxis /W=Angle_Energy leftImageY
					SetAxis /W=Angle_Energy leftImageY V_min,dval
					
					break
				case "SetBottom":
					//ControlInfo /W=k_Space_2D SetBottomLeft
					GetAxis /W=Angle_Energy bottomImageX
					SetAxis /W=Angle_Energy bottomImageX dval,V_max
					
					GetAxis /W=Angle_Energy leftImageY
					SetAxis /W=Angle_Energy leftImageY dval,V_max
					break
					
				case "default":

					break
			endswitch
			
					
			break
	endswitch

	return 0
End

Function Equalize3(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			//DoWindow/F Profiles_FinalBlend				//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow Profiles_FinalBlend
			//endif
			
		break
		
		case 2: // mouse up
			// click code here
			STRING name1, name2
			
			Setdatafolder root:Specs:
			WAVE Images3D = Images3D
			
			
			name2 =  ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			WAVE Image3
			WAVE ImageX
			WAVE ImageY
			
			Variable Rows, Columns , Layers
			Variable Layers1
			Variable i, j , k
			Variable Average1 , Average2
			Variable help1
			
			Rows 	= DimSize( Images3D, 0 )
			Columns	= DimSize( Images3D, 1 )
			Layers 	= DimSize( Images3D, 2 )
			Layers1 = Rows - 1
			Make/O/N =(Columns,Layers)  v1 
			Make/O/N =(Columns,Layers)  v2 
			
			for( k = 0 ; k < Layers1 ; k = k + 1 )
				v1[][] =  Images3D[k][p][q]
				v2[][] =  Images3D[k+1][p][q]
				ImageStats v1	
				Average1 = V_avg
				ImageStats v2
				Average2 = V_avg
				help1 = Average1/Average2
				v2 = v2*help1
				Images3D[k+1][][] = v2[q][r]
			endfor	
			
			Variable energy1
			ControlInfo /W=k_Space_2D SetLayers
			help1 = V_value
			energy1 =  DimOffset(Images3D,0) + DimDelta(Images3D,0) * ( help1 - 1 )  
			
			Variable help2
			ControlInfo /W=k_Space_2D Position1
			help2 = V_value
			
			Variable help3
			ControlInfo /W=k_Space_2D Position3
			help3 = V_value
			
			Image3[][] = Images3D[help1][p][q]
			ImageX[][] = Images3D[p][q][help2]
			ImageY[][] = Images3D[p][help3][q]
			
		break
	endswitch
	KillWaves v1,v2
	return 0
End

Function Equalize1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			//DoWindow/F Profiles_FinalBlend				//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow Profiles_FinalBlend
			//endif
			
		break
		
		case 2: // mouse up
			// click code here
			STRING name1, name2
			
			Setdatafolder root:folder3D:
			Variable help6
			ControlInfo /W=k_Space_2D check5
			help6 = V_value
			if(help6)
				WAVE Images3D = Images3Dder
			else
				WAVE Images3D = Images3D
			endif
			name2 =  ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			WAVE Image3
			WAVE ImageX
			WAVE ImageY
			
			Variable Rows, Columns , Layers
			Variable Layers1
			Variable i, j , k
			Variable Average1 , Average2
			Variable help1
			
			Rows 	= DimSize( Images3D, 0 )
			Columns	= DimSize( Images3D, 1 )
			Layers 	= DimSize( Images3D, 2 )
			Layers1 = Layers - 1
			Make/O/N =(Rows,Columns)  v1 
			Make/O/N =(Rows,Columns)  v2 
			
			for( k = 0 ; k < Layers1 ; k = k + 1 )
				v1[][] =  Images3D[p][q][k]
				v2[][] =  Images3D[p][q][k+1]
				ImageStats v1	
				Average1 = V_avg
				ImageStats v2
				Average2 = V_avg
				help1 = Average1/Average2
				v2 = v2*help1
				Images3D[][][k+1] = v2[p][q]
			endfor	
			
			Variable energy1
			ControlInfo /W=k_Space_2D SetLayers
			help1 = V_value
			energy1 =  DimOffset(Images3D,0) + DimDelta(Images3D,0) * ( help1 - 1 )  
			
			Variable help2
			ControlInfo /W=k_Space_2D Position1
			help2 = V_value
			
			Variable help3
			ControlInfo /W=k_Space_2D Position3
			help3 = V_value
			
			Image3[][] = Images3D[help1][p][q]
			ImageX[][] = Images3D[p][q][help2]
			ImageY[][] = Images3D[p][help3][q]
			
		break
	endswitch
	KillWaves v1,v2
	return 0
End

Function Equalize2(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			//DoWindow/F Profiles_FinalBlend				//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow Profiles_FinalBlend
			//endif
			
		break
		
		case 2: // mouse up
			// click code here
			STRING name1, name2
			
			Setdatafolder root:folder3D:
			Variable help6
			ControlInfo /W=k_Space_2D check5
			help6 = V_value
			if(help6)
				WAVE Images3D = Images3Dder
			else
				WAVE Images3D = Images3D
			endif
			name2 =  ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			WAVE Image3
			WAVE ImageX
			WAVE ImageY
			
			Variable Rows, Columns , Layers
			Variable Layers1
			Variable i, j , k, i0
			Variable Average1 , Average2
			Variable help1
			
			Rows 	= DimSize( Images3D, 0 )
			Columns	= DimSize( Images3D, 1 )
			Layers 	= DimSize( Images3D, 2 )
			Layers1 = Layers - 1
			Make/O/N =(Rows,Columns)  v1 
			Make/O/N =(Rows,Columns)  v2 
			Make/O/N =(Columns)  L1 
			Make/O/N =(Columns)  L2 
			
			ControlInfo SetLayers
			i0 = V_value
			for( k = 0 ; k < Layers1 ; k = k + 1 )
				L1 = Images3D[i0][p][k]
				WaveStats /Q L1
				Average1 = V_avg
				L2 = Images3D[i0][p][k+1]
				WaveStats /Q L2
				Average2 = V_avg
				v1[][] =  Images3D[p][q][k]
				v2[][] =  Images3D[p][q][k+1]
				
				help1 = Average1/Average2
				v2 = v2*help1
				Images3D[][][k+1] = v2[p][q]
			endfor	
			KillWaves v1,v2,L1,L2
			
			Variable energy1
			ControlInfo /W=k_Space_2D SetLayers
			help1 = V_value
			energy1 =  DimOffset(Images3D,0) + DimDelta(Images3D,0) * ( help1 - 1 )  
			
			Variable help2
			ControlInfo /W=k_Space_2D Position1
			help2 = V_value
			
			Variable help3
			ControlInfo /W=k_Space_2D Position3
			help3 = V_value
			
			Image3[][] = Images3D[help1][p][q]
			ImageX[][] = Images3D[p][q][help2]
			ImageY[][] = Images3D[p][help3][q]
			
		break
	endswitch
	return 0
End

Function DoubleSlices(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case -1: // control being killed
			//DoWindow/F Profiles_FinalBlend				//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow Profiles_FinalBlend
			//endif
			
		break
		
		case 2: // mouse up
			// click code here
			STRING name1, name2
			
			Setdatafolder root:folder3D:
			NVAR ifDerivative
			WAVE Images3D
			WAVE Images3Dder
			WAVE Image3
			WAVE Image3der
			WAVE Multipliers
			WAVE ImageY
			WAVE ImageX
			
			name2 =  ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			Wave Image = $name2
			
			Variable Rows, Columns , Layers
			Variable Layers1 ,  Rows1 , Columns1
			Variable i, j , k
			Variable Average1 , Average2
			Variable help1
			Variable pix1,pix2,pix3,pix4,pix5,pix6, pixL, pixR
			
			Rows 	= DimSize( Images3D, 0 )
			Columns	= DimSize( Images3D, 1 )
			Layers 	= DimSize( Images3D, 2 )
			
			Duplicate/O Images3D, Images3Dtemp
			
			Layers1 = Layers * 2 
			Redimension/N=( Rows , Columns  , Layers1 ) Images3D
			Redimension/N=( Layers1 ) Multipliers
			
			SetScale /P x, DimOffset(Images3Dtemp,0), DimDelta(Images3Dtemp,0) , "" , Images3D
			SetScale /P y, DimOffset(Images3Dtemp,1), DimDelta(Images3Dtemp,1) , "" , Images3D
			SetScale /P z, DimOffset(Images3Dtemp,2), DimDelta(Images3Dtemp,2)/2 , "" , Images3D
			
			Multipliers = 1
			
			Columns1 = Columns
			Rows1 = Rows - 1
			
			Variable j1 , j2 , k1 , k2
			
			for ( i = 0 ; i < Rows1 ; i+=1 )
				//Print i
				for ( j = 1 ; j < Columns1 ; j+=1 )
					for( k = 2 ; k < Layers1 ; k+=2 )
						k1 = floor(k/2) - 1
						k2 = floor(k/2)
						Images3D[i][j][k] = ( Images3Dtemp[i][j][k1] + 3*Images3Dtemp[i][j][k2] ) / 4
					endfor
					
					for( k = 1 ; k < Layers1 ; k+=2 )
						k1 = floor(k/2) 
						k2 = floor(k/2) + 1
						Images3D[i][j][k] = ( 3*Images3Dtemp[i][j][k1] + Images3Dtemp[i][j][k2] ) / 4
					endfor
				endfor	
			endfor
			
			Variable Column2 = Columns1 - 1
			for ( i = 0 ; i < Rows1 ; i+=1 )	
				for( k = 0 ; k < Layers1 ; k+=1 )
					k1= floor(k/2)
					Images3D[i][0][k] = Images3Dtemp[i][0][k1]
					
					Images3D[i][Columns1 - 1][k] = Images3Dtemp[i][Columns1 - 1][k1]
				endfor
			endfor	
			
			for ( i = 0 ; i < Rows1 ; i+=1 )	
				for( j = 0 ; j < Columns1 ; j+=1 )
					Images3D[i][j][0] = Images3Dtemp[i][j][0]
					Images3D[i][j][Layers1 - 1] = Images3Dtemp[i][j][floor((Layers1 -1)/2)]
				endfor
			endfor	
			
			Variable nrPix1,nrPix2,numberFrames
			nrPix1 = DimSize(Images3D,0)
			nrPix2 = DimSize(Images3D,1)
			numberFrames = DimSize(Images3D,2)
			Variable temp1
			Make /FREE /N=(nrPix1) v1
			if(ifDerivative)
				Duplicate/O Images3D, Images3Dder			
				for(j = 0; j <nrPix2;j+=1)
					for(k = 0; k <numberFrames;k+=1)
						v1[] =  Images3D[p][j][k]
						Differentiate v1
						Differentiate v1
						for(i =0;i<nrPix1;i=i+1)
							temp1 = -v1[i]
							if(temp1<0)
								Images3Dder[i][j][k] = 0
							else
								Images3Dder[i][j][k] = temp1
							endif
						endfor
					endfor
				endfor
			endif
			
			Killwaves Images3Dtemp //, Images3DtempDer
			
			//RemoveImage $name2
			
			//Redimension/N=( Columns , Layers * 2 - 1 ) $name2
			//Image[][] = Images3D[0][p][q]
			Redimension/N=( Columns , Layers * 2  ) Image3
			Redimension/N=( Rows , Layers * 2  ) ImageY
			
			SetScale /P x, DimOffset(Images3D,1), DimDelta(Images3D,1) , "" , Image3
			SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "" , Image3
			
			//SetScale /P x, DimOffset(Images3D,1), DimDelta(Images3D,1) , "Angle" , Image3der
			//SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "Angle" , Image3der
			
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , ImageX
			SetScale /P y, DimOffset(Images3D,1), DimDelta(Images3D,1) , "Angle" , ImageX
			
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , ImageY
			SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "Angle" , ImageY
			
			
			//AppendImage /L=bottomImage3 /B=leftImage3 $name2
			//AppendImage /L=leftImage3 /B=bottomImage3 $name2
			
			//ModifyGraph  swapXY=1 ,lblPosMode= 2
			//DoUpdate 
			//ModifyGraph margin =40
			//ModifyGraph margin(right) =20
			//ModifyGraph margin(top) =10
			//ModifyGraph mode=2,rgb=(0,0,0)
			//DoUpdate 
			//ModifyGraph freePos(leftImage3)={0.1,kwFraction}
			//ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
			//ModifyGraph axisEnab(bottomImage3)={0.1,1}
			//ModifyGraph axisEnab(leftImage3)={0.1,1}
			//ModifyGraph margin(bottom)=20	
			
			Slider Line1 , limits = { 0 , ( DimSize(Image3,1) - 1 ) , 1 }
			
			Variable energy1
			ControlInfo /W=k_Space_2D SetLayers
			help1 = V_value
			energy1 =  DimOffset(Images3D,0) + DimDelta(Images3D,0) * ( help1 - 1 )  
			
			Variable help2
			ControlInfo /W=k_Space_2D Position1
			help2 = V_value
			
			Variable help3
			ControlInfo /W=k_Space_2D Position3
			help3 = V_value
			
			Variable help6
			ControlInfo /W=k_Space_2D check5
			help6 = V_value
			if(help6)
				if(ifderivative)
					Image3[][] = Images3Dder[help1][p][q]
					ImageX[][] = Images3Dder[p][q][help2]
					ImageY[][] = Images3Dder[p][help3][q]
				endif
			else
				Image3[][] = Images3D[help1][p][q]
				ImageX[][] = Images3D[p][q][help2]
				ImageY[][] = Images3D[p][help3][q]
			endif
			
			DoUpdate
		break
	endswitch

	return 0
End

Function Display3Dder(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Wave /T W_WaveList
			String name1
			Variable number
			Setdatafolder root:Specs:
			WAVE Images3D
			WAVE Images3Dder
			WAVE Image3
			
			SetActiveSubwindow $"k_Space_2D"
			GetWindow $"k_Space_2D" wavelist
			number = WaveExists(W_WaveList)
			//if(number == 0 )
			//	number = 1
			//else
			GetWindow $"k_Space_2D" wavelist
			name1 = W_WaveList[0][0]
			number = exists(name1)
			//endif
			
			if( number != 0 )
				RemoveImage /W=$"k_Space_2D" $name1
			endif
			ControlInfo D3Dd
			number = cmpstr (name1 , "Image3")
			
			if( number == 0 )
				AppendImage /L=leftImage3 /B=bottomImage3 Image3der
			
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph margin =40
				ModifyGraph margin(right) =20
				ModifyGraph margin(top) =10
				ModifyGraph mode=2,rgb=(0,0,0)
				ModifyGraph freePos(leftImage3)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage3)={0.1,1}
				ModifyGraph axisEnab(leftImage3)={0.1,1}
				ModifyGraph margin(bottom)=20	
			
				ModifyGraph swapXY=1
				//ModifyImage Image3der ctab= {*,*,Grays,1}
				//ModifyImage Image3der ctab= {*,*,BrownViolet,1}
				Button D3Dd,title="Go to\rImage"
			else
				AppendImage /L=leftImage3 /B=bottomImage3 Image3
			
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph margin =40
				ModifyGraph margin(right) =20
				ModifyGraph margin(top) =10
				ModifyGraph mode=2,rgb=(0,0,0)
				ModifyGraph freePos(leftImage3)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage3)={0.1,1}
				ModifyGraph axisEnab(leftImage3)={0.1,1}
				ModifyGraph margin(bottom)=20	
			
				ModifyGraph  /W=$"k_Space_2D" swapXY=1
				Button D3Dd,title="Go to\r2nd Der."
			endif
			
			//KillWaves W_WaveList
			break
	endswitch
	DoUpdate 
	return 0
End

Function LoadRHOfile2(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			String  	curve_list 							//list of all curves in the given folder
			String 	path_list								//list of all paths, witchout name of the file
			String 	name_file_list						//name of the file
			String	data_folder 
			String 	Wave_name
			Variable ref_file								//Variable keeps refernce to the flie
			Variable position1								//Varaible used to keep position in the file
			Variable nCurves						//Varaible used to keep number of curves in the file
			Variable number_folders						//keeps number of folders in a given folder
			Variable counter1
			Variable extension
			Variable help1
			Variable Rows, Columns
			Variable i
			Variable Lower, Higher
			Variable aSpan, Low1, High1
			Variable Status
			
			//String 	message		= 	"Select a file"
			String	full_path
			String 	file_path
			String 	file_name
			SVAR 	list_file_path 		= 	root:Specs:list_file_path	
			SVAR 	list_file_name	= 	root:Specs:list_file_name	
			SVAR 	list_folder 		= 	root:Specs:list_folder
			NVAR 	val1 			=	root:Specs:val_slider1
			NVAR 	val2 			=	root:Specs:val_slider2
			NVAR 	val3 			=	root:Specs:val_slider3
	
			WAVE/T 	ListWave1 	= 	root:ListWave1
			WAVE 		sw1			=	root:sw1	
	
			String 	name1,name2,name3,name4
	
			String 	file_filters = "Data Files (*.rho):.rho;"		//filter for Open
			String 	buffer1, buffer2
			DFREF 	dfr
			STRUCT file_header fh
			
			String message = "Select one or more files"
			String outputPaths
			//Open /R /F=file_filters /M=message ref_file		//if the file was not opend the ref_file variable is unchanged
			Open /D /R /MULT=1 /F=file_filters /M=message ref_file
			DoUpdate 
			outputPaths = S_fileName
			
			if (strlen(outputPaths) == 0)
				Print "Cancelled"
				Return 0
			else
				Variable numFilesSelected = ItemsInList(outputPaths, "\r")
				Variable k
				Variable position
				aSpan = 21
				for(k=0; k<numFilesSelected; k+=1)
					String path = StringFromList(k, outputPaths, "\r")
					Printf "%d: %s\r", k, path	
					full_path = path
					position = ItemsInList(full_path, ":")
					file_name = StringFromList(position - 1, full_path, ":")
					position = strsearch(full_path,":",inf,1)
					file_path = full_path[0 , position]
					//Open /C="IGR0" /P= path ref_file	
					//FStatus ref_file	
					//If(V_flag == 0)
					//	return 0
					//endif
				
					//file_path 	= 	S_path						//contains path to the computer folder						
					//file_name 	= 	S_fileName					//contains name of the file with extension
					//full_path		= 	file_path + file_name
				
					// here checking file extension and removing extension
					help1  = strsearch(file_name,"rho",0)
					if( help1 == -1)
						name1 = file_name
						extension = 0
					else	
						name1 = file_name
						extension = 1
					endif
			
					//name1 		= 	ReplaceString(".xy", file_name, "")		//contains name of the flie without extension
			
					data_folder = "root:Specs:"
					data_folder = data_folder + file_name
			
					if(strsearch(list_file_name,file_name,0) == -1 )
		
						if(extension == 0)
							
						else
							name3 = "root:Specs:" + file_name
							name1 = GetDataFolder(1)
							name1 = "root:'" + file_name + "':"
							Status = DataFolderExists ( name1 ) 
							if ( status == 1 )
 								KillDataFolder ( name1 )
 							endif
 							
 							status = Load_RHO(full_path)
							if(status != 0)
							 	return 0
							endif
							
							name2 = "Density2DParam"
							Wave WaveLoaded = $name2
							
							status = WaveExists (WaveLoaded)
							if(status == 0)
							 	return 0
							endif
							MoveDataFolder root:$(file_name) , root:Specs
							
					
							list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
							list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
							list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
							counter1 				=	ItemsInList(list_file_name)
							counter1					= 	counter1 - 1
							name1 					=	StringFromList(counter1, list_file_name)
							ListWave1[counter1][0] 	=	name1
							ListWave1[counter1][1] = num2str(0)
							ListWave1[counter1][2] = num2str(0)
							ListWave1[counter1][3] = num2str(0)
							ListWave1[counter1][4] = num2str(0)
							ListWave1[counter1][5] = num2str(1)
							ListWave1[counter1][6] = num2str(fh.tiTime)
							ListWave1[counter1][7] = num2str(0)
							
							sw1[counter1][1]			=   	sw1[counter1][1] | (2^1)
							sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
							sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
							sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
							sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
							sw1[counter1][6]			=   	sw1[counter1][5] | (2^1)
							sw1[counter1][7]			=   	sw1[counter1][5] | (2^1)
						endif
					endif
				endfor
			endif
			
		break
	endswitch
	return 0
End

Function LoadRHOfile(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			WAVE/T 	ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
			WAVE 		sw1			=	root:Load_and_Set_Panel:sw1	
			String  	curve_list 							//list of all curves in the given folder
			String 	path_list								//list of all paths, witchout name of the file
			String 	name_file_list						//name of the file
			String	data_folder 
			String 	Wave_name
			Variable ref_file								//Variable keeps refernce to the flie
			Variable position1								//Varaible used to keep position in the file
			Variable nCurves						//Varaible used to keep number of curves in the file
			Variable number_folders						//keeps number of folders in a given folder
			Variable counter1
			Variable extension
			Variable help1
			Variable Rows, Columns
			Variable i
			Variable Lower, Higher
			Variable aSpan, Low1, High1
			Variable Status
			
			//String 	message		= 	"Select a file"
			String	full_path
			String 	file_path
			String 	file_name
			SVAR 	list_file_path 		= 	root:Specs:list_file_path	
			SVAR 	list_file_name	= 	root:Specs:list_file_name	
			SVAR 	list_folder 		= 	root:Specs:list_folder
			NVAR 	val1 			=	root:Specs:val_slider1
			NVAR 	val2 			=	root:Specs:val_slider2
			NVAR 	val3 			=	root:Specs:val_slider3
	
			String 	name1,name2,name3,name4
	
			String 	file_filters = "Data Files (*.rho):.rho;"		//filter for Open
			String 	buffer1, buffer2
			DFREF 	dfr
			STRUCT file_header fh
			
			String message = "Select one or more files"
			String outputPaths
			//Open /R /F=file_filters /M=message ref_file		//if the file was not opend the ref_file variable is unchanged
			Open /D /R /MULT=1 /F=file_filters /M=message ref_file
			DoUpdate 
			outputPaths = S_fileName
			
			if (strlen(outputPaths) == 0)
				Print "Cancelled"
				Return 0
			else
				Variable numFilesSelected = ItemsInList(outputPaths, "\r")
				Variable k
				Variable position
				aSpan = 21
				for(k=0; k<numFilesSelected; k+=1)
					String path = StringFromList(k, outputPaths, "\r")
					//Printf "%d: %s\r", k, path	
					full_path = path
					position = ItemsInList(full_path, ":")
					file_name = StringFromList(position - 1, full_path, ":")
					position = strsearch(full_path,":",inf,1)
					file_path = full_path[0 , position]
					//Open /C="IGR0" /P= path ref_file	
					//FStatus ref_file	
					//If(V_flag == 0)
					//	return 0
					//endif
				
					//file_path 	= 	S_path						//contains path to the computer folder						
					//file_name 	= 	S_fileName					//contains name of the file with extension
					//full_path		= 	file_path + file_name
				
					// here checking file extension and removing extension
					help1  = strsearch(file_name,"rho",0)
					if( help1 == -1)
						name1 = file_name
						extension = 0
					else	
						name1 = file_name
						extension = 1
					endif
			
					//name1 		= 	ReplaceString(".xy", file_name, "")		//contains name of the flie without extension
			
					data_folder = "root:Specs:"
					data_folder = data_folder + file_name
			
					if(strsearch(list_file_name,file_name,0) == -1 )
		
						if(extension == 0)
							
						else
							name3 = "root:Specs:" + file_name
							name1 = GetDataFolder(1)
							name1 = "root:'" + file_name + "':"
							Status = DataFolderExists ( name1 ) 
							if ( status == 1 )
 								KillDataFolder ( name1 )
 							endif
 							
 							status = Load_RHO(full_path)
							if(status != 0)
							 	return 0
							endif
							
							name2 = "Density2DParam"
							Wave WaveLoaded = $name2
							
							status = WaveExists (WaveLoaded)
							if(status == 0)
							 	return 0
							endif
							MoveDataFolder root:$(file_name) , root:Specs
							
					
							list_file_path 				= 	AddListItem(file_path, list_file_path , ";", Inf)		 //Adds item to the end of the string
							list_file_name 			= 	AddListItem(file_name, list_file_name , ";", Inf)
							list_folder 				= 	AddListItem(data_folder, list_folder , ";", Inf)
							counter1 				=	ItemsInList(list_file_name)
							counter1					= 	counter1 - 1
							name1 					=	StringFromList(counter1, list_file_name)
							ListWave1[counter1][0] 	=	num2str(counter1 + 1)
							ListWave1[counter1][1] 	=	name1
							ListWave1[counter1][2] = num2str(0)
							ListWave1[counter1][3] = num2str(0)
							ListWave1[counter1][4] = num2str( DimSize(WaveLoaded,1) * DimDelta(WaveLoaded,1) )
							ListWave1[counter1][5] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
							ListWave1[counter1][6] = num2str( DimOffset(WaveLoaded,0) )
							ListWave1[counter1][7] = num2str(0)
							ListWave1[counter1][8] = num2str(DimDelta(WaveLoaded,1) )
							ListWave1[counter1][9] = num2str(1)
							ListWave1[counter1][10] = num2str(1)
							ListWave1[counter1][11] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) + 4.5)
							ListWave1[counter1][12] = num2str(4.5)
							ListWave1[counter1][13] = num2str( DimOffset(WaveLoaded,0) + (DimSize(WaveLoaded,0) - 1) * DimDelta(WaveLoaded,0) )
							ListWave1[counter1][14] = num2str(0)
							ListWave1[counter1][15] = num2str(0)
							ListWave1[counter1][16] = num2str(0)
							ListWave1[counter1][17] = num2str(0)
							ListWave1[counter1][18] = num2str(0)
							ListWave1[counter1][19] = num2str(0)
							
							sw1[counter1][16] = sw1[counter1][16] | (2^5)
							sw1[counter1][17] = sw1[counter1][17] | (2^5)
							sw1[counter1][18] = sw1[counter1][18] | (2^5)
							sw1[counter1][19] = sw1[counter1][19] | (2^5)
							
							sw1[counter1][0]			=   	sw1[counter1][1] | (2^1)
							sw1[counter1][2]			=   	sw1[counter1][2] | (2^1)
							sw1[counter1][3]			=   	sw1[counter1][3] | (2^1)
							sw1[counter1][4]			=   	sw1[counter1][4] | (2^1)
							sw1[counter1][5]			=   	sw1[counter1][5] | (2^1)
							sw1[counter1][6]			=   	sw1[counter1][6] | (2^1)
							sw1[counter1][7]			=   	sw1[counter1][7] | (2^1)
							sw1[counter1][8]			=   	sw1[counter1][8] | (2^1)
							sw1[counter1][9]			=   	sw1[counter1][9] | (2^1)
							sw1[counter1][10]			=   	sw1[counter1][10] | (2^1)
							sw1[counter1][11]			=   	sw1[counter1][10] | (2^1)
							sw1[counter1][12]			=   	sw1[counter1][12] | (2^1)
							sw1[counter1][13]			=   	sw1[counter1][13] | (2^1)
							sw1[counter1][14]			=   	sw1[counter1][14] | (2^1)
							sw1[counter1][15]			=   	sw1[counter1][15] | (2^1)

						endif
					endif
				endfor
			endif
			
		break
	endswitch
	return 0
End


Function Load_RHO(path)
    	String path
   
   	variable file
    	open/R/F="SPECS XY Files (*.rho):.rho;All Files:.*;" file as path
 	String fname
 	String newfname
 	String str
 	String S_waveNames
 	
	Variable line 
	Variable lastRound
	Variable rows, columns
	Variable sizex , sizey
	Variable i,j
	
   	SetDataFolder root:
      
    	FStatus file
    	fname = S_fileName
    	newfname = S_fileName
	  
 	NewDataFolder/s $newfname
       FReadLine file, str
  	Close file
  	sscanf str, " %f %f %f %f", rows, columns, sizex, sizey
  	//sscanf "Value= 1.234", "Value= %f", v1
    	//LoadWave/J/D/W/K=0 "C:Documents and Settings:jacos:Desktop:MAX-lab:Calculations_wien2k:soh_test_40.rho"
  	LoadWave/A/G/D/K=0 path
  	WAVE wave0 = $StringFromList(0,  S_waveNames)
	WAVE wave1 = $StringFromList(1,  S_waveNames)
	WAVE wave2 = $StringFromList(2,  S_waveNames)
	WAVE wave3 = $StringFromList(3,  S_waveNames)
	WAVE wave4 = $StringFromList(4,  S_waveNames)
	
  	Make /O/N=(rows, columns) Density2D
 	Variable help1 , help2, help3, help4, help0
  	for(i=0;i<rows;i = i + 1)
  		for(j=0;j<columns;j = j + 5)
  			help0 = wave0[j/5 + columns*i/5]
  			help1 = wave1[j/5 + columns*i/5]
  			help2 = wave2[j/5 + columns*i/5]
  			help3 = wave3[j/5 + columns*i/5]
  			help4 = wave4[j/5 + columns*i/5]
  			Density2D[i+0][j+0] = help0
  			Density2D[i+0][j+1] = help1
  			Density2D[i+0][j+2] = help2
  			Density2D[i+0][j+3] = help3
  			Density2D[i+0][j+4] = help4
  		endfor
  	endfor
  	
  	Make /O/N=(rows*columns,3) Density2DTriplet
  	
  	SetScale/I x, 0 , sizex, "[A]" Density2D
       SetScale/I y, 0 , sizey, "[A]" Density2D
  	
  	Variable RowCol = rows*columns
  	Make /O/N=(Rows,Columns,3) Density2DParam
  	Variable x0, dx , y0, dy
  	x0 = DimOffset(Density2D,0) 
  	y0 = DimOffset(Density2D,1) 
  	dx = DimDelta(Density2D,0) 
  	dy = DimDelta(Density2D,1) 
  	
  	for(i=0;i<rows;i = i + 1)
  		help1 = i*columns
  		help3 = i*dx
  		for(j=0;j<columns;j = j + 1)
  			help2 = help1 + j
  			Density2DTriplet[help2][0] = help3
  			Density2DTriplet[help2][1] = j*dy
  			Density2DTriplet[help2][2] = Density2D[i][j]
  			
  			Density2DParam[i][j][0] = help3
  			Density2DParam[i][j][1] = j*dy
  			Density2DParam[i][j][2] = Density2D[i][j]
  		endfor
  	endfor
  	
  	WAVE W_WaveTransform
  	WaveTransform /D/P= {1, 1, 1, 90, 90, 120} crystalToRect Density2DTriplet
  	WAVE M_CrystalToRect
  	for(i=0;i<rows;i = i + 1)
  		help1 = i*columns
  		help3 = i*dx
  		for(j=0;j<columns;j = j + 1)
  			help2 = help1 + j
  			Density2DParam[i][j][0] = M_CrystalToRect[help2][0]
  			Density2DParam[i][j][1] = M_CrystalToRect[help2][1]
  			Density2DParam[i][j][2] = M_CrystalToRect[help2][2]
  		endfor
  	endfor
  	
  	//Execute "NewGizmo/i/N=Electron_Density_Plot"
  	//for(i=0;i<rows;i = i + 5)
  	//	Density2D[i+0][] = wave0[q + columns*i/5]
  	//	Density2D[i+1][] = wave1[q + columns*i/5]
  	//	Density2D[i+2][] = wave2[q + columns*i/5]
  	//	Density2D[i+3][] = wave3[q + columns*i/5]
  	//	Density2D[i+4][] = wave4[q + columns*i/5]
  	//endfor

  	return 0 
end

Function ButtonProc_Build3Ddensity(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here

			WAVE/T ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
			WAVE 		sw1			=	root:sw1	
			Variable number1 , number2, number3 
			Variable leftAngle , rightAngle , deltaAngle , numberPoints
			Variable position
			Variable help1 ,help2
			Variable i ,j ,k
			Variable tiltAngle
			Variable lowAngle
			STRUCT file_header fh
			Variable eShift
			
			DoWindow/F $"Electron_Density"			//pulls the window to the front
			if (V_Flag==1)	
				DoWindow/K $"Electron_Density"	
			endif
			
			SetDataFolder root:Specs:
			SVAR list_folder //= root:Specs:list_folder

			number1 = ItemsInList( list_folder ) 
			leftAngle = str2num( ListWave1[0][3] )
			rightAngle = str2num( ListWave1[number1 - 1][3] )
			
			deltaAngle = abs( str2num( ListWave1[0][3] ) - str2num( ListWave1[1][3] ) )
			for( i = 1 ; i<(number1 - 1) ; i = i +1 )
				help1 = abs( str2num( ListWave1[i][3] ) - str2num( ListWave1[i+1][3] ) )
				if( abs(help1 - deltaAngle) > deltaAngle/100 )
					return 0
					//deltaAngle = help1
				endif
			endfor
			
			numberPoints = abs(rightAngle - leftAngle) 
			numberPoints = numberPoints / deltaAngle
			numberPoints = round (numberPoints + 1)
			
			STRING name1 , name2
			
			name1 = ListWave1[0][1]
			Setdatafolder root:Specs:$name1
			WAVE First = Density2D
				
			number2 = DimSize(First,0)
			number3 = DimSize(First,1)
			SetDataFolder root:Specs:
			Make/O/N=(number1, DimSize(First,0), DimSize(First,1)) Images3D
			
			SetScale /P z, DimOffset(First,0), DimDelta(First,0) , "z" , Images3D
			SetScale /P y, DimOffset(First,1), DimDelta(First,1) , "y" , Images3D
			SetScale /I x, leftAngle, rightAngle , "x" , Images3D
			
			position = leftAngle
			j = 0
			for(i = 0 ; i<numberPoints ; i = i +1)
				//help1 = str2num( ListWave1[j][1] )
				//position = DimOffset(Images3D,0) + DimDelta(Images3D,0)*i
				//if( help1 == position )
					name1 = ListWave1[j][1]
					Setdatafolder root:Specs:$name1
					WAVE Density2D
					//StructGet /B=0 fh, header
					//eShift = round ( fh.eShift / DimDelta(Density2D,0) )
					Images3D[i][][] = Density2D[q][r]
					j = j + 1
				//else
				//	Images3D[i][][] = 0
				//endif
			endfor
			
			SetDataFolder root:Specs:
			
			Make/O/N=(DimSize(Images3D,1),DimSize(Images3D,2)) Image3
			Make/O/N=(DimSize(Images3D,1),DimSize(Images3D,2)) Image3der
			
			Make/O/N=(DimSize(Images3D,0),DimSize(Images3D,1)) ImageX
			Make/O/N=(DimSize(Images3D,0),DimSize(Images3D,2)) ImageY
			
			SetScale /P x, DimOffset(Images3D,1), DimDelta(Images3D,1) , "Angle" , Image3
			SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "Angle" , Image3
			
			SetScale /P x, DimOffset(Images3D,1), DimDelta(Images3D,1) , "Angle" , Image3der
			SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "Angle" , Image3der
			
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , ImageX
			SetScale /P y, DimOffset(Images3D,1), DimDelta(Images3D,1) , "Angle" , ImageX
			
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , ImageY
			SetScale /P y, DimOffset(Images3D,2), DimDelta(Images3D,2) , "Angle" , ImageY
			
			Image3[][] = Images3D[0][p][q]
			
			ImageX[][] = Images3D[p][q][0]
			ImageY[][] = Images3D[p][0][q]
			
			DoWindow/F $"Angle_Energy"			//pulls the window to the front
			if (V_Flag==1)	
				DoWindow/K $"Angle_Energy"	
				DoUpdate
				Display/K=1 /W=(10,70,390,417)
				Dowindow/C $"Angle_Energy"	
				
				AppendImage /L=leftImageX /B=bottomImageX ImageX
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph freePos(leftImageX)={0.1,kwFraction}
				ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImageX)={0.1,1}
				ModifyGraph axisEnab(leftImageX)={0.1,0.45}

				
				AppendImage /L=leftmImageY /B=bottomImageY ImageY
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph freePos(leftImageY)={0.55,kwFraction}
				ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
				ModifyGraph axisEnab(leftImageY)={0.1,1}
				ModifyGraph axisEnab(bottomImageY)={0.55,1}	
			else
				Display/K=1 /W=(10,70,390,417)
				Dowindow/C $"Angle_Energy"	
				
				AppendImage /L=leftImageX /B=bottomImageX ImageX
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph freePos(leftImageX)={0.1,kwFraction}
				ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImageX)={0.1,1}
				ModifyGraph axisEnab(leftImageX)={0.1,0.45}

				
				AppendImage  /L=leftImageY /B=bottomImageY ImageY
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph freePos(leftImageY)={0.55,kwFraction}
				ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
				ModifyGraph axisEnab(leftImageY)={0.1,1}
				ModifyGraph axisEnab(bottomImageY)={0.55,1}
				
			endif
			
			DoWindow/F $"Electron_Density"			//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow $"Profiles_FinalBlend"
			//endif
			//------------display the results
			if (V_Flag==1)	
				
			else
				Display/K=1 /W=(400,80,1000,550)
				Dowindow/C $"Electron_Density"		
	
				AppendImage /L=bottomImage3 /B=leftImage3 Image3
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				
				ControlBar/L 160
				ControlBar/T 60
				
				DoUpdate 
				ModifyGraph margin =40
				ModifyGraph margin(right) =20
				ModifyGraph margin(top) =10
				ModifyGraph mode=2,rgb=(0,0,0)
				DoUpdate 
				ModifyGraph freePos(leftImage3)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage3)={0.1,1}
				ModifyGraph axisEnab(leftImage3)={0.1,1}
				ModifyGraph margin(bottom)=20	
				DoUpdate 	
				
				GetAxis bottomImage3
				
				SetVariable SetBottomLeft,pos={35,110},size={80,20},proc=SetAxis3,title="L"
				SetVariable SetBottomLeft,fSize=14,limits={-inf,inf,0.01},value= _NUM: V_min
				
				SetVariable SetBottomRight,pos={35,135},size={80,20},proc=SetAxis3,title="R"
				SetVariable SetBottomRight,fSize=14,limits={-inf,inf,0.01},value= _NUM:V_max
				
				GetAxis leftImage3
				DoUpdate 
				SetVariable SetLeftUpper,pos={25,170},size={90,20},proc=SetAxis3,title="Up"
				SetVariable SetLeftUpper,fSize=14,limits={-inf,inf,0.01},value= _NUM:V_max
				
				SetVariable SetLeftLower,pos={20,195},size={100,20},proc=SetAxis3,title="Low"
				SetVariable SetLeftLower,fSize=14,limits={-inf,inf,0.01},value= _NUM:V_min
				
				GetAxis /W=Angle_Energy bottomImageX
				SetVariable SetHigher,pos={20,230},size={90,20},proc=SetAxis3,title="High"
				SetVariable SetHigher,fSize=14,limits={-inf,inf,0.01},value= _NUM:V_max
				
				SetVariable SetBottom,pos={15,255},size={100,20},proc=SetAxis3,title="Bottom"
				SetVariable SetBottom,fSize=14,limits={-inf,inf,0.01},value= _NUM:V_min
				
				
				SetVariable SetLayers,pos={10,365},size={120,20},proc=SetLayer2,live=1,title="Layer"
				SetVariable SetLayers,fSize=18,limits={0,numberPoints-1,1},value= _NUM:0
				
				ValDisplay Energy1, pos={10,400} , value=0,   title="Energy [eV]",size={120,20},value=0,frame=1,fSize=14
				DelayUpdate
				
				DoUpdate 
				Button Export2,pos={35,290},size={70,20},proc=ExportImages2,title="Export"
				Button Export2,fSize=14
				DoUpdate 
				//Button Equalize,pos={35,430},size={70,20},proc=Equalize1,title="Equalize"
				//Button Equalize,fSize=14
				
				//Button Equalize2,pos={35,455},size={70,40},proc=Equalize2,title="Equalize\rto plane"
				//Button Equalize2,fSize=14
				
				Button Double,pos={35,500},size={70,40},proc=DoubleSlices,title="Double\rSlices"
				Button Double,fSize=14
				
				//SetVariable Smooth1,pos={15,545},size={100,20},proc=SmoothX,title="SmoothX"
				//SetVariable Smooth1,fSize=15,limits={0,1000,1},value= _NUM:0
				
				Button D3Dd,pos={15,5},size={70,40},proc=Display3Dder,title="Go to\r2nd Der."
				Button D3Dd,fSize=14
				
				CheckBox check1,pos={60,345},size={104,16},title="Equ."
				CheckBox check1,labelBack=(47872,47872,47872),fSize=14,value= 0
				
				SetVariable Param1,pos={20,320},size={100,20},live=1,title="Gamma"
				SetVariable Param1,fSize=14,limits={0,inf,0.1},value= _NUM:1
				
				Slider Line1 , pos={210,5} , size={350,13} , proc=moveLine1D , live=1
				Slider Line1 , limits = { 0 , ( DimSize(Image3,1) - 1 ) , 1 } , value= 0 , side= 0 , vert= 0 , ticks= 0
				
				Slider Line2 , pos={135,70} , size={10,400} , proc=moveLine2D , live=1
				Slider Line2 , limits = { 0 , ( DimSize(Image3,0) - 1 ) , 1 } , value= 0 , side= 0 , vert= 1 , ticks= 0
				
				ValDisplay Position1, pos={100,5} , value=0,   title="Position",size={100,20},value=0,frame=1,fSize=14
				
				ValDisplay Position2, pos={120,25} , value=0,  title="unit", size={80,20},value=0,frame=1,fSize=14
				
				ValDisplay Position3, pos={25,65} , value=0,   title="Position",size={100,20},value=0,frame=1,fSize=14
				
				ValDisplay Position4, pos={45,85} , value=0,  title="unit", size={80,20},value=0,frame=1,fSize=14
				
				SetVariable Multiplier,pos={580,5},size={110,20},proc=SetMultiplier,live=1,title="Multiplier"
				SetVariable Multiplier,fSize=14,limits={0,100,0.01},value= _NUM:1
				
				Button Reset1,pos={575,28},size={55,20},proc=ResetMultipliers,title="Reset"
				Button Reset1,fSize=14
				
				Button Accept1,pos={635,28},size={55,20},proc=AcceptMultipliers,title="Accept"
				Button Accept1,fSize=14
				
				Button cut1,pos={5,85},size={40,20},proc=Cut3D,title="Cut"
				Button cut1,fSize=14
				
				SetVariable ShiftX,pos={330,30},size={110,20},title="Set_X"
				SetVariable ShiftX,fSize=14,limits={-inf,inf,0.1},value= _NUM:0
				
				SetVariable ShiftY,pos={450,30},size={110,20},title="Set_Y"
				SetVariable ShiftY,fSize=14,limits={-inf,inf,0.1},value= _NUM:0
				
				Button SetOffset,pos={235,35},size={70,20},proc=ShiftAxis3D,title="Set Axis"
				Button SetOffset,fSize=14
				
				Button display3D1,pos={35,570},size={70,40},proc=Display3Da,title="Display3D"
				Button display3D1,fSize=14
				
				SetVariable sum1,pos={5,440},size={130,20},proc=SumDensity,live=1,title="Sum"
				SetVariable sum1,fSize=14,limits={0,inf,0.001},value= _NUM:0
				
				Button eqialize3Dz,pos={35,640},size={70,40},proc=Equalize3,title="Equalize"
				Button eqialize3Dz,fSize=14
				
				DoUpdate 
				GetWindow $"Electron_Density" wavelist
				
			endif
			
			break
	endswitch

	return 0
End

Function Display3Da(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Wave /T W_WaveList
			String name1 , name2
			Variable number
			
			
			SetDataFolder root:Specs:
			WAVE sw1 = root:sw1
			WAVE/T ListWave1 = root:Load_and_Set_Panel:ListWave1
			Variable i , j , k
			Variable size1 , size2
			
			
			ControlInfo SetLayers 
			i = V_value
			
			SetDataFolder root:Specs:$ListWave1[i][1]
			name2 = GetDataFolder(1)
			name2 = name2
			WAVE	Density2DParam
			Setdatafolder root:Specs:
			Duplicate/O Density2DParam , D2DP
			name1 = ListWave1[i][1]
			//if( strsearch(name1,".rho",0) == -1)
			//	break
			//endif
			
			
			
			String objectList
			DoWindow/F Electron_Density_Plot					//pulls the window to the front
			If(V_flag == 0)									//checks if there is a window....
				Execute "NewGizmo/N=Electron_Density_Plot"
				Execute " AppendToGizmo surface=Density2DParam, name=surface0 "
			endif
			SetDataFolder root:Specs:
			
			//KillWaves W_WaveList
			break
	endswitch
	DoUpdate 
	return 0
End


Function SumDensity(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			
			String name1, name2
			Wave /T W_WaveList
			Variable number
			
			Setdatafolder root:Specs:
			WAVE Image3
			WAVE Image3der
			WAVE Images3D
			WAVE Images3Dder
			WAVE M_ImageHistEq
			WAVE W_ImageHis
			WAVE Multipliers
			WAVE ImageX
			WAVE ImageY
			
			Variable deltaE
			Variable Energy
			
			Make/O/N=(256) W_ImageHis
			
			Wave /T W_WaveList
			
			SetActiveSubwindow $"Electron_Density"
			GetWindow $"Electron_Density" wavelist
			number = WaveExists(W_WaveList)
			//if(number == 0 )
			//	number = 1
			//else
			GetWindow $"Electron_Density" wavelist
			name1 = W_WaveList[0][0]
			number = exists(name1)
			//endif
			
			Variable nx, ny , nz ,i , j , k
			Variable sumX
			nx =  DimSize (Images3D, 0)
			ny =  DimSize (Images3D, 1)
			nz =  DimSize (Images3D, 2)
			Duplicate/O Image3 , ImageSum
			ImageSum = 0
			for( j  = 0 ; j < ny ; j = j + 1)
				for( k  = 0 ; k < nz ; k = k + 1)
					for( i = nx - 1 ; i > -1 ; i = i - 1 )
						sumX =  Images3D[i][j][k]  + sumX 
						if(sumX > dval)
							break
						endif
					endfor
					ImageSum[j][k] =  i 
					SumX = 0 
				endfor
			endfor
			
			Variable rows, columns , maxi , maxj , i1, j1
			maxi = DimSize(ImageSum,0)
			maxj = DimSize(ImageSum,1)
			rows = DimSize(ImageSum,0)
			columns = DimSize(ImageSum,1)
			Make /O/N=(10*rows,10*columns) ImageSum3
			SetScale/I x, 0 , DimOffset(Images3D, 1) + (DimSize(Images3D, 1) - 1)*DimDelta(Images3D,1)*3, "[A]"  ImageSum3
 		      SetScale/I y, 0 , DimOffset(Images3D, 2) + (DimSize(Images3D, 2) - 1)*DimDelta(Images3D,2)*3, "[A]"  ImageSum3
			rows = DimSize(ImageSum3,0)
			columns = DimSize(ImageSum3,1)
			
			for(i=0;i<rows;i=i+1)
				for(j=0;j<columns;j=j+1)
					i1 = mod(i,maxi)
					j1 = mod(j,maxj)
					ImageSum3[i][j] = ImageSum[i1][j1]
				endfor	
			endfor		
					
			Make /O/N=(rows*columns,3) Density2DTriplet
	 	 	Variable RowCol = rows*columns
  			Make /O/N=(rows,columns,3) Density2DParam
  			Variable x0, dx , y0, dy
  			Variable help1, help2,help3
  			x0 = DimOffset(ImageSum,0) 
  			y0 = DimOffset(ImageSum,1) 
  			dx = DimDelta(ImageSum,0) 
  			dy = DimDelta(ImageSum,1) 
  		
  			for(i=0;i<rows;i = i + 1)
  				help1 = i*columns
  				help3 = i*dx
  				for(j=0;j<columns;j = j + 1)
  					help2 = help1 + j
  					//Density2DTriplet[help2][0] = help3
  					//Density2DTriplet[help2][1] = j*dy
  					
  					Density2DTriplet[help2][0] =  j*dy
  					Density2DTriplet[help2][1] = help3
  					Density2DTriplet[help2][2] = ImageSum3[i][j]
  					
  				endfor
  			endfor
  		
  			WAVE W_WaveTransform
  			WaveTransform /D/P= {1, 1, 1, 90, 90, 120} crystalToRect Density2DTriplet
  			WAVE M_CrystalToRect
  			for(i=0;i<rows;i = i + 1)
  				help1 = i*columns
  				help3 = i*dx
  				for(j=0;j<columns;j = j + 1)
  					help2 = help1 + j
  					Density2DParam[i][j][0] = M_CrystalToRect[help2][0]
  					Density2DParam[i][j][1] = M_CrystalToRect[help2][1]
  					Density2DParam[i][j][2] = M_CrystalToRect[help2][2]
  				endfor
  			endfor
			break
		endswitch

	return 0
End


Function Display3DdensityPlot(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Wave /T W_WaveList
			String name1
			Variable number
			
			SetDataFolder root:Specs:
			WAVE sw1 = root:sw1
			WAVE/T ListWave1 = root:ListWave1
			Variable i , j , k
			Variable size1 , size2
			size1 = DimSize ( sw1 , 1)
			size2 = DimSize ( sw1 , 0)
			
			for ( i = 0 ; i < size2 ; i = i + 1)
				if( (sw1[i][0] == (2^0)) || (sw1[i][1] == (2^0)) || (sw1[i][2] == (2^0)) || (sw1[i][3] == (2^0)) || (sw1[i][4] == (2^0)) )
					break	
				endif
			endfor
			
			if ( cmpstr ( ListWave1[i][0] , "" ) == 0 )
				return 0
			endif
			SetDataFolder root:Specs:$ListWave1[i][0]
			WAVE	Density2DParam
			Setdatafolder root:Specs:
			
			name1 = ListWave1[i][0]
			if( strsearch(name1,".rho",0) == -1)
				break
			endif
			
			WAVE/T TW_DisplayList
			WAVE/T TW_gizmoObjectList
			String S_DisplayList
			String S_DisplayNames
			String S_gizmoObjectList
			String S_ObjectNames
			
			String objectList
			DoWindow/F Electron_Density_Plot					//pulls the window to the front
			If(V_flag == 0)									//checks if there is a window....
				Execute "NewGizmo/N=Electron_Density_Plot"
				ControlBar/L 160
			endif
			Execute " GetGizmo /N=Electron_Density_Plot displayList"
			Execute " GetGizmo /N=Electron_Density_Plot displayNameList"
			Execute " GetGizmo /N=Electron_Density_Plot objectList"
			Execute " GetGizmo /N=Electron_Density_Plot objectNameList"
			
			//SetActiveSubwindow $"Electron_Density_Plot"
			GetWindow $"Electron_Density_Plot" wavelist
			number = WaveExists(W_WaveList)
			//if(number == 0 )
			//	number = 1
			//else
			GetWindow $"Electron_Density_Plot" wavelist
			name1 = W_WaveList[0][0]
			number = exists(name1)
			//endif
			
			if( number != 0 )
				RemoveImage /W=$"Electron_Density_Plot" $name1
			endif
			ControlInfo D3Dd
			number = cmpstr (name1 , "Image3")
			
			if( number == 0 )
				AppendImage /L=leftImage3 /B=bottomImage3 Image3der
			
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph margin =40
				ModifyGraph margin(right) =20
				ModifyGraph margin(top) =10
				ModifyGraph mode=2,rgb=(0,0,0)
				ModifyGraph freePos(leftImage3)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage3)={0.1,1}
				ModifyGraph axisEnab(leftImage3)={0.1,1}
				ModifyGraph margin(bottom)=20	
			
				ModifyGraph swapXY=1
				//ModifyImage Image3der ctab= {*,*,Grays,1}
				//ModifyImage Image3der ctab= {*,*,BrownViolet,1}
				Button D3Dd,title="Go to\rImage"
			else
				AppendImage /L=leftImage3 /B=bottomImage3 Image3
			
				ModifyGraph  swapXY=1 ,lblPosMode= 2
				ModifyGraph margin =40
				ModifyGraph margin(right) =20
				ModifyGraph margin(top) =10
				ModifyGraph mode=2,rgb=(0,0,0)
				ModifyGraph freePos(leftImage3)={0.1,kwFraction}
				ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
				ModifyGraph axisEnab(bottomImage3)={0.1,1}
				ModifyGraph axisEnab(leftImage3)={0.1,1}
				ModifyGraph margin(bottom)=20	
			
				ModifyGraph  /W=$"k_Space_2D" swapXY=1
				Button D3Dd,title="Go to\r2nd Der."
			endif
			
			//KillWaves W_WaveList
			break
	endswitch
	DoUpdate 
	return 0
End

Function setValueHelperLine1(dval,ctrlName)
	Variable dval
	String ctrlName
	
	String name1
	String name2 , name3
				
	name1 = ImageNameList("", "" )
	name1 = StringFromList (0, name1  , ";")
	DoUpdate
	Setdatafolder root:folder3D:
	Variable help5	
	ControlInfo /W=k_Space_2D check5
	help5 = V_value		
	if(help5)
		WAVE Images3D = Images3Dder
	else
		WAVE Images3D = Images3D
	endif		
	WAVE Image3
	//WAVE Images3D
	WAVE CutX_K
	WAVE CutY_K
				
	WAVE M_InterpolatedImage
	WAVE Image1 = $name1
	WAVE VCS = VCS
	WAVE Multipliers
	WAVE ImageX
	WAVE ImageY
	//WAVE Images3D
	//WAVE EDC=EDC
				
	SetVariable Multiplier, value=Multipliers[dval]
									
	if (strlen(csrinfo(A,""))==0)
		execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0) A "+name1+" 0,0"
		ValDisplay Position2,value=_NUM:vcsr(A,"")
		SetVariable Position1,value=_NUM:dval
	endif
	if (cmpstr(ctrlName,"Line1")==0)
		execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0) A "+name1+" pcsr(A,\"\"),"+num2str(dval)
		SetVariable Position1,value=_NUM:dval
		ValDisplay Position2,value=_NUM:vcsr(A,"")
					
	endif
	if (cmpstr(ctrlName,"Position1")==0)
		execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0) A "+name1+" pcsr(A,\"\"),"+num2str(dval)
		Slider Line1,value=dval
		ValDisplay Position2,value=_NUM:vcsr(A,"")
					
	endif
	return 0
End

Function mouseUpHelperLine1()
	Setdatafolder root:folder3D:
	Variable help5
	String nameS,nameR,nameL
	nameS = ImageNameList("Angle_Energy", "" )
	nameL = StringFromList (0, nameS  , ";")
	nameR = StringFromList (1, nameS  , ";")
	
	ControlInfo /W=k_Space_2D check5
	help5 = V_value
	if(help5)
		WAVE Images3D = Images3Dder
	else
		WAVE Images3D = Images3D
	endif		
	
	NVAR PE = PhotonEnergy
	NVAR WF = WorkFunction
	NVAR KF = KineticFermi
	
	Variable checked
	Variable i , number2
	Variable help1, help2 , help3
	//WAVE Images3Dder
	WAVE Image3der
	WAVE Image3
	//WAVE Images3D
	WAVE CutX_K
	WAVE CutY_K
	
	WAVE M_InterpolatedImage
	WAVE Multipliers
	WAVE ImageX
	WAVE ImageY
	//WAVE Images3D
	WAVE LayerN_K
	Variable C1,C2
	C2 = 180/Pi
		
	ControlInfo /W=k_Space_2D check2
	checked = V_value
	ControlInfo /W=k_Space_2D SetLayers
	help3 = V_value
	ControlInfo /W=k_Space_2D Param1
	help2 = V_value

	switch(checked)	// string switch
		case 0:		// execute if case matches expression
			Variable ni
			Variable mi
			ControlInfo /W=k_Space_2D Param1
			help2 = V_value
			number2 = DimSize (Images3D, 2)
			
			ni = qcsr(A)
			mi = pcsr(A)
			ImageX[][] = Images3D[p][q][ni]
			ImageY[][] = Images3D[p][mi][q]
	
			for( i = 0 ; i < number2 ; i = i +1)
				ImageY[][i] = 	ImageY[p][i]*Multipliers[i]
			endfor
	
			ImageX = ImageX^help2
			ImageY = ImageY^help2
			Duplicate/O ImageX , ImageX_B
			SetScale /P x, (DimOffset( Images3D,0 )-KF), DimDelta(Images3D,0) , "" , ImageX_B
			
			DoWindow/F $"Angle_Energy"			//pulls the window to the front
			if (V_Flag==1)
				Wave waveL = $nameL
				Wave waveR = $nameR
				
				Wavestats/Q/Z waveL
				Slider contrastmin1,limits={V_min,V_max,0},value=V_min
				Slider contrastmax1,limits={V_min,V_max,0},value=V_max
				Wavestats/Q/Z waveR
				Slider contrastmin2,limits={V_min,V_max,0},value=V_min
				Slider contrastmax2,limits={V_min,V_max,0},value=V_max
			endif
			DoWindow/F $"k_Space_2D"	
			DoUpdate
			break						// exit from switch
		case 1:		// execute if case matches expression
			Variable x0
			Variable deltaE
			Variable Energy
			WAVE M_ImageHistEq
			Variable kx1 , kx2 , ky1 , ky2
			Variable Xmin, Xmax, Ymin, Ymax, Zmin , Zmax
			Xmin = DimOffset(Images3D,1)
			Xmax = DimOffset(Images3D,1) + (Dimsize(Images3D,1)-1) *DimDelta(Images3D,1)
			Ymin = DimOffset(Images3D,2)
			Ymax = DimOffset(Images3D,2) + (Dimsize(Images3D,2)-1) *DimDelta(Images3D,2)
			Zmin = DimOffset(Images3D,0)
			Zmax = DimOffset(Images3D,0) + (Dimsize(Images3D,0)-1) *DimDelta(Images3D,0)
		
			ni = vcsr(A,"")
			mi = hcsr(A,"")
			//CutX_K = 0
			//CutY_K = 0
			kx1 = DimOffset(CutX_K,1)
			kx2 = DimOffset(CutX_K,1) + (Dimsize(CutX_K,1)-1) *DimDelta(CutX_K,1)
			ky1 = DimOffset(CutY_K,1)
			ky2 = DimOffset(CutY_K,1) + (Dimsize(CutY_K,1)-1) *DimDelta(CutY_K,1)
			
			//CutX_K = Images3D(x)( asin(y/(0.512*sqrt(x)))*C2 )( asin( ni/( 0.512*sqrt(x) *cos(asin(y/(0.512*sqrt(x))))))*C2 )
			
			Variable x1,y1, x2, x2p, y2 , z1
			Variable j , k , imax , jmax , kmax, deltai, deltaj , deltak, y0 , z0
			imax = DimSize (CutX_K,1)
			//jmax = DimSize (CutX_K,1)
			kmax = DimSize (CutX_K,0)
			
			deltai = DimDelta (CutX_K,1)
			//deltaj = DimDelta (CutX_K,1)
			deltak = DimDelta (CutX_K,0)
			
			x0 = DimOffset (CutX_K,1)
			//y0 = DimOffset (CutX_K,1)
			z0 = DimOffset (CutX_K,0)
			
			//C1 = 1/(0.512*sqrt(Energy))
			
			Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
			Variable delta_k_n , delta_k_m , delta_phi , delta_theta
			Variable k_n0 , k_m0 , phi0 , theta0
			Variable phi1 , phi2 , theta1 , theta2
			Variable i_n , j_m 
			Variable n_max , m_max
			Variable i_max , j_max
			Variable i_1 , i_2 , j_1 , j_2
			Variable wL , wR , wU , wD 
			Variable o , o_max , E_o0 , delta_E , E_o
			
			Variable energy2
			energy2 = PE-WF+ energy - KF
			C1 = 1/(0.512*sqrt(energy2))
			C2 = 180/Pi
			
			n_max = DimSize (CutX_K,1)
			m_max = DimSize (LayerN_K,1)
			o_max = DimSize (CutX_K,0)
			
			k_n0 = DimOffset (CutX_K,1)
			k_m0 = DimOffset (LayerN_K,1)
			E_o0 = DimOffset (CutX_K,0)
			
			delta_k_n = DimDelta (CutX_K,1)
			delta_k_m = DimDelta (LayerN_K,1)
			delta_E = DimDelta (CutX_K,0)
			
			i_max = DimSize (Images3D,1) - 1
			j_max = DimSize (Images3D,2) - 1
			
			phi0 = DimOffset (Images3D,1)
			theta0 = DimOffset (Images3D,2)
			
			delta_phi = DimDelta (Images3D,1)
			delta_theta = DimDelta (Images3D,2)
			
			Variable cursorV
			cursorV = vcsr(A,"")
			k_n = k_n0
			k_m = cursorV
			E_o = PE-WF-KF+E_o0
			
			Variable sinPhi
			Variable cosPhi
			Variable sinTheta
			Variable deltaFiPrime
			Variable deltaThetaPrime
			Variable help6
			Variable sinAlfa
			Variable cosAlfa
			Variable C3,C4
			C2 = 180/Pi
			C3 = Pi/180
			
			ControlInfo /W=k_Space_2D rotation
			help6 = V_value
			sinAlfa = sin(help6*C3)
			cosAlfa = cos(help6*C3)
			CutX_K = NaN
			
			for(o=0;o<o_max;o=o+1)
				C1 = 1/(0.512*sqrt(E_o))
				for( n=0;n<n_max;n=n+1)
					sinPhi = C1*(cosAlfa*k_n - sinAlfa*k_m)
					phi_n_rad = asin( sinPhi )
					phi_n = phi_n_rad * C2
					i_n = (phi_n - phi0)/delta_phi
					if(i_n>=0 && i_n<=i_max)
						cosPhi = sqrt(1-sinPhi*sinPhi)
						C4 = C1/ cosPhi
						sinTheta = C4*(sinAlfa*k_n + cosAlfa*k_m)
						theta_m = asin( sinTheta ) * C2
						j_m = (theta_m - theta0)/delta_theta	
						if(j_m>=0 && j_m<=j_max)	
							i_1 = floor(i_n)
							i_2 = ceil(i_n)
							j_1 = floor(j_m)
							j_2 = ceil(j_m)
							wR = i_n - i_1
							wL = 1 - wR
							wU = j_m - j_1
							wD = 1 - wU
							CutX_K[o][n] = Images3D[o][i_1][j_1]*wL*wD + Images3D[o][i_2][j_1]*wR*wD + Images3D[o][i_1][j_2]*wL*wU + Images3D[o][i_2][j_2]*wR*wU
						else
							CutX_K[o][n] = Nan
						endif
							//k_m = k_m + delta_k_m
						//endfor
					else
						CutX_K[o][n] = Nan
					endif
					//k_m = k_m0
					k_n = k_n + delta_k_n
				endfor
				k_n = k_n0
				E_o = E_o + delta_E
			endfor
			
			if( help2 != 1)
				CutX_K = CutX_K^help2
				//CutY_K = CutY_K^help2
			endif
			Duplicate/O CutX_K , CutX_K_B
			SetScale /P x, (DimOffset( Images3D,0 )-KF), DimDelta(Images3D,0) , "" , CutX_K_B
			
			DoWindow/F $"Angle_Energy"			//pulls the window to the front
			if (V_Flag==1)
				Wave waveL = $nameL
				Wave waveR = $nameR
					
				Wavestats/Q/Z waveL
				Slider contrastmin1,limits={V_min,V_max,0},value=V_min
				Slider contrastmax1,limits={V_min,V_max,0},value=V_max
				Wavestats/Q/Z waveR
				Slider contrastmin2,limits={V_min,V_max,0},value=V_min
				Slider contrastmax2,limits={V_min,V_max,0},value=V_max
			endif
			DoWindow/F $"k_Space_2D"	
			break
		
		default:
		
	endswitch
End

Function setValueHelperLine2(dval,ctrlName)
	Variable dval
	String ctrlName

	String name1
	String name2 , name3
	
	name1 = ImageNameList("", "" )
	name1 = StringFromList (0, name1  , ";")
	DoUpdate
	Setdatafolder root:folder3D:
	Variable help5
	ControlInfo /W=k_Space_2D check5
	help5 = V_value
	if(help5)
		WAVE Images3D = Images3Dder
	else
		WAVE Images3D = Images3D
	endif		
	WAVE Image3
	//WAVE Images3D
	WAVE CutX_K
	WAVE CutY_K
	WAVE LayerN_K
	
	WAVE M_InterpolatedImage
	WAVE Image1 = $name1
	WAVE Multipliers
	WAVE ImageX
	WAVE ImageY
	//WAVE Images3D
	Variable C1,C2
	C2 = 180/Pi
	
	//SetVariable Multiplier value=Multipliers[curval]
	
	if (strlen(csrinfo(A,""))==0)
		execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0) A "+name1+" 0,0"
		ValDisplay Position4,value=_NUM:hcsr(A,"")
		SetVariable Position3,value=_NUM:dval
	endif
	if (cmpstr(ctrlName,"Line2")==0)
		execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0) A "+ name1+ " " + num2str(dval) +",qcsr(A,\"\")"
		ValDisplay Position4,value=_NUM:hcsr(A,"")
		SetVariable Position3,value=_NUM:dval
	endif
	if (cmpstr(ctrlName,"Position3")==0)
		execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0) A "+ name1+ " " + num2str(dval) +",qcsr(A,\"\")"
		ValDisplay Position4,value=_NUM:hcsr(A,"")
		Slider Line1,value=dval
	endif
	return 0
End

Function mouseUpHelperLine2()
	Setdatafolder root:folder3D:
	String nameS,nameR,nameL
	Variable help5,C1,C2
	C2 = 180/Pi
	nameS = ImageNameList("Angle_Energy", "" )
	nameL = StringFromList (0, nameS  , ";")
	nameR = StringFromList (1, nameS  , ";")
	
	ControlInfo /W=k_Space_2D check5
	help5 = V_value
	if(help5)
		WAVE Images3D = Images3Dder
	else
		WAVE Images3D = Images3D
	endif		
	NVAR PE = PhotonEnergy
	NVAR WF = WorkFunction
	NVAR KF = KineticFermi
	Variable checked
	Variable i , number2
	Variable help1, help2 , help3
	//WAVE Images3Dder
	WAVE Image3der
	WAVE Image3
	//WAVE Images3D
	WAVE CutX_K
	WAVE CutY_K
	
	WAVE M_InterpolatedImage
	WAVE Multipliers
	WAVE ImageX
	WAVE ImageY
	//WAVE Images3D
	
	ControlInfo /W=k_Space_2D check2
	checked = V_value
	ControlInfo /W=k_Space_2D SetLayers
	help3 = V_value
	ControlInfo /W=k_Space_2D Param1
	help2 = V_value
	
	switch(checked)	// string switch
		case 0:		// execute if case matches expression
			Variable ni
			Variable mi
			ControlInfo /W=k_Space_2D Param1
			help2 = V_value
			number2 = DimSize (Images3D, 2)
			
			ni = qcsr(A)
			mi = pcsr(A)
			ImageX[][] = Images3D[p][q][ni]
			ImageY[][] = Images3D[p][mi][q]
	
			for( i = 0 ; i < number2 ; i = i +1)
				ImageY[][i] = 	ImageY[p][i]*Multipliers[i]
			endfor
	
			ImageX = ImageX^help2
			ImageY = ImageY^help2
			Duplicate/O ImageY , ImageY_B
			SetScale /P x, (DimOffset( Images3D,0 )-KF), DimDelta(Images3D,0) , "" , ImageY_B
			DoWindow/F $"Angle_Energy"			//pulls the window to the front
			if (V_Flag==1)
				Wave waveL = $nameL
				Wave waveR = $nameR
				
				Wavestats/Q/Z waveL
				Slider contrastmin1,limits={V_min,V_max,0},value=V_min
				Slider contrastmax1,limits={V_min,V_max,0},value=V_max
				Wavestats/Q/Z waveR
				Slider contrastmin2,limits={V_min,V_max,0},value=V_min
				Slider contrastmax2,limits={V_min,V_max,0},value=V_max
			endif
			DoWindow/F $"k_Space_2D"	
			DoUpdate
			break						// exit from switch
		case 1:		// execute if case matches expression
			Variable x0
			Variable deltaE
			Variable Energy
			WAVE M_ImageHistEq
			Variable kx1 , kx2 , ky1 , ky2
			
			ni = vcsr(A,"")
			mi = hcsr(A,"")
			//CutX_K = 0
			CutY_K = Nan
			kx1 = DimOffset(CutX_K,1)
			kx2 = DimOffset(CutX_K,1) + (Dimsize(CutX_K,1)-1) *DimDelta(CutX_K,1)
			ky1 = DimOffset(CutY_K,1)
			ky2 = DimOffset(CutY_K,1) + (Dimsize(CutY_K,1)-1) *DimDelta(CutY_K,1)
			
			//CutY_K = Images3D(x)( asin(mi/(0.512*sqrt(x)))*C2 )( asin( y/( 0.512*sqrt(x) *cos(asin(mi/(0.512*sqrt(x))))))*C2 )
			
			Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
			Variable delta_k_n , delta_k_m , delta_phi , delta_theta
			Variable k_n0 , k_m0 , phi0 , theta0
			Variable phi1 , phi2 , theta1 , theta2
			Variable i_n , j_m 
			Variable n_max , m_max
			Variable i_max , j_max
			Variable i_1 , i_2 , j_1 , j_2
			Variable wL , wR , wU , wD 
			Variable o , o_max , E_o0 , delta_E , E_o
			
			//C1 = 1/(0.512*sqrt(Energy))
			C2 = 180/Pi
			
			n_max = DimSize (LayerN_K,0)
			m_max = DimSize (CutY_K,1)
			o_max = DimSize (CutY_K,0)
			
			k_n0 = DimOffset (LayerN_K,0)
			k_m0 = DimOffset (CutY_K,1)
			E_o0 = DimOffset (CutY_K,0)
			
			delta_k_n = DimDelta (LayerN_K,0)
			delta_k_m = DimDelta (CutY_K,1)
			delta_E = DimDelta (CutY_K,0)
			
			i_max = DimSize (Images3D,1) - 1
			j_max = DimSize (Images3D,2) - 1
			
			phi0 = DimOffset (Images3D,1)
			theta0 = DimOffset (Images3D,2)
			
			delta_phi = DimDelta (Images3D,1)
			delta_theta = DimDelta (Images3D,2)
			
			Variable cursorV , cursorH
			cursorV = vcsr(A,"")
			cursorH = hcsr(A,"")
			k_n = cursorH
			k_m = k_m0
			E_o = PE-WF-KF+E_o0
			
			Variable sinPhi
			Variable cosPhi
			Variable sinTheta
			Variable deltaFiPrime
			Variable deltaThetaPrime
			Variable help6
			Variable sinAlfa
			Variable cosAlfa
			Variable C3,C4
			C2 = 180/Pi
			C3 = Pi/180
			
			ControlInfo /W=k_Space_2D rotation
			help6 = V_value
			sinAlfa = sin(help6*C3)
			cosAlfa = cos(help6*C3)
			CutY_K = NaN
			
			for(o=0;o<o_max;o=o+1)
				C1 = 1/(0.512*sqrt(E_o))
				for( m=0;m<m_max;m=m+1)
					sinPhi = C1*(cosAlfa*k_n - sinAlfa*k_m)
					phi_n_rad = asin( sinPhi )
					phi_n = phi_n_rad * C2
					i_n = (phi_n - phi0)/delta_phi
					if(i_n>=0 && i_n<=i_max)
						cosPhi = sqrt(1-sinPhi*sinPhi)
						C4 = C1/ cosPhi
						sinTheta = C4*(sinAlfa*k_n + cosAlfa*k_m)
						theta_m = asin( sinTheta ) * C2
						j_m = (theta_m - theta0)/delta_theta	
						if(j_m>=0 && j_m<=j_max)	
							i_1 = floor(i_n)
							i_2 = ceil(i_n)
							j_1 = floor(j_m)
							j_2 = ceil(j_m)
							wR = i_n - i_1
							wL = 1 - wR
							wU = j_m - j_1
							wD = 1 - wU
							CutY_K[o][m] = Images3D[o][i_1][j_1]*wL*wD + Images3D[o][i_2][j_1]*wR*wD + Images3D[o][i_1][j_2]*wL*wU + Images3D[o][i_2][j_2]*wR*wU
						else
							CutY_K[o][m] = Nan
						endif
					else
						CutY_K[o][m] = Nan
					endif
					k_m = k_m + delta_k_m
					//k_n = k_n + delta_k_n
				//endfor
				//k_n = k_n0
				endfor
				k_m = k_m0
				E_o = E_o + delta_E
			endfor
			if( help2 != 1)
				//CutX_K = CutX_K^help2
				CutY_K = CutY_K^help2
			endif
		
			Duplicate/O CutY_K , CutY_K_B
			SetScale /P x, (DimOffset( Images3D,0 )-KF), DimDelta(Images3D,0) , "" , CutY_K_B
	
			DoWindow/F $"Angle_Energy"			//pulls the window to the front
			if (V_Flag==1)
				Wave waveL = $nameL
				Wave waveR = $nameR
				
				Wavestats/Q/Z waveL
				Slider contrastmin1,limits={V_min,V_max,0},value=V_min
				Slider contrastmax1,limits={V_min,V_max,0},value=V_max
				Wavestats/Q/Z waveR
				Slider contrastmin2,limits={V_min,V_max,0},value=V_min
				Slider contrastmax2,limits={V_min,V_max,0},value=V_max
			endif
			DoWindow/F $"k_Space_2D"	
			break
		
		default:
		
	endswitch
End

Function moveLine1Btn(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva
 
	switch( sva.eventCode )
		case 1: // mouse up
			setValueHelperLine1(sva.dval,sva.ctrlName)
			mouseUpHelperLine1()
		case 3: // Live update
			setValueHelperLine1(sva.dval,sva.ctrlName)
			break
	endswitch
 
	return 0
End

Function moveLine1(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			//Print sa
			if( sa.eventCode & 1 ) // value set
				setValueHelperLine1(sa.curval,sa.ctrlName)
			endif
			
			if( sa.eventCode  == 4 ) // mouse up
				mouseUpHelperLine1()
			endif
		break
	endswitch			
	return 0
End

Function moveLine2Btn(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva
 
	switch( sva.eventCode )
		case 1: // mouse up
			setValueHelperLine2(sva.dval,sva.ctrlName)
			mouseUpHelperLine2()
		case 3: // Live update
			setValueHelperLine2(sva.dval,sva.ctrlName)
			break
	endswitch
 
	return 0
End


Function moveLine2(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			//Print sa
			if( sa.eventCode & 1 ) // value set
				setValueHelperLine2(sa.curval,sa.ctrlName)
			endif
			
			if( sa.eventCode  == 4 ) // mouse up
				mouseUpHelperLine2()
			endif
		break
	endswitch			
	return 0
End

Function moveLine1D(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			//Print sa
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1
				String name2 , name3
				
				name1 = ImageNameList("", "" )
				name1 = StringFromList (0, name1  , ";")
				DoUpdate
				name3 = GetWavesDataFolder($name1,1)
				SetDataFolder GetWavesDataFolder($name1,1)
				WAVE M_InterpolatedImage
				WAVE Image1 = $name1
				WAVE VCS = VCS
				WAVE Multipliers
				WAVE ImageX
				WAVE ImageY
				WAVE Images3D
				//WAVE EDC=EDC
				
				if(WaveExists(Multipliers))
					SetVariable Multiplier value=Multipliers[curval]
				endif
				
				if (strlen(csrinfo(A,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0) A "+name1+" 0,0"
					ValDisplay Position2,value=_NUM:vcsr(A,"")
					SetVariable Position1,value=_NUM:curval
				endif
				if (cmpstr(sa.ctrlName,"Line1")==0)
					//VCS = Image1[p][curval]
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0) A "+name1+" pcsr(A,\"\"),"+num2str(curval)
					SetVariable Position1,value=_NUM:curval
					ValDisplay Position2,value=_NUM:vcsr(A,"")
					
				endif
				
			endif
			
			if( sa.eventCode  == 4 ) // mouse up
				Variable help2
				WAVE Multipliers
				WAVE ImageX
				WAVE ImageY
				WAVE Images3D
				ControlInfo /W=Electron_Density Param1
				help2 = V_value
				
				Variable i , number2
				number2 = DimSize (Images3D, 2)
							
				Variable ni
				Variable mi
				ni = qcsr(A)
				mi = pcsr(A)
				ImageX[][] = Images3D[p][q][ni]
				ImageY[][] = Images3D[p][mi][q]
				
				ImageX = ImageX^help2
				ImageY = ImageY^help2
				DoUpdate
			endif
			//ValDisplay cross2,value=_NUM:hcsr(B,"Blended_Panel#G0")
			//ValDisplay cross1,value=_NUM:vcsr(B,"Blended_Panel#G0")
			
			break
	endswitch

	return 0
End

Function moveLine2D(sa) : SliderControl
	STRUCT WMSliderAction &sa

	switch( sa.eventCode )
		case -1: // kill
			break
		default:
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1
				String name2 , name3
				
				name1 = ImageNameList("", "" )
				name1 = StringFromList (0, name1  , ";")
				DoUpdate
				name3 = GetWavesDataFolder($name1,1)
				SetDataFolder GetWavesDataFolder($name1,1)
				WAVE M_InterpolatedImage
				WAVE Image1 = $name1
				WAVE Multipliers
				WAVE ImageX
				WAVE ImageY
				WAVE Images3D
				//WAVE EDC=EDC
				
				//SetVariable Multiplier value=Multipliers[curval]
				
				if (strlen(csrinfo(A,""))==0)
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0) A "+name1+" 0,0"
					ValDisplay Position4,value=_NUM:hcsr(A,"")
					ValDisplay Position3,value=_NUM:curval
				endif
				if (cmpstr(sa.ctrlName,"Line2")==0)
					//VCS = Image1[p][curval]
					execute/Z/Q "Cursor/W=# /P/I/H=1/C=(65280,0,0) A "+ name1+ " " + num2str(curval) +",qcsr(A,\"\")"
					ValDisplay Position4,value=_NUM:hcsr(A,"")
					ValDisplay Position3,value=_NUM:curval
				endif
				//if (cmpstr(sa.ctrlName,"moveEDC1")==0)
				//	VCS = Image1[curval][p]
				//	execute/Z/Q "Cursor/W=# /P/I/H=2/C=(65280,0,0) A "+name1+" "+num2str(curval)+",qcsr(A,\"\")"
				//	ValDisplay valdisp1,value=_NUM:hcsr(A,"")
				//endif		
			endif
			
			if( sa.eventCode  == 4 ) // mouse up
				Variable help2
				WAVE Multipliers
				WAVE ImageX
				WAVE ImageY
				WAVE Images3D
				ControlInfo /W=Electron_Density Param1
				help2 = V_value
				
				Variable i , number2
				number2 = DimSize (Images3D, 2)
							
				Variable ni
				Variable mi
				ni = qcsr(A)
				mi = pcsr(A)
				ImageX[][] = Images3D[p][q][ni]
				ImageY[][] = Images3D[p][mi][q]
				
				if(WaveExists(Multipliers))
					SetVariable Multiplier value=Multipliers[curval]
					for( i = 0 ; i < number2 ; i = i +1)
						ImageY[][i] = 	ImageY[p][i]*Multipliers[i]
					endfor
				endif
				ImageX = ImageX^help2
				ImageY = ImageY^help2
				DoUpdate
			endif
			//ValDisplay cross2,value=_NUM:hcsr(B,"Blended_Panel#G0")
			//ValDisplay cross1,value=_NUM:vcsr(B,"Blended_Panel#G0")
			
			break
	endswitch

	return 0
End

Function SetMultiplier(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			
			String name1, name2
			Wave /T W_WaveList
			Variable number
			
			Setdatafolder root:folder3D:
			WAVE Image3
			WAVE Image3der
			WAVE Images3D
			WAVE Images3Dder
			WAVE M_ImageHistEq
			WAVE W_ImageHis
			WAVE Multipliers
			
			Variable deltaE
			Variable x0
			Variable Energy
			
			Make/O/N=(256) W_ImageHis
			
			Variable help1
			Variable help2
			Variable help3
			Variable help4
			
			ControlInfo /W=k_Space_2D check1
			help1 = V_value
			ControlInfo /W=k_Space_2D Param1
			help2 = V_value
			ControlInfo /W=k_Space_2D SetLayers
			help3 = V_value
			ControlInfo /W=k_Space_2D Position1
			help4 = V_value
			
			Multipliers[help4] = dval
			
			Variable i , number2
			number2 = DimSize (Images3D, 2)
			
			Image3[][] = Images3D[help3][p][q]
			
			for( i = 0 ; i < number2 ; i = i +1)
				Image3[][i] = 	Image3[p][i]*Multipliers[i]
			endfor
			
			Image3 = Image3^help2
			
			x0 = DimOffset (Images3D,0)
			deltaE = DimDelta (Images3D,0)
			Energy = x0 + help3*deltaE
			
			ValDisplay Energy1, value=_NUM:Energy
			
			if(help1 == 1)
				ImageHistModification Image3
				Image3 = M_ImageHistEq	
			else
				//Image3[][] = Images3D[help3][p][q]^help2
				//Image3der[][] = Images3Dder[help3][p][q]^help2	
			endif
		
		break
	endswitch

	return 0
End


Function InsertWave(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here

			WAVE/T ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
			WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
			Variable number1 , number2, number3 
			Variable leftAngle , rightAngle , deltaAngle , numberPoints
			Variable position
			Variable help1 ,help2
			Variable i ,j ,k
			Variable tiltAngle
			Variable lowAngle
			STRUCT file_header fh
			
			SetDataFolder root:Specs:
			SVAR list_folder //= root:Specs:list_folder
			
			number1 = ItemsInList( list_folder ) 
			
			String waveName1
			String WaveList1 
			String columnName
			WaveList1  = WaveList("*",";","")
			Prompt waveName1,"Wave List",popup, WaveList("*",";","")
			Prompt columnName,"Column",popup,"Emission;Tilt/Emission;Width;Kinetic Energy, High;Kinetic Energy, Low;Energy Shift;Delta Angle;Keithley;Exposure;Photon Energy;Work Function;Kinetic Energy of Fermi Level;S.E.;S.A."
			DoPrompt "Choose Wave and Column",waveName1,columnName
			if (V_Flag)
				return 0									// user canceled
			endif
			Wave WaveTOinsert = $waveName1
			Variable column 
			strswitch(columnName)						// string switch
				case "Emission":
					column = 2
					break
				case "Tilt/Emission":
					column = 3
					break
				case "Width":
					column = 4
					break
				case "Kinetic Energy, High":
					column = 5
					break
				case "Kinetic Energy, Low":
					column = 6
					break
				case "Energy Shift":
					column = 7
					break
				case "Delta Angle":
					column = 8
					break
				case "Keithley":
					column = 9
					break
				case "Exposure":
					column = 10
					break
				case "Photon Energy":
					column = 11
					break
				case "Work Function":
					column = 12
					break	
				case "Kinetic Energy of Fermi Level":
					column = 13
					break
				case "S.E.":
					column = 14
					break
				case "S.A.":
					column = 15
					break
				
			endswitch
			
			for( i = 0 ; i<(number1) ; i = i +1 )
				ListWave1[i][column]  = num2str (WaveTOinsert[i])
			endfor
					
			break
	endswitch

	return 0
End

Function InsertValues(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Display_MultipleSet_Panel()
					
			break
	endswitch

	return 0
End

Function SetValues(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here

			WAVE/T ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
			WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
			Variable number1 , number2, number3 
			Variable leftAngle , rightAngle , deltaAngle , numberPoints
			Variable position
			Variable help1 ,help2
			Variable i ,j ,k
			Variable tiltAngle
			Variable lowAngle
			STRUCT file_header fh
			
			SetDataFolder root:Specs:
			SVAR list_folder //= root:Specs:list_folder
			
			String waveName1
			String WaveList1 
			String columnName
			WaveList1  = WaveList("*",";","")
			
			number1 = ItemsInList( list_folder ) 
			Variable offset
			Variable delta = 0
			Variable startingN = 1
			Variable endAt =number1
			Variable correction = 0
			
			Prompt offset, "Offset:"
			Prompt delta, "Delta:"
			Prompt correction, "Correction:"
			Prompt startingN, "Start From:"
			Prompt endAt,"End At:"
			Prompt columnName,"Column",popup,"Emission;Tilt/Emission;Width;Kinetic Energy, High;Kinetic Energy, Low;Energy Shift;Delta Angle;Keithley;Exposure;Photon Energy;Work Function;Kinetic Energy of Fermi Level;S.E.;S.A.;Hot Pixels;Background;Straight;Defects;Last Four Columns H.,B.,S.,D"
			DoPrompt "Set Parameters and Choose Column:",offset, delta,correction,  startingN,endAt, columnName
			if (V_Flag)
				return 0									// user canceled
			endif
			Variable column 
			strswitch(columnName)						// string switch
				case "Emission":
					column = 2
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
						//Set_Angle_2D( i )
					endfor
					break
				case "Tilt/Emission":
					column = 3
					for( i = startingN - 1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
					endfor
					break
				case "Width":
					column = 4
					for( i = startingN - 1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
						//Set_Angle_2D( i )
						endfor
					break
				case "Kinetic Energy, High":
					column = 5
					for( i = startingN - 1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
						//Set_Angle_2D( i )
					endfor
					break
				case "Kinetic Energy, Low":
					column = 6
					for( i = startingN - 1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
						//Set_Angle_2D( i )
					endfor
					break
				case "Energy Shift":
					column = 7
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
						//Set_Angle_2D( i )
					endfor
					break
				case "Delta Angle":
					column = 8
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
						SetDataFolder root:Specs:$listWave1[i][1]
						WAVE wave1 = $listWave1[i][1]
						SetScale_2D( i , wave1 )
					endfor
					break
				case "Keithley":
					column = 9
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
						//Set_Angle_2D( i )
					endfor
					break
				case "Exposure":
					column = 10
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
						//Set_Angle_2D( i )
					endfor
					break
				case "Photon Energy":
					column = 11
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
					endfor
					break
				case "Work Function":
					column = 12
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
					endfor
					break	
				case "Kinetic Energy of Fermi Level":
					column = 13
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
					endfor
					break
				case "S.E.":
					column = 14
					STRING name1, name2
					Variable Low1 , High1
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
						//Set_Angle_2D( i )
					endfor
					break
				case "S.A.":
					column = 15
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if(correction !=0)
							ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
						else
							ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
						endif
						//Set_Angle_2D( i )
					endfor
					break
				case "Hot Pixels":
					column = 16
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if( offset>0 )
							sw1[i][column] = sw1[i][column] | (2^4)
							listWave1[i][column] = num2str(1)
						else
							sw1[i][column] = sw1[i][column] & ~(2^4)
							listWave1[i][column] = num2str(0)	
						endif
					endfor
					break		
				case "Background":
					column = 17
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if( offset>0 )
							sw1[i][column] = sw1[i][column] | (2^4)
							listWave1[i][column] = num2str(1)
						else
							sw1[i][column] = sw1[i][column] & ~(2^4)
							listWave1[i][column] = num2str(0)	
						endif
					endfor
					break		
				case "Straight":
					column = 18
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if( offset>0 )
							sw1[i][column] = sw1[i][column] | (2^4)
							listWave1[i][column] = num2str(1)
						else
							sw1[i][column] = sw1[i][column] & ~(2^4)
							listWave1[i][column] = num2str(0)	
						endif
					endfor
					break
				case "Defects":
					column = 19
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						if( offset>0 )
							sw1[i][column] = sw1[i][column] | (2^4)
							listWave1[i][column] = num2str(1)
						else
							sw1[i][column] = sw1[i][column] & ~(2^4)
							listWave1[i][column] = num2str(0)	
						endif
					endfor
					break	
				case "Last Four Columns H.,B.,S.,D":
					for( i = startingN -1 ; i<(endAt) ; i = i +1 )
						column = 16
						if( offset>0 )
							sw1[i][column] = sw1[i][column] | (2^4)
							listWave1[i][column] = num2str(1)	
							column +=1
							sw1[i][column] = sw1[i][column] | (2^4)
							listWave1[i][column] = num2str(1)
							column +=1
							sw1[i][column] = sw1[i][column] | (2^4)
							listWave1[i][column] = num2str(1)
							column +=1
							sw1[i][column] = sw1[i][column] | (2^4)
							listWave1[i][column] = num2str(1)
						else
							sw1[i][column] = sw1[i][column] & ~(2^4)
							listWave1[i][column] = num2str(0)
							column +=1	
							sw1[i][column] = sw1[i][column] & ~(2^4)
							listWave1[i][column] = num2str(0)
							column +=1	
							sw1[i][column] = sw1[i][column] & ~(2^4)
							listWave1[i][column] = num2str(0)
							column +=1	
							sw1[i][column] = sw1[i][column] & ~(2^4)
							listWave1[i][column] = num2str(0)
						endif
					endfor
						
			endswitch
					
			break
	endswitch

	return 0
End
				
Function Set_Angle_2D( row )
	Variable row
	
	WAVE/T ListWave 	= 	root:Load_and_Set_Panel:ListWave1
	WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
	
	SetDataFolder root:Specs:$listWave[row][1]	
	WAVE wave1 = $listWave[row][1]
	WAVE Angle_2D
	Variable emission , left, right , deltaA, deltaE , ES , lower , keithley
	Variable i
		
	emission = 0
	left = emission - ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	right = emission + ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	Duplicate/O/R= ( str2num( listWave[row][6] ), str2num( listWave[row][5] ) )( left, right ) wave1, Angle_2D
				
	emission = str2num ( listWave[row][2] )
	left = emission - ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	right = emission + ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	deltaA = DimDelta(Angle_2D,1)
	ES = str2num ( listWave[row][9] )
	lower = ES + DimOffset( Angle_2D,0 )
	deltaE = DimDelta(Angle_2D,0)
	SetScale/P x, lower , deltaE, "Kinetic Energy [eV]" Angle_2D
	SetScale/P y, left , deltaA, "Angle [deg]" Angle_2D

	Variable nPointsX , nPointsY 
	Variable val1, val2 
	WAVE w0 = Angle_2D
			
	val1 =  str2num( ListWave[row][7] ) 
	val2 =  str2num( ListWave[row][8] ) 
	nPointsX = DimSize(Angle_2D,0)
	nPointsY = DimSize(Angle_2D,1)
	Make/FREE /N=(nPointsX) v1 
	Make/FREE /N=(nPointsY) v2 
					
	if(val1 > 0 )
		for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
			v1 =  w0[p][i]
			Smooth val1 , v1
			w0[][i] = v1[p]
		endfor
	endif
					
	if(val2 > 0 )
		for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
			v2 =  w0[i][p]
			Smooth val2 , v2
			w0[i][] = v2[q]
		endfor
	endif	
	keithley = str2num ( listWave[row][10] )
	Angle_2D = Angle_2D/keithley
	return 0 
End 

Function SetScale_2D( row , target_wave )
	Variable row
	Wave target_wave
	
	WAVE/T ListWave 	= 	root:Load_and_Set_Panel:ListWave1
	WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
	
	//SetDataFolder root:Specs:$listWave[row][1]	
	//WAVE nwave = nwave
	Variable newWidth , deltaA , aLow
	deltaA = str2num( ListWave[row][8] )
	newWidth = DimSize(target_wave,1) *deltaA
	ListWave[row][4] = num2str(newWidth)
	aLow = (deltaA - newWidth )/2
	SetScale/P y, aLow , deltaA, "Angle [deg]" target_wave
	return 0 
End 

Function Cut_SetEmission( row , target_wave )
	Variable row
	Wave target_wave
	
	WAVE/T ListWave 	= 	root:Load_and_Set_Panel:ListWave1
	WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
	
	SetDataFolder root:Specs:$listWave[row][1]	
	WAVE nwave = nwave
	
	WAVE wave1 = $listWave[row][1]
	WAVE wave2
	Variable emission , left, right , deltaA, deltaE , ES , lower , keithley, exposure
	Variable i
		
	emission = 0
	left = emission - ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	right = emission + ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	Duplicate/O/R= ( str2num( listWave[row][6] ), str2num( listWave[row][5] ) )( left, right ) wave1, wave2
	Redimension/S wave2
	//if( DimSize(nwave, 0 ) != DimSize(wave2, 1 ) )
	//	listWave[row][18] = num2str(0)
	//	Redimension/N =(DimSize(wave2, 1 )) nwave	
	//endif
				
	emission = str2num ( listWave[row][2] )
	left = emission - ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	right = emission + ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	deltaA = DimDelta(wave2,1)
	ES = str2num ( listWave[row][7] )
	lower = ES + DimOffset( wave2,0 )
	deltaE = DimDelta(wave2,0)
	
	SetScale/P x, lower , deltaE, "Kinetic Energy [eV]" wave2
	SetScale/P y, left , deltaA, "Emission Angle [deg]" wave2

	keithley = str2num ( listWave[row][9] )
	exposure = str2num ( listWave[row][10] )
	Variable multiply1
	multiply1 = 1/keithley/exposure
	wave2 = wave2*multiply1
	Duplicate/O wave2 , target_wave
	Killwaves wave2
	
	return 0 
End 

Function HotPix_2D( source_wave )
	Wave source_wave
	
	Variable nPointsX, nPointsY, i, j ,k
	Variable help1, help2, help3, help4, help5, help6
	Duplicate /O source_wave, wave1
	Duplicate /O source_wave, wave2
	nPointsX = DimSize(source_wave,0)
	nPointsY = DimSize(source_wave,1)
	
	Diff_2D(wave1,0)
	Diff_2D(wave2,1)
	
	ImageHistogram  wave1
	WAVE W_ImageHist
	Duplicate/O W_ImageHist, hist1
	ImageHistogram  wave2
	Duplicate/O W_ImageHist, hist2
			
	Variable threshold1,threshold2 , n_pix , index0 , index1, index2 , val1, val2
	n_pix = numpnts(hist1)
	index0 = round(abs(DimOffset(hist1,0)/DimDelta(hist1,0)))
	for(i = index0;i<n_pix;i+=1)
		help1 = hist1[i]
		if(hist1[i]==0)
			break
		endif
	endfor
	index1= i
	val1 = DimOffset(hist1,0) + DimDelta(hist1,0)*index1
		
	n_pix = numpnts(hist2)			
	index0 = round(abs(DimOffset(hist2,0)/DimDelta(hist2,0)))
	for(i = index0;i<n_pix;i+=1)
		if(hist2[i]==0)
			break
		endif
	endfor
	index2= i
	val2 = DimOffset(hist2,0) + DimDelta(hist2,0)*index2
	
	nPointsX = DimSize(source_wave,0) -1
	nPointsY = DimSize(source_wave,1) 

	for(j = 0; j <nPointsY;j+=1)	// Initialize variables;continue test
		for(i=1;i<nPointsX;i+=1)
			help1 = wave1[i][j]
			help2 = wave1[i+1][j]
			help3 = wave1[i-1][j]
			help4 = source_wave[i-1][j]
			help5 = source_wave[i+1][j]
			help6 = source_wave[i][j]
			if(help1>val1 )
				if(help2<=val1)
					if(help3<=val1)
						if(help4<help5)
							source_wave[i][j] = help4
						else
							source_wave[i][j] = help5
						endif
					else
						source_wave[i][j] = help5
					endif
				else
					if(help3<=val1)
						source_wave[i][j] = help4
					else
							
					endif
				endif
			endif
		endfor	
	endfor
		
	nPointsX = DimSize(wave3,0) 
	nPointsY = DimSize(wave3,1) -1 
	
	for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
		for(j=1;j<nPointsY;j+=1)
			help1 = wave2[i][j]
			help2 = wave2[i][j+1]
			help3 = wave2[i][j-1]
			help4 = source_wave[i][j-1]
			help5 = source_wave[i][j+1]
			help6 = source_wave[i][j]
			if(help1>val2 )
				if(help2<=val2)
					if(help3<=val2)
						if(help4<help5)
							source_wave[i][j] = help4
						else
							source_wave[i][j] = help5
						endif
					else
						source_wave[i][j] = help5
					endif
				else
					if(help3<=val2)
						source_wave[i][j] = help4
					else
							
					endif	
				endif	
			endif
		endfor
	endfor
	Killwaves wave1,wave2
	Killwaves hist1, hist2, W_ImageHist
	return 0
End 

Function Background_2D( source_wave,fermi )
	Wave source_wave
	Variable fermi
	
	Variable i1,i2, i , j , k , nPointsX, nPointsY
	Variable V_min, help1, help2
	
	nPointsX = DimSize(source_wave,0) 
	nPointsY = DimSize(source_wave,1)
	i1 = round((fermi - DimOffset(source_wave,0) )/DimDelta(source_wave,0) + 1)
	i2 = DimSize(source_wave,0)
	V_min = source_wave[i1][0]
	for(j=0;j<nPointsY;j=j+1)
		//V_min = source_wave[i1][j]
		for(i=i1;i<i2;i=i+1)
			help1 = source_wave[i][j]
			if(help1 < V_min)
				V_min = help1
			endif		
		endfor
		//for(k=0;k<nPointsX;k=k+1)
		//	help1 = source_wave[k][j]
		//	if(help1 >= 0)
		//		help2 = help1 - V_min
		//		if(help2<0)
		//			source_wave[k][j] = 0
		//		else
		//			source_wave[k][j] = help2
		//		endif	
		//	endif
		//endfor
	endfor	
	for(j=0;j<nPointsY;j=j+1)
		for(i=0;i<nPointsX;i=i+1)
			source_wave[i][j] = source_wave[i][j] - V_min	
		endfor
	endfor	
	return 0
End 

Function Final_2D( row_nr, source_wave)
	Variable row_nr
	Wave source_wave
	
	WAVE/T ListWave = root:Load_and_Set_Panel:ListWave1
	Cut_SetEmission( row_nr , source_wave )
	Variable flag_str
	flag_str = str2num( ListWave[row_nr][18] )
	if(flag_str)
		Straight_2D( row_nr, source_wave )
	endif
	H_B_D( row_nr, source_wave )
	return 0
End 

Function Straight_2D( row_nr, source_wave)
	Variable row_nr
	Wave source_wave
	
	WAVE/T ListWave = root:Load_and_Set_Panel:ListWave1
	SetDataFolder root:Specs:$listWave[row_nr][1]
	WAVE nwave 
	
	Variable jmin
	Variable nPointsX , nPointsY ,i, j , k , help1, help3, help4
	nPointsX = DimSize(source_wave,0)
	nPointsY = DimSize(source_wave,1)
	
	Variable columns
	columns = DimSize(source_wave,1)
	Make/Free/N=(columns) wave_FE
	
	Variable centerP1, centerP2
	centerP1 = trunc(DimSize(nwave,0)/2)
	centerP2 = trunc(DimSIze(wave_FE,0)/2)
			
	if(centerP1 == centerP2)
		wave_FE[] = nwave[p]	
	endif
	if(centerP1>centerP2)
		wave_FE[] = nwave[centerP1-centerP2 + p] 
	endif
	if(centerP1<centerP2)
		wave_FE[centerP2-centerP1,centerP2+centerP1] = nwave[centerP1-centerP2+p]
		wave_FE[0,centerP2-centerP1-1] = nwave[0]
		wave_FE[centerP2+centerP1+1,inf] = nwave[DimSize(nwave,0)-1]
	endif	
	for(j=0;j<nPointsY;j=j+1)
		help1 = wave_FE[j]
		if(help1 != 0)
			help4 = nPointsX - 1
			for(i=help4;i>=help1;i=i-1)
				source_wave[i][j] = source_wave[i-help1][j]
			endfor
			help3 = source_wave[help1][j]
			for(i=help1-1;i>=0;i=i-1)
				source_wave[i][j] = help3
			endfor
		endif
	endfor
	
	return 0
End 

Function Defects_2D( source_wave )
	Wave source_wave
	
	Variable nPointsX , nPointsY ,i, j , k
	nPointsX = DimSize(source_wave,0)
	nPointsY = DimSize(source_wave,1)
	Variable centerP
	centerP =  floor(DimSize(source_wave,0)/2)
	Make/Free /N=(nPointsX) v1
	Make/Free /N=(nPointsX) v2
	Variable average1, average2 , multiplier
	v1=source_wave[p][centerP]
	average1 = Average_1D(v1)
	for(j=centerP+1;j<nPointsY;j=j+1)
		v2=source_wave[p][j]
		average2 = Average_1D(v2)
		multiplier = average1/average2
		Multiply1Line_2D( source_wave, j, multiplier )		
	endfor
	for(j=centerP-1;j>-1;j=j-1)
		v2=source_wave[p][j]
		average2 = Average_1D(v2)
		multiplier = average1/average2
		Multiply1Line_2D( source_wave, j, multiplier )		
	endfor
	return 0
End 

Function Average_1D( source_wave )
	Wave source_wave
	
	Variable nPointsX, i , average
	nPointsX = DimSize(source_wave,0)
	average = 0
	for(i=0;i<nPointsX;i+=1)
		average+=source_wave[i]			
	endfor
	average = average/nPointsX
	return average
End 

Function Multiply1Line_2D( source_wave,index,multiplier)
	Wave source_wave
	Variable index
	Variable multiplier
	
	Variable nPointsX, i
	nPointsX = DimSize(source_wave,0)
	for(i=0;i<nPointsX;i+=1)
		source_wave[i][index] = source_wave[i][index]*multiplier			
	endfor
	
	return 0
End 


Function H_B_D( row, source_wave )
	Variable row
	Wave source_wave
	
	WAVE/T ListWave 	= 	root:Load_and_Set_Panel:ListWave1
	WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
	
	SetDataFolder root:Specs:$listWave[row][1]
	
	Variable nPointsX , nPointsY ,i, j , k
	nPointsX = DimSize(source_wave,0)
	nPointsY = DimSize(source_wave,1)
	
	Variable flag_hotpix = str2num(listWave[row][16])
	Variable flag_back = str2num(listWave[row][17])
	Variable flag_straight = str2num(listWave[row][18])
	Variable flag_defects = str2num(listWave[row][19])
	WAVE nwave = nwave
	Variable fermi = str2num(listWave[row][13])
	
	Variable i1,i2 , V_min , help1 , help2
	Variable  help3,help4,help5
	
	if(flag_hotpix)
		HotPix_2D( source_wave )
	endif
	
	if(flag_back)
		Background_2D( source_wave,fermi )
	endif
	
	//if(flag_straight)
	//	Straight_2D( row,source_wave )
	//endif
	
	if(flag_defects)
		Defects_2D( source_wave ) 
	endif
	 
	return 0
End 

Function Cut_Frame_2D( row , name3 )
	Variable row
	String name3
	
	WAVE/T ListWave 	= 	root:Load_and_Set_Panel:ListWave1
	WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
	
	SetDataFolder root:Specs:$listWave[row][1]	
	WAVE wave1 = $listWave[row][1]
	WAVE/S wave2
	Variable emission , left, right , deltaA, deltaE , ES , lower , keithley
	Variable i
		
	emission = 0
	left = emission - ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	right = emission + ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	Duplicate/O/S/R= ( str2num( listWave[row][6] ), str2num( listWave[row][5] ) )( left, right ) wave1, wave2
	Make/O/S /N=( DimSize(wave2,0), DimSize(wave2,1) ) wave3
				
	emission = str2num ( listWave[row][2] )
	left = emission - ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	right = emission + ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	deltaA = DimDelta(wave2,1)
	ES = str2num ( listWave[row][9] )
	lower = ES + DimOffset( wave2,0 )
	deltaE = DimDelta(wave2,0)
	
	SetScale/P x, lower , deltaE, "Kinetic Energy [eV]" wave3
	SetScale/P y, left , deltaA, "Angle [deg]" wave3
	
	SetScale/P x, lower , deltaE, "Kinetic Energy [eV]" wave2
	SetScale/P y, left , deltaA, "Angle [deg]" wave2
	
	wave3 = wave2
	Killwaves wave2
	
	Variable nPointsX , nPointsY 
	nPointsX = DimSize(wave3,0)
	nPointsY = DimSize(wave3,1)
	
	Variable val1, val2 
			
	//val1 =  str2num( ListWave[row][7] ) 
	//val2 =  str2num( ListWave[row][8] ) 
	//nPointsX = DimSize(Angle_2D,0)
	//nPointsY = DimSize(Angle_2D,1)
	//Make/FREE /N=(nPointsX) v1 
	//Make/FREE /N=(nPointsY) v2 
	//if(val1 > 0 )
	//	for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
	//		v1 =  w0[p][i]
	//		Smooth val1 , v1
	//		w0[][i] = v1[p]
	//	endfor
	//endif
					
	//if(val2 > 0 )
	//	for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
	//		v2 =  w0[i][p]
	//		Smooth val2 , v2
	//		w0[i][] = v2[q]
	//	endfor
	//endif	
	
	keithley = str2num ( listWave[row][10] )
	wave3 = wave3/keithley
	if(WaveExists($name3)) 
		KillWaves $name3
	endif
	MoveWave wave3 , $name3	
	return 0 
End 

Function Cut_Frame_2D_b( row , name3 )
	Variable row
	String name3
	
	WAVE/T ListWave 	= 	root:Load_and_Set_Panel:ListWave1
	WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
	
	SetDataFolder root:Specs:$listWave[row][1]	
	WAVE wave1 = $listWave[row][1]
	WAVE/S wave2
	Variable emission , left, right , deltaA, deltaE , ES , lower , keithley
	Variable i
		
	emission = 0
	left = emission - ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	right = emission + ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	Duplicate/O/S/R= ( str2num( listWave[row][6] ), str2num( listWave[row][5] ) )( left, right ) wave1, wave2
	//Make/O/S /N=( DimSize(wave2,0), DimSize(wave2,1) ) wave3
				
	emission = str2num ( listWave[row][2] )
	left = emission - ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	right = emission + ( str2num( listWave[row][4] ) - DimDelta( wave1, 1 ) )/ 2
	deltaA = DimDelta(wave2,1)
	ES = str2num ( listWave[row][9] )
	lower = ES + DimOffset( wave2,0 )
	deltaE = DimDelta(wave2,0)
	
	//SetScale/P x, lower , deltaE, "Kinetic Energy [eV]" wave3
	//SetScale/P y, left , deltaA, "Angle [deg]" wave3
	
	SetScale/P x, lower , deltaE, "Kinetic Energy [eV]" wave2
	SetScale/P y, left , deltaA, "Angle [deg]" wave2
	
	Wave wave3 = $name3
	Duplicate/O wave2, wave3
	Killwaves wave2
	
	Variable nPointsX , nPointsY 
	nPointsX = DimSize(wave3,0)
	nPointsY = DimSize(wave3,1)
	
	Variable val1, val2 
			
	//val1 =  str2num( ListWave[row][7] ) 
	//val2 =  str2num( ListWave[row][8] ) 
	//nPointsX = DimSize(Angle_2D,0)
	//nPointsY = DimSize(Angle_2D,1)
	//Make/FREE /N=(nPointsX) v1 
	//Make/FREE /N=(nPointsY) v2 
	//if(val1 > 0 )
	//	for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
	//		v1 =  w0[p][i]
	//		Smooth val1 , v1
	//		w0[][i] = v1[p]
	//	endfor
	//endif
					
	//if(val2 > 0 )
	//	for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
	//		v2 =  w0[i][p]
	//		Smooth val2 , v2
	//		w0[i][] = v2[q]
	//	endfor
	//endif	
	
	keithley = str2num ( listWave[row][10] )
	wave3 = wave3/keithley
	
	return 0 
End 

Function Make_Corrections_2D( name3 )
	STRING name3
	
	String NameDataFolder
	NameDataFolder = GetWavesDataFolder(name3, 1 )
	SetDataFolder $NameDataFolder
	WAVE wave3 = $name3
	Duplicate /O wave3, wave1
	Duplicate /O wave3, wave2
	
	Variable nPointsX , nPointsY ,i, j , k
	nPointsX = DimSize(wave3,0)
	nPointsY = DimSize(wave3,1)
	
	NVAR flag_hotpix = flag_hotpix
	NVAR energy1 = energy1
	NVAR energy2 = energy2
	NVAR flag_back = flag_back
	NVAR flag_straight = flag_straight
	WAVE nwave = nwave
	Variable i1,i2 , V_min , help1 , help2
	Variable  help3,help4,help5
	
	if(flag_hotpix)
		nPointsX = DimSize(wave3,0)
		nPointsY = DimSize(wave3,1)
		Make/O/N =(nPointsX)  v1 
		Make/O/N =(nPointsY)  v2 
		for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
			v1 =  wave3[p][i]
			Smooth 1 , v1
			Differentiate v1
			Differentiate v1
			wave1[][i] = -v1[p]
		endfor
				
		for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
			v2 =  wave3[i][p]
			Smooth 1 , v2
			Differentiate v2
			Differentiate v2
			wave2[i][] = -v2[q]		
		endfor
		
		ImageHistogram  wave1
		WAVE W_ImageHist
		Duplicate/O W_ImageHist , hist1
		ImageHistogram  wave2
		Duplicate/O W_ImageHist , hist2
			
		Variable threshold1,threshold2 , n_pix , index0 , index1, index2 , val1, val2
		n_pix = numpnts(hist1)
		index0 = round(abs(DimOffset(hist1,0)/DimDelta(hist1,0)))
		for(i = index0;i<n_pix;i+=1)
			help1 = hist1[i]
			if(hist1[i]==0)
				break
			endif
		endfor
		index1= i
		val1 = DimOffset(hist1,0) + DimDelta(hist1,0)*index1
		
		n_pix = numpnts(hist2)			
		index0 = round(abs(DimOffset(hist2,0)/DimDelta(hist2,0)))
		for(i = index0;i<n_pix;i+=1)
			if(hist2[i]==0)
				break
			endif
		endfor
		index2= i
		val2 = DimOffset(hist2,0) + DimDelta(hist2,0)*index2
	
	
		nPointsX = DimSize(wave3,0) -1
		nPointsY = DimSize(wave3,1) 
		Make/O/N =(nPointsX)  v1 
		Make/O/N =(nPointsY)  v2 
		for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
			for(j=1;j<nPointsX;j+=1)
				help1 = wave1[j][i]
				help2 = wave1[j+1][i]
				help3 = wave1[j-1][i]
				help4 = wave3[j-1][i]
				help5 = wave3[j+1][i]
				if(help1>val1 )
					if(help2<=val1)
						if(help3<=val1)
							if(help4<help5)
								wave3[j][i] = wave3[j-1][i]
							else
								wave3[j][i] = wave3[j+1][i]
							endif
						else
							wave3[j][i] = wave3[j+1][i]
						endif
					else
						if(help3<=val1)
							wave3[j][i] = wave3[j-1][i]
						else
								
						endif
					
					endif
					
				endif
			endfor	
		endfor
		
		nPointsX = DimSize(wave3,0) 
		nPointsY = DimSize(wave3,1) -1 
		
		for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
			for(j=1;j<nPointsY;j+=1)
				help1 = wave3[i][j]
					help1 = wave2[i][j]
					help2 = wave2[i][j+1]
					help3 = wave2[i][j-1]
					help4 = wave3[i][j-1]
					help5 = wave3[i][j+1]
					if(help1>val2 )
						if(help2<=val2)
							if(help3<=val2)
								if(help4<help5)
									wave3[i][j] = wave3[i][j-1]
								else
									wave3[i][j] = wave3[i][j+1]
								endif
							else
								wave3[i][j] = wave3[i][j+1]
							endif
						else
							if(help3<=val2)
								wave3[i][j] = wave3[i][j-1]
							else
									
							endif	
						endif	
					endif
			endfor
		endfor
		KillWaves v1,v2
		Killwaves wave1,wave2
	endif
	
	nPointsX = DimSize(wave3,0)
	nPointsY = DimSize(wave3,1)
	
	if(flag_back)
		i1 = round((energy1 - DimOffset(wave3,0) )/DimDelta(wave3,0) + 1)
		i2 = round((energy2 - DimOffset(wave3,0) )/DimDelta(wave3,0) + 1)
		for(i=0;i<nPointsY;i=i+1)
			V_min = wave3[i1][i]
			for(j=i1;j<i2;j=j+1)
				help1 = wave3[j][i]
				if(help1 < V_min)
					V_min = help1
				endif		
			endfor
			for(k=0;k<nPointsX;k=k+1)
				help1 = wave3[k][i]
				if(help1 >= 0)
					help2 = help1 - V_min
					if(help2<0)
						wave3[k][i] = 0
					else
						wave3[k][i] = help2
					endif	
				endif
			endfor
		endfor	
	endif
	
	if(flag_straight)
		Variable jmin
		for(i=0;i<nPointsY;i=i+1)
			help1 = nwave[i]
			help4 = nPointsX - 1
			for(j=help4;j>=help1;j=j-1)
				wave3[j][i] = wave3[j-help1][i]
			endfor
			help3 = wave3[help1+1][i]
			for(j=help1-1;j>=0;j=j-1)
				wave3[j][i] = help3
			endfor
		endfor
	endif
	 
	//MoveWave wave3 , $name3	
	return 0
End 

Function ShiftAxis3Dz(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			
			Variable help1
			Variable help2
			Variable x0 , y0 , z0 , dx , dy, dz
			
			SetDataFolder root:Specs:
			WAVE Images3D
			WAVE Images3Dder
			WAVE ImageX
			WAVE ImageY
			
			ControlInfo /W=k_Space_2D ShiftX
			help1 = V_value
			
			ControlInfo /W=k_Space_2D ShiftY
			help2 = V_value
			
			x0 = DimOffset(Images3D,0)
			y0 = DimOffset(Images3D,1)
			z0 = DimOffset(Images3D,2)
			dx = DimDelta(Images3D,0)
			dy = DimDelta(Images3D,1)
			dz = DimDelta(Images3D,2)
			
			//SetScale /P x, x0 + help1, DimDelta(First,0) , "Energy" , Images3D
			SetScale /P y, y0 + help2, dy , "Angle" , Images3D
			SetScale /P z, z0 + help1, dz , "Angle" , Images3D
			
			SetScale /P x, y0,  dy , "Angle" , Image3
			SetScale /P y, z0, dz , "Angle" , Image3
			
			SetScale /P x, y0, dy , "Angle" , Image3der
			SetScale /P y, z0, dz , "Angle" , Image3der
			
			//SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , ImageX
			SetScale /P y, y0, dy , "Angle" , ImageX
			
			//SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , ImageY
			SetScale /P y, z0, dz , "Angle" , ImageY
			
			SetVariable ShiftX,value= _NUM:0
			SetVariable ShiftY,value= _NUM:0
		break
	endswitch

	return 0
End

Function ShiftAxis3D(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here

			Variable help1
			Variable help2
			Variable help3
			Variable help4
			
			Variable x0 , y0 , z0 , dx , dy, dz
			
			SetDataFolder root:folder3D:
			WAVE Images3D
			WAVE Images3Dder
			WAVE ImageX
			WAVE ImageY
			
			ControlInfo /W=k_Space_2D ShiftX
			help1 = V_value
			
			ControlInfo /W=k_Space_2D ShiftY
			help2 = V_value
			
			ControlInfo /W=k_Space_2D Position2
			help3 = V_value
			
			ControlInfo /W=k_Space_2D Position4
			help4 = V_value
			
			x0 = DimOffset(Images3D,0)
			y0 = DimOffset(Images3D,1)
			z0 = DimOffset(Images3D,2)
			dx = DimDelta(Images3D,0)
			dy = DimDelta(Images3D,1)
			dz = DimDelta(Images3D,2)
			
			//SetScale /P x, x0 + help1, DimDelta(First,0) , "Energy" , Images3D
			SetScale /P y, y0 + help2 - help4, dy , "Angle" , Images3D
			SetScale /P z, z0 + help1 - help3, dz , "Angle" , Images3D
			
			SetScale /P y, y0 + help2 - help4, dy , "Angle" , Images3Dder
			SetScale /P z, z0 + help1 - help3, dz , "Angle" , Images3Dder
			
			SetScale /P x, y0 + help2 - help4, dy , "Angle" , Image3
			SetScale /P y, z0 + help1 - help3, dz , "Angle" , Image3
			
			//SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , ImageX
			SetScale /P y, y0 + help2 - help4, dy, "Angle" , ImageX
			
			//SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , ImageY
			SetScale /P y, z0 + help1  - help3, dz , "Angle" , ImageY
			
			//SetVariable ShiftX,value= _NUM:0
			//SetVariable ShiftY,value= _NUM:0
			DoUpdate
			 
			ValDisplay Position2,value= _NUM:help1
			ValDisplay Position4,value= _NUM:help2
			
			GetAxis bottomImage3
			DoUpdate
			SetVariable SetBottomLeft,value= _NUM: V_min
			SetVariable SetBottomRight,value= _NUM:V_max
				
			GetAxis leftImage3
			DoUpdate 
			SetVariable SetLeftUpper,value= _NUM:V_max
			SetVariable SetLeftLower,value= _NUM:V_min
				
			GetAxis /W=Angle_Energy bottomImageX
			SetVariable SetHigher,value= _NUM:V_max
			SetVariable SetBottom,value= _NUM:V_min
					
			break
	endswitch

	return 0
End


Function ChangeKB(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			
			Setdatafolder root:folder3D:
			WAVE Images3D
			WAVE Image3
			WAVE LayerN_K
			WAVE ImageX
			WAVE ImageY
			WAVE M_ImageHistEq
			WAVE Multipliers
			WAVE CutX_K
			WAVE CutY_K
			WAVE CutX_K_B
			WAVE CutY_K_B
			WAVE ImageX
			WAVE ImageY
			WAVE ImageX_B
			WAVE ImageY_B
			WAVE Plane1
			WAVE Plane1_B
			
			Variable x0 
			Variable deltaE 
			Variable Energy
			Variable i
			String name1, name2, name3
			
			Variable help1
			ControlInfo /W=k_Space_2D check2
			help1 = V_value
			
			strswitch(cba.win)
				case "Angle_Energy":
					switch(checked)	// string switch
						case 0:		// execute if case matches expression
							name1 = ImageNameList("", "" )
							name2 = StringFromList (0, name1  , ";")
							name3 = StringFromList (1, name1  , ";")
							if(help1)
								RemoveImage /W=$"Angle_Energy" CutX_K_B
								RemoveImage /W=$"Angle_Energy" CutY_K_B
						
								AppendImage /L=leftImageX /B=bottomImageX CutX_K
								DoUpdate
								ModifyGraph  swapXY=1 ,lblPosMode= 2
								ModifyGraph freePos(leftImageX)={0.1,kwFraction}
								ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
								ModifyGraph axisEnab(bottomImageX)={0.1,1}
								ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
								AppendImage /L=leftImageY /B=bottomImageY CutY_K
								DoUpdate
								ModifyGraph  swapXY=1 ,lblPosMode= 2
								ModifyGraph freePos(leftImageY)={0.6,kwFraction}
								ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
								ModifyGraph axisEnab(leftImageY)={0.1,1}
								ModifyGraph axisEnab(bottomImageY)={0.6,1}	
							else
								RemoveImage /W=$"Angle_Energy" ImageX_B
								RemoveImage /W=$"Angle_Energy" ImageY_B
						
								AppendImage /L=leftImageX /B=bottomImageX ImageX
								DoUpdate
								ModifyGraph  swapXY=1 ,lblPosMode= 2
								ModifyGraph freePos(leftImageX)={0.1,kwFraction}
								ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
								ModifyGraph axisEnab(bottomImageX)={0.1,1}
								ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
								AppendImage /L=leftImageY /B=bottomImageY ImageY
								DoUpdate
								ModifyGraph  swapXY=1 ,lblPosMode= 2
								ModifyGraph freePos(leftImageY)={0.6,kwFraction}
								ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
								ModifyGraph axisEnab(leftImageY)={0.1,1}
								ModifyGraph axisEnab(bottomImageY)={0.6,1}	
							
							endif
							break						// exit from switch
						case 1:		// execute if case matches expression
							name1 = ImageNameList("", "" )
							name2 = StringFromList (0, name1  , ";")
							name3 = StringFromList (1, name1  , ";")
							if(help1)
								RemoveImage /W=$"Angle_Energy" CutX_K
								RemoveImage /W=$"Angle_Energy" CutY_K
						
								AppendImage /L=leftImageX /B=bottomImageX CutX_K_B
								DoUpdate
								ModifyGraph  swapXY=1 ,lblPosMode= 2
								ModifyGraph freePos(leftImageX)={0.1,kwFraction}
								ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
								ModifyGraph axisEnab(bottomImageX)={0.1,1}
								ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
								AppendImage /L=leftImageY /B=bottomImageY CutY_K_B
								DoUpdate
								ModifyGraph  swapXY=1 ,lblPosMode= 2
								ModifyGraph freePos(leftImageY)={0.6,kwFraction}
								ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
								ModifyGraph axisEnab(leftImageY)={0.1,1}
								ModifyGraph axisEnab(bottomImageY)={0.6,1}	
							else
								RemoveImage /W=$"Angle_Energy" ImageX
								RemoveImage /W=$"Angle_Energy" ImageY
						
								AppendImage /L=leftImageX /B=bottomImageX ImageX_B
								DoUpdate
								ModifyGraph  swapXY=1 ,lblPosMode= 2
								ModifyGraph freePos(leftImageX)={0.1,kwFraction}
								ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
								ModifyGraph axisEnab(bottomImageX)={0.1,1}
								ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
								AppendImage /L=leftImageY /B=bottomImageY ImageY_B
								DoUpdate
								ModifyGraph  swapXY=1 ,lblPosMode= 2
								ModifyGraph freePos(leftImageY)={0.6,kwFraction}
								ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
								ModifyGraph axisEnab(leftImageY)={0.1,1}
								ModifyGraph axisEnab(bottomImageY)={0.6,1}	
							
							endif
							break
						default:							// optional default expression executed
							break							// when no case matches
					endswitch
				break
				
				case "Arbitrary_Plane":
					switch(checked)	// string switch
						case 1:		// execute if case matches expression
							name1 = ImageNameList("", "" )
							name2 = StringFromList (0, name1  , ";")
							RemoveImage /W=$"Arbitrary_Plane" Plane1
							
							AppendImage /L=left /B=bottom Plane1_B
							ModifyGraph  swapXY=1
							ModifyGraph margin =40
							ModifyGraph margin(right) =20
							ModifyGraph margin(top) =20
							break						// exit from switch
						case 0:		// execute if case matches expression
							name1 = ImageNameList("", "" )
							name2 = StringFromList (0, name1  , ";")	
							RemoveImage /W=$"Arbitrary_Plane" Plane1_B
							
							AppendImage /L=left /B=bottom Plane1
							ModifyGraph  swapXY=1
							ModifyGraph margin =40
							ModifyGraph margin(right) =20
							ModifyGraph margin(top) =20
							break
						default:							// optional default expression executed
							break							// when no case matches
					endswitch	
				break
			
			endswitch
			break
	endswitch

	return 0
End

Function CheckProcToDer(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			
			Setdatafolder root:folder3D:
			if(checked)
				WAVE Images3D = Images3Dder
			else
				WAVE Images3D = Images3D
			endif
			
			WAVE Image3
			WAVE LayerN_K
			WAVE ImageX
			WAVE ImageY
			WAVE M_ImageHistEq
			WAVE Multipliers
			
			NVAR KineticFermi
			NVAR PhotonEnergy
			NVAR WorkFunction
			Variable KF = KineticFermi
			Variable PE = PhotonEnergy
			Variable WF = WorkFunction
			
			Variable x0 
			Variable deltaE 
			Variable Energy
			Variable i
					
			String name1
			name1 =  ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			
			Variable help1,help2,help3 , help5 , help6
			String help4
			ControlInfo /W=k_Space_2D check1
			help1 = V_value
			ControlInfo /W=k_Space_2D Param1
			help2 = V_value
			ControlInfo /W=k_Space_2D SetLayers
			help3 = V_value
			ControlInfo /W=k_Space_2D popup0
			help4 = S_value
			ControlInfo /W=Angle_Energy check1
			help5 = V_value
			ControlInfo /W=k_Space_2D check2
			help6 = V_value
			Variable positionY, positionZ
			
			switch(help6)	// string switch
				case 0:		// execute if case matches expression
			
					RemoveImage /W=$"k_Space_2D" $name1
					
					Variable number2
					number2 = DimSize (Images3D, 2)
			
					Image3[][] = Images3D[help3][p][q]
			
					for( i = 0 ; i < number2 ; i = i +1)
						Image3[][i] = 	Image3[p][i]*Multipliers[i]
					endfor
					Image3 = Image3^help2
					
					if(help1 == 1)
						ImageHistModification Image3
						Image3 = M_ImageHistEq	
					endif
					
					AppendImage /L=bottomImage3 /B=leftImage3 Image3
					ModifyGraph  swapXY=1 ,lblPosMode= 2
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					ModifyGraph mode=2,rgb=(0,0,0)
					ModifyGraph freePos(leftImage3)={0.1,kwFraction}
					ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
					ModifyGraph axisEnab(bottomImage3)={0.1,1}
					ModifyGraph axisEnab(leftImage3)={0.1,1}
					ModifyGraph margin(bottom)=20	
					ModifyGraph swapXY=1
					
					Wavestats/Q/Z Image3
					Slider contrastmin,limits={V_min,V_max,0},value=V_min
					Slider contrastmax,limits={V_min,V_max,0},value=V_max
					ModifyImage Image3, ctab= {V_min,V_max,$help4,0}
					
					if (strlen(csrinfo(A,""))!=0)
						positionY = vcsr(A,"")
						positionZ = hcsr(A,"")
					else
						positionY = DimOffset (Image3,0)
						positionZ = DimOffset (Image3,1)
					endif
					
					ImageX[][] = Images3D[p][q](positionZ)
					ImageY[][] = Images3D[p](positionY)[q]
					
					String name2,name3
					DoWindow/F $"Angle_Energy"			//pulls the window to the front
					if (V_Flag==1)	
						name1 = ImageNameList("", "" )
						name2 = StringFromList (0, name1  , ";")
						name3 = StringFromList (1, name1  , ";")
						
						RemoveImage /W=$"Angle_Energy" $name2
						RemoveImage /W=$"Angle_Energy" $name3
					
						if(help5)
							AppendImage /L=leftImageX /B=bottomImageX ImageX_B
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageX)={0.1,kwFraction}
							ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
							ModifyGraph axisEnab(bottomImageX)={0.1,1}
							ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
							AppendImage /L=leftImageY /B=bottomImageY ImageY_B
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageY)={0.6,kwFraction}
							ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
							ModifyGraph axisEnab(leftImageY)={0.1,1}
							ModifyGraph axisEnab(bottomImageY)={0.6,1}	
						else
							AppendImage /L=leftImageX /B=bottomImageX ImageX
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageX)={0.1,kwFraction}
							ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
							ModifyGraph axisEnab(bottomImageX)={0.1,1}
							ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
							AppendImage /L=leftImageY /B=bottomImageY ImageY
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageY)={0.6,kwFraction}
							ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
							ModifyGraph axisEnab(leftImageY)={0.1,1}
							ModifyGraph axisEnab(bottomImageY)={0.6,1}	
							
						endif
					endif
						
					DoWindow/F $"k_Space_2D"
					GetAxis /W=k_Space_2D bottomImage3
					SetVariable SetBottomLeft,value= _NUM: V_min
					SetVariable SetBottomRight,value= _NUM:V_max
				
					GetAxis /W=k_Space_2D leftImage3
					DoUpdate 
					SetVariable SetLeftUpper,value= _NUM:V_max
					SetVariable SetLeftLower,value= _NUM:V_min
				
					GetAxis /W=Angle_Energy bottomImageX
					SetVariable SetHigher,value= _NUM:V_max
					SetVariable SetBottom,value= _NUM:V_min
					
					Slider Line1, limits = { 0 , ( DimSize(Image3,1) - 1 ) , 1 } , value= positionY/DimDelta(Image3,1) 
					Slider Line2, limits = { 0 , ( DimSize(Image3,0) - 1 ) , 1 } , value= positionZ/DimDelta(Image3,0) 
					
					CheckBox check3,disable = 2
					break						// exit from switch
				case 1:		// execute if case matches expression
					
					Variable C2
					C2 = 180/Pi
					//Variable layers
					//layers = DimSize (Images3D, 0)
			
					Variable Xmin, Xmax, Ymin, Ymax, Zmin , Zmax
					Xmin = DimOffset(Images3D,1)
					Xmax = DimOffset(Images3D,1) + (Dimsize(Images3D,1)-1) *DimDelta(Images3D,1)
					Ymin = DimOffset(Images3D,2)
					Ymax = DimOffset(Images3D,2) + (Dimsize(Images3D,2)-1) *DimDelta(Images3D,2)
					Zmin = DimOffset(Images3D,0)
					Zmax = DimOffset(Images3D,0) + (Dimsize(Images3D,0)-1) *DimDelta(Images3D,0)
					
					Variable Xzero1
					if(Xmin>0)
						Xzero1 = Xmin
					else
						if(Xmax<0)
							Xzero1 = Xmax
						else
							Xzero1 = 0
						endif
					endif
					
					Variable Xzero2
					if(Xmin>=0)
						Xzero2 = Xmax
					else
						if(Xmax<0)
							Xzero2 = Xmin
						else
							if(Xmax>(-Xmin))
								Xzero2 = Xmax
							else
								Xzero2 = Xmin
							endif
						endif
					endif
					
					Variable kx1 , kx2 , ky1 , ky2
					kx1 = 0.512*sqrt(Zmax)*sin(Xmin*Pi/180)
					kx2 = 0.512*sqrt(Zmax)*sin(Xmax*Pi/180)
					if(Ymax >=0 )
						ky2 = 0.512*sqrt(Zmax)*sin(Ymax*Pi/180)*cos(Xzero1*Pi/180)
					else
						ky2 = 0.512*sqrt(Zmin)*sin(Ymax*Pi/180)*cos(Xzero2*Pi/180)
					endif
					
					if(Ymin >=0 )
						ky1 = 0.512*sqrt(Zmin)*sin(Ymin*Pi/180)*cos(Xzero1*Pi/180)
					else
						ky1 = 0.512*sqrt(Zmax)*sin(Ymin*Pi/180)*cos(Xzero2*Pi/180)
					endif					
					
					Variable ResolutionX, ResolutionY 
					ResolutionX = Dimsize(Images3D,2) * 4
					ResolutionY = Dimsize(Images3D,1)
					//if( Dimsize(Images3D,2) > Resolution )
					//	Resolution = Dimsize(Images3D,2)
					//endif
			
					//PE = PhotonEnergy
					//WF = WorkFunction
					//Prompt PE, "Photon Energy in eV"
					//Prompt WF, "Work Function in eV"
					Prompt ResolutionX, "Number of pixels along X axis"
					Prompt ResolutionY, "Number of pixels along Y axis"			
					DoPrompt "SET THE PARAMETERS",ResolutionX,ResolutionY
			
					//Variable YL=SelectNumber(sign(Xmin)==+1,Ymax,Ymin)
					//Variable YR=SelectNumber(sign(Xmax)==+1,Ymin,Ymax)
			
					Make/O/N=(ResolutionY, ResolutionX) LayerN_K
					Make/O/N=(Dimsize(Images3D,0), ResolutionY) CutX_K
					Make/O/N=(Dimsize(Images3D,0), ResolutionX) CutY_K
				
					Setscale/I x,kx1,kx2,"" LayerN_K
					Setscale/I y,ky1,ky2,"" LayerN_K
			
					//Setscale/I x,kx1,kx2,"k\B||\M [Å]" LayerN_Kder
					//Setscale/I y,ky1,ky2,"k\B||\M [Å]" LayerN_Kder
			
					SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , CutX_K
					SetScale /I y, kx1, kx2 , "" , CutX_K
			
					SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , CutY_K
					SetScale /I y, ky1, ky2 , "" , CutY_K
			
					Variable  energy1
					energy1 =  DimOffset(Images3D,0) + DimDelta(Images3D,0) * help3  
					
					ControlInfo /W=k_Space_2D Position1
					help1 = V_value
			
					//ControlInfo /W=k_Space_2D Position3
					//help2 = V_value
					
					//LayerN_K = 0
					//LayerN_K =  Images3D(energy1)( asin(x/C1)*C2 )( asin( y/(  C1 *cos( asin(x/C1) ) ) )*C2 )
					Variable x1,y1, x2, x2p , y2
					//LayerN_K = 0
					//LayerN_K = ( ( asin(x/C1)*C2 > Xmax ||  asin(x/C1)*C2 < Xmin ) || (asin(y/(C1*cos(asin(x/C1))))*C2) >Ymax || (asin(y/(C1*cos(asin(x/C1))))*C2) <Ymin ) ?Nan : Images3D(energy1)( asin(x/C1)*C2 )( asin( y/(  C1 *cos( asin(x/C1) ) ) )*C2 )
					RemoveImage /W=$"k_Space_2D" $name1 
					
					Variable C1
					Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
					Variable delta_k_n , delta_k_m , delta_phi , delta_theta
					Variable k_n0 , k_m0 , phi0 , theta0
					Variable phi1 , phi2 , theta1 , theta2
					Variable i_n , j_m 
					Variable n_max , m_max
					Variable i_max , j_max
					Variable i_1 , i_2 , j_1 , j_2
					Variable wL , wR , wU , wD 
					
					Variable energy2
					energy2 = PE-WF+ energy1 - KF
					C1 = 1/(0.512*sqrt(energy2))
					C2 = 180/Pi
					
					n_max = DimSize (LayerN_K,0)
					m_max = DimSize (LayerN_K,1)
					
					k_n0 = DimOffset (LayerN_K,0)
					k_m0 = DimOffset (LayerN_K,1)
					
					delta_k_n = DimDelta (LayerN_K,0)
					delta_k_m = DimDelta (LayerN_K,1)
					
					i_max = DimSize (Images3D,1) - 1
					j_max = DimSize (Images3D,2) - 1
					
					phi0 = DimOffset (Images3D,1)
					theta0 = DimOffset (Images3D,2)
					
					delta_phi = DimDelta (Images3D,1)
					delta_theta = DimDelta (Images3D,2)

					k_n = k_n0
					k_m = k_m0
				
					for( n=0;n<n_max;n=n+1)
						phi_n_rad = asin( k_n * C1 )
						phi_n = phi_n_rad * C2
						i_n = (phi_n - phi0)/delta_phi
						if(i_n>=0 && i_n<=i_max)
							for( m=0;m<m_max;m=m+1)
								theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
								j_m = (theta_m - theta0)/delta_theta
								if(j_m>=0 && j_m<=j_max)	
									i_1 = floor(i_n)
									i_2 = ceil(i_n)
									j_1 = floor(j_m)
									j_2 = ceil(j_m)
									wR = i_n - i_1
									wL = 1 - wR
									wU = j_m - j_1
									wD = 1 - wU
									LayerN_K[n][m] = Images3D(energy1)[i_1][j_1]*wL*wD + Images3D(energy1)[i_2][j_1]*wR*wD + Images3D(energy1)[i_1][j_2]*wL*wU + Images3D(energy1)[i_2][j_2]*wR*wU
								else
									LayerN_K[n][m] = Nan
								endif
								k_m = k_m + delta_k_m
							endfor
						else
							LayerN_K[n][] = Nan
						endif
						k_m = k_m0
						k_n = k_n + delta_k_n
					endfor
					
					if( help2 != 1)
						LayerN_K = LayerN_K^help2
					endif
					
					AppendImage /L=bottomImage3 /B=leftImage3 LayerN_K
					ModifyGraph  swapXY=1 ,lblPosMode= 2
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					ModifyGraph mode=2,rgb=(0,0,0)
					ModifyGraph freePos(leftImage3)={0.1,kwFraction}
					ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
					ModifyGraph axisEnab(bottomImage3)={0.1,1}
					ModifyGraph axisEnab(leftImage3)={0.1,1}
					ModifyGraph margin(bottom)=20	
					ModifyGraph swapXY=1
					
					Wavestats/Q/Z LayerN_K
					Slider contrastmin,limits={V_min,V_max,0},value=V_min
					Slider contrastmax,limits={V_min,V_max,0},value=V_max
					ModifyImage LayerN_K, ctab= {V_min,V_max,$help4,0}
					
					if (strlen(csrinfo(A,""))!=0)
						positionY = vcsr(A,"")
						positionZ = hcsr(A,"")
					else
						positionY = DimOffset (Images3D,2)
						positionZ = DimOffset (Images3D,1)
					endif
					
					CutX_K = Images3D(x)( asin(y/(0.512*sqrt(x)))*C2 )( asin( positionY/( 0.512*sqrt(x) *cos(asin(y/(0.512*sqrt(x))))))*C2 )
					CutY_K = Images3D(x)( asin(positionZ/(0.512*sqrt(x)))*C2 )( asin( y/( 0.512*sqrt(x) *cos(asin(positionZ/(0.512*sqrt(x))))))*C2 )
					
					Duplicate/O CutX_K , CutX_K_B
					Duplicate/O CutY_K , CutY_K_B
					SetScale /P x, (DimOffset( Images3D,0 )-KineticFermi), DimDelta(Images3D,0) , "" , CutX_K_B
					SetScale /P x, (DimOffset( Images3D,0 )-KineticFermi), DimDelta(Images3D,0) , "" , CutY_K_B
					
					DoWindow/F $"Angle_Energy"			//pulls the window to the front
					if (V_Flag==1)	
						
						name1 = ImageNameList("", "" )
						name2 = StringFromList (0, name1  , ";")
						name3 = StringFromList (1, name1  , ";")
						
						RemoveImage /W=$"Angle_Energy" $name2
						RemoveImage /W=$"Angle_Energy" $name3
					
						if(help5)
							AppendImage /L=leftImageX /B=bottomImageX CutX_K_B
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageX)={0.1,kwFraction}
							ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
							ModifyGraph axisEnab(bottomImageX)={0.1,1}
							ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
							AppendImage /L=leftImageY /B=bottomImageY CutY_K_B
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageY)={0.6,kwFraction}
							ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
							ModifyGraph axisEnab(leftImageY)={0.1,1}
							ModifyGraph axisEnab(bottomImageY)={0.6,1}	
						else
						
							AppendImage /L=leftImageX /B=bottomImageX CutX_K
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageX)={0.1,kwFraction}
							ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
							ModifyGraph axisEnab(bottomImageX)={0.1,1}
							ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
							AppendImage /L=leftImageY /B=bottomImageY CutY_K
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageY)={0.6,kwFraction}
							ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
							ModifyGraph axisEnab(leftImageY)={0.1,1}
							ModifyGraph axisEnab(bottomImageY)={0.6,1}	
							
						endif
					endif
					
					DoWindow/F $"k_Space_2D"	
					GetAxis /W=k_Space_2D bottomImage3
					GetAxis bottomImage3
					SetVariable SetBottomLeft,value= _NUM: V_min
					SetVariable SetBottomRight,value= _NUM:V_max
				
					GetAxis /W=k_Space_2D leftImage3
					DoUpdate 
					SetVariable SetLeftUpper,value= _NUM:V_max
					SetVariable SetLeftLower,value= _NUM:V_min
				
					GetAxis /W=Angle_Energy bottomImageX
					SetVariable SetHigher,value= _NUM:V_max
					SetVariable SetBottom,value= _NUM:V_min
					
					Slider Line1, limits = { 0 , ( DimSize(LayerN_K,1) - 1 ) , 1 } , value= asin(positionZ/sqrt( (0.512)^2*energy1-(positionY)^2))*180/Pi / DimDelta(LayerN_K,1) 
					Slider Line2, limits = { 0 , ( DimSize(LayerN_K,0) - 1 ) , 1 } , value= asin(positionY/(0.512*sqrt(energy1)))*180/Pi / DimDelta(LayerN_K,0) 
					
					CheckBox check3, disable = 0
					break
				default:							// optional default expression executed
											// when no case matches
			endswitch
			
			break
	endswitch

	return 0
End

Function CheckProcToKpar(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			
			Setdatafolder root:folder3D:
			Variable help6
			ControlInfo /W=k_Space_2D check5
			help6 = V_value
			if(help6)
				WAVE Images3D = Images3Dder
			else
				WAVE Images3D = Images3D
			endif
					
			//WAVE Images3D
			WAVE Image3
			WAVE LayerN_K
			WAVE ImageX
			WAVE ImageY
			WAVE M_ImageHistEq
			WAVE Multipliers
			
			NVAR KineticFermi
			NVAR PhotonEnergy
			NVAR WorkFunction
			Variable KF = KineticFermi
			Variable PE = PhotonEnergy
			Variable WF = WorkFunction
			
			Variable x0 
			Variable deltaE 
			Variable Energy
			Variable i
					
			String name1
			name1 =  ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			
			Variable help1,help2,help3 , help5
			String help4
			ControlInfo /W=k_Space_2D check1
			help1 = V_value
			ControlInfo /W=k_Space_2D Param1
			help2 = V_value
			ControlInfo /W=k_Space_2D SetLayers
			help3 = V_value
			ControlInfo /W=k_Space_2D popup0
			help4 = S_value
			ControlInfo /W=Angle_Energy check1
			help5 = V_value
			
			Variable positionY, positionZ
			
			switch(checked)	// string switch
				case 0:		// execute if case matches expression
			
					RemoveImage /W=$"k_Space_2D" $name1
					
					Variable number2
					number2 = DimSize (Images3D, 2)
			
					Image3[][] = Images3D[help3][p][q]
			
					for( i = 0 ; i < number2 ; i = i +1)
						Image3[][i] = 	Image3[p][i]*Multipliers[i]
					endfor
					Image3 = Image3^help2
					
					if(help1 == 1)
						ImageHistModification Image3
						Image3 = M_ImageHistEq	
					endif
					
					AppendImage /L=bottomImage3 /B=leftImage3 Image3
					ModifyGraph  swapXY=1 ,lblPosMode= 2
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					ModifyGraph mode=2,rgb=(0,0,0)
					ModifyGraph freePos(leftImage3)={0.1,kwFraction}
					ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
					ModifyGraph axisEnab(bottomImage3)={0.1,1}
					ModifyGraph axisEnab(leftImage3)={0.1,1}
					ModifyGraph margin(bottom)=20	
					ModifyGraph swapXY=1
					
					Wavestats/Q/Z Image3
					Slider contrastmin,limits={V_min,V_max,0},value=V_min
					Slider contrastmax,limits={V_min,V_max,0},value=V_max
					ModifyImage Image3, ctab= {V_min,V_max,$help4,0}
					
					if (strlen(csrinfo(A,""))!=0)
						positionY = vcsr(A,"")
						positionZ = hcsr(A,"")
					else
						positionY = DimOffset (Image3,0)
						positionZ = DimOffset (Image3,1)
					endif
					
					ImageX[][] = Images3D[p][q](positionZ)
					ImageY[][] = Images3D[p](positionY)[q]
					
					String name2,name3
					DoWindow/F $"Angle_Energy"			//pulls the window to the front
					if (V_Flag==1)	
						name1 = ImageNameList("", "" )
						name2 = StringFromList (0, name1  , ";")
						name3 = StringFromList (1, name1  , ";")
						
						RemoveImage /W=$"Angle_Energy" $name2
						RemoveImage /W=$"Angle_Energy" $name3
					
						if(help5)
							AppendImage /L=leftImageX /B=bottomImageX ImageX_B
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageX)={0.1,kwFraction}
							ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
							ModifyGraph axisEnab(bottomImageX)={0.1,1}
							ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
							AppendImage /L=leftImageY /B=bottomImageY ImageY_B
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageY)={0.6,kwFraction}
							ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
							ModifyGraph axisEnab(leftImageY)={0.1,1}
							ModifyGraph axisEnab(bottomImageY)={0.6,1}	
						else
							AppendImage /L=leftImageX /B=bottomImageX ImageX
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageX)={0.1,kwFraction}
							ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
							ModifyGraph axisEnab(bottomImageX)={0.1,1}
							ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
							AppendImage /L=leftImageY /B=bottomImageY ImageY
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageY)={0.6,kwFraction}
							ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
							ModifyGraph axisEnab(leftImageY)={0.1,1}
							ModifyGraph axisEnab(bottomImageY)={0.6,1}	
							
						endif
					endif
						
					DoWindow/F $"k_Space_2D"
					GetAxis /W=k_Space_2D bottomImage3
					SetVariable SetBottomLeft,value= _NUM: V_min
					SetVariable SetBottomRight,value= _NUM:V_max
				
					GetAxis /W=k_Space_2D leftImage3
					DoUpdate 
					SetVariable SetLeftUpper,value= _NUM:V_max
					SetVariable SetLeftLower,value= _NUM:V_min
				
					GetAxis /W=Angle_Energy bottomImageX
					SetVariable SetHigher,value= _NUM:V_max
					SetVariable SetBottom,value= _NUM:V_min
					
					Slider Line1, limits = { 0 , ( DimSize(Image3,1) - 1 ) , 1 } , value= positionY/DimDelta(Image3,1) 
					Slider Line2, limits = { 0 , ( DimSize(Image3,0) - 1 ) , 1 } , value= positionZ/DimDelta(Image3,0) 
					
					CheckBox check3,disable = 2
					Button Double,disable = 0
			
					SetVariable Multiplier,disable = 0
					Button Reset1,disable = 0
					Button Accept1,disable = 0
					Button SetOffset,disable = 0
					Button Button_MakeMovie,disable = 2
					Button Button_Average,disable = 2
					Button Equalize,disable = 0
					Button Equalize2,disable = 0
					SetVariable rotation,disable=2,value= _NUM:0
					break						// exit from switch
				case 1:		// execute if case matches expression
					
					Variable C2
					C2 = 180/Pi
					//Variable layers
					//layers = DimSize (Images3D, 0)
			
					Variable Xmin, Xmax, Ymin, Ymax, Zmin , Zmax
					Xmin = DimOffset(Images3D,1)
					Xmax = DimOffset(Images3D,1) + (Dimsize(Images3D,1)-1) *DimDelta(Images3D,1)
					Ymin = DimOffset(Images3D,2)
					Ymax = DimOffset(Images3D,2) + (Dimsize(Images3D,2)-1) *DimDelta(Images3D,2)
					Zmin = DimOffset(Images3D,0)
					Zmax = DimOffset(Images3D,0) + (Dimsize(Images3D,0)-1) *DimDelta(Images3D,0)
					
					Variable Xzero1
					if(Xmin>0)
						Xzero1 = Xmin
					else
						if(Xmax<0)
							Xzero1 = Xmax
						else
							Xzero1 = 0
						endif
					endif
					
					Variable Xzero2
					if(Xmin>=0)
						Xzero2 = Xmax
					else
						if(Xmax<0)
							Xzero2 = Xmin
						else
							if(Xmax>(-Xmin))
								Xzero2 = Xmax
							else
								Xzero2 = Xmin
							endif
						endif
					endif
					
					Variable kx1 , kx2 , ky1 , ky2
					kx1 = 0.512*sqrt(Zmax)*sin(Xmin*Pi/180)
					kx2 = 0.512*sqrt(Zmax)*sin(Xmax*Pi/180)
					if(Ymax >=0 )
						ky2 = 0.512*sqrt(Zmax)*sin(Ymax*Pi/180)*cos(Xzero1*Pi/180)
					else
						ky2 = 0.512*sqrt(Zmin)*sin(Ymax*Pi/180)*cos(Xzero2*Pi/180)
					endif
					
					if(Ymin >=0 )
						ky1 = 0.512*sqrt(Zmin)*sin(Ymin*Pi/180)*cos(Xzero1*Pi/180)
					else
						ky1 = 0.512*sqrt(Zmax)*sin(Ymin*Pi/180)*cos(Xzero2*Pi/180)
					endif					
					
					Variable ResolutionX, ResolutionY 
					ResolutionX = Dimsize(Images3D,2) * 4
					ResolutionY = Dimsize(Images3D,1)
					//if( Dimsize(Images3D,2) > Resolution )
					//	Resolution = Dimsize(Images3D,2)
					//endif
			
					//PE = PhotonEnergy
					//WF = WorkFunction
					//Prompt PE, "Photon Energy in eV"
					//Prompt WF, "Work Function in eV"
					Prompt ResolutionX, "Number of pixels along X axis"
					Prompt ResolutionY, "Number of pixels along Y axis"			
					DoPrompt "SET THE PARAMETERS",ResolutionX,ResolutionY
			
					//Variable YL=SelectNumber(sign(Xmin)==+1,Ymax,Ymin)
					//Variable YR=SelectNumber(sign(Xmax)==+1,Ymin,Ymax)
			
					Make/O/N=(ResolutionY, ResolutionX) LayerN_K
					Make/O/N=(Dimsize(Images3D,0), ResolutionY) CutX_K
					Make/O/N=(Dimsize(Images3D,0), ResolutionX) CutY_K
				
					Setscale/I x,kx1,kx2,"" LayerN_K
					Setscale/I y,ky1,ky2,"" LayerN_K
			
					//Setscale/I x,kx1,kx2,"k\B||\M [Å]" LayerN_Kder
					//Setscale/I y,ky1,ky2,"k\B||\M [Å]" LayerN_Kder
			
					SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , CutX_K
					SetScale /I y, kx1, kx2 , "" , CutX_K
			
					SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , CutY_K
					SetScale /I y, ky1, ky2 , "" , CutY_K
			
					Variable  energy1
					energy1 =  DimOffset(Images3D,0) + DimDelta(Images3D,0) * help3  
					
					ControlInfo /W=k_Space_2D Position1
					help1 = V_value
			
					//ControlInfo /W=k_Space_2D Position3
					//help2 = V_value
					
					//LayerN_K = 0
					//LayerN_K =  Images3D(energy1)( asin(x/C1)*C2 )( asin( y/(  C1 *cos( asin(x/C1) ) ) )*C2 )
					Variable x1,y1, x2, x2p , y2
					//LayerN_K = 0
					//LayerN_K = ( ( asin(x/C1)*C2 > Xmax ||  asin(x/C1)*C2 < Xmin ) || (asin(y/(C1*cos(asin(x/C1))))*C2) >Ymax || (asin(y/(C1*cos(asin(x/C1))))*C2) <Ymin ) ?Nan : Images3D(energy1)( asin(x/C1)*C2 )( asin( y/(  C1 *cos( asin(x/C1) ) ) )*C2 )
					RemoveImage /W=$"k_Space_2D" $name1 
					
					Variable C1
					Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
					Variable delta_k_n , delta_k_m , delta_phi , delta_theta
					Variable k_n0 , k_m0 , phi0 , theta0
					Variable phi1 , phi2 , theta1 , theta2
					Variable i_n , j_m 
					Variable n_max , m_max
					Variable i_max , j_max
					Variable i_1 , i_2 , j_1 , j_2
					Variable wL , wR , wU , wD 
					
					Variable energy2
					energy2 = PE-WF+ energy1 - KF
					C1 = 1/(0.512*sqrt(energy2))
					C2 = 180/Pi
					
					n_max = DimSize (LayerN_K,0)
					m_max = DimSize (LayerN_K,1)
					
					k_n0 = DimOffset (LayerN_K,0)
					k_m0 = DimOffset (LayerN_K,1)
					
					delta_k_n = DimDelta (LayerN_K,0)
					delta_k_m = DimDelta (LayerN_K,1)
					
					i_max = DimSize (Images3D,1) - 1
					j_max = DimSize (Images3D,2) - 1
					
					phi0 = DimOffset (Images3D,1)
					theta0 = DimOffset (Images3D,2)
					
					delta_phi = DimDelta (Images3D,1)
					delta_theta = DimDelta (Images3D,2)

					k_n = k_n0
					k_m = k_m0
				
					for( n=0;n<n_max;n=n+1)
						phi_n_rad = asin( k_n * C1 )
						phi_n = phi_n_rad * C2
						i_n = (phi_n - phi0)/delta_phi
						if(i_n>=0 && i_n<=i_max)
							for( m=0;m<m_max;m=m+1)
								theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
								j_m = (theta_m - theta0)/delta_theta
								if(j_m>=0 && j_m<=j_max)	
									i_1 = floor(i_n)
									i_2 = ceil(i_n)
									j_1 = floor(j_m)
									j_2 = ceil(j_m)
									wR = i_n - i_1
									wL = 1 - wR
									wU = j_m - j_1
									wD = 1 - wU
									LayerN_K[n][m] = Images3D(energy1)[i_1][j_1]*wL*wD + Images3D(energy1)[i_2][j_1]*wR*wD + Images3D(energy1)[i_1][j_2]*wL*wU + Images3D(energy1)[i_2][j_2]*wR*wU
								else
									LayerN_K[n][m] = Nan
								endif
								k_m = k_m + delta_k_m
							endfor
						else
							LayerN_K[n][] = Nan
						endif
						k_m = k_m0
						k_n = k_n + delta_k_n
					endfor
					
					if( help2 != 1)
						LayerN_K = LayerN_K^help2
					endif
					DoUpdate
					AppendImage /L=bottomImage3 /B=leftImage3 LayerN_K
					ModifyGraph  swapXY=1 ,lblPosMode= 2
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =10
					ModifyGraph mode=2,rgb=(0,0,0)
					ModifyGraph freePos(leftImage3)={0.1,kwFraction}
					ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
					ModifyGraph axisEnab(bottomImage3)={0.1,1}
					ModifyGraph axisEnab(leftImage3)={0.1,1}
					ModifyGraph margin(bottom)=20	
					ModifyGraph swapXY=1
					
					Wavestats/Q/Z LayerN_K
					Slider contrastmin,limits={V_min,V_max,0},value=V_min
					Slider contrastmax,limits={V_min,V_max,0},value=V_max
					ModifyImage LayerN_K, ctab= {V_min,V_max,$help4,0}
					
					if (strlen(csrinfo(A,""))!=0)
						positionY = vcsr(A,"")
						positionZ = hcsr(A,"")
					else
						positionY = DimOffset (Images3D,2)
						positionZ = DimOffset (Images3D,1)
					endif
					
					CutX_K = Images3D(x)( asin(y/(0.512*sqrt(x)))*C2 )( asin( positionY/( 0.512*sqrt(x) *cos(asin(y/(0.512*sqrt(x))))))*C2 )
					CutY_K = Images3D(x)( asin(positionZ/(0.512*sqrt(x)))*C2 )( asin( y/( 0.512*sqrt(x) *cos(asin(positionZ/(0.512*sqrt(x))))))*C2 )
					
					Duplicate/O CutX_K , CutX_K_B
					Duplicate/O CutY_K , CutY_K_B
					SetScale /P x, (DimOffset( Images3D,0 )-KineticFermi), DimDelta(Images3D,0) , "" , CutX_K_B
					SetScale /P x, (DimOffset( Images3D,0 )-KineticFermi), DimDelta(Images3D,0) , "" , CutY_K_B
					
					DoWindow/F $"Angle_Energy"			//pulls the window to the front
					if (V_Flag==1)	
						
						name1 = ImageNameList("", "" )
						name2 = StringFromList (0, name1  , ";")
						name3 = StringFromList (1, name1  , ";")
						
						RemoveImage /W=$"Angle_Energy" $name2
						RemoveImage /W=$"Angle_Energy" $name3
					
						if(help5)
							AppendImage /L=leftImageX /B=bottomImageX CutX_K_B
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageX)={0.1,kwFraction}
							ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
							ModifyGraph axisEnab(bottomImageX)={0.1,1}
							ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
							AppendImage /L=leftImageY /B=bottomImageY CutY_K_B
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageY)={0.6,kwFraction}
							ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
							ModifyGraph axisEnab(leftImageY)={0.1,1}
							ModifyGraph axisEnab(bottomImageY)={0.6,1}	
						else
						
							AppendImage /L=leftImageX /B=bottomImageX CutX_K
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageX)={0.1,kwFraction}
							ModifyGraph freePos(bottomImageX)={0.1,kwFraction}
							ModifyGraph axisEnab(bottomImageX)={0.1,1}
							ModifyGraph axisEnab(leftImageX)={0.1,0.50}
						
							AppendImage /L=leftImageY /B=bottomImageY CutY_K
							DoUpdate
							ModifyGraph  swapXY=1 ,lblPosMode= 2
							ModifyGraph freePos(leftImageY)={0.6,kwFraction}
							ModifyGraph freePos(bottomImageY)={0.1,kwFraction}
							ModifyGraph axisEnab(leftImageY)={0.1,1}
							ModifyGraph axisEnab(bottomImageY)={0.6,1}	
							
						endif
					endif
					
					DoWindow/F $"k_Space_2D"	
					GetAxis /W=k_Space_2D bottomImage3
					GetAxis bottomImage3
					SetVariable SetBottomLeft,value= _NUM: V_min
					SetVariable SetBottomRight,value= _NUM:V_max
				
					GetAxis /W=k_Space_2D leftImage3
					DoUpdate 
					SetVariable SetLeftUpper,value= _NUM:V_max
					SetVariable SetLeftLower,value= _NUM:V_min
				
					GetAxis /W=Angle_Energy bottomImageX
					SetVariable SetHigher,value= _NUM:V_max
					SetVariable SetBottom,value= _NUM:V_min
					
					Slider Line1, limits = { 0 , ( DimSize(LayerN_K,1) - 1 ) , 1 } , value= asin(positionZ/sqrt( (0.512)^2*energy1-(positionY)^2))*180/Pi / DimDelta(LayerN_K,1) 
					Slider Line2, limits = { 0 , ( DimSize(LayerN_K,0) - 1 ) , 1 } , value= asin(positionY/(0.512*sqrt(energy1)))*180/Pi / DimDelta(LayerN_K,0) 
					
					CheckBox check3, disable = 0
					Button Double,disable = 2
					SetVariable Multiplier,disable = 2
					Button Reset1,disable = 2
					Button Accept1,disable = 2
					Button SetOffset,disable = 2
					Button Button_MakeMovie,disable = 0
					Button Equalize,disable = 2
					Button Equalize2,disable = 2
					Button Button_Average,disable = 0
					SetVariable rotation,disable=0
					
					//Duplicate LayerN_K,LayerN_K1
					//Duplicate CutX_K,CutX_K1
					//Duplicate CutY_K,CutY_K1
					
					break
				default:							// optional default expression executed
											// when no case matches
			endswitch
			
			break
	endswitch

	return 0
End

Function toKpar(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			SetDataFolder root:Specs:
			WAVE Images3D
			WAVE Images3Dder
			WAVE ImageX
			WAVE ImageY
			WAVE LayerN_A
			WAVE LayerN_Ader
			WAVE LayerN_K
			WAVE LayerN_Kder
			WAVE Images3Dk
			WAVE Images3Dder
			WAVE Image3
			
			//Duplicate/O Image3 , LayerN_A 
			//Duplicate/O Image3 , LayerN_Ader 
			
			STRING name1, name2
			
			Setdatafolder root:Specs:
			WAVE Images3D
			name2 =  ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			
			Variable i , layers
			layers = DimSize (Images3D, 0)
			
			Variable Xmin, Xmax, Ymin, Ymax, Zmin , Zmax
			Xmin = DimOffset(Images3D,1)
			Xmax = DimOffset(Images3D,1) + (Dimsize(Images3D,1)-1) *DimDelta(Images3D,1)
			Ymin = DimOffset(Images3D,2)
			Ymax = DimOffset(Images3D,2) + (Dimsize(Images3D,2)-1) *DimDelta(Images3D,2)
			Zmin = DimOffset(Images3D,0)
			Zmax = DimOffset(Images3D,0) + (Dimsize(Images3D,0)-1) *DimDelta(Images3D,0)
			
			Variable kx1 , kx2 , ky1 , ky2
			kx1 = 0.512*sqrt(Zmax)*sin(Ymin*Pi/180)
			kx2 = 0.512*sqrt(Zmax)*sin(Ymax*Pi/180)
			ky1 = 0.512*sqrt(Zmax)*sin(Xmin*Pi/180)
			ky2 = 0.512*sqrt(Zmax)*sin(Xmax*Pi/180)
			
			Variable PE, WF , Resolution 
			Resolution = Dimsize(Images3D,1)
			if( Dimsize(Images3D,2) > Resolution )
				Resolution = Dimsize(Images3D,2)
			endif
			
			//PE = PhotonEnergy
			//WF = WorkFunction
			//Prompt PE, "Photon Energy in eV"
			//Prompt WF, "Work Function in eV"
			Prompt Resolution, "Number of pixels"		
			DoPrompt "PARAMETERS TO PUT",Resolution
			
			//Variable YL=SelectNumber(sign(Xmin)==+1,Ymax,Ymin)
			//Variable YR=SelectNumber(sign(Xmax)==+1,Ymin,Ymax)
			
			Make/O/N=(Resolution, Resolution) LayerN_K
			Make/O/N=(Dimsize(Images3D,0), Resolution) CutX_K
			Make/O/N=(Dimsize(Images3D,0), Resolution) CutY_K
				
			Setscale/I x,ky1,ky2,"k\B||\M [Å]" LayerN_K
			Setscale/I y,kx1,kx2,"k\B||\M [Å]" LayerN_K
			
			//Setscale/I x,kx1,kx2,"k\B||\M [Å]" LayerN_Kder
			//Setscale/I y,ky1,ky2,"k\B||\M [Å]" LayerN_Kder
			
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , CutX_K
			SetScale /I y, kx1, kx2 , "Angle" , CutX_K
			
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "Energy" , CutY_K
			SetScale /I y, ky1, ky2 , "Angle" , CutY_K
			
			Variable help1 , energy1
			ControlInfo /W=k_Space_2D SetLayers
			help1 = V_value
			energy1 =  DimOffset(Images3D,0) + DimDelta(Images3D,0) * ( help1 - 1 )  
			
			Variable help2
			ControlInfo /W=k_Space_2D Position1
			help2 = V_value
			
			Variable help3
			ControlInfo /W=k_Space_2D Position3
			help3 = V_value
			
			LayerN_K = Image3( asin( x/( 0.512*sqrt(energy1) ) )*180/Pi )( asin(y/(0.512*sqrt(energy1)))*180/Pi )
			CutX_K = ImageY(x)( asin( y/( 0.512*sqrt(x)))*180/Pi )
			CutY_K = ImageX(x)(  asin( y/( 0.512*sqrt(x)))*180/Pi )
			
			//Amatrix(x)(asin(y/(0.512*sqrt(PE-WF+x)))*180/Pi)
			//Duplicate/O LayerN_K , Images3D 
			
			//Redimension/N=( Resolution, Resolution ) Image3
			//Redimension/N=( Resolution, Resolution ) Image3der
			
			//Redimension/N=( DimSize(Images3D,0), Resolution ) ImageX
			//Redimension/N=( DimSize(Images3D,0), Resolution ) ImageY
			
			Variable number
			Wave /T W_WaveList
			
			SetActiveSubwindow $"k_Space_2D"
			GetWindow $"k_Space_2D" wavelist
			number = WaveExists(W_WaveList)
			//if(number == 0 )
			//	number = 1
			//else
			GetWindow $"k_Space_2D" wavelist
			name1 = W_WaveList[0][0]
			number = exists(name1)
			//endif
			
			if( number != 0 )
				RemoveImage /W=$"k_Space_2D" $name1
			endif
			
	
			AppendImage /L=leftImage3 /B=bottomImage3 LayerN_K
			
			ModifyGraph  swapXY=1 ,lblPosMode= 2
			ModifyGraph margin =40
			ModifyGraph margin(right) =20
			ModifyGraph margin(top) =10
			ModifyGraph mode=2,rgb=(0,0,0)
			ModifyGraph freePos(leftImage3)={0.1,kwFraction}
			ModifyGraph freePos(bottomImage3)={0.1,kwFraction}
			ModifyGraph axisEnab(bottomImage3)={0.1,1}
			ModifyGraph axisEnab(leftImage3)={0.1,1}
			ModifyGraph margin(bottom)=20	
			
			ModifyGraph swapXY=1
			//ModifyImage Image3der ctab= {*,*,Grays,1}
			//ModifyImage Image3der ctab= {*,*,BrownViolet,1}
			//Button D3Dd,title="Go to\rImage"
				
			break
	endswitch

	return 0
End

Function contrast1(sa) : SliderControl
	STRUCT WMSliderAction &sa
	
	switch( sa.eventCode )
		case -1: // kill
			
			break
		default:
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1, name2 , name3
				SetDataFolder root:folder3D
				name1 = sa.ctrlName
				
				name2 = ImageNameList("", "" )
				name2 = StringFromList (0, name2  , ";")
				Variable help1
				//Wavestats/Q/Z $name2
				//Slider contrastmin,limits={V_min,V_max,0}
				//Slider contrastmax,limits={V_min,V_max,0}
				name3 = sa.win
				if( cmpstr (name1 , "contrastmin") == 0 )
					ControlInfo contrastmax
					help1 = V_value
					ModifyImage /W=$name3 $name2, ctab= {curval,help1,,0}
				else
					ControlInfo contrastmin
					help1 = V_value
					ModifyImage /W=$name3 $name2, ctab= {help1, curval,,0}
				endif
	
			endif
			break
	endswitch

	return 0
End

Function contrast0(sa) : SliderControl
	STRUCT WMSliderAction &sa
	
	switch( sa.eventCode )
		case -1: // kill
			
			break
		default:
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1, name2 , name3
				SetDataFolder root:$sa.win
				name1 = sa.ctrlName
				
				name2 = ImageNameList("", "" )
				name2 = StringFromList (0, name2  , ";")
				Variable help1
				//Wavestats/Q/Z $name2
				//Slider contrastmin,limits={V_min,V_max,0}
				//Slider contrastmax,limits={V_min,V_max,0}
				name3 = sa.win
				if( cmpstr (name1 , "contrastmin") == 0 )
					ControlInfo contrastmax
					help1 = V_value
					ModifyImage /W=$name3 $name2, ctab= {curval,help1,,0}
				else
					ControlInfo contrastmin
					help1 = V_value
					ModifyImage /W=$name3 $name2, ctab= {help1, curval,,0}
				endif
	
			endif
			break
	endswitch

	return 0
End

Function SetVarProc_Gamma(sva) : SetVariableControl
	STRUCT WMSetVariableAction &sva

	switch( sva.eventCode )
		case 1: // mouse up
		case 2: // Enter key
		case 3: // Live update
			Variable dval = sva.dval
			String sval = sva.sval
			
			if(dval == 0)
				break
			endif
			
			String name1, name2
			Wave /T W_WaveList
			Variable number
			
			Setdatafolder root:folder3D:
			Variable help6
			ControlInfo /W=k_Space_2D check5
			help6 = V_value
			if(help6)
				WAVE Images3D = Images3Dder
			else
				WAVE Images3D = Images3D
			endif		
				
			NVAR KineticFermi
			NVAR PhotonEnergy
			NVAR WorkFunction
			Variable KF = KineticFermi
			Variable PE = PhotonEnergy
			Variable WF = WorkFunction
			
			WAVE Image3
			WAVE Image3der
			//WAVE Images3D
			//WAVE Images3Dder
			WAVE M_ImageHistEq
			WAVE W_ImageHis
			WAVE Multipliers
			WAVE ImageX
			WAVE ImageY
			WAVE LayerN_K
			WAVE CutX_K
			WAVE CutY_K
			
			Variable deltaE
			Variable x0
			Variable Energy
			Variable help1, help2, help3, help4 ,help7
			String help5
			
			Variable positionY
			Variable positionZ
			
			ControlInfo /W=k_Space_2D check1
			help1 = V_value
			ControlInfo /W=k_Space_2D SetLayers
			help2 = V_value
			ControlInfo /W=k_Space_2D check2
			help3 = V_value
			ControlInfo /W=k_Space_2D Energy1
			help4 = V_value
			ControlInfo /W=k_Space_2D popup0
			help5 = S_value
			ControlInfo /W=k_Space_2D rotation
			help6 = V_value
			ControlInfo /W=k_Space_2D SetLayers
			help7 = V_value
			
			String nameI
			nameI = ImageNameList("", "" )
			nameI = StringFromList (0, nameI  , ";")
				
			Make/O/N=(256) W_ImageHis
			Wave /T W_WaveList
			Variable i , number2
			
			switch(help3)
				case 0:
			
					Image3[][] = Images3D[help2][p][q]
			
					for( i = 0 ; i < number2 ; i = i +1)
						Image3[][i] = 	Image3[p][i]*Multipliers[i]
					endfor
			
					Image3 = Image3^dval
			
					if(help1 == 1)
						ImageHistModification Image3
						Image3 = M_ImageHistEq	
					endif
			
					Wavestats/Q/Z  Image3
					Slider contrastmin,limits={V_min,V_max,0},value=V_min
					Slider contrastmax,limits={V_min,V_max,0},value=V_max
					ModifyImage  Image3, ctab= {V_min,V_max,$help5,0}
					
					Variable ni
					Variable mi
					ControlInfo /W=k_Space_2D Param1
					help2 = V_value
					number2 = DimSize (Images3D, 2)
						
					if(  strlen(CsrInfo(A))  == 0 )
						break
					endif	
						
					ni = qcsr(A)
					mi = pcsr(A)
					ImageX[][] = Images3D[p][q][ni]
					ImageY[][] = Images3D[p][mi][q]
				
					for( i = 0 ; i < number2 ; i = i +1)
						ImageY[][i] = 	ImageY[p][i]*Multipliers[i]
					endfor
				
					ImageX = ImageX^dval
					ImageY = ImageY^dval
					
					break

				case 1:
					x0 = DimOffset (Images3D,0)
					deltaE = DimDelta (Images3D,0)
					Energy = x0 + help2*deltaE
					
					Variable C1,C2,C3,C4
					
					Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
					Variable delta_k_n , delta_k_m , delta_phi , delta_theta
					Variable k_n0 , k_m0 , phi0 , theta0
					Variable phi1 , phi2 , theta1 , theta2
					Variable i_n , j_m 
					Variable n_max , m_max
					Variable i_max , j_max
					Variable i_1 , i_2 , j_1 , j_2
					Variable wL , wR , wU , wD 
					
					Variable energy2
					energy2 = PE-WF+ energy - KF
					C1 = 1/(0.512*sqrt(energy2))
					C2 = 180/Pi
					C3 = Pi/180
					
					n_max = DimSize (LayerN_K,0)
					m_max = DimSize (LayerN_K,1)
					
					k_n0 = DimOffset (LayerN_K,0)
					k_m0 = DimOffset (LayerN_K,1)
					
					delta_k_n = DimDelta (LayerN_K,0)
					delta_k_m = DimDelta (LayerN_K,1)
					
					i_max = DimSize (Images3D,1) 
					j_max = DimSize (Images3D,2)
					
					phi0 = DimOffset (Images3D,1)
					theta0 = DimOffset (Images3D,2)
					
					delta_phi = DimDelta (Images3D,1)
					delta_theta = DimDelta (Images3D,2)
					
					k_n = k_n0
					k_m = k_m0
					
					Variable sinPhi
					Variable cosPhi
					Variable sinTheta
					Variable deltaFiPrime
					Variable deltaThetaPrime
					Variable sinAlfa
					Variable cosAlfa
					sinAlfa = sin(help6*C3)
					cosAlfa = cos(help6*C3)
					LayerN_K = NaN
					
					for( n=0;n<n_max;n=n+1)
						for( m=0;m<m_max;m=m+1)
							sinPhi = C1*(cosAlfa*k_n - sinAlfa*k_m)
							phi_n_rad = asin( sinPhi )
							phi_n = phi_n_rad * C2
							i_n = (phi_n - phi0)/delta_phi
							if(i_n>=0 && i_n<=i_max)
								cosPhi = sqrt(1-sinPhi*sinPhi)
								C4 = C1/ cosPhi
								sinTheta = C4*(sinAlfa*k_n + cosAlfa*k_m)
								theta_m = asin( sinTheta ) * C2
								j_m = (theta_m - theta0)/delta_theta
								if(j_m>=0 && j_m<=j_max)	
									i_1 = floor(i_n)
									i_2 = ceil(i_n)
									j_1 = floor(j_m)
									j_2 = ceil(j_m)
									wR = i_n - i_1
									wL = 1 - wR
									wU = j_m - j_1
									wD = 1 - wU
									LayerN_K[n][m] = Images3D(energy)[i_1][j_1]*wL*wD + Images3D(energy)[i_2][j_1]*wR*wD + Images3D(Energy)[i_1][j_2]*wL*wU + Images3D(Energy)[i_2][j_2]*wR*wU
								else
									LayerN_K[n][m] = Nan
								endif
								
							else
								LayerN_K[n][m] = Nan
							endif
							k_m = k_m + delta_k_m
						endfor
						k_m = k_m0
						k_n = k_n + delta_k_n
					endfor
					
					if( dval != 1)
						LayerN_K = LayerN_K^dval
					endif
					
					if(help1 == 1)
						ImageHistModification LayerN_K
						LayerN_K = M_ImageHistEq		
					endif
	
					Wavestats/Q/Z LayerN_K
					Slider contrastmin,limits={V_min,V_max,0},value=V_min
					Slider contrastmax,limits={V_min,V_max,0},value=V_max
					ModifyImage LayerN_K, ctab= {V_min,V_max,$help5,0}
					
					Variable o , o_max , E_o0 , delta_E , E_o
						
					C1 = 1/(0.512*sqrt(Energy))
					C2 = 180/Pi
						
					n_max = DimSize (CutX_K,1)
					m_max = DimSize (LayerN_K,1)
					o_max = DimSize (CutX_K,0)
							
					k_n0 = DimOffset (CutX_K,1)
					k_m0 = DimOffset (LayerN_K,1)
					E_o0 = DimOffset (CutX_K,0)
						
					delta_k_n = DimDelta (CutX_K,1)
					delta_k_m = DimDelta (LayerN_K,1)
					delta_E = DimDelta (CutX_K,0)
						
					i_max = DimSize (Images3D,1) - 1
					j_max = DimSize (Images3D,2) - 1
						
					phi0 = DimOffset (Images3D,1)
					theta0 = DimOffset (Images3D,2)
						
					delta_phi = DimDelta (Images3D,1)
					delta_theta = DimDelta (Images3D,2)
				
					if(  strlen(CsrInfo(A))  == 0 )
						break
					endif	
					
					Variable cursorV
					cursorV = vcsr(A,"")
					k_n = k_n0
					k_m = cursorV
					E_o = PE-WF-KF+E_o0
						
					for(o=0;o<o_max;o=o+1)
						C1 = 1/(0.512*sqrt(E_o))
						for( n=0;n<n_max;n=n+1)
							sinPhi = C1*(cosAlfa*k_n - sinAlfa*k_m)
							phi_n_rad = asin( sinPhi )
							phi_n = phi_n_rad * C2
							i_n = (phi_n - phi0)/delta_phi
							if(i_n>=0 && i_n<=i_max)
								cosPhi = sqrt(1-sinPhi*sinPhi)
								C4 = C1/ cosPhi
								sinTheta = C4*(sinAlfa*k_n + cosAlfa*k_m)
								theta_m = asin( sinTheta ) * C2
								j_m = (theta_m - theta0)/delta_theta	
								if(j_m>=0 && j_m<=j_max)	
									i_1 = floor(i_n)
									i_2 = ceil(i_n)
									j_1 = floor(j_m)
									j_2 = ceil(j_m)
									wR = i_n - i_1
									wL = 1 - wR
									wU = j_m - j_1
									wD = 1 - wU
									CutX_K[o][n] = Images3D[o][i_1][j_1]*wL*wD + Images3D[o][i_2][j_1]*wR*wD + Images3D[o][i_1][j_2]*wL*wU + Images3D[o][i_2][j_2]*wR*wU
								else
									CutX_K[o][n] = Nan
								endif
									//k_m = k_m + delta_k_m
								//endfor
							else
								CutX_K[o][n] = Nan
							endif
							//k_m = k_m0
							k_n = k_n + delta_k_n
						endfor
						k_n = k_n0
						E_o = E_o + delta_E
					endfor
							
					//C1 = 1/(0.512*sqrt(Energy))
					C2 = 180/Pi
							
					n_max = DimSize (LayerN_K,0)
					m_max = DimSize (CutY_K,1)
					o_max = DimSize (CutY_K,0)
							
					k_n0 = DimOffset (LayerN_K,0)
					k_m0 = DimOffset (CutY_K,1)
					E_o0 = DimOffset (CutY_K,0)
							
					delta_k_n = DimDelta (LayerN_K,0)
					delta_k_m = DimDelta (CutY_K,1)
					delta_E = DimDelta (CutY_K,0)
							
					i_max = DimSize (Images3D,1) - 1
					j_max = DimSize (Images3D,2) - 1
							
					phi0 = DimOffset (Images3D,1)
					theta0 = DimOffset (Images3D,2)
							
					delta_phi = DimDelta (Images3D,1)
					delta_theta = DimDelta (Images3D,2)
							
					Variable cursorH
					cursorV = vcsr(A,"")
					cursorH = hcsr(A,"")
					k_n = cursorH
					k_m = k_m0
					E_o = PE-WF-KF+E_o0
							
					for(o=0;o<o_max;o=o+1)
						C1 = 1/(0.512*sqrt(E_o))
						for( m=0;m<m_max;m=m+1)
							sinPhi = C1*(cosAlfa*k_n - sinAlfa*k_m)
							phi_n_rad = asin( sinPhi )
							phi_n = phi_n_rad * C2
							i_n = (phi_n - phi0)/delta_phi
							if(i_n>=0 && i_n<=i_max)
								cosPhi = sqrt(1-sinPhi*sinPhi)
								C4 = C1/ cosPhi
								sinTheta = C4*(sinAlfa*k_n + cosAlfa*k_m)
								theta_m = asin( sinTheta ) * C2
								j_m = (theta_m - theta0)/delta_theta	
								if(j_m>=0 && j_m<=j_max)	
									i_1 = floor(i_n)
									i_2 = ceil(i_n)
									j_1 = floor(j_m)
									j_2 = ceil(j_m)
									wR = i_n - i_1
									wL = 1 - wR
									wU = j_m - j_1
									wD = 1 - wU
									CutY_K[o][m] = Images3D[o][i_1][j_1]*wL*wD + Images3D[o][i_2][j_1]*wR*wD + Images3D[o][i_1][j_2]*wL*wU + Images3D[o][i_2][j_2]*wR*wU
								else
									CutY_K[o][m] = Nan
								endif
							else
								CutY_K[o][m] = Nan
							endif
							k_m = k_m + delta_k_m
							//k_n = k_n + delta_k_n
						//endfor
						//k_n = k_n0
						endfor
						k_m = k_m0
						E_o = E_o + delta_E
					endfor
					if( dval != 1)
						CutX_K = CutX_K^dval
						CutY_K = CutY_K^dval
					endif
				break
			endswitch
			
			
			break
	
	endswitch
	DoUpdate
	return 0
End

Function MY_SPECS_Load_SH5(path, [showUnits])
  string path
  variable showUnits
  if (ParamIsDefault(showUnits))
     showUnits = 1
  endif

  Variable fileID, i, cnt=0, nameCnt
  string group,fName, wName, suffix=".new", image,imageGroup, baseGroup, tmpName, compoundName, dataName, transImage, images

  variable startx, starty, endx, endy, roiOfs_x, roiOfs_y
  Wave wv

  //names of data which we read in
  variable Ekin, Epass, PixelCount_x, PixelCount_y, RoiOffset_x, RoiOffset_y, DeN, Da, DcPixDispOfs_x, DcPixDispOfs_y, DcPixDispFac_x, DcPixDispFac_y
  string LensMode, xAxisText="", yAxisText=""

  SetDataFolder root:

  HDF5OpenFile/R fileID as path

  if (fileID == 0)
    printf "No file given, aborting"
    return -1
  endif

  FStatus fileID
  fname = S_fileName
  print "Opening file: " + fname

  wName = makeShortName(fname,nameCnt,"")
  tmpName = makeShortName(fname,nameCnt,"")

  if(DataFolderExists(tmpName))
    wName += suffix
    do
      tmpName = wName + num2str(cnt)
      cnt+=1
    while(DataFolderExists(tmpName))
  endif

  NewDataFolder/s $tmpName

  getFirstImageGroup(fileID,baseGroup,imageGroup)
  group = baseGroup + "/" + "Applications/CCD-Acquire"
  imageGroup = baseGroup + "/" + "Data" + "/" + imageGroup
  compoundName="DummyDispersion"
   LoadFloat(fileID, group, compoundName,"DcPixDispFac.x",DcPixDispFac_x) // dispersionFactor for transformed image
   LoadFloat(fileID, group, compoundName,"DcPixDispFac.y",DcPixDispFac_y) // dito
   LoadFloat(fileID, group, compoundName,"DcPixDispOfs.x",DcPixDispOfs_x) 
   LoadFloat(fileID, group, compoundName,"DcPixDispOfs.y",DcPixDispOfs_y) 
   LoadFloat(fileID, group, compoundName,"DeN",DeN) // dispFactor for untransformed image
   LoadFloat(fileID, group, compoundName,"Da",Da) //dito
   LoadFloat(fileID, group, compoundName,"Ekin",Ekin)
   LoadFloat(fileID, group, compoundName,"Epass",Epass)
   LoadFloat(fileID, group, compoundName,"PixelCount.x",PixelCount_x)
   LoadFloat(fileID, group, compoundName,"PixelCount.y",PixelCount_y)
   LoadFloat(fileID, group, compoundName,"RoiOffset.x",RoiOffset_x)
   LoadFloat(fileID, group, compoundName,"RoiOffset.y",RoiOffset_y)
   LoadString(fileID, group, compoundName,"LensMode",LensMode)
 
   group= "/Applications/CCD-Acquire"
   compoundName="UI_Data"
  LoadString(fileID,group, compoundName, "UserXAxisText",xAxisText)
  LoadString(fileID,group, compoundName, "UserYAxisText",yAxisText)

  image = makeShortName(wName,nameCnt,"")
  compoundName = "Raw"
  
   if ( LoadImage(fileID, imageGroup, compoundName, image,1) != -1 )
     print "Found image data"
   else
    print "Found no image data, therefore aborting"
    return 0
   endif

  transImage = makeShortName(wName,nameCnt,"-trans")
  compoundName= "DispCorr"

  if ( LoadImage(fileID, imageGroup, compoundName, transImage,0) != -1) // group here is the same as that of the untransformed image
    print "Found transformed image data"
    images = image + "\\" + transImage  
  else
    images = image + "\\"
  endif

  if( strlen(xAxisText) == 0 )
    xAxisText="Kinetic Energy [eV]"
  endif
  
  if( strlen(yAxisText) == 0 )
    yAxisText="Azimuth"  
  endif  

  for( i=0 ; i < ItemsInList(images,"\\") ; i+=1 )
    Wave wv = $StringFromList(i,images,"\\")
    
    if(!WaveExists(wv))
      break
    endif
    
    DebugPrint( "Name of wave is: " + NameOfWave(wv) )
    Note/K wv
    Note wv, "LensMode:" + LensMode
    Note wv, "FileName:" + fname
    MatrixTranspose wv

    If( PixelCount_x == 0 || PixelCount_y == 0 ) // get the dimension from the wave
      PixelCount_x = DimSize(wv, 0)
      PixelCount_y = DimSize(wv, 1)
      debugPrint("new dims are " + num2str(PixelCount_x) + "x" +  num2str(PixelCount_y))
    endif
      
    if( showUnits )

      if( stringmatch(NameOfWave(wv),"*-trans") ) // transformed image
        
        Note wv, "Type:Transformed Image"
        
        if( DcPixDispFac_x == 0 || DcPixDispFac_y == 0 )
          print "Using pixel axis for wave " + NameOfWave(wv) + " because there is not enough data available to display physical axis"
          continue
        endif

        SetScale/P x, DcPixDispOfs_x, DcPixDispFac_x, xAxisText, wv
        SetScale/P y, DcPixDispOfs_y, DcPixDispFac_y, yAxisText, wv
        
      else // untransformed image
        
        if( Epass == 0 || Ekin == 0 || Da == 0 || DeN == 0 )
          print "Using pixel axis for wave " + NameOfWave(wv)  + " because there is not enough data available to display physical axis"
          continue
        endif

        // check for odd/even necessary ?!    
        roiOfs_x = ( pixelCount_x ) / 2.0  - RoiOffset_x
        roiOfs_y = ( pixelCount_y ) / 2.0  - RoiOffset_y
        
        variable dx,dy
        dx = Epass*DeN
        dy = Da
        
        startx = Ekin - dx * roiOfs_x
        endx  = Ekin + dx * roiOfs_x
        
        starty = - Da * roiOfs_y
        endy =  Da * roiOfs_y

        SetScale/I x, startx,endx, xAxisText, wv
        SetScale/I y, starty, endy, yAxisText, wv
        // SetScale/P x, startx,dx, xAxisText, wv
        // SetScale/P y, starty, dy, yAxisText, wv
        DebugPrint("dy=" + num2str(dy) +", dx=" + num2str(dx))
        DebugPrint("and should also be dx=" + num2str((endx-startx)/pixelCount_x) + "dy=" + num2str((endy-starty)/pixelCount_y))
        DebugPrint("startx=" + num2str(startx) + ", endx=" + num2str(endx) + ", starty=" +  num2str(starty) + ", endy=" + num2str(endy))
      endif
    endif
    	if( i == 1)
  		NewImage wv
  	endif
  endfor    
    
  HDF5CloseFile fileID
  return 0
end

static Function getFirstImageGroup(fileID,baseGroup,imageGroup)
  variable fileID
  string &baseGroup,&imageGroup
  
  baseGroup=""
  imageGroup=""
  variable groupID, i, cntGroups=0,j
  string groups, groupName="/Groups", subGroup, innerGroups, innerSubGroup
  string DATA_NAME="Data"
  string DISP_MESH="DispersionMesh"

  do
    cntGroups+=1
    HDF5ListGroup/Z/TYPE=1 fileID, groupName
      
    if (V_Flag != 0 )
      print "This file does not look like a CCD-Acquire file"
      return -1
    endif

    groups = S_HDF5ListGroup
    subGroup = StringFromList(0,groups)

    if( strlen(subGroup) == 0 )
        print "This file does not look like a CCD-Acquire file"
        return -1
    endif

    for( i=0; i < ItemsInList(groups); i+=1)
      if( cmpstr(StringFromList(i,groups),DATA_NAME) == 0 )
        DebugPrint("Target group found " + groupName)
        baseGroup = groupName
        // get image Group
        groupName = baseGroup + "/" + DATA_NAME
        HDF5ListGroup/Z/Type=1 fileID, groupName
        innerGroups = S_HDF5ListGroup
        DebugPrint("innerGroups are " + innerGroups)
        
        if( ItemsInList(innerGroups) == 1 )// older CCD-Acquire produces only one group
          imageGroup=StringFromList(0,innerGroups)
          return 0
        else        
          for( j=0; j < ItemsInList(innerGroups); j+=1 ) // newer versions have at least two, so take the first one not being DISP_MESH
            innerSubGroup = StringFromList(j,innerGroups)
            if( cmpstr(innerSubGroup,DISP_MESH) != 0 )
              imageGroup=innerSubGroup
              DebugPrint("ImageGroup found " + imageGroup)
              return 0
            endif
          endfor
        endif
      endif
    endfor
      
    groupName = groupName + "/" + subGroup
    Debugprint("subGroup is " + subGroup)
  while(1)
end

static Function/S makeShortName(name,nameCnt,suffix)
  variable &nameCnt
  string name, suffix
  
  variable sufLen, nameLen
  sufLen = strlen(suffix)
  nameLen = strlen(name)
  
  string str
  
  if (sufLen + nameLen <= 31 )
    str = name + suffix
  else
    nameCnt+=1
    str = "data" + num2str(nameCnt) + suffix
  endif
  
  return str
end
  
static Function groupExist(fileID, group)
  variable fileID
  string group
  
  variable groupID
  HDF5OpenGroup/Z fileID, group, groupID
  
  if (V_Flag != 0 )
    DebugPrint("group " + group + " does not exist")
    return 0
  else
    return 1
  endif
end

static Function LoadImage(file, group, dataName, name, warn)
  variable file,warn
  string group, dataName, name
  
  if( groupExist(file, group) )
    HDF5LoadData/Z/N=$name file, group + "/" + dataName
    if (V_Flag != 0 )
        if(warn)
          print "Error loading data from file, aborting"
        endif
      return -1
    endif
  else
    return -1
  endif
end

static Function LoadFloat(file, group, compoundName, dataName, float)
  variable file, &float
  string dataName, group, compoundName
  
  string str
  return LoadCustom(file, group, compoundName, dataName, float, str, 0)
end

static Function LoadString(file, group, compoundName, dataName, str)
  variable file
  string dataName, group, &str, compoundName
  
  variable float
  return LoadCustom(file, group, compoundName, dataName, float, str, 1)
end

static Function LoadCustom(file, group, compoundName, dataName, dataFloat, dataString, type)
  variable file, type, &dataFloat
  string group, dataName, &dataString, compoundName
  
  dataFloat=0 // overwrite with save defaults
  dataString=""
  variable groupID
  string loc, name="Energydata"
  
  if(!groupExist(file, group))
    return -1
  endif
  
  loc = group + "/" + compoundName
  HDF5LoadData/Z/COMP={1,dataName}/N=$name file, loc
  
  if (V_Flag != 0 )
    DebugPrint("Error loading data " + dataName + "from file")
    return -1
  endif  
  
  switch(type)
    case 0:
      Wave wv = $name
      dataFloat  = wv[0][0]
      KillWaves wv
    break
    case 1:
      Wave/T wvT = $name
      dataString = wvT[0]
      KillWaves wvT
    break
    default:
      DebugPrint("Error in type")
      return -1
    break
  endswitch
  DebugPrint("Reading " + dataName + ", dataString=" +  dataString + " and dataFloat=" + num2str(dataFloat))
end

//static Function DebugPrint(str)
//  string str

//  print str
//end

Function contrast2(sa) : SliderControl
	STRUCT WMSliderAction &sa
	
	switch( sa.eventCode )
		case -1: // kill
			
			break
		default:
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1, name2 , name3
				SetDataFolder root:folder3D
				name1 = sa.ctrlName
				
				name2 = ImageNameList("", "" )
				name2 = StringFromList (0, name2  , ";")
				Variable help1
				//Wavestats/Q/Z $name2
				//Slider contrastmin,limits={V_min,V_max,0}
				//Slider contrastmax,limits={V_min,V_max,0}
				name3 = sa.win
				if( cmpstr (name1 , "contrastmin1") == 0 )
					ControlInfo contrastmax1
					help1 = V_value
					ModifyImage /W=$name3 $name2, ctab= {curval,help1,,0}
				else
					ControlInfo contrastmin1
					help1 = V_value
					ModifyImage /W=$name3 $name2, ctab= {help1, curval,,0}
				endif
	
			endif
			break
	endswitch

	return 0
End

Function contrast3(sa) : SliderControl
	STRUCT WMSliderAction &sa
	
	switch( sa.eventCode )
		case -1: // kill
			
			break
		default:
			if( sa.eventCode & 1 ) // value set
				Variable curval = sa.curval
				String name1, name2 , name3
				SetDataFolder root:folder3D
				name1 = sa.ctrlName
				
				name2 = ImageNameList("", "" )
				name2 = StringFromList (1, name2  , ";")
				Variable help1
				//Wavestats/Q/Z $name2
				//Slider contrastmin,limits={V_min,V_max,0}
				//Slider contrastmax,limits={V_min,V_max,0}
				name3 = sa.win
				if( cmpstr (name1 , "contrastmin2") == 0 )
					ControlInfo contrastmax2
					help1 = V_value
					ModifyImage /W=$name3 $name2, ctab= {curval,help1,,0}
				else
					ControlInfo contrastmin2
					help1 = V_value
					ModifyImage /W=$name3 $name2, ctab= {help1, curval,,0}
				endif
	
			endif
			break
	endswitch

	return 0
End


Function ListResizeHook2(s)
	STRUCT WMWinHookStruct &s
	
	Variable statusCode= 0
	String win= s.winName
	strswitch (s.eventName) 
		case "resize":
			Variable kMinWinWidthPixels = 800
			Variable kMinWinHeightPixels = 200
			Variable tooSmall= MinWindowSize2(win,kMinWinWidthPixels*72/ScreenResolution,kMinWinHeightPixels*72/ScreenResolution)	// make sure the window isn't too small (at least 200 pixels)
			if( !tooSmall )	// don't bother resizing if another resize event is pending
				FitListToWindow2(win,"list2")
			endif
			//statusCode=1	// allow other resize hooks to run
			break
		case "kill":
			//WC_WindowCoordinatesSave(win)
			break
	endswitch
	return statusCode	// 0 if nothing done, else 1 or 2
End

Function MinWindowSize2(win,minwidth,minheight)
	String win
	Variable minwidth,minheight	// points. Note that Panel window recreation macros are in pixels.

	GetWindow $win wsize
	Variable width= V_right-V_left
	Variable height= V_bottom-V_top
	Variable neededWidth= max(width,minwidth)
	Variable neededHeight= max(height,minheight)
	Variable resizePending= (neededWidth > width) || (neededHeight > height)
	if( resizePending )
		//MoveWindow/W=$win V_left, V_top, V_left+newwidth, V_top+newheight
		// To prevent EnforceMinSize commands from piling up, we set a flag that the minimizer has been scheduled to run.
		// To avoid global variables, we use userdata on the window being resized.
		String enforceMinSizeScheduledStr= GetUserData(win,"","enforceMinSizeScheduled")	// "" if never set (means "no")
		if( strlen(enforceMinSizeScheduledStr) == 0 )
			SetWindow $win, userdata(enforceMinSizeScheduled)= "yes"
			String cmd
			sprintf cmd, "EnforceMinSize2(\"%s\", %g,%g)", win, minwidth,minheight
			Execute/P/Q cmd	// after the functions stop executing, the EnforceMinSize's call to MoveWindow will provoke another resize event.
		endif
	endif
	return resizePending	
End

Function EnforceMinSize2(win,minwidth,minheight)
	String win
	Variable minwidth,minheight	// points. Note that Panel window recreation macros are in pixels.

	Variable resizeNeeded= 0
	DoWindow $win
	if( V_Flag )
		GetWindow $win wsize
		Variable width= V_right-V_left
		Variable height= V_bottom-V_top
		Variable neededWidth= max(width,minwidth)
		Variable neededHeight= max(height,minheight)
		resizeNeeded= (neededWidth > width) || (neededHeight > height)
		if( resizeNeeded )
			MoveWindow/W=$win V_left, V_top, V_left+neededWidth, V_top+neededHeight
		endif
		SetWindow $win, userdata(enforceMinSizeScheduled)= ""
	endif
	return resizeNeeded	
End

Function FitListToWindow2(win, ctrlName)
	String win, ctrlName
	
	GetWindow $win wsizeDC		// the new window size
	Variable winHeight= V_bottom-V_top	// pixels
	Variable winWidth= V_right-V_left		// pixels

	// keep the same top/left coordinates, but make the list span the entire height of the panel
	// and as much width as  will leave room for the other controls.
	// We measure the other controls' widths here.
	String otherControls= RemoveFromList(ctrlName,ControlNameList(win))
	Variable i, n=ItemsInList(otherControls)
	Variable neededWidth= 0		// compute needed width for controls on the right side of the panel
	neededWidth += 14	// extra margin
	// Move the list
	ControlInfo/W=$win $ctrlName
	Variable left= V_left		// pixels
	Variable width= (winWidth-neededWidth)-0	// pixels
	Variable height= winHeight-(V_top + 10)		// pixels, equal margin at top and bottom
	ModifyControl $ctrlName, win=$win, pos={left,V_top},size={width,height}
	ModifyControl $ctrlName, win=$win, pos={left,V_top},size={width,height}
	ModifyControl $ctrlName, win=$win, widths={height-42} , special={1,height-42,1}
	
End

Function CheckProc(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			
			Setdatafolder root:Load_and_Set_Panel:
			SVAR title_left1 =  title_left1
			SVAR title_right1 =  title_right1
			
			SetDataFolder root:Blending_Panel
			SVAR K1
			Variable help1
			Wave FinalBlendKE
			Wave FinalBlendKE_ori
			
			WAVE TemporaryHoldKE_L
			WAVE TemporaryHoldKE_R
			Variable La1,Ra1
			Variable La2,Ra2
			Variable He1,Le1
			Variable He2,Le2
			Variable index1A,index2A,index3A,index4A
			Variable index1E,index2E,index3E,index4E
			
			//Duplicate/O FinalBlendKEori, FinalBlendKE
			
			Variable aShift
			ControlInfo setvar1
			aShift = V_value
			
			Variable eShift
			ControlInfo setvar0
			eShift = V_value
			
			Variable n1, n2
			Variable deltaA
			Variable deltaE
			
			n1 = DimSize(FinalBlendKEori,0) 
			n2 = DimSize(FinalBlendKEori,1) + aShift
			deltaA = DimDelta(FinalBlendKEori,1)
			deltaE = DimDelta(FinalBlendKEori,0)
			//Redimension /N=(n1,n2) FinalBlendKE
			Redimension /N=(n1,n2) TemporaryHoldKE_L
			Redimension /N=(n1,n2) TemporaryHoldKE_R
			
			Setdatafolder root:Load_and_Set_Panel:
			Wave L_image1
			Wave Angle_2D = L_image1		
			
			SetDataFolder root:$"Blending_Panel"
			Duplicate/O Angle_2D, L_Image
			
			WAVE L_Image_dif
			
			La1 = DimOffset(L_Image,1)
			Ra1 = DimOffset(L_image,1) + (DimSize(L_image,1)-1)*DimDelta(L_image,1)
			He1 = DimOffset(L_image,0) + (DimSize(L_image,0)-1)*DimDelta(L_image,0)
			Le1 = DimOffset(L_image,0)
			
			index1A = round ( ( La1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
			index3A = round ( ( Ra1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) 
			index1E = round ( ( Le1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
			index3E = round ( ( He1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
			
			if(checked)
				TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image_dif(x)(y)
			else
				TemporaryHoldKE_L[index1E,index3E][index1A,Index3A] = L_Image(x)(y)
			endif
			//FinalBlendKE = TemporaryHoldKE_L
			
			Setdatafolder root:Load_and_Set_Panel:
			Wave R_image1
			Wave Angle_2D = R_image1		
			
			SetDataFolder root:$"Blending_Panel"
			Duplicate/O Angle_2D,  R_Image 
			Duplicate/O Angle_2D,  R_Image_dif
			
			Variable nrPixE
			Variable nrPixA
			nrPixE = DimSize(R_Image_dif,0)
			nrPixA = DimSize(R_Image_dif,1)
			Make/FREE /N=(nrPixE)  v1 
			
			Variable i,j
			R_Image_dif = 0
			for(i = 0; i <nrPixA;i+=1)	// Initialize variables;continue test
				v1 =  R_Image[p][i]
				//Smooth 2 , v1
				Differentiate/METH=0/EP=0 v1
				Differentiate/METH=0/EP=0 v1
				R_Image_dif[][i] = -v1[p]
			endfor
			KillWaves v1
				
			La2 = DimOffset(R_image,1)
			Ra2 = DimOffset(R_image,1) + (DimSize(R_image,1)-1)*DimDelta(R_image,1)
			He2 = DimOffset(R_image,0) + (DimSize(R_image,0)-1)*DimDelta(R_image,0)
			Le2 = DimOffset(R_image,0)
				
			index1A = round ( ( La1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) )
			index3A = round ( ( Ra1 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) 
			index2A = round ( ( La2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) + aShift
			index4A = round ( ( Ra2 - DimOffset(FinalBlendKE, 1) ) / DimDelta(FinalBlendKE,1) ) + aShift
			
			index1E = round ( ( Le1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) )
			index3E = round ( ( He1 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) 
			index2E = round ( ( Le2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) + eShift
			index4E = round ( ( He2 - DimOffset(FinalBlendKE, 0) ) / DimDelta(FinalBlendKE,0) ) + eShift
			
			//SetScale/P y, La2 + aShift*deltaA, deltaA, "" R_Image
			//SetScale/P x, Le2 + eshift*deltaE, deltaE, "" R_Image
					
			//SetScale/P y, La2 + aShift*deltaA, deltaA, "" R_Image_dif
			//SetScale/P x, Le2 + eshift*deltaE, deltaE, "" R_Image_dif
			
			if(checked)
				TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image_dif(x)(y)
			else
				TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
			endif
				
			//TemporaryHoldKE_R[index2E,index4E][index2A,Index4A] = R_Image(x)(y)
			
			SetDataFolder root:Blending_Panel
			NVAR Normalization
			TemporaryHoldKE_R = TemporaryHoldKE_R*Normalization
			
			Variable totalNrPixA
			Variable totalNrPixE
			totalNrPixA = DimSize(FinalBlendKE,1)
			totalNrPixE = DimSize(FinalBlendKE,0)
			
			Make/O/N=(totalNrPixA) Crossection6
			Make/O/N=(totalNrPixA) Crossection7
			
			Make/O/N=(totalNrPixE) Crossection8
			Make/O/N=(totalNrPixE) Crossection9
			
			//DoWindow/F Blended_Panel					//pulls the window to the front
			//If(V_flag != 0)									//checks if there is a window....
			//	KillWindow Blended_Panel
			//endif
			//Display_Blended_Panel()
			
			Slider slider0,limits={0,(totalNrPixE - 1),1}
			Slider slider1,limits={0,(totalNrPixA - 1),1}
			
			Variable num2
			ControlInfo /W=Blended_Panel buttonUD
			num2 = strsearch(S_recreation,"Down",0)
			
			Variable index3Ehalf
  			index3Ehalf = round(index3E/2)
  			
			if(num2 != -1)
				Button buttonUD,title="Down"
				FinalBlendKE[index2E,index4E][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
				FinalBlendKE[index1E,index3E][index1A,Index3A] = TemporaryHoldKE_L[p][q]
				execute/Z/Q "Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE "+num2str(index3Ehalf)+"," +num2str(index3A)
				//Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0, index3A 
			else
				Button buttonUD,title="Up"
				FinalBlendKE[index1E,index3E][index1A,Index3A] = TemporaryHoldKE_L[p][q]
				FinalBlendKE[index2E,index4E][index2A+1,index4A] = TemporaryHoldKE_R[p][q]
				execute/Z/Q "Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE " +num2str(index3Ehalf)+"," +num2str(index2A)	
				//Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0,index2A 
			endif	
			
			DoUpdate
			
			//AppendImage /W=Blended_Panel#G0 FinalBlendKE
			//ModifyGraph  /W=Blended_Panel#G0 swapXY=1
			
			//AppendToGraph /W=Blended_Panel#G1 Crossection6
			//AppendToGraph /W=Blended_Panel#G1 /C=(0,65535,0) Crossection7
			
			//ModifyGraph /W=Blended_Panel#G2 swapXY=1
			//AppendToGraph /W=Blended_Panel#G2 Crossection8
			//AppendToGraph /W=Blended_Panel#G2 /C=(0,65535,0) Crossection9
			//ModifyGraph /W=Blended_Panel#G2 notation(bottom)=1
			
			//execute/Z/Q "Cursor/A=1 /W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) A FinalBlendKE 0," +num2str(index3A)
			//execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=1/C=(65280,0,0) B FinalBlendKE 0,0"
			//CursorDependencyForGraph()
			//execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,65280,0) B ImageLR 0," + num2str(jmax -1- jmin)
			//execute/Z/Q "Cursor/W=Blended_Panel#G0 /P/I/H=2/C=(0,0,65280) C ImageLR 0," + nu1m2str(jmax -1)
			SetVariable setvar0 value = _NUM:0
			ValDisplay valdispAvg,value=_NUM:0
			//Killwaves tImageLR1,tImageLR2
			
			
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ShowHideCursor(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
			
			String name1
			name1 = ImageNameList("", "" )
			name1 = StringFromList (0, name1  , ";")
			
			DoUpdate
			Setdatafolder root:folder3D:
			Variable help6
			ControlInfo /W=k_Space_2D check5
			help6 = V_value
			if(help6)
				WAVE Images3D = Images3Dder
			else
				WAVE Images3D = Images3D
			endif
			
			NVAR PE = PhotonEnergy
			NVAR WF = WorkFunction
			NVAR KF = KineticFermi
							
			WAVE Image3
			//WAVE Images3D
			WAVE LayerN_K
			WAVE CutX_K
			WAVE CutY_K
				
			WAVE M_InterpolatedImage
			WAVE Image1 = $name1
			WAVE VCS = VCS
			WAVE Multipliers
			WAVE ImageX
			WAVE ImageY
			//WAVE Images3D
				
			Variable x2,y2
			Variable numPixX	
			Variable numPixY
			
			Variable checked2
			ControlInfo /W=k_Space_2D check2
			checked2 = V_value
			if(checked2)
				numPixX = DimSize(LayerN_K,1)
				numPixY = DimSize(LayerN_K,0)
			else
				numPixX = DimSize(Image3,1)
				numPixY = DimSize(Image3,0)
			endif
			Variable x0,x1,y0,y1
					
			if(checked)
				if(DataFolderExists("root:WinGloBals:k_Space_2D:"))
					KillDataFolder root:WinGloBals:k_Space_2D
				endif
				execute/Z/Q "Cursor /K A "
				execute/Z/Q "Cursor/W=# /P/I/H=0/S=0/C=(0,65280,0) I "+name1+" "+ num2str(numPixY/2-1) +"," + num2str(0)
				execute/Z/Q "Cursor/W=# /P/I/H=0/S=0/C=(0,65280,0) J "+name1+" "+ num2str(numPixY/2-1) +"," + num2str(numPixX-1)
				DoUpdate
				y0 = hcsr(I)
				x0 = vcsr(I)
				y1 = hcsr(J)
				x1 = vcsr(J) 
				DrawAction getgroup=line, delete
				SetDrawEnv gstart,gname= line
				SetDrawEnv xcoord= bottomImage3,ycoord= leftImage3
				SetDrawEnv linefgc= (65535,0,0)
				DrawLine x0, y0, x1, y1
 				SetDrawEnv gstop
 				DoUpdate
 				CursorDependencyForGraph4()
 				Slider Line1 , disable=2
 				Slider Line2 , disable=2
 				CheckBox check2, disable=2
 				
 				Variable numPixE
 				Variable numPixK
 				numPixE = DimSize(Images3D,0)
 				if(numPixX>numPixY)
 					numPixK = numPixX*2
 				else
 					numPixK = numPixY*2
 				endif
 				SetDataFolder root:folder3D
 				Make/O /N=(numPixE,numPixK) Plane1
				
 				DoWindow/F $"Arbitrary_Plane"			//pulls the window to the front
				if (V_Flag==0)	
					Display/K=1 /W=(10,70,390,417)
					Dowindow/C $"Arbitrary_Plane"	
					ControlBar/T 70
					AppendImage /L=left /B=bottom Plane1
					ModifyGraph  swapXY=1
					ModifyGraph margin =40
					ModifyGraph margin(right) =20
					ModifyGraph margin(top) =20
					
					if(checked2)

						Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
						Variable delta_k_n , delta_k_m , delta_phi , delta_theta
						Variable k_n0 , k_m0 
						Variable phi1 , phi2 , theta1 , theta2
						Variable i_n , j_m 
						Variable n_max , m_max
						Variable i_max , j_max
						Variable i_1 , i_2 , j_1 , j_2
						Variable wL , wR , wU , wD 
						Variable o , o_max , E_o0 , delta_E , E_o,C1, C2
						
						Variable k_0 , k_max , k_nmax, k_mmax
						Variable alfa_rad , sin_alfa , cos_alfa 
						Variable delta_k_ , i
						
						C2 = 180/Pi
						alfa_rad = atan((x1-x0)/(y1-y0))
						sin_alfa = sin(alfa_rad)
						cos_alfa = cos(alfa_rad)
						
						k_n0 = y0
						k_m0 = x0
						k_nmax = y1
						k_mmax = x1
						
						k_0 = k_m0*sin_alfa 
						k_0 = k_0 + k_n0*cos_alfa
						k_max = k_mmax*sin_alfa + k_nmax*cos_alfa
						
						SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , Plane1
						SetScale /I y, k_0, k_max , "" , Plane1
						
						delta_k_ = DimDelta (Plane1,1)
						delta_E = DimDelta (Plane1,0)
						
						Variable phi0 , phiMax , theta0 , thetaMax
						phi0 = DimOffset(Images3D,1)
						phiMax = DimOffset(Images3D,1) + (DimSize(Images3D,1) - 1)*DimDelta(Images3D,1)
						theta0 = DimOffset(Images3D,2)
						thetaMax = DimOffset(Images3D,2) + (DimSize(Images3D,2) - 1)*DimDelta(Images3D,2)
				
						delta_phi = DimDelta(Images3D,1)
						delta_theta = DimDelta(Images3D,2)
					
						i_max = DimSize (Plane1,1)
						o_max = DimSize (Plane1,0)

						E_o0 = DimOffset (Plane1,0)
						
						delta_k_m = delta_k_*sin_alfa
						delta_k_n = delta_k_*cos_alfa
						delta_E = DimDelta (Plane1,0)
						
						//i_max = DimSize (Images3D,1) - 1
						//j_max = DimSize (Images3D,2) - 1
						
						k_n = k_n0
						k_m = k_m0
						E_o = PE-WF-KF+E_o0
						Plane1 = Nan
						DoUpdate
						for(o=0;o<o_max;o=o+1)
							C1 = 1/(0.512*sqrt(E_o))
							for( i=0;i<i_max;i=i+1)
								phi_n_rad = asin( k_n * C1 )
								phi_n = phi_n_rad * C2
								if(phi_n>=phi0 && phi_n<=phiMax)
									i_n = (phi_n - phi0)/delta_phi
									//if(i_n>=0 && i_n<=i_max)
									//for( m=0;m<m_max;m=m+1)
									theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
										j_m = (theta_m - theta0)/delta_theta
										if(theta_m>=theta0 && theta_m<=thetaMax)	
											i_1 = floor(i_n)
											i_2 = ceil(i_n)
											j_1 = floor(j_m)
											j_2 = ceil(j_m)
											wR = i_n - i_1
											wL = 1 - wR
											wU = j_m - j_1
											wD = 1 - wU
									
											//Plane1[o][i] = Images3D[o][i_1][j_1]*wL*wD + Images3D[o][i_2][j_1]*wR*wD + Images3D[o][i_1][j_2]*wL*wU + Images3D[o][i_2][j_2]*wR*wU
											Plane1[o][i] = Images3D[o][i_1][j_1]*wL*wD + Images3D[o][i_2][j_1]*wR*wD + Images3D[o][i_1][j_2]*wL*wU + Images3D[o][i_2][j_2]*wR*wU
											//Plane1[o][i] = Images3D[o](theta_m)(phi_n)
											//Plane1[o][n] = Images3D[o](phi_n)(theta_m)
										//else
										//	Plane1[o][n] = Nan
										endif
										//k_m = k_m + delta_k_m
									//endfor
								//else
								//	Plane1[o][n] = Nan
								endif
								//k_m = k_m0
								k_n = k_n + delta_k_n
								k_m = k_m + delta_k_m
							endfor
							k_n = k_n0
							k_m = k_m0
							E_o = E_o + delta_E
						endfor
						
						Duplicate/O Plane1, Plane1_B
						SetScale /P x, (DimOffset( Images3D,0 )-KF), DimDelta(Images3D,0) , "" , Plane1_B
						Wavestats/Q/Z Plane1
				
						TitleBox zmin title="Min",pos={10,10}
						Slider contrastmin1,vert= 0,pos={40,10},size={200,16},proc=contrast2
						Slider contrastmin1,limits={V_min,V_max,0},ticks= 0,value=V_min
			
						TitleBox zmax title="Max",pos={10,40}
						Slider contrastmax1,vert= 0,pos={40,40},size={200,16},proc=contrast2
						Slider contrastmax1,limits={V_min,V_max,0},ticks= 0,value=V_max
						
						CheckBox check1,pos={250,5},size={104,16},title="B/K"
						CheckBox check1,labelBack=(47872,47872,47872),fSize=16,value= 0
						CheckBox check1,proc=ChangeKB	
						
						Button Button_Derivate,pos={380,5},size={100,30},proc=ButtonProc_Derivate1,title="2nd der."
						Button Button_Derivate,fSize=14
						
						SetVariable Gamma_Button,pos={300,5},size={70,20},title="G"
						SetVariable Gamma_Button,fSize=16,limits={0,inf,0.1},value= _NUM:1
						
						SetVariable Smooth1_Button,pos={360,40},size={110,20},title="Smooth"
						SetVariable Smooth1_Button,fSize=16,limits={0,inf,1},value= _NUM:1
						
						Button Button_Export,pos={260,35},size={80,30},proc=ExportImages4,title="Export"
						Button Button_Export,fSize=14
					else
						
					endif
				endif
			else
				execute/Z/Q "Cursor /K J "
				execute/Z/Q "Cursor /K I "
				if(DataFolderExists("root:WinGloBals:k_Space_2D:"))
					KillDataFolder root:WinGloBals:k_Space_2D
				endif
				DoWindow/F $"Arbitrary_Plane"			//pulls the window to the front
				if (V_Flag==1)	
					DoWindow/K $"Arbitrary_Plane"
				endif
				DrawAction getgroup=line, delete
				DoUpdate
				Slider Line1 , disable=0
 				Slider Line2 , disable=0
 				CheckBox check2, disable=0
			endif
			
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_Derivate1(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:folder3D:
			
			NVAR PE = PhotonEnergy
			NVAR WF = WorkFunction
			NVAR KF = KineticFermi
						
			WAVE Images3D
			WAVE Plane1
			String df= GetDataFolder(1);
			Variable x0,x1,y0,y1
			//SetDataFolder root:folder3D:
			DrawAction getgroup=line, delete
			DoUpdate
			y0 = hcsr(I , "k_Space_2D")
			x0 = vcsr(I,"k_Space_2D")
			y1 = hcsr(J,"k_Space_2D")
			x1 = vcsr(J,"k_Space_2D") 
 				
 			Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
			Variable delta_k_n , delta_k_m , delta_phi , delta_theta
			Variable k_n0 , k_m0 
			Variable phi1 , phi2 , theta1 , theta2
			Variable i_n , j_m 
			Variable n_max , m_max
			Variable i_max , j_max
			Variable i_1 , i_2 , j_1 , j_2
			Variable wL , wR , wU , wD 
			Variable o , o_max , E_o0 , delta_E , E_o,C1, C2
						
			Variable k_0 , k_max , k_nmax, k_mmax
			Variable alfa_rad , sin_alfa , cos_alfa 
			Variable delta_k_ , i , j
						
			//C1 = 1/(0.512*sqrt(Energy))
			C2 = 180/Pi
			alfa_rad = atan((x1-x0)/(y1-y0))
			sin_alfa = sin(alfa_rad)
			cos_alfa = cos(alfa_rad)
						
			k_n0 = y0
			k_m0 = x0
			k_nmax = y1
			k_mmax = x1
						
			k_0 = k_m0*sin_alfa 
			k_0 = k_0 + k_n0*cos_alfa
			k_max = k_mmax*sin_alfa + k_nmax*cos_alfa
						
			SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , Plane1
			SetScale /I y, k_0, k_max , "" , Plane1
						
			delta_k_ = DimDelta (Plane1,1)
			delta_E = DimDelta (Plane1,0)
						
			Variable phi0 , phiMax , theta0 , thetaMax
			phi0 = DimOffset(Images3D,1)
			phiMax = DimOffset(Images3D,1) + (DimSize(Images3D,1) - 1)*DimDelta(Images3D,1)
			theta0 = DimOffset(Images3D,2)
			thetaMax = DimOffset(Images3D,2) + (DimSize(Images3D,2) - 1)*DimDelta(Images3D,2)
				
			delta_phi = DimDelta(Images3D,1)
			delta_theta = DimDelta(Images3D,2)
					
			i_max = DimSize (Plane1,1)
			o_max = DimSize (Plane1,0)

			E_o0 = DimOffset (Plane1,0)
						
			delta_k_m = delta_k_*sin_alfa
			delta_k_n = delta_k_*cos_alfa
			delta_E = DimDelta (Plane1,0)
						
			//i_max = DimSize (Images3D,1) - 1
			//j_max = DimSize (Images3D,2) - 1
						
			k_n = k_n0
			k_m = k_m0
			E_o = PE-WF-KF+E_o0
			Plane1 = Nan
			DoUpdate
			for(o=0;o<o_max;o=o+1)
				C1 = 1/(0.512*sqrt(E_o))
				for( i=0;i<i_max;i=i+1)
					phi_n_rad = asin( k_n * C1 )
					phi_n = phi_n_rad * C2
					if(phi_n>=phi0 && phi_n<=phiMax)
						i_n = (phi_n - phi0)/delta_phi
						//if(i_n>=0 && i_n<=i_max)
						//for( m=0;m<m_max;m=m+1)
						theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
							j_m = (theta_m - theta0)/delta_theta
							if(theta_m>=theta0 && theta_m<=thetaMax)	
								i_1 = floor(i_n)
								i_2 = ceil(i_n)
								j_1 = floor(j_m)
								j_2 = ceil(j_m)
								wR = i_n - i_1
								wL = 1 - wR
								wU = j_m - j_1
								wD = 1 - wU
								
								//Plane1[o][i] = Images3D[o][i_1][j_1]*wL*wD + Images3D[o][i_2][j_1]*wR*wD + Images3D[o][i_1][j_2]*wL*wU + Images3D[o][i_2][j_2]*wR*wU
								Plane1[o][i] = Images3D[o][i_1][j_1]*wL*wD + Images3D[o][i_2][j_1]*wR*wD + Images3D[o][i_1][j_2]*wL*wU + Images3D[o][i_2][j_2]*wR*wU
								//Plane1[o][i] = Images3D[o](theta_m)(phi_n)
								//Plane1[o][n] = Images3D[o](phi_n)(theta_m)
							else
								Plane1[o][n] = Nan
							endif
							//k_m = k_m + delta_k_m
						//endfor
					else
						Plane1[o][n] = Nan
					endif
					//k_m = k_m0
					k_n = k_n + delta_k_n
					k_m = k_m + delta_k_m
				endfor
				k_n = k_n0
				k_m = k_m0
				E_o = E_o + delta_E
			endfor
			Duplicate/O Plane1, Plane1_B
			SetScale /P x, (DimOffset( Images3D,0 )-KF), DimDelta(Images3D,0) , "" , Plane1_B		
				
			Variable val1,val2	, nPointsX , nPointsY

			nPointsX = DimSize(Plane1,0)
			nPointsY = DimSize(Plane1,1)
			Make/O/N =(nPointsX)  v1 
			
			ControlInfo Smooth1_Button
			val1 = V_value
			ControlInfo Gamma_Button
			val2 = V_value
			
			if(val1 > 0 )
				for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
					v1 =  Plane1[p][i]
					Smooth val1 , v1
					Plane1[][i] = v1[p]
				endfor
			endif
			
			if(val1 > 0 )
				for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
					v1 =  Plane1_B[p][i]
					Smooth val1 , v1
					Plane1_B[][i] = v1[p]
				endfor
			endif
			
			for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
				v1 =  Plane1[p][i]
				//Smooth 2 , v1
				Differentiate/METH=0/EP=0 v1
				Differentiate/METH=0/EP=0 v1
				Plane1[][i] = -v1[p]
			endfor
			
			for(i = 0; i <nPointsY;i+=1)	// Initialize variables;continue test
				v1 =  Plane1_B[p][i]
				//Smooth 2 , v1
				Differentiate/METH=0/EP=0 v1
				Differentiate/METH=0/EP=0 v1
				Plane1_B[][i] = -v1[p]
			endfor
			
			for(i = 0; i <nPointsX;i+=1)	// Initialize variables;continue test
				for(j = 0; j <nPointsY;j+=1)
					if(Plane1[i][j] < 0)
						Plane1[i][j] = 0 
						Plane1_B[i][j] = 0	
					endif
				endfor
			endfor
			
			String nameS
			nameS = ImageNameList("", "" )
			nameS = StringFromList (0, nameS  , ";")
			WAVE w = $nameS
			w = w^val2	
			Wavestats/Q/Z $nameS
			DoWindow/F $"Arbitrary_Plane"			//pulls the window to the front
			DoUpdate
			if (V_Flag==1)	
				Slider contrastmin1,limits={V_min,V_max,0},value=V_min
				Slider contrastmax1,limits={V_min,V_max,0},value=V_max
				//ModifyImage /W=$name3 $name2, ctab= {V_min,V_max,,0}
				ModifyImage $nameS, ctab= {V_min,V_max,,0}
			endif

			KillWaves v1
			
			break
	endswitch

	return 0
End

Function CursorDependencyForGraph4()
	String graphName = WinName(0,1)
	
	//String graphName1= "k_Space_2D"
	if( strlen(graphName) )
		String df= GetDataFolder(1);
		NewDataFolder/O root:WinGlobals
		NewDataFolder/O/S root:WinGlobals:$graphName
 		String/G S_CursorJInfo
		Variable/G dependentJ
		SetFormula dependentJ, "CursorMoved4(S_CursorJInfo)"
		
		String/G S_CursorIInfo
		Variable/G dependentI
		SetFormula dependentI, "CursorMoved4(S_CursorIInfo)"
		
		SetDataFolder df
	endif
End

Function CursorMoved4(info)
	String info
	
	Variable result= NaN			// error result
	// Check that the top graph is the one in the info string.
	String name2 = WinName(0,1)
	String graphName= StringByKey("GRAPH", info)
	GetWindow $name2 activeSW
	String name3 = name2
	if( CmpStr(name3, S_value) == 0 )
		if( CmpStr(graphName, name2) == 0 )
			// If the cursor is being turned off
			// the trace name will be zero length.
			String tName= StringByKey("TNAME", info)
			if( strlen(tName) )			// cursor still on
			
				Setdatafolder root:folder3D:
				Variable help6
				ControlInfo /W=k_Space_2D check5
				help6 = V_value
				if(help6)
					WAVE Images3D = Images3Dder
				else
					WAVE Images3D = Images3D
				endif
				NVAR PE = PhotonEnergy
				NVAR WF = WorkFunction
				NVAR KF = KineticFermi
							
				//WAVE Images3D
				WAVE Plane1
			
				String df= GetDataFolder(1);
				Variable x0,x1,y0,y1
				//SetDataFolder root:folder3D:
				DrawAction getgroup=line, delete
				DoUpdate
				y0 = hcsr(I)
				x0 = vcsr(I)
				y1 = hcsr(J)
				x1 = vcsr(J) 
				SetDrawEnv gstart,gname= line
				SetDrawEnv xcoord= bottomImage3,ycoord= leftImage3
				SetDrawEnv linefgc= (65535,0,0)
				DrawLine x0, y0, x1, y1
 				SetDrawEnv gstop
 				DoUpdate
 				
 				Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
				Variable delta_k_n , delta_k_m , delta_phi , delta_theta
				Variable k_n0 , k_m0 
				Variable phi1 , phi2 , theta1 , theta2
				Variable i_n , j_m 
				Variable n_max , m_max
				Variable i_max , j_max
				Variable i_1 , i_2 , j_1 , j_2
				Variable wL , wR , wU , wD 
				Variable o , o_max , E_o0 , delta_E , E_o,C1, C2
						
				Variable k_0 , k_max , k_nmax, k_mmax
				Variable alfa_rad , sin_alfa , cos_alfa 
				Variable delta_k_ , i
						
				//C1 = 1/(0.512*sqrt(Energy))
				C2 = 180/Pi
				alfa_rad = atan((x1-x0)/(y1-y0))
				sin_alfa = sin(alfa_rad)
				cos_alfa = cos(alfa_rad)
						
				k_n0 = y0
				k_m0 = x0
				k_nmax = y1
				k_mmax = x1
						
				k_0 = k_m0*sin_alfa 
				k_0 = k_0 + k_n0*cos_alfa
				k_max = k_mmax*sin_alfa + k_nmax*cos_alfa
						
				SetScale /P x, DimOffset(Images3D,0), DimDelta(Images3D,0) , "" , Plane1
				SetScale /I y, k_0, k_max , "" , Plane1
						
				delta_k_ = DimDelta (Plane1,1)
				delta_E = DimDelta (Plane1,0)
						
				Variable phi0 , phiMax , theta0 , thetaMax
				phi0 = DimOffset(Images3D,1)
				phiMax = DimOffset(Images3D,1) + (DimSize(Images3D,1) - 1)*DimDelta(Images3D,1)
				theta0 = DimOffset(Images3D,2)
				thetaMax = DimOffset(Images3D,2) + (DimSize(Images3D,2) - 1)*DimDelta(Images3D,2)
				
				delta_phi = DimDelta(Images3D,1)
				delta_theta = DimDelta(Images3D,2)
					
				i_max = DimSize (Plane1,1)
				o_max = DimSize (Plane1,0)

				E_o0 = DimOffset (Plane1,0)
						
				delta_k_m = delta_k_*sin_alfa
				delta_k_n = delta_k_*cos_alfa
				delta_E = DimDelta (Plane1,0)
						
				//i_max = DimSize (Images3D,1) - 1
				//j_max = DimSize (Images3D,2) - 1
						
				k_n = k_n0
				k_m = k_m0
				E_o = PE-WF-KF+E_o0
				Plane1 = Nan
				
				Variable sinPhi
				Variable cosPhi
				Variable sinTheta
				Variable deltaFiPrime
				Variable deltaThetaPrime
				Variable sinAlfa
				Variable cosAlfa
				Variable C3,C4
				C2 = 180/Pi
				C3 = Pi/180
				ControlInfo /W=k_Space_2D rotation
				help6 = V_value
				Variable help2
				ControlInfo /W=k_Space_2D Param1
				help2 = V_value
				
				sinAlfa = sin(help6*C3)
				cosAlfa = cos(help6*C3)
						
				DoUpdate
				for(o=0;o<o_max;o=o+1)
					C1 = 1/(0.512*sqrt(E_o))
					for( i=0;i<i_max;i=i+1)
						sinPhi = C1*(cosAlfa*k_n - sinAlfa*k_m)
						phi_n_rad = asin( sinPhi )
						phi_n = phi_n_rad * C2
						//i_n = (phi_n - phi0)/delta_phi
						if(phi_n>=phi0 && phi_n<=phiMax)
							i_n = (phi_n - phi0)/delta_phi
							cosPhi = sqrt(1-sinPhi*sinPhi)
							C4 = C1/ cosPhi
							sinTheta = C4*(sinAlfa*k_n + cosAlfa*k_m)
							theta_m = asin( sinTheta ) * C2
							//j_m = (theta_m - theta0)/delta_theta	
							if(theta_m>=theta0 && theta_m<=thetaMax)	
								j_m = (theta_m - theta0)/delta_theta
								i_1 = floor(i_n)
								i_2 = ceil(i_n)
								j_1 = floor(j_m)
								j_2 = ceil(j_m)
								wR = i_n - i_1
								wL = 1 - wR
								wU = j_m - j_1
								wD = 1 - wU
										
								//Plane1[o][i] = Images3D[o][i_1][j_1]*wL*wD + Images3D[o][i_2][j_1]*wR*wD + Images3D[o][i_1][j_2]*wL*wU + Images3D[o][i_2][j_2]*wR*wU
								Plane1[o][i] = Images3D[o][i_1][j_1]*wL*wD + Images3D[o][i_2][j_1]*wR*wD + Images3D[o][i_1][j_2]*wL*wU + Images3D[o][i_2][j_2]*wR*wU
								//Plane1[o][i] = Images3D[o](theta_m)(phi_n)
								//Plane1[o][n] = Images3D[o](phi_n)(theta_m)
							else
								Plane1[o][n] = Nan
							endif
							//k_m = k_m + delta_k_m
						//endfor
						else
							Plane1[o][n] = Nan
						endif
						//k_m = k_m0
						k_n = k_n + delta_k_n
						k_m = k_m + delta_k_m
					endfor
					k_n = k_n0
					k_m = k_m0
					E_o = E_o + delta_E
				endfor
				if( help2 != 1)
					Plane1 = Plane1^help2
				endif
						
				Duplicate/O Plane1, Plane1_B
				SetScale /P x, (DimOffset( Images3D,0 )-KF), DimDelta(Images3D,0) , "" , Plane1_B		
				Wavestats/Q/Z Plane1
				DoWindow/F $"Arbitrary_Plane"			//pulls the window to the front
				DoUpdate
				if (V_Flag==1)	
					Slider contrastmin1,limits={V_min,V_max,0},value=V_min
					Slider contrastmax1,limits={V_min,V_max,0},value=V_max
					String nameS
					nameS = ImageNameList("", "" )
					nameS = StringFromList (0, nameS  , ";")
					ModifyImage $nameS, ctab= {V_min,V_max,,0}
				endif
				DoWindow/F $"k_Space_2D"
						
			endif
		endif
	endif
	return result
End

Function ShowTools1(cba) : CheckBoxControl
	STRUCT WMCheckboxAction &cba

	switch( cba.eventCode )
		case 2: // mouse up
			Variable checked = cba.checked
	
			if(checked)
				ShowTools  /W=$cba.win
			else
				HideTools  /W=$cba.win
			endif
			
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_MakeMovie(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:folder3D:
			Variable help6
			ControlInfo /W=k_Space_2D check5
			help6 = V_value
			if(help6)
				WAVE Images3D = Images3Dder
			else
				WAVE Images3D = Images3D
			endif
			String name2 
			name2 = ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			Wave wave0 = $name2
			
			NVAR KineticFermi
			NVAR PhotonEnergy
			NVAR WorkFunction
			Variable KF = KineticFermi
			Variable PE = PhotonEnergy
			Variable WF = WorkFunction
			WAVE LayerN_K
			//WAVE Images3D
			
			Variable delta0, delta1
			delta0 = DimDelta (LayerN_K,0)
			delta1 = DimDelta (LayerN_K,1)
			
			Variable deltaTime = 10
			Variable startingN = Nan
			Variable endAt = Nan
			
			Prompt deltaTime, "Frame rate [1/s]:"
			Prompt startingN, "Start From:"
			Prompt endAt,"End At:"
			DoPrompt "SET PARMETERS FOR MOVIE",deltaTime, startingN,endAt
			
			if (V_Flag)
				return 0									// user canceled
			endif
			
			if(startingN == Nan || endAt == Nan)
				return 0
			endif
	
			if(startingN==endAt)
				return 0 
			endif
			
			Variable deltaN
			if(startingN>endAt)
				deltaN =  -1 
			else 
				deltaN = 1
			endif
			
			Variable x1 , x2 , y1, y2
			
			GetAxis leftImage3
			y1 = V_min
			y2 = V_max
			GetAxis bottomImage3
			x1 = V_min
			x2 = V_max
			
			NewDatafolder/O root:Movie3D
			SetDataFolder root:Movie3D
			Variable numPixX , numPixY
			numPixX = ceil((x2 - x1)/delta1)
			numPixY = ceil((y2 - y1)/delta0)
			Make/O /N=(numPixY,numPixX) Frame
			SetScale/I x , y1,y2, Frame
			SetScale/I y, x1,x2, Frame
			
			Variable i
			Variable C1,C2
			Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
			Variable delta_k_n , delta_k_m , delta_phi , delta_theta
			Variable k_n0 , k_m0 , phi0 , theta0
			Variable phi1 , phi2 , theta1 , theta2
			Variable i_n , j_m 
			Variable n_max , m_max
			Variable i_max , j_max
			Variable i_1 , i_2 , j_1 , j_2
			Variable wL , wR , wU , wD 
			Variable energy2
			Variable help1,help2,help3,help4
			String help5
			Variable x0 ,deltaE , energy
			ControlInfo /W=k_Space_2D check1
			help1 = V_value
			ControlInfo /W=k_Space_2D Param1
			help2 = V_value
			ControlInfo /W=k_Space_2D check2
			help3 = V_value
			ControlInfo /W=k_Space_2D Energy1
			help4 = V_value
			ControlInfo /W=k_Space_2D popup0
			help5 = S_value
			
			x0 = DimOffset (Images3D,0)
			deltaE = DimDelta (Images3D,0)
			n_max = DimSize (LayerN_K,0)
			m_max = DimSize (LayerN_K,1)
		
			k_n0 = DimOffset (LayerN_K,0)
			k_m0 = DimOffset (LayerN_K,1)
					
			delta_k_n = DimDelta (LayerN_K,0)
			delta_k_m = DimDelta (LayerN_K,1)
					
			i_max = DimSize (Images3D,1) - 1
			j_max = DimSize (Images3D,2) - 1
					
			phi0 = DimOffset (Images3D,1)
			theta0 = DimOffset (Images3D,2)
					
			delta_phi = DimDelta (Images3D,1)
			delta_theta = DimDelta (Images3D,2)
			C2 = 180/Pi
			k_n = k_n0
			k_m = k_m0	
			CloseMovie
			String filenameStr
			Variable framerate
			framerate = deltaTime
			NewMovie /F=(frameRate) /A
				
			for(i = startingN ; i != (endAt +deltaN) ; i = i + deltaN)
				energy = x0 + i*deltaE
				energy2 = PE-WF+ energy - KF
				C1 = 1/(0.512*sqrt(energy2))

				for( n=0;n<n_max;n=n+1)
					phi_n_rad = asin( k_n * C1 )
					phi_n = phi_n_rad * C2
					i_n = (phi_n - phi0)/delta_phi
					if(i_n>=0 && i_n<=i_max)
						for( m=0;m<m_max;m=m+1)
							theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
							j_m = (theta_m - theta0)/delta_theta
							if(j_m>=0 && j_m<=j_max)	
								i_1 = floor(i_n)
								i_2 = ceil(i_n)
								j_1 = floor(j_m)
								j_2 = ceil(j_m)
								wR = i_n - i_1
								wL = 1 - wR
								wU = j_m - j_1
								wD = 1 - wU
								LayerN_K[n][m] = Images3D(energy)[i_1][j_1]*wL*wD + Images3D(energy)[i_2][j_1]*wR*wD + Images3D(energy)[i_1][j_2]*wL*wU + Images3D(energy)[i_2][j_2]*wR*wU
							else
								LayerN_K[n][m] = Nan
							endif
							k_m = k_m + delta_k_m
						endfor
					else
						LayerN_K[n][] = Nan
					endif
					k_m = k_m0
					k_n = k_n + delta_k_n
				endfor	
				k_n = k_n0
				k_m = k_m0
				
				if( help2 != 1)
					LayerN_K = LayerN_K^help2
				endif
				
				Wavestats/Q/Z wave0
				DoUpdate
				ModifyImage $name2, ctab= {V_min,V_max,$help5,0}
					
				DoUpdate
				AddMovieFrame
			endfor
			CloseMovie
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_Avarage(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			Setdatafolder root:folder3D:
			Variable help6
			ControlInfo /W=k_Space_2D check5
			help6 = V_value
			if(help6)
				WAVE Images3D = Images3Dder
			else
				WAVE Images3D = Images3D
			endif
			String name2 
			name2 = ImageNameList("", "" )
			name2 = StringFromList (0, name2  , ";")
			Wave wave0 = $name2
			
			NVAR KineticFermi
			NVAR PhotonEnergy
			NVAR WorkFunction
			Variable KF = KineticFermi
			Variable PE = PhotonEnergy
			Variable WF = WorkFunction
			WAVE LayerN_K
			//WAVE Images3D
			
			Variable delta0, delta1
			delta0 = DimDelta (LayerN_K,0)
			delta1 = DimDelta (LayerN_K,1)
			
			Variable deltaTime = 10
			Variable startingN = Nan
			Variable endAt = Nan
			
			Prompt startingN, "Start From:"
			Prompt endAt,"End At:"
			DoPrompt "SET PARMETERS FOR AVERAGE", startingN,endAt
			
			if (V_Flag)
				return 0									// user canceled
			endif
			
			if(startingN == Nan || endAt == Nan)
				return 0
			endif
	
			if(startingN==endAt)
				return 0 
			endif
			
			Variable deltaN
			if(startingN>endAt)
				deltaN =  -1 
			else 
				deltaN = 1
			endif
			
			Variable x1 , x2 , y1, y2
			
			GetAxis leftImage3
			y1 = V_min
			y2 = V_max
			GetAxis bottomImage3
			x1 = V_min
			x2 = V_max
			
			Duplicate/O LayerN_K , TempAve 
			Duplicate/O LayerN_K , Average
			Average = 0
			
			Variable i
			Variable C1,C2
			Variable n , m , k_n , k_m , phi_n , theta_m , phi_n_rad
			Variable delta_k_n , delta_k_m , delta_phi , delta_theta
			Variable k_n0 , k_m0 , phi0 , theta0
			Variable phi1 , phi2 , theta1 , theta2
			Variable i_n , j_m 
			Variable n_max , m_max
			Variable i_max , j_max
			Variable i_1 , i_2 , j_1 , j_2
			Variable wL , wR , wU , wD 
			Variable energy2
			Variable help1,help2,help3,help4
			String help5
			Variable x0 ,deltaE , energy
			ControlInfo /W=k_Space_2D check1
			help1 = V_value
			ControlInfo /W=k_Space_2D Param1
			help2 = V_value
			ControlInfo /W=k_Space_2D check2
			help3 = V_value
			ControlInfo /W=k_Space_2D Energy1
			help4 = V_value
			ControlInfo /W=k_Space_2D popup0
			help5 = S_value
			
			x0 = DimOffset (Images3D,0)
			deltaE = DimDelta (Images3D,0)
			n_max = DimSize (LayerN_K,0)
			m_max = DimSize (LayerN_K,1)
		
			k_n0 = DimOffset (LayerN_K,0)
			k_m0 = DimOffset (LayerN_K,1)
					
			delta_k_n = DimDelta (LayerN_K,0)
			delta_k_m = DimDelta (LayerN_K,1)
					
			i_max = DimSize (Images3D,1) - 1
			j_max = DimSize (Images3D,2) - 1
					
			phi0 = DimOffset (Images3D,1)
			theta0 = DimOffset (Images3D,2)
					
			delta_phi = DimDelta (Images3D,1)
			delta_theta = DimDelta (Images3D,2)
			C2 = 180/Pi
			k_n = k_n0
			k_m = k_m0	
				
			for(i = startingN ; i != (endAt +deltaN) ; i = i + deltaN)
				energy = x0 + i*deltaE
				energy2 = PE-WF+ energy - KF
				C1 = 1/(0.512*sqrt(energy2))

				for( n=0;n<n_max;n=n+1)
					phi_n_rad = asin( k_n * C1 )
					phi_n = phi_n_rad * C2
					i_n = (phi_n - phi0)/delta_phi
					if(i_n>=0 && i_n<=i_max)
						for( m=0;m<m_max;m=m+1)
							theta_m = asin( k_m * C1 / cos( phi_n_rad ) ) * C2
							j_m = (theta_m - theta0)/delta_theta
							if(j_m>=0 && j_m<=j_max)	
								i_1 = floor(i_n)
								i_2 = ceil(i_n)
								j_1 = floor(j_m)
								j_2 = ceil(j_m)
								wR = i_n - i_1
								wL = 1 - wR
								wU = j_m - j_1
								wD = 1 - wU
								TempAve[n][m] = Images3D(energy)[i_1][j_1]*wL*wD + Images3D(energy)[i_2][j_1]*wR*wD + Images3D(energy)[i_1][j_2]*wL*wU + Images3D(energy)[i_2][j_2]*wR*wU
							else
								TempAve[n][m] = Nan
							endif
							k_m = k_m + delta_k_m
						endfor
					else
						TempAve[n][] = Nan
					endif
					k_m = k_m0
					k_n = k_n + delta_k_n
				endfor	
				k_n = k_n0
				k_m = k_m0
				
				if( help2 != 1)
					TempAve = TempAve^help2
				endif
				
				Average = Average + TempAve
					
			endfor
			LayerN_K = Average
			Wavestats/Q/Z wave0
			DoUpdate
			Slider contrastmin,limits={V_min,V_max,0} 
			Slider contrastmax,limits={V_min,V_max,0}
			ModifyImage $name2, ctab= {V_min,V_max,$help5,0}
			DoUpdate
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function tabs1(ba) : TabControl
	STRUCT WMTabControlAction  &ba

	WAVE/T ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
	WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
	SetDataFolder root:Load_and_Set_Panel
	NVAR last_tab
	Variable new_tab = ba.tab
	String name1, name2,name3,name4,name5
	Variable size1
	size1 = DimSize(ListWave,0)
	
	if(last_tab != new_tab)
		if(new_tab !=14 && last_tab != 14)
			name1 = "setvar"+num2str(last_tab)+"1"
			name2 = "setvar"+num2str(last_tab)+"2"
			name3 = "setvar"+num2str(last_tab)+"3"
			name4 = "check"+num2str(last_tab)
			SetVariable $name1 , disable=1
			SetVariable $name2 , disable=1
			SetVariable $name3 , disable=1
			CheckBox $name4 , disable=1
			name1 = "setvar"+num2str(new_tab)+"1"
			name2 = "setvar"+num2str(new_tab)+"2"
			name3 = "setvar"+num2str(new_tab)+"3"
			name4 = "check"+num2str(new_tab)
			SetVariable $name1 , disable=0
			SetVariable $name2 , disable=0
			SetVariable $name3 , disable=0
			CheckBox $name4 , disable=0
		endif
		if( new_tab==14 && last_tab!=14)
			name1 = "setvar"+num2str(last_tab)+"1"
			name2 = "setvar"+num2str(last_tab)+"2"
			name3 = "setvar"+num2str(last_tab)+"3"
			name4 = "check"+num2str(last_tab)
			SetVariable $name1 , disable=1
			SetVariable $name2 , disable=1
			SetVariable $name3 , disable=1
			CheckBox $name4 , disable=1
			name1 = "check"+num2str(new_tab)+"1"
			name2 = "check"+num2str(new_tab)+"2"
			name3 = "check"+num2str(new_tab)+"3"
			name4 = "check"+num2str(new_tab)+"4"
			name5 = "check"+num2str(new_tab)
			CheckBox $name1 , disable=0
			CheckBox $name2 , disable=0
			CheckBox $name3 , disable=0
			CheckBox $name4 , disable=0	
			CheckBox $name5 , disable=0	
		endif
		if(new_tab!=14 && last_tab==14)
			name1 = "check"+num2str(last_tab)+"1"
			name2 = "check"+num2str(last_tab)+"2"
			name3 = "check"+num2str(last_tab)+"3"
			name4 = "check"+num2str(last_tab)+"4"
			name5 = "check"+num2str(last_tab)
			CheckBox $name1 , disable=1
			CheckBox $name2 , disable=1
			CheckBox $name3 , disable=1
			CheckBox $name4 , disable=1	
			CheckBox $name5 , disable=1	
			name1 = "setvar"+num2str(new_tab)+"1"
			name2 = "setvar"+num2str(new_tab)+"2"
			name3 = "setvar"+num2str(new_tab)+"3"
			name4 = "check"+num2str(new_tab)
			SetVariable $name1 , disable=0
			SetVariable $name2 , disable=0
			SetVariable $name3 , disable=0
			CheckBox $name4 , disable=0		
		endif	
		last_tab=new_tab
	endif
	
End

Function SetMultiple(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			String name1 
			name1 = ba.ctrlName
			strswitch(name1)
				case "Cancel1":
					KillWindow $ba.win
					break
				
				case "Continue1":
					WAVE/T ListWave1 	= 	root:Load_and_Set_Panel:ListWave1
					WAVE 		sw1		=	root:Load_and_Set_Panel:sw1	
					Variable size1,size2
					Variable startingN  
					Variable endAt
					Variable correction,delta, offset
					Variable i,j
					String name2
					Variable column 
					Variable checkSet
					
					size1 = DimSize(ListWave1,1) - 6
					ControlInfo setvar04
					startingN = V_value
					ControlInfo setvar05
					endAt = V_value
					for(j = 0;j<size1;j+=1)
						name2 = "setvar"+num2str(j)+"3"
						ControlInfo $name2
						correction = V_value
						name2 = "setvar"+num2str(j)+"2"
						ControlInfo $name2
						delta = V_value
						name2 = "setvar"+num2str(j)+"1"
						ControlInfo $name2
						offset = V_value
						column = j+2
						name2 = "check"+num2str(j)
						ControlInfo $name2
						checkSet = V_value
						if( checkSet)
							for( i = startingN -1 ; i<(endAt) ; i = i +1 )
								if(correction !=0)
									ListWave1[i][column] = num2str(str2num(ListWave1[i][column]) + correction)
									if(column==8)
										SetDataFolder root:Specs:$listWave1[i][1]
										WAVE wave1 = $listWave1[i][1]
										SetScale_2D( i , wave1 )
									endif
								else
									ListWave1[i][column]  = num2str (offset + delta*(i-startingN +1) )
									if(column==8)
										SetDataFolder root:Specs:$listWave1[i][1]
										WAVE wave1 = $listWave1[i][1]
										SetScale_2D( i , wave1 )
									endif
								endif
							endfor
						endif
					endfor
					column = j+2
					name2 = "check"+num2str(j)
					ControlInfo $name2
					checkSet = V_value
					if( checkSet)
						for( i = startingN -1 ; i<(endAt) ; i = i +1 )
							column = 16
							name2 = "check"+num2str(j)+"1"
							ControlInfo $name2
							checkSet = V_value
							if( checkSet )
								sw1[i][column] = sw1[i][column] | (2^4)
								listWave1[i][column] = num2str(1)
							else
								sw1[i][column] = sw1[i][column] & ~(2^4)
								listWave1[i][column] = num2str(0)
							endif
							name2 = "check"+num2str(j)+"2"
							ControlInfo $name2
							checkSet = V_value
							column +=1
							if( checkSet )
								sw1[i][column] = sw1[i][column] | (2^4)
								listWave1[i][column] = num2str(1)
							else
								sw1[i][column] = sw1[i][column] & ~(2^4)
								listWave1[i][column] = num2str(0)
							endif
							name2 = "check"+num2str(j)+"3"
							ControlInfo $name2
							checkSet = V_value
							column +=1
							if( checkSet )
								sw1[i][column] = sw1[i][column] | (2^4)
								listWave1[i][column] = num2str(1)
							else
								sw1[i][column] = sw1[i][column] & ~(2^4)
								listWave1[i][column] = num2str(0)
							endif
							name2 = "check"+num2str(j)+"4"
							ControlInfo $name2
							checkSet = V_value
							column +=1
							if( checkSet )
								sw1[i][column] = sw1[i][column] | (2^4)
								listWave1[i][column] = num2str(1)
							else
								sw1[i][column] = sw1[i][column] & ~(2^4)
								listWave1[i][column] = num2str(0)
							endif
							
						endfor
					
					endif
					
					KillWindow $ba.win
					break
			endswitch
			
			break
			// click code here
		case -1: // control being killed
			break
	endswitch

	return 0
End

Function ButtonProc_AnalyzeCore(ba) : ButtonControl
	STRUCT WMButtonAction &ba

	switch( ba.eventCode )
		case 2: // mouse up
			// click code here
			
			WAVE 		sw1			=	root:Load_and_Set_Panel:sw1
			WAVE/T 	ListWave = 	root:Load_and_Set_Panel:ListWave1
			
			Variable counter1, counter2
			Variable test2, i, j, number
			String name2
			
			number = DimSize(ListWave,0) 
			counter2 = DimSize(ListWave,1) 
			test2 = 0
			for(i = 0; i < number ; i += 1)
				for(j = 0; j < counter2 ; j += 1)
					if( (sw1[i][j] & 2^0) != 0 )
						test2 = i 
						break
					endif
				endfor
				if( test2 != 0 )
					break
				endif
			endfor
			
			i = test2
			
			name2 =  ListWave[i][1]
			if(	 cmpstr ( name2, "") == 0  )
				return 0
			endif
			
			DoUpdate
			NewPanel /K=1 /W=(10,70,700,700)  /N=Core_Panel
			//ControlBar/T 40
			NewDataFolder/O root:Core_Panel
			SetDataFolder  root:Core_Panel
			
			Display/W=(0.15,0.15,0.98,0.98)/HOST=#
			RenameWindow #,G0
			//AppendImage /W=# Display1
			//ModifyGraph  /W=# swapXY=1 //, noLabel(bottom)=1
			SetActiveSubwindow ##
			break
		case -1: // control being killed
			break
	endswitch

	return 0
End




						
			