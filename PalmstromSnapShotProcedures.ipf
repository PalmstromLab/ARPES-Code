#pragma rtGlobals=3		// Use modern global access method and strict wave access.

Function/D FitFermiLevelFromEspectroscopia()
	Profiles("profiles")
	ShowInfo
	variable autoAbortSecs=0
	variable/G Auto=0
	String win=WinName(0,1)
	if (UserCursorAdjust(win,autoAbortSecs) != 0)
		return -1
	endif
	
	Wave EDC
	variable w0=vcsr(A), w1=(xcsr(B)+xcsr(A))/2, w2=300, w3=vcsr(B)
	print w0
	print w1
	print w2
	print w3
	Make/D/N=4/O W_coef
	W_coef[0] = {w0,w1,w2,w3}
	FuncFit/NTHR=0 FermiEdge W_coef  EDC[pcsr(A),pcsr(B)] /D 
	
	variable Efermi=W_coef[1]
	return Efermi

end

Macro CreateSnapShot(PhotonEnergy,kxmin,kxmax,BEmin,BEmax,tickslikeaboss)
	variable PhotonEnergy
	variable kxmin=-0.5
	variable kxmax=0.5
	variable BEmin=-2.5
	variable BEmax=0.5
	//variable ImageType, 
	variable tickslikeaboss=1
	Prompt PhotonEnergy, "What photon energy is this?"
	Prompt kxmin, "What limit on kx min would you like?"
	Prompt kxmax, "What limit on kx max would you like?"
	Prompt BEmin, "What would you like as the min binding energy?"
	Prompt BEmax, "What would you like as the max binding energy?"
	//String ImageChoice="Normal; 2nd Derivative"
	//String gotticks="No Ticks;With Ticks,Ticks and Labels"
	//Prompt ImageType "Is this a Normal Image or a 2nd Derivative", popup ImageChoice
	Prompt tickslikeaboss, "Like ticks?", popup "No Ticks;With Ticks;Ticks and Labels"

	String CurrentWindow=WinName(0,1)
	Print CurrentWindow
	Variable EFermi=FitFermiLevelFromEspectroscopia()

	//DoPrompt "When I was your age...." PhotonEnergy, kxmin, kxmax, BEmin, BEmax, tickslikeaboss//, ImageType
	DoWindow/C ProfileGraph
	DoWindow/K ProfileGraph
	print "back to the program"
	String KPARnormal, KPAR2D, KPARmatrix
	//CrearGrayScale(EFermi,1,64,"ReCalc")	
	KPARnormal="KPARmatrix"+num2str(PhotonEnergy)+"eV"
	KPAR2D="KPARmatrix2D"+num2str(PhotonEnergy)+"eV"
	KPARmatrix="KPARmatrix"
	
//Normal Graph
	CrearGrayScale(EFermi,1,64,"ReCalc")
	Print "about to run CambiarRealRec"
	CambiarRealRec_button("CambiarRealRec")
	String KPARnormalControl="PlotOf"+num2str(PhotonEnergy)+"eVSnapShot"
	//Wave KPARmatrix
	Duplicate/O $KPARmatrix $KPARnormal
	DoWindow/K $KPARnormalControl
	Display as KPARnormal;AppendImage $KPARnormal
	DoWindow/C $KPARnormalControl
	ModifyImage $KPARnormal ctab= {*,*,Grays,0}
	ModifyGraph width=340.157,height={Aspect,1}
	Label bottom "\\Z18\\f01K\\B||\\M\\Z16(\\Z12Å\\S-1\\M\\Z16)"
	ModifyGraph fSize=18,standoff(left)=0;DelayUpdate
	Label left "\\Z18\\f01Binding energy (eV)"
	SetAxis left BEmin,BEmax;DelayUpdate
	SetAxis bottom kxmin, kxmax
	ModifyGraph margin(top)=43
	wavestats $KPARnormal
	variable/G Scalemin=V_min, Scalemax=V_max
	//String zMinNormal="zMin"+num2str(PhotonEnergy)+"eV", zMaxNormal="zMax"+num2str(PhotonEnergy)+"eV"
	variable/G zMinNormal=V_min
	variable/G zMaxNormal=V_max
	print Scalemin, Scalemax
	ModifyImage $KPARnormal ctab= {-Scalemin/1.1,Scalemax/1.1,Grays,0}
	
	if (tickslikeaboss == 0)
		ModifyGraph mirror=1,axThick=2
	endif
	if (tickslikeaboss == 1)
		ModifyGraph mirror=2,axThick=2
	endif
	if (tickslikeaboss == 2)
		ModifyGraph mirror=3,axThick=2
	endif
	TitleBox zminimo title=num2str(PhotonEnergy)+"eVzMin ",pos={5,25}
	Slider corteminimo,vert= 0,pos={71,27},size={100,16},proc=MycontrastNormal
	Slider corteminimo,limits={Scalemin,Scalemax,0},variable=zMinNormal,ticks= 0
	TitleBox zmaximo title=num2str(PhotonEnergy)+"eVzMax",pos={5,3}
	Slider cortemaximo,vert= 0,pos={71,7},size={100,16},proc=MycontrastNormal
	Slider cortemaximo,limits={Scalemin,Scalemax,0},variable=zMaxNormal,ticks= 0
	ModifyImage $KPARnormal ctab= {Scalemin/1.1,Scalemax/1.1,Grays,0}
	
// 2D Plot
	DoWindow/F $CurrentWindow
	CrearGrayScale(EFermi,2,64,"ReCalc")
	CambiarRealRec_button("CambiarRealRec")
	Duplicate/O KPARmatrix $KPAR2D
	String KPAR2DControl="PlotOf2D"+num2str(PhotonEnergy)+"eVSnapShot"
	DoWindow/K $KPAR2DControl
	Display as KPAR2D;AppendImage $KPAR2D
	DoWindow/C $KPAR2DControl
	ModifyImage $KPAR2D ctab= {*,*,Grays,0}
	ModifyGraph width=340.157,height={Aspect,1}
	Label bottom "\\Z18\\f01K\\B||\\M\\Z16(\\Z12Å\\S-1\\M\\Z16)"
	ModifyGraph fSize=18,standoff(left)=0;DelayUpdate
	Label left "\\Z18\\f01Binding energy (eV)"
	SetAxis left BEmin,BEmax;DelayUpdate
	SetAxis bottom kxmin, kxmax
	ModifyGraph margin(top)=43
	wavestats $KPAR2D
	Variable/G Scalemin2D=V_min
	Variable/G Scalemax2D=V_max
	//String zMin2D="zMin2D"+num2str(PhotonEnergy)+"eV", zMax2D="zMax2D"+num2str(PhotonEnergy)+"eV"
	variable/G zMin2D=V_min, zMax2D=V_max
	print Scalemin, Scalemax
	ModifyImage $KPAR2D ctab= {Scalemin/1.5,Scalemax/1.5,Grays,0}
	
	if (tickslikeaboss == 0)
		ModifyGraph mirror=1,axThick=2
	endif
	if (tickslikeaboss == 1)
		ModifyGraph mirror=2,axThick=2
	endif
	if (tickslikeaboss == 2),axThick=2
		ModifyGraph mirror=3
	endif
	TitleBox zminimo title=num2str(PhotonEnergy)+"eVzMin ",pos={5,25}
	Slider corteminimo,vert= 0,pos={71,27},size={100,16},proc=Mycontrast2D
	Slider corteminimo,limits={Scalemin2D,Scalemax2D,0},variable=zMin2D,ticks= 0
	TitleBox zmaximo title=num2str(PhotonEnergy)+"eVzMax",pos={5,3}
	Slider cortemaximo,vert= 0,pos={71,7},size={100,16},proc=Mycontrast2D
	Slider cortemaximo,limits={Scalemin2D,Scalemax2D,0},variable=zMax2D,ticks= 0
	ModifyImage $KPAR2D ctab= {Scalemin2D/2,Scalemax2D/2,Grays,0}

	
endMacro

Function MycontrastNormal(name, value, event)
		String name	// name of this slider control
		Variable value	// value of slider
		Variable event	// bit field: bit 0: value set; 1: mouse down; 2: mouse up, 3: mouse moved
		
		string nombre=WinName(0,1)[10,strlen(WinName(0,1))]
		Svar serie=root:arups:NombreseriesGLOBAL
		serie=nombre
		variable/G zMinNormal
		//print "varMin="+num2str(varMin)
		variable/G zMaxNormal
		//print "varMax="+num2str(varMax)
		string matriz=StringFromList(0,ImageNameList("", ";"))
		ModifyImage $matriz ctab= {zMinNormal,zMaxNormal,Grays,0}

		return 0	// other return values reserved
End

Function Mycontrast2D(name, value, event)
		String name	// name of this slider control
		Variable value	// value of slider
		Variable event	// bit field: bit 0: value set; 1: mouse down; 2: mouse up, 3: mouse moved
		
		string nombre=WinName(0,1)[10,strlen(WinName(0,1))]
		Svar serie=root:arups:NombreseriesGLOBAL
		serie=nombre
		variable/G zMin2D
		//print "varMin="+num2str(varMin)
		variable/G zMax2D
		//print "varMax="+num2str(varMax)
		string matriz=StringFromList(0,ImageNameList("", ";"))
		ModifyImage $matriz ctab= {zMin2D,zMax2D,Grays,0}

		return 0	// other return values reserved
End
