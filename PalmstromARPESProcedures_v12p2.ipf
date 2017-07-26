#pragma rtGlobals=3		// Use modern global access method and strict wave access.
#include <FilterDialog> menus=0
// Updated by Sean 3-27-16 
//    Includes Waterfall plotting


menu "Macros"
	"FSurf: Save Fermi cuts and current kx and ky slices", SaveAllMyPlots()
	"Kparallel: Build and save 4D kperp matrix", KparFixedKperpConversion()
	"Kparallel: Load kperp matrix for 3 gratings", LoadKperpMatrix()
	"Kparallel: Extract constant variable slice", GetConstantVariableSlice()
	"Kperp: Find the Fermi Level of ImageY", FindFermiLevel()
	"Kperp: Adjust the Fermi level of ImageY or Images3D", AdjustFermiLevel()
	"Kperp: Convert adjusted image to 1D matrix vectors", ConvertTo1DVectorsForKconv()
	"Kperp: Load 1D matrix vectors and convert to kperp graph", Load1DVectors()
	"Other: Adjust Images3D wave parameters", SetImages3DParams()
	"Other: Build X2-G-X1-M-G Plot", buildProjectionPlot()
	"Plot the Ring Current and Flux", PlotRingCurrentandFlux()
end

function TrimWave(IncomingWave, xtrimstart,xtrimfinish,ytrimstart,ytrimfinish)
	// ON THE TYPICAL kx-ky PLOT X IS THE Y AXIS (FLIPPED WINDOW)
	wave IncomingWave
	variable xtrimstart, ytrimstart, xtrimfinish, ytrimfinish
	variable temp
	
	if (xtrimstart > xtrimfinish)
		temp = xtrimstart
		xtrimstart = xtrimfinish
		xtrimfinish = temp
	endif
	if (ytrimstart > ytrimfinish)
		temp = ytrimstart
		ytrimstart = ytrimfinish
		ytrimfinish = temp
	endif
	
	variable rowmax = dimsize(IncomingWave,0)
	variable colmax = dimsize(IncomingWave,1)
	variable xcurrent, ycurrent
	
	variable i,j
	for (i=0;i<rowmax;i+=1)
		for (j=0;j<colmax;j+=1)
			xcurrent = dimoffset(IncomingWave,0)+i*dimdelta(IncomingWave,0)
			ycurrent = dimoffset(IncomingWave,1)+j*dimdelta(IncomingWave,1)
			
			if (xcurrent <= xtrimfinish && xcurrent >= xtrimstart && ycurrent <= ytrimfinish && ycurrent >= ytrimstart)
				IncomingWave[i][j] = NaN
			endif
			
		endfor
	endfor
end

function Equalize(IncomingWave)

		wave IncomingWave
		STRING name1, name2
		SetDataFolder root:folder3D
		Print time() + ": Equalize Started."
	
		
		Variable Rows, Columns , Layers
		Variable Layers1
		Variable i, j , k
		Variable Average1 , Average2
		Variable help1
		
		Rows 	= DimSize( IncomingWave, 0 )
		Columns	= DimSize( IncomingWave, 1 )
		Layers 	= DimSize( IncomingWave, 2 )
		Layers1 = Layers - 1
		Make/O/N =(Rows,Columns)  v1 
		Make/O/N =(Rows,Columns)  v2 
		
		for( k = 0 ; k < Layers1 ; k = k + 1 )
			v1[][] =  IncomingWave[p][q][k]
			v2[][] =  IncomingWave[p][q][k+1]
			ImageStats v1	
			Average1 = V_avg
			ImageStats v2
			Average2 = V_avg
			help1 = Average1/Average2
			v2 = v2*help1
			IncomingWave[][][k+1] = v2[p][q]
		endfor	
			
		Variable energy1
		ControlInfo /W=k_Space_2D SetLayers
		help1 = V_value
		energy1 =  DimOffset(IncomingWave,0) + DimDelta(IncomingWave,0) * ( help1 - 1 )  
			
		Variable help2
		ControlInfo /W=k_Space_2D Position1
		help2 = V_value
		
		Variable help3
		ControlInfo /W=k_Space_2D Position3
		help3 = V_value
			
//		Image3[][] = IncomingWave[help1][p][q]
//		ImageX[][] = IncomingWave[p][q][help2]
//		ImageY[][] = IncomingWave[p][help3][q]
			
		Print time() + ": Operation Complete."
end

function FindFermiLevel()
	wave ImageY
	
	SetDataFolder root:folder3D
	//Duplicate/O ImageY
	DoWindow/K OriginalBandStructure
	Display as "Original Band Structure";AppendImage ImageY
	DoWindow/C OriginalBandStructure
	ModifyGraph swapXY=1, width=288,height=288
	
	Duplicate/O ImageY, ImageWave_smth
	Smooth 30, ImageWave_smth
	Differentiate/DIM=0  ImageWave_smth/D=ImageWave_smth_DIF
	make/O/N=(dimsize(ImageWave_smth_DIF,1)), MinLocation
	variable i=0, j=0, k=0, tempminlocprev=420, tempminvalprev=0, lowerbound=395, upperbound=450, autoAbortSecs=0
	Make/O/N=(dimsize(ImageWave_smth_DIF,0)), tempwave
	
	variable xstart=dimoffset(ImageWave_smth,0), xdelta=dimdelta(ImageWave_smth,0)
	SetScale/P x xstart, xdelta,"", tempwave
	DoWindow/K Derivative
	Display tempwave as "Derivative of Image"
	DoWindow/C Derivative
	ModifyGraph width=300,height=216
	MoveWindow 500, 0, 900, 300
		
//	execute/Z/Q "Cursor/W=# /P/H=2/C=(0,0,0)/S=2 B tempwave 340"
//	execute/Z/Q "Cursor/W=# /P/H=2/C=(0,0,0)/S=2 A tempwave 500"
	variable/G Auto=0
	String win=WinName(0,1)
	Showinfo
	for(i=0; i<dimsize(ImageWave_smth_DIF,1); i+=1)
		tempwave=Imagewave_smth_DIF[p][i]
		TextBox/C/N=text0/X=10.00/Y=10.00/F=0 "hw="+num2str(dimoffset(ImageY,1)+dimdelta(ImageY,1)*i)+"eV"
		if(Auto==0)
			if (UserCursorAdjust(win,autoAbortSecs,0) != 0)
				return -1
			endif
		endif
		if (strlen(CsrWave(A))>0 && strlen(CsrWave(B))>0)	// Cursors are on trace?
			lowerbound=pcsr(A);
			upperbound=pcsr(B);
			// print lowerbound, upperbound
		else
			lowerbound=tempminlocprev-10*xdelta
			upperbound=tempminlocprev+12*xdelta
		endif
		findpeak/Q/R=[lowerbound,upperbound]/N/M=(tempminvalprev*0.5) tempwave
		if (V_flag==0)
			MinLocation[i]=V_PeakLoc
			tempminlocprev=V_PeakLoc
			tempminvalprev=V_PeakVal
		else
			MinLocation[i]=tempminlocprev
		endif
		Cursor A, tempwave, tempminlocprev-10*xdelta
		Cursor B, tempwave, tempminlocprev+12*xdelta
		// Print i, V_PeakLoc, V_PeakVal
	endfor
	
	KillWindow win
	
	Duplicate/O MinLocation,MinLocation_smth
	Display MinLocation, MinLocation_smth
	ModifyGraph width=400,height=150
	MoveWindow 650, 300, 988, 600
	AdjustFermiLevel()
	
	Variable Smoothing=1
	String YesNo= "Yes;No"
	variable MoreSmooth=1
	do
		doupdate
		Prompt MoreSmooth, "More Smoothing", popup YesNo
		DoPrompt "I'd take a goldfish now", MoreSmooth
		if (V_Flag==1)
			return 1
		endif
		if (MoreSmooth==1)
			Prompt Smoothing, "How much more smoothing"
			DoPrompt "Who is bothering me now?", Smoothing
			if (V_Flag==1)
				return 1
			endif
			Smooth Smoothing, MinLocation_smth
			AdjustFermiLevel()
		endif
	while (MoreSmooth!=2)
	Wave AdjustedImage
//	LinePlots(AdjustedImage,15)	
end

Function AdjustFermiLevel()
	
	SetDataFolder root:folder3D
	String wavechoice= "ImageY;Images3D"
	variable Image=0, V_Flag
	Prompt Image, "Select which Image to adjust the fermi level of", popup wavechoice
	DoPrompt "I better be getting paid for this", Image
	if (V_Flag==1)
		return 0
	endif
	wave ImageY, Images3D, MinLocation_smth

	if (Image==1)
		Duplicate/O ImageY ImageWave
	elseif (Image==2)
		Duplicate/O Images3D ImageWave
	endif	
	
	variable changeinfermi=wavemax(MinLocation_smth)-wavemin(MinLocation_smth)
	variable xstart=dimoffset(ImageWave,0), xdelta=dimdelta(ImageY,0)
	variable xnewstart=dimoffset(ImageWave,0)-WaveMax(MinLocation_smth)
	variable i=0, j=0, k=0
	
	variable delta=DimDelta(ImageWave,0)
	variable startx=(-mean(MinLocation_smth)*delta)
	variable starty=DimOffset(ImageWave,1)
	variable deltay=DimDelta(ImageWave,1)
	
	If(dimsize(ImageWave,2)==0) // Working with ImageY
		Make/O/N=(dimsize(ImageWave,0)+ceil(changeinfermi/dimdelta(ImageWave,0)),dimsize(ImageWave,1)) AdjustedImage; AdjustedImage=0
		If(dimsize(ImageWave,1)>dimsize(MinLocation_smth,0))
			Interpolate2/T=3/N=(dimsize(ImageWave,1))/F=0/Y=FermiLocation_SS MinLocation_smth
			Duplicate/O FermiLocation_SS MinLocation_smth
			KillWaves FermiLocation_SS
		endif	
		SetScale/P x xnewstart, xdelta, "", AdjustedImage
		for(i=0; i<dimsize(ImageWave,1); i+=1)
			k=0
			j=xnewstart-MinLocation_smth[i]+WaveMax(MinLocation_smth)
			do
				AdjustedImage[x2pnt(AdjustedImage,j)][i]=ImageWave[k][i]
				j=j+xdelta
				k+=1
			while (k<dimsize(ImageWave,0))
		endfor
		
		DoWindow/K OriginalBandStructure
		Display as "Original Band Structure";AppendImage ImageWave
		DoWindow/C OriginalBandStructure
		ModifyGraph swapXY=1
		ModifyGraph width=288,height=288
		
		DoWindow/K AdjustedBandStructure
		Display as "Adjusted Band Structure";AppendImage AdjustedImage
		DoWindow/C AdjustedBandStructure
		
		// Added button for waterfall plots V12
		controlbar 40
		variable/G factorOffset=30 // starting value for offset
		variable/G smoothing=1 // most mild smoothing
		SetVariable setvarOffset,pos={100,9},size={100,15},proc=ChangeOffset,title="Offset (%)"
		SetVariable setvarOffset,value=factorOffset
		SetVariable setvarSmoothing,pos={210,9},size={100,15},proc=ChangeSmoothing,title="Smoothing"
		SetVariable setvarSmoothing,value=smoothing
		Button CreateWaterfall,pos={6,7},size={90,20},proc=CreateWaterfalls,title="Waterfall Plot"
		
		MoveWindow/W=AdjustedBandStructure 400, 0, 688, 388
		SetScale/P y starty, deltay,"", AdjustedImage
		ModifyGraph swapXY=1
		ModifyGraph width=288,height=288
		Label bottom "Photon Energy (eV)"
		Label left "Binding Energy (eV)"	
	else  // Images3D
		Make/O/N=(dimsize(ImageWave,0)+ceil(changeinfermi/dimdelta(ImageWave,0)),dimsize(ImageWave,1),dimsize(ImageWave,2)) AdjustedImage; AdjustedImage=0		
		SetScale/P x xnewstart, xdelta, "", AdjustedImage
//		print dimoffset(AdjustedImage,0), dimoffset(AdjustedImage,0)+dimsize(AdjustedImage,0)*dimdelta(AdjustedImage,0)
		
		If(dimsize(ImageWave,2)!=dimsize(MinLocation_smth,0))
			Interpolate2/T=3/N=(dimsize(ImageWave,2))/F=2/Y=FermiLocation_SS MinLocation_smth
			Duplicate/O FermiLocation_SS MinLocation_smth
			KillWaves FermiLocation_SS
		endif	

		for(i=0; i<dimsize(ImageWave,2); i+=1)
			k=0
			j=xnewstart-MinLocation_smth[i]+WaveMax(MinLocation_smth)
			do
				AdjustedImage[x2pnt(AdjustedImage,j)][*][i]=ImageWave[k][q][i]
				j=j+xdelta
				k+=1
			while (k<dimsize(ImageWave,0))
		endfor
		
		DoWindow/K OriginalBandStructure
		Display as "Original Band Structure";AppendImage ImageWave
		DoWindow/C OriginalBandStructure
		ModifyGraph swapXY=1
		ModifyGraph width=288,height=288
		Label bottom "Theta (deg)"
		Label left "Binding Energy (eV)"
		variable startz=DimOffset(ImageWave,2)
		variable deltaz=DimDelta(ImageWave,2)
		
		DoWindow/K AdjustedBandStructure
		Display as "Adjusted Band Structure";AppendImage AdjustedImage
		DoWindow/C AdjustedBandStructure
		SetScale/P y starty, deltay,"", AdjustedImage
		SetScale/P z startz, deltaz,"", AdjustedImage
		ModifyGraph swapXY=1
		ModifyGraph width=288,height=288
		Label bottom "Theta (deg)"
		Label left "Binding Energy (eV)"	
		
		
	endif
	
end

Function ConvertTo1DVectorsForKconv()
	
	SetDataFolder root:folder3D
	String gratingchoice="1;2;3"
	variable U0=12 // inner potential
	variable gratingprompt=1, V_Flag
	Prompt gratingprompt "Which Grating number is this?", popup gratingchoice
	Prompt U0, "What inner potential?"
	DoPrompt "WHY ARE YOU ALWAYS BUGGING ME?", gratingprompt, U0
	
	if (V_Flag==1)
		return -1
	endif
	
	wave AdjustedImage
	
	Make/O/N=(dimsize(AdjustedImage,1)) Ephoton;
	variable firstphotonenergy=DimOffset(AdjustedImage,1)
	variable denergy=DimDelta(AdjustedImage,1)
	Ephoton=firstphotonenergy+p*denergy
	
	variable phi=4.5 // Work function of detector in eV
	
	Make/O/N=(dimsize(AdjustedImage,0)) Ebinding;
	variable firstbindingenergy=DimOffset(AdjustedImage,0)
	variable dbenergy=DimDelta(AdjustedImage,0)
	Ebinding=firstbindingenergy+p*dbenergy
	
	Make/O/N=(dimsize(AdjustedImage,0),dimsize(AdjustedImage,1)) Ematrix, kperp
	Ematrix[][*]=Ebinding[p]
	
	variable i=0, j=0
	for(i=0; i<dimsize(Ephoton,0); i+=1)
		for(j=0; j<dimsize(Ebinding,0); j+=1)
			kperp[j][i]=0.512*Sqrt(Ephoton[i]+Ebinding[j]-phi+U0)
		endfor
	endfor
	
	variable oneDlength=dimsize(kperp,0)*dimsize(kperp,1)
	
	duplicate/O AdjustedImage oneDAdjustedImage
	NVAR rows
	rows=(round(dimsize(kperp,1)*2.5))
	NVAR cols
	cols=(dimsize(kperp,0))
	variable mktbl=2,mkimg=2
	
	Redimension/N=(oneDlength) kperp
	Redimension/N=(oneDlength) Ematrix
	Redimension/N=(oneDlength) oneDAdjustedImage
	
	String Grating = num2str(gratingprompt)
	
	String filename="", newwavename=""
	filename="kperpG"+Grating+".ibw"
	newwavename="kperpG"+Grating
	KillWaves/Z $newwavename
	rename kperp $newwavename
	print filename
	Save/C $newwavename as filename
	filename="EmatrixG"+Grating+".ibw"
	newwavename="EmatrixG"+Grating
	KillWaves/Z $newwavename
	rename Ematrix $newwavename
	Save/C $newwavename as filename
	filename="kcorImageG"+Grating+".ibw"
	newwavename="kcorImageG"+Grating
	KillWaves/Z $newwavename
	rename oneDAdjustedImage $newwavename
	Save/C $newwavename as filename

end

function UnpackWave(wavetemp)
	wave wavetemp
	variable i, j, k
	String newname
	
	for (k=0; k<dimsize(wavetemp,2); k+=1)
	
		Make/O/N=(dimsize(wavetemp,0),dimsize(wavetemp,1)) temparray
		for (i=0; i<dimsize(wavetemp,0);i+=1)
			for (j=0; j<dimsize(wavetemp,1); j+=1)
				
				temparray[i][j] = wavetemp[i][j][k]
				
			endfor
		endfor
		
		SetScale/P x, dimoffset(wavetemp,0), dimdelta(wavetemp,0), temparray
		SetScale/P y, dimoffset(wavetemp,1), dimdelta(wavetemp,1), temparray
		
		newname = "temp" + num2str(k)
		Duplicate/O temparray $newname
	endfor
	
	KillWaves/Z temparray, newname
end

function LoadKperpMatrix()

	SetDataFolder root:folder3D
	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif

	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif

	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif
	
	if (!exists("quartetarray1"))
		Print time()+": quartetarray1 not found."
	endif
	if (!exists("quartetarray2"))
		Print time()+": quartetarray2 not found."
	endif
		if (!exists("quartetarray3"))
		Print time()+": quartetarray3 not found."
	endif
	
	wave quartetarray1, quartetarray2, quartetarray3
	Print time()+": 4D vectors loaded successfully. "+num2str(dimsize(quartetArray1,0)+dimsize(quartetArray2,0)+dimsize(quartetArray3,0))+" rows loaded."

	
//	wave quartetarray1, quartetarray2
//	if (exists("quartetarray1")&&exists("quartetarray2"))
//		Concatenate/O/KILL/NP=0 {quartetarray1,quartetarray2}, quartetarray
//		Print time()+": 4D vectors loaded successfully. "+num2str(dimsize(quartetArray,0))+" rows loaded."
//	endif
end

function Load1DVectors()

	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif

	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif

	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif
	
	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif

	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif

	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif

	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif

	LoadWave/H/O
	if (V_Flag==0)
		return -1
	endif

	LoadWave/H/O

	if (V_Flag==0)
		return -1
	endif

	if (!exists("EmatrixG1"))
		Print time()+": EmatrixG1 not found."
	endif
	if (!exists("EmatrixG2"))
		Print time()+": EmatrixG2 not found."
	endif
	if (!exists("EmatrixG3"))
		Print time()+": EmatrixG3 not found."
	endif
	if (!exists("kcorImageG1"))
		Print time()+": kcorImageG1 not found."
	endif
	if (!exists("kcorImageG2"))
		Print time()+": kcorImageG2 not found."
	endif
	if (!exists("kcorImageG3"))
		Print time()+": kcorImageG3 not found."
	endif
	if (!exists("kperpG1"))
		Print time()+": kperpG1 not found."
	endif
	if (!exists("kperpG2"))
		Print time()+": kperpG2 not found."
	endif
	if (!exists("kperpG3"))
		Print time()+": kperpG3 not found."
	endif

	if (exists("EmatrixG1")&&exists("EmatrixG2")&&exists("EmatrixG3")&&exists("kcorImageG1")&&exists("kcorImageG2")&&exists("kcorImageG3")&&exists("kperpG1")&&exists("kperpG2")&&exists("kperpG3"))
		Print time()+": 1D vectors loaded successfully."
		GratingWavesToTriplet()
	endif

end

function GratingWavesToTriplet()
	wave kperpG1, kperpG2, kperpG3, EmatrixG1,EmatrixG2, EmatrixG3, kcorImageG1, kcorImageG2, kcorImageG3
	Concatenate/O/NP/KILL {kperpG1,kperpG2,kperpG3}, kperpAll
	Concatenate/O/NP/KILL {EmatrixG1,EmatrixG2,EmatrixG3}, EmatrixAll
	variable sfactor1, sfactor2, G1max, G2max, G3max, G1ave, G2ave, G3ave
	wavestats kcorImageG1
	G1max=V_max
	G1ave=V_avg
	wavestats kcorImageG2
	G2max=V_max
	G2ave=V_avg
	wavestats kcorImageG3
	G3max=V_max
	G3ave=V_avg
	sfactor1=(G3max/G1max+G3ave/G1ave)/2
	sfactor2=(G3max/G2max+G3ave/G2ave)/2
	kcorImageG1=kcorImageG1*sfactor1
	kcorImageG2=kcorImageG2*sfactor2
	wavestats kcorImageG1
	wavestats kcorImageG2
	Concatenate/O/NP/KILL {kcorImageG1,kcorImageG2, kcorImageG3}, kcorImageAll
	Concatenate/O/DL/KILL {kperpAll,EmatrixAll,kcorImageAll}, triplet
	print time()+": Triplet wave created, beginning interpolation"
	tripletTokperp()
end
	
function tripletTokperp()
	
	SetDataFolder root:folder3D
	wave triplet
	String mat="matrix"
	variable rows=450
	variable cols=680
	Silent 1;PauseUpdate
	
	NewPath/O path2

	// ImageInterpolate requires triplet wave
// 	wave triplet
// 	Concatenate/O/DL {kperp,Ematrix,oneDAdjustedImage}, triplet
//	
	Variable tripletRows= DimSize(triplet,0)
	ImageStats/M=1/G={0, tripletRows-1, 0,0} triplet
	variable xmin=  V_min
	variable xmax= V_max
	
	ImageStats/M=1/G={0, tripletRows-1, 1,1} triplet
	variable ymin= V_min
	variable ymax= V_max
	
	Variable dx= (xmax-xmin) / (rows-1)
	if( dx <= 0 )
		Abort "max X must be greater than min X!"
	endif
	Variable dy= (ymax-ymin) / (cols-1)
	if( dy <= 0 )
		Abort "max Y must be greater than min Y!"
	endif

	Variable pftl=1e-5	// overcome perturbation
	ImageInterpolate/DEST=$mat/PFTL=(pftl)/S={(xmin),(dx),(xmax),(ymin),(dy),(ymax)} Voronoi, triplet

	KillWaves/Z triplet
	print time()+": Interpolation complete."
	
	Display;AppendImage $mat
	ModifyGraph width=576,height=288
	Label left "Binding Energy (eV)"
	Label bottom "k\\B_|_\\M (Å\\S-1\\M)"
	SetAxis left -2.5,0.5
	SetAxis bottom 2.3,6.45
	ModifyGraph nticks(bottom)=10, minor(bottom)=1
	SavePICT/E=-4/I/W=(0,0,8,4)/P=path2 as "kperp_combinedgratings.bmp"
	
end

function KparFixedKperpConversion()

	if (!exists("AdjustedImage"))
		Print time()+": No 'AdjustedImage' array found."
		return -1
	endif

	KparPhotonEnergyToKperUser($"AdjustedImage")

end

function KparPhotonEnergyToKperUser(Input3D)
	wave Input3D
	
	SetDataFolder root:folder3D
	variable U0=12 // inner potential
	variable WF=4.5 // Work function of detector in eV
	String gratingchoice="1;2;3"
	variable gratingprompt=1, V_Flag
	
	Prompt gratingprompt "Which Grating number is this?", popup gratingchoice
	Prompt U0, "What is the inner potential?"
	Prompt WF, "What is the work function?"
	DoPrompt "What you want?!", gratingprompt, U0, WF
	if (V_Flag==1)
		return 1
	endif
	NewPath/O pathname
	
	KparPhotonEnergyToKper(Input3D, U0, WF, gratingprompt)
	
end

// varyU0 ($"AdjustedImage", 10, 14, 0.5)
function varyU0 (Input3D, startval, endval, delta)
	wave Input3D
	variable startval,endval, delta
	variable WF = 4.5

	String gratingchoice="1;2;3"
	variable gratingprompt=1, V_Flag
	Prompt gratingprompt "Which Grating number is this?", popup gratingchoice
	Prompt WF, "What is the work function?"
	DoPrompt "What you want?!", gratingprompt, WF
	if (V_Flag==1)
		return 1
	endif
	NewPath/O pathname

	variable i
	for (i=startval; i<=endval; i += delta)
		KparPhotonEnergyToKper(Input3D, i, WF, gratingprompt)
	endfor

end

Function KparPhotonEnergyToKper(Input3D, U0, WF, gratingprompt)
	wave Input3D
	variable U0, WF, gratingprompt
	String path
	
	Print time()+": Building kperp matrix."
	
	Make/O/N=(dimsize(Input3D,2)) Ephoton;
	variable firstphotonenergy=DimOffset(Input3D,2)
	variable denergy=DimDelta(Input3D,2)
	Ephoton=firstphotonenergy+p*denergy
		
	Make/O/N=(dimsize(Input3D,0)) Ebinding;
	variable firstbindingenergy=DimOffset(Input3D,0)
	variable dbenergy=DimDelta(Input3D,0)
	Ebinding=firstbindingenergy+p*dbenergy
	
	Make/O/N=(dimsize(Input3D,1)) Theta; // Emission angle index, first value and delta
	variable firstTheta=DimOffset(Input3D,1)
	variable dTheta=DimDelta(Input3D,1)
	Theta=firstTheta+p*dTheta
	
	Make/O/N=(dimsize(Input3D,2),dimsize(Input3D,0),dimsize(Input3D,1)) OutputWave, kperp, kpar, BE, photonarray
	
	variable i=0, j=0, k=0
	for(i=0; i<dimsize(Ephoton,0); i+=1)
		for(j=0; j<dimsize(Ebinding,0); j+=1)
			for(k=0; k<dimsize(Theta,0); k+=1)
				kperp[i][j][k]=0.512*Sqrt((Ephoton[i]+Ebinding[j]-WF)*cos(Theta[k]*Pi/180)^2+U0)
				kpar[i][j][k]=0.512*Sqrt(Ephoton[i]+Ebinding[j]-WF)*sin(Theta[k]*Pi/180)
				OutputWave[i][j][k]=Input3D[j][k][i]
				BE[i][j][k]=Ebinding[j]
				photonarray[i][j][k]=Ephoton[i]
			endfor
		endfor
	endfor
	
	Duplicate/O kperp kperpVector
	Duplicate/O kpar kparVector
	Duplicate/O BE BEVector
	Duplicate/O OutputWave kcorWaveVector
	Duplicate/O photonarray photonarray2

	KillWaves/Z OutputWave, kperp, kpar, BE, Ephoton, Ebinding, Theta, photonarray
	
	variable oneDlength=dimsize(kperpVector,0)*dimsize(kperpVector,1)*dimsize(kperpVector,2)	
	
	Redimension/N=(oneDlength) kperpVector
	Redimension/N=(oneDlength) kparVector
	Redimension/N=(oneDlength) BEVector
	Redimension/N=(oneDlength) kcorWaveVector
	Redimension/N=(oneDlength) photonarray2
	Concatenate/O/DL/KILL {kparVector,kperpVector,BEVector,kcorWaveVector, photonarray2}, quartetArray
	
	Print time()+": Matrix 'quartetArray' built. " + num2str(dimsize(quartetArray,0)) + " rows processed."
	
	String Grating = num2str(gratingprompt)
	
	String filename="", newwavename=""
	filename="quartetarray"+Grating+"("+num2str(U0)+").ibw"
	newwavename="quartetarray"+Grating
	KillWaves/Z $newwavename
	rename quartetarray $newwavename
	Save/C/P=pathname $newwavename as filename
end

//Slower but potentially lower memory impact for VERY large data sets, needs modification for correct output
//Function KparPhotonEnergyToKper2(Input3D)
//	wave Input3D
//	
//	SetDataFolder root:folder3D
//	variable U0=12 // inner potential
//	variable WF=4.5 // Work function of detector in eV
//	String gratingchoice="1;2;3"
//	variable gratingprompt=1, V_Flag
//	
//	Prompt gratingprompt "Which Grating number is this?", popup gratingchoice
//	Prompt U0, "What is the inner potential?"
//	Prompt WF, "What is the work function?"
//	DoPrompt "What you want?!", gratingprompt, U0, WF
//	if (V_Flag==1)
//		return 1
//	endif
//	NewPath/O pathname
//	
//	Print time()+": Building kperp matrix."
//	
//	Make/O/N=0 temp0 //kpar
//	Make/O/N=0 temp1 //kperp
//	Make/O/N=0 temp2 //BE
//	Make/O/N=0 temp3 //Intensity
//	
//	variable i, j, k, count=0
//	variable Ephoton, Ebinding, Theta
//	for(i=0; i<dimsize(Input3D,2); i+=1) 				//Layer (photon energy)
//		for(j=0; j<dimsize(Input3D,0); j+=1) 			//Row (BE)
//			for(k=0; k<dimsize(Input3D,1); k+=1)	//Column (Theta)
//
//				InsertPoints count,1,temp0
//				InsertPoints count,1,temp1
//				InsertPoints count,1,temp2
//				InsertPoints count,1,temp3
//				
//				Ephoton = DimOffset(Input3D,2)+DimDelta(Input3D,2)*i
//				Ebinding = DimOffset(Input3D,0)+DimDelta(Input3D,0)*j
//				Theta = DimOffset(Input3D,1)+DimDelta(Input3D,1)*k
//
//				temp0[count] = 0.512*Sqrt(Ephoton+Ebinding-WF)*sin(Theta*Pi/180)				//kpar
//				temp1[count] = 0.512*Sqrt((Ephoton+Ebinding-WF)*cos(Theta*Pi/180)^2+U0)		//kerp
//
////				temp0[count] = Theta
////				temp1[count] = Ephoton
//
//				temp2[count] = Ebinding												//BE
//				temp3[count] = Input3D[j][k][i]  											//Intensity
//				count+=1	
//			endfor
//		endfor
//
//	if (mod (i,5)==0)
//		Print time() + ": " + num2str(((i+1)/dimsize(Input3D,2))*100) + "% complete."
//	endif
//
//	endfor
//	
//	Concatenate/O/DL/KILL {temp0,temp1,temp2,temp3}, quartetArray
//	
//	Print time()+": Matrix 'quartetArray' built. " + num2str(dimsize(quartetArray,0)) + " rows processed."
//	
//	String Grating = num2str(gratingprompt)
//	
//	String filename="", newwavename=""
//	filename="quartetarray"+Grating+".ibw"
//	newwavename="quartetarray"+Grating
//	KillWaves/Z $newwavename
//	rename quartetarray $newwavename
//	Save/C/P=pathname $newwavename as filename
//end

function GetConstantVariableSlice()

//	SetDataFolder root:folder3D
	variable center=-0.1, column=3
	variable tolerance=0.005
	variable V_Flag
	
	if (!exists("quartetarray1"))
		Print time()+": quartetarray1 not found."
		return 1
	endif
	if (!exists("quartetarray2"))
		Print time()+": quartetarray2 not found."
		return 1
	endif
	if (!exists("quartetarray3"))
		Print time()+": quartetarray3 not found."
		return 1
	endif
	
	wave quartetarray1, quartetarray2, quartetarray3
	
	variable slicesdesired=1
	variable step=-0.1
	
	String colchoice= "kparallel;kperp;Binding Energy;Intensity"
	Prompt column, "What variable would you like constant", popup colchoice
	
	Prompt center, "What value do you want your first slice around?"
	Prompt tolerance, "What tolerance do you want (value ± tolerance)?"
	Prompt slicesdesired, "How many slices do you want?"
	Prompt step, "What space between slices?"
	DoPrompt "Give me all your money!", column, center, tolerance, slicesdesired, step
	
	if (V_Flag==1)
		return 1
	endif
	
	NewPath/O pathname
	
	variable i
	
	for (i=0; i<slicesdesired; i+=1)
	
		KillWaves/Z triwave
		Make/O/N=(0,5) Triwave
		SelectVariableSlice(quartetarray1,center+i*+step, tolerance, column)
		SelectVariableSlice(quartetarray2,center+i*+step, tolerance, column)
		SelectVariableSlice(quartetarray3,center+i*+step, tolerance, column)
		wave triwave
		
		String name = "triwave(" + num2str((center+i*step)*1000) + ")"
		
		Print time() + ": Triwave built, " + num2str(dimsize(triwave,0)) + " rows. Saving as: " + name + ".dat"
	
		Save/C/J/P=pathname triwave as name + ".dat"
		
	endfor
	
//	String mat="matrix"
//	variable rows=450
//	variable cols=680
//	Silent 1;PauseUpdate
//
//
//	ImageInterpolate requires triplet wave
// 	wave triplet
// 	Concatenate/O/DL {kperp,Ematrix,oneDAdjustedImage}, triplet
//	
//	Variable triwaveRows= DimSize(triwave,0)
//	ImageStats/M=1/G={0, triwaveRows-1, 0,0} triwave
//	variable xmin=  V_min
//	variable xmax= V_max
//	
//	ImageStats/M=1/G={0, triwaveRows-1, 1,1} triwave
//	variable ymin= V_min
//	variable ymax= V_max
//	
//	Variable dx= (xmax-xmin) / (rows-1)
//	if( dx <= 0 )
//		Abort "max X must be greater than min X!"
//	endif
//	Variable dy= (ymax-ymin) / (cols-1)
//	if( dy <= 0 )
//		Abort "max Y must be greater than min Y!"
//	endif
//
//	Variable pftl=1e-5	// overcome perturbation
//	ImageInterpolate/DEST=$mat/PFTL=(pftl)/S={(xmin),(dx),(xmax),(ymin),(dy),(ymax)} Voronoi, triwave
//	
//	Display;AppendImage $mat
//	ModifyGraph width=576,height=288
//	Label left "Binding Energy (eV)"
//	Label bottom "k\\By\\M (Å\\S-1\\M)"
//	SetAxis left -2.5,0.5
//	SetAxis bottom 2.3,6.45
//	ModifyGraph nticks(bottom)=10, minor(bottom)=1


end

function GetArrayParams(InputWave)
	
	wave InputWave
	variable xsize = dimsize(InputWave,0), xoffset, xdelta
	variable ysize = dimsize(InputWave,1), yoffset, ydelta
	variable zsize = dimsize(InputWave,2), zoffset, zdelta
	variable csize = dimsize(InputWave,3), coffset, cdelta
	
	Print time() + ": Array info:"
	if (xsize > 0)
		xoffset = dimoffset(InputWave,0)
		xdelta = dimdelta(InputWave,0)
		print "xsize=" + num2str(xsize) + ", xoffset=" + num2str(xoffset) + ", xdelta=" + num2str(xdelta)
	endif
	if (ysize > 0)
		yoffset = dimoffset(InputWave,1)
		ydelta = dimdelta(InputWave,1)
		print "ysize=" + num2str(ysize) + ", yoffset=" + num2str(yoffset) + ", ydelta=" + num2str(ydelta)
	endif
	if (zsize > 0)
		zoffset = dimoffset(InputWave,2)
		zdelta = dimdelta(InputWave,2)
		print "zsize=" + num2str(zsize) + ", zoffset=" + num2str(zoffset) + ", zdelta=" + num2str(zdelta)
	endif
	if (csize > 0)
		coffset = dimoffset(InputWave,3)
		cdelta = dimdelta(InputWave,3)
		print "csize=" + num2str(csize) + ", coffset=" + num2str(coffset) + ", cdelta=" + num2str(cdelta)
	endif
end

function SetImages3DParams()

	wave Images3D
	SetArrayParams(Images3D)

end

function SetArrayParams (InputWave)
	wave InputWave
	GetArrayParams(InputWave)

	variable xsize = dimsize(InputWave,0), xoffset, xdelta
	variable ysize = dimsize(InputWave,1), yoffset, ydelta
	variable zsize = dimsize(InputWave,2), zoffset, zdelta
	variable csize = dimsize(InputWave,3), coffset, cdelta
	
	if (xsize > 0)
		xoffset = dimoffset(InputWave,0)
		xdelta = dimdelta(InputWave,0)
	endif
	if (ysize > 0)
		yoffset = dimoffset(InputWave,1)
		ydelta = dimdelta(InputWave,1)
	endif
	if (zsize > 0)
		zoffset = dimoffset(InputWave,2)
		zdelta = dimdelta(InputWave,2)
	endif
	if (csize > 0)
		coffset = dimoffset(InputWave,3)
		cdelta = dimdelta(InputWave,3)
	endif
	
	Prompt xoffset, "New row offset"
	Prompt xdelta, "New row delta"
	Prompt yoffset, "New column offset"
	Prompt ydelta, "New column delta"
	Prompt zoffset, "New layer offset"
	Prompt zdelta, "New layer delta"
	Prompt coffset, "New chunk offset"
	Prompt cdelta, "New chunk delta"
	variable V_Flag
	if (xsize==0)
		print "No rows found."
	elseif (ysize==0)
		DoPrompt "I believe!", xoffset, xdelta
		if (V_Flag==1)
			return 1
		endif
		SetScale/P x, xoffset, xdelta, InputWave
	elseif (zsize==0)
		DoPrompt "I feel the need... the need, for speed!", xoffset, xdelta, yoffset, ydelta
		if (V_Flag==1)
			return 1
		endif
		SetScale/P x, xoffset, xdelta, InputWave
		SetScale/P y, yoffset, ydelta, InputWave
	elseif (csize==0)
		DoPrompt "Ha-cha-cha!", xoffset, xdelta, yoffset, ydelta, zoffset, zdelta
		if (V_Flag==1)
			return 1
		endif
		SetScale/P x, xoffset, xdelta, InputWave
		SetScale/P y, yoffset, ydelta, InputWave
		SetScale/P z, zoffset, zdelta, InputWave
	else
		DoPrompt "IT'S FULL OF STARS!", xoffset, xdelta, yoffset, ydelta, zoffset, zdelta, coffset, cdelta
		if (V_Flag==1)
			return 1
		endif
		SetScale/P x, xoffset, xdelta, InputWave
		SetScale/P y, yoffset, ydelta, InputWave
		SetScale/P z, zoffset, zdelta, InputWave
		SetScale/P t, coffset, cdelta, InputWave
	endif
end

function SelectVariableSlice (searcharray, cen, tol, col)
	variable cen, tol
	variable col // 1=kparallel; 2=kperp; 3= Binding Energy; 4=Intensity
	wave searchArray
	String type
	wave triwave
	
	switch (col)
		case 1:
			type="kparallel"
		break
		
		case 2:
			type="kperp"
		break
		
		case 3:
			type="BE"
		break
		
		case 4:
			type="Intensity"
		break
		
		default:
			type="N/A"
		break
	endswitch

	Print time()+": Selecting "+type+" points: "+num2str(cen)+"±"+num2str(tol)+" Å^-1. Searching "+num2str(dimsize(searchArray,0))+" rows."
	
	variable i,j, intensitymod=1, Ephoton
	variable length = dimsize(searchArray,0)
	
	switch (col)
		case 1: //kparallel
			for (i=0,j=dimsize(triwave,0); i<length;i+=1)
				if(searchArray[i][0] <= cen+tol && searchArray[i][0] >= cen-tol)
			
					//Kpar inside tolerances - KEEP THIS ROW

					InsertPoints j,1,triwave

					triwave[j][0] = searchArray[i][1]
					triwave[j][1] = searchArray[i][2]
					triwave[j][2] = searchArray[i][3]
					Ephoton = searchArray[i][4]
					
					if (searchArray[i][4] <=40) //Grating 1
						intensitymod = (1*10^13)/(-6.96448980E+03*(Ephoton^9) + 1.63594124E+06*(Ephoton^8) -1.67397237E+08*(Ephoton^7) + 9.78271805E+09*(Ephoton^6) -3.59477163E+11*(Ephoton^5) + 8.60645344E+12*(Ephoton^4) -1.34178529E+14*(Ephoton^3) + 1.31335550E+15*(Ephoton^2) -7.32491418E+15*(Ephoton^1) + 1.77457751E+16)
					elseif (searchArray[i][4] <= 90) //Grating 2
						intensitymod = (1*10^13)/(1.27295830E+00*(Ephoton^9) - 7.47838382E+02*(Ephoton^8) + 1.92430164E+05*(Ephoton^7) - 2.84467554E+07*(Ephoton^6) + 2.66102317E+09*(Ephoton^5) - 1.63284180E+11*(Ephoton^4) + 6.57109130E+12*(Ephoton^3) - 1.67248398E+14*(Ephoton^2) + 2.44369939E+15*(Ephoton^1) - 1.56195197E+16)
					else //Grating 3
						intensitymod = (1*10^13)/(-3.41904797E-04*(Ephoton^9) + 4.16813907E-01*(Ephoton^8) - 2.18877440E+02*(Ephoton^7) + 6.44343583E+04*(Ephoton^6) - 1.15614961E+07*(Ephoton^5) + 1.27947740E+09 *(Ephoton^4) - 8.27481569E+10*(Ephoton^3) + 2.54332707E+12*(Ephoton^2) + 0*(Ephoton^1) - 1.38896030E+15)
					endif
					
					if (searchArray[i][4] <= 40)
						triwave[j][3] = searchArray[i][3]*(intensitymod)
					elseif (searchArray[i][4] <= 90)
						triwave[j][3] = searchArray[i][3]*(intensitymod)
					else
						triwave[j][3] = searchArray[i][3]*(intensitymod)*2.5
					endif
					
					j+=1	
				endif
			endfor
		break
		
		case 2: //kperp
			for (i=0,j=0; i<length;i+=1)
				if(searchArray[i][1] <= cen+tol && searchArray[i][1] >= cen-tol)
			
					//Kperp inside tolerances - KEEP THIS ROW

					InsertPoints j,1,triwave
					
					triwave[j][0] = searchArray[i][0]
					triwave[j][1] = searchArray[i][2] 
					triwave[j][2] = searchArray[i][3] 					
					Ephoton = searchArray[i][4]
					
					if (searchArray[i][4] <=40) //Grating 1
						intensitymod = (1*10^13)/(-6.96448980E+03*(Ephoton^9) + 1.63594124E+06*(Ephoton^8) -1.67397237E+08*(Ephoton^7) + 9.78271805E+09*(Ephoton^6) -3.59477163E+11*(Ephoton^5) + 8.60645344E+12*(Ephoton^4) -1.34178529E+14*(Ephoton^3) + 1.31335550E+15*(Ephoton^2) -7.32491418E+15*(Ephoton^1) + 1.77457751E+16)
					elseif (searchArray[i][4] <= 90) //Grating 2
						intensitymod = (1*10^13)/(1.27295830E+00*(Ephoton^9) - 7.47838382E+02*(Ephoton^8) + 1.92430164E+05*(Ephoton^7) - 2.84467554E+07*(Ephoton^6) + 2.66102317E+09*(Ephoton^5) - 1.63284180E+11*(Ephoton^4) + 6.57109130E+12*(Ephoton^3) - 1.67248398E+14*(Ephoton^2) + 2.44369939E+15*(Ephoton^1) - 1.56195197E+16)
					else //Grating 3
						intensitymod = (1*10^13)/(-3.41904797E-04*(Ephoton^9) + 4.16813907E-01*(Ephoton^8) - 2.18877440E+02*(Ephoton^7) + 6.44343583E+04*(Ephoton^6) - 1.15614961E+07*(Ephoton^5) + 1.27947740E+09 *(Ephoton^4) - 8.27481569E+10*(Ephoton^3) + 2.54332707E+12*(Ephoton^2) + 0*(Ephoton^1) - 1.38896030E+15)
					endif
					
					if (searchArray[i][4] <= 40)
						triwave[j][3] = searchArray[i][3]*(intensitymod)
					elseif (searchArray[i][4] <= 90)
						triwave[j][3] = searchArray[i][3]*(intensitymod)
					else
						triwave[j][3] = searchArray[i][3]*(intensitymod)*2.5
					endif
					
					j+=1	
				endif
			endfor
		break
		
		case 3: //BE
			for (i=0,j=0; i<length;i+=1)
				if(searchArray[i][2] <= cen+tol && searchArray[i][2] >= cen-tol)
			
					//BE inside tolerances - KEEP THIS ROW
					
					InsertPoints j,1,triwave
			
					triwave[j][0] = searchArray[i][0]
					triwave[j][1] = searchArray[i][1]
					triwave[j][2] = searchArray[i][3]
					Ephoton = searchArray[i][4]
					
//					if (searchArray[i][4] <=40) //Grating 1
//						intensitymod = (1*10^13)/(-6.96448980E+03*(Ephoton^9) + 1.63594124E+06*(Ephoton^8) -1.67397237E+08*(Ephoton^7) + 9.78271805E+09*(Ephoton^6) -3.59477163E+11*(Ephoton^5) + 8.60645344E+12*(Ephoton^4) -1.34178529E+14*(Ephoton^3) + 1.31335550E+15*(Ephoton^2) -7.32491418E+15*(Ephoton^1) + 1.77457751E+16)
//					elseif (searchArray[i][4] <= 90) //Grating 2
//						intensitymod = (1*10^13)/(1.27295830E+00*(Ephoton^9) - 7.47838382E+02*(Ephoton^8) + 1.92430164E+05*(Ephoton^7) - 2.84467554E+07*(Ephoton^6) + 2.66102317E+09*(Ephoton^5) - 1.63284180E+11*(Ephoton^4) + 6.57109130E+12*(Ephoton^3) - 1.67248398E+14*(Ephoton^2) + 2.44369939E+15*(Ephoton^1) - 1.56195197E+16)
//					else //Grating 3
//						intensitymod = (1*10^13)/(-3.41904797E-04*(Ephoton^9) + 4.16813907E-01*(Ephoton^8) - 2.18877440E+02*(Ephoton^7) + 6.44343583E+04*(Ephoton^6) - 1.15614961E+07*(Ephoton^5) + 1.27947740E+09 *(Ephoton^4) - 8.27481569E+10*(Ephoton^3) + 2.54332707E+12*(Ephoton^2) + 0*(Ephoton^1) - 1.38896030E+15)
//					endif

					wave hvG1, Initial_FluxG1, FluxG1, hvG2, Initial_FluxG2, FluxG2, hvG3, Initial_FluxG3, FluxG3
					variable pointcounter

					if (Ephoton <=40.1) //Grating 1 (14-40 by 0.5)
					
						pointcounter=0
						if (hvG1[pointcounter] > hvG1[pointcounter + 1])
							for (; hvG1[pointcounter] > Ephoton;)
								pointcounter+=1
							endfor
						else
							for (; hvG1[pointcounter] < Ephoton;)
								pointcounter+=1
							endfor
						endif
						
						if (hvG1[pointcounter] != Ephoton)
							Print time() + ": Point not found correctly (G1)! hv=" + num2str(Ephoton)  + " != pointcounterhv=" + num2str(hvG1[pointcounter])
						endif
						
						intensitymod = 2.5E-8 / FluxG1 [pointcounter]
		
					elseif (Ephoton <= 89.6) //Grating 2 ( 41-89 by 1.0)
					
						pointcounter=0
						if (hvG2[pointcounter] > hvG2[pointcounter + 1])
							for (; hvG2[pointcounter] > Ephoton;)
								pointcounter+=1
							endfor
						else
							for (; hvG2[pointcounter] < Ephoton;)
								pointcounter+=1
							endfor
						endif
						
						if (hvG2[pointcounter] != Ephoton)
							Print time() + ": Point not found correctly (G2)! hv=" + num2str(Ephoton) + " != pointcounterhv=" + num2str(hvG2[pointcounter])
						endif
						
						intensitymod = 2.5E-8 / FluxG2 [pointcounter]
						
					else //Grating 3 (90-150 by 1.0)
					
						pointcounter=0
						if (hvG3[pointcounter] > hvG3[pointcounter + 1])
							for (; hvG3[pointcounter] > Ephoton;)
								pointcounter+=1
							endfor
						else
							for (; hvG3[pointcounter] < Ephoton;)
								pointcounter+=1
							endfor
						endif
						
						if (hvG3[pointcounter] != Ephoton)
							Print time() + ": Point not found correctly (G3)! hv=" + num2str(Ephoton)  + " != pointcounterhv=" + num2str(hvG3[pointcounter])
						endif
						
						intensitymod = 2.5E-8 / FluxG3 [pointcounter]
					endif
					
					triwave[j][3] = searchArray[i][3]*(intensitymod) //Apply flux correction
					
					variable gammavalue=0.8
					triwave[j][4] = (searchArray[i][3]*(1))^gammavalue //apply gamma correction
	
					j+=1	
				endif
			endfor
		break
		
		case 4: //Intensity
			
			Print time() + ": Intensity search not implemented due to normalization difficulties."
			
		break
		
		default:
		break
	endswitch
end

Function UpdateKspaceGraphs()
	
	SetDataFolder root:folder3D
	variable/G klimits
	//printf "The axis will be: %g\r", k
	DoWindow/F $"k_Space_2D"
	Label bottomImage3 "k\\By\\M (Å\\S-1\\M)"
	Label leftImage3 "k\\Bx\\M (Å\\S-1\\M)"
	SetAxis bottomImage3 -klimits,klimits
	SetAxis leftImage3 -klimits,klimits
	ModifyGraph lblMargin(bottomImage3)=15,lblMargin(leftImage3)=20,lblLatPos=0
	
End	

Function SaveAllMyPlots()
	variable startindex=0, delta=0, numofplots=0
	variable unitCellDim=1.376, numUnitCell=1
	variable energyhigh=0.5,energylow=-3
	
	Prompt startindex, "What layer index would you like to start with?"
	Prompt delta, "What spacing between cuts would you like?"
	Prompt numofplots, "How many Energy cuts would you like?"
	Prompt unitCellDim, "What is the k-space unit cell dimension? (inverse Å)"
	Prompt numUnitCell, "How many unit cells would you like displayed?"
	String scalingchoice= "50% of Max;75% of Max;Auto;Same as current"
	String colorchoice="Black and White;Blue Hot;Both"
	variable scale=1, color=3
	Prompt scale, "Select which Image to adjust the fermi level of", popup scalingchoice
	Prompt color "Select the color of the output plots", popup colorchoice
	Prompt energyhigh "Max binding energy?"
	Prompt energylow "Min binding energy?"
	DoPrompt "Give me all your love", startindex, delta, numofplots, unitCellDim, numUnitCell, scale, energyhigh, energylow, color
	
	variable/G gscale=scale-1, gcolor=color-1
	if (V_Flag==1)
		return -1
	endif
	variable/G klimits
	klimits=unitCellDim*numUnitCell
	newpath/O/C path
	string kx="",ky=""
	DoWindow/F $"k_space_2D"
	ModifyGraph width={Aspect,1}
	ControlInfo Position4
	sprintf kx, "%.3f", V_Value
	ControlInfo Position2
	sprintf ky, "%.3f", V_Value
		
	variable i=0, currentlayer
	for(i=0; i<numofplots; i+=1)
		currentlayer=startindex+i*delta
		SaveFermiCut(currentlayer)
	endfor	
	NVAR PhotonEnergy, klimits
	DoWindow/F $"Angle_Energy"
	string filenameBW="BW_hw="+num2str(PhotonEnergy)+"eV_kx="+kx+"ky="+ky+".bmp"
	string filenameColor="Color_hw="+num2str(PhotonEnergy)+"eV_kx="+kx+"ky="+ky+".bmp"
	TextBox/C/N=text0/X=93.00/Y=5/F=0 "hw="+num2str(PhotonEnergy)+"eV"
	TextBox/C/N=text1/X=15.00/Y=2.00/B=(0,0,0)/F=0 "\\K(65535,65535,65535)k\\By\\M="+kx
	TextBox/C/N=text2/X=65.00/Y=2.00/B=(0,0,0)/F=0 "\\K(65535,65535,65535)k\\Bx\\M="+ky
	Label leftImageX "k\\Bx\\M (Å\\S-1\\M)"
	Label bottomImageX "Binding Energy (eV)"
	Label bottomImageY "k\\By\\M (Å\\S-1\\M)"
	SetAxis bottomImageY -klimits,klimits
	SetAxis leftImageX -klimits,klimits
	SetAxis bottomImageX energylow,energyhigh
	SetAxis leftImageY energylow,energyhigh
	ModifyGraph lblMargin(bottomImageX)=21
	ModifyGraph width={Aspect,2.3}
	
	if(gcolor==0)
		ModifyImage CutX_K_B ctab= {*,*,Grays,0}
		ModifyImage CutY_K_B ctab= {*,*,Grays,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameBW
	elseif(gcolor==1)
		ModifyImage CutX_K_B ctab= {*,*,BlueHot,0}
		ModifyImage CutY_K_B ctab= {*,*,BlueHot,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameColor
	elseif(gcolor==2)
		ModifyImage CutX_K_B ctab= {*,*,Grays,0}
		ModifyImage CutY_K_B ctab= {*,*,Grays,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameBW
		ModifyImage CutX_K_B ctab= {*,*,BlueHot,0}
		ModifyImage CutY_K_B ctab= {*,*,BlueHot,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameColor
	endif
	
End

Function UserCursorAdjust(graphName,autoAbortSecs, type)
	String graphName
	Variable autoAbortSecs,type

	Variable/G Auto
	DoWindow/F $graphName							// Bring graph to front
	if (V_Flag == 0)									// Verify that graph exists
		Abort "UserCursorAdjust: No such graph."
		return -1
	endif
	
	
	NewPanel /K=2 /W=(187,368,437,531) as "Pause for Cursor"
	DoWindow/C tmp_PauseforCursor					// Set to an unlikely name
	AutoPositionWindow/E/M=1/R=$graphName			// Put panel near the graph

	DrawText 21,20,"Adjust the cursors and then"
	DrawText 21,40,"Click Continue."
	if (type==0)
		DrawText 21,60,"or Click Automate."
	else
		DrawText 21,60,"or Click Redo."
	endif
	
	Button button0,pos={50,58},size={92,20},title="Continue"
	if (type==0)
		Button button1,pos={150,58},size={92,20},title="Automate"
	else
		Button button1,pos={150,58},size={92,20},title="Redo"
	endif
	Button button0,proc=UserCursorAdjust_ContButtonProc
	Button button1,proc=UserCursonAdjust_AutoButtonProc
	Variable didAbort= 0
	if( autoAbortSecs == 0 )
		PauseForUser tmp_PauseforCursor,$graphName
	else
		SetDrawEnv textyjust= 1
		DrawText 162,103,"sec"
		SetVariable sv0,pos={48,97},size={107,15},title="Aborting in "
		SetVariable sv0,limits={-inf,inf,0},value= _NUM:10
		Variable td= 10,newTd
		Variable t0= ticks
		Do
			newTd= autoAbortSecs - round((ticks-t0)/60)
			if( td != newTd )
				td= newTd
				SetVariable sv0,value= _NUM:newTd,win=tmp_PauseforCursor
				if( td <= 10 )
					SetVariable sv0,valueColor= (65535,0,0),win=tmp_PauseforCursor
				endif
			endif
			if( td <= 0 )
				DoWindow/K tmp_PauseforCursor
				didAbort= 1
				break
			endif
				
			PauseForUser/C tmp_PauseforCursor,$graphName
		while(V_flag)
	endif
	return didAbort
End

Function UserCursorAdjust_ContButtonProc(ctrlName) : ButtonControl
	String ctrlName

	DoWindow/K tmp_PauseforCursor				// Kill self
End

Function UserCursonAdjust_AutoButtonProc(ctrlName) : ButtonControl
	String ctrlName
	
	//print "Automated"
	Variable/G Auto=1
	DoWindow/K tmp_PauseforCursor				// Kill self
End

Function SaveFermiCut(slicenum)
	variable slicenum
	
	SetDataFolder root:folder3D
	NVAR PhotonEnergy
	DoWindow/F k_Space_2D
	SetVariable SetLayers,value=_NUM:slicenum
	MySetLayer()
	DoUpdate
	ControlInfo /W=k_Space_2D SetLayers
	// print "Current Layer =", V_value
	ControlInfo /W=k_Space_2D Energy2
	//print "Current Energy =",V_value
	string BindingEnergy
	sprintf BindingEnergy, "%*.*feV",1,4, V_value
	string filenameBW="BW_hw="+num2str(PhotonEnergy)+"eV_BE="+BindingEnergy+".bmp"
	string filenameColor="Color_hw="+num2str(PhotonEnergy)+"eV_BE="+BindingEnergy+".bmp"

	//string filename="hw="+num2str(PhotonEnergy)+"eV_BE="+mynum2str(V_value)+".bmp"
	//print filename
	UpdateKspaceGraphs()
	NVAR gcolor, gscale
	variable scalemin, scalemax
	wave Images3D
	wavestats Images3D
	scalemin=V_min
	scalemax=V_max
	wave LayerN_K
	TextBox/C/N=text0/X=15.00/Y=0.50/F=0 "hw="+num2str(PhotonEnergy)+"eV\rBE="+BindingEnergy
	if (gscale==0&&gcolor==0)
		scalemin=0.5*scalemin
		scalemax=0.5*scalemax
		ModifyImage LayerN_K ctab= {scalemin,scalemax,Grays,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameBW
	elseif (gscale==1&&gcolor==0)
		scalemin=0.75*scalemin
		scalemax=0.75*scalemax
		ModifyImage LayerN_K ctab= {scalemin,scalemax,Grays,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameBW
	elseif (gscale==2&&gcolor==0)
		ModifyImage LayerN_K ctab= {*,*,Grays,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameBW
	elseif (gscale==0&&gcolor==1)
		scalemin=0.5*scalemin
		scalemax=0.5*scalemax
		ModifyImage LayerN_K ctab= {scalemin,scalemax,BlueHot,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameColor
	elseif (gscale==1&&gcolor==1)
		scalemin=0.75*scalemin
		scalemax=0.75*scalemax
		ModifyImage LayerN_K ctab= {scalemin,scalemax,BlueHot,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameColor
	elseif (gscale==2&&gcolor==1)
		ModifyImage LayerN_K ctab= {*,*,BlueHot,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameColor
		elseif (gscale==0&&gcolor==2)
		scalemin=0.5*scalemin
		scalemax=0.5*scalemax
		ModifyImage LayerN_K ctab= {scalemin,scalemax,Gray,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameBW
		ModifyImage LayerN_K ctab= {scalemin,scalemax,BlueHot,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameColor
	elseif (gscale==1&&gcolor==2)
		scalemin=0.75*scalemin
		scalemax=0.75*scalemax
		ModifyImage LayerN_K ctab= {scalemin,scalemax,Gray,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameBW
		ModifyImage LayerN_K ctab= {scalemin,scalemax,BlueHot,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameColor
	elseif (gscale==2&&gcolor==2)
		ModifyImage LayerN_K ctab= {*,*,Gray,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameBW
		ModifyImage LayerN_K ctab= {*,*,BlueHot,0}
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameColor
	elseif (gscale==3)
		SavePICT/E=-4/I/W=(0,0,6,6)/P=path as filenameBW
	endif
	
End

Function TestPlots(ImageWave)
	wave ImageWave
	
	NewPath/O path
	variable i,j
	
	for (i=4;i<=29;i+=1)
		for (j=1000;j<=5000;j+=50)
			LinePlotGenerate(ImageWave,5,i,j,-1.5)
			string filenameLinear="LinePlot_Linear_Step="+num2str(i)+"eV_Spacing="+num2str(j)+".bmp"
			DoWindow/F LinePlot
			SavePICT/E=-4/P=path as filenameLinear
		endfor
	endfor

End

Function LinePlots(ImageWave,smoothing)
	wave ImageWave
	variable smoothing
	variable V_Flag

	variable Spacing=800
	variable step=10, lowlimit=-1.5
	
	Prompt Spacing, "What spacing would you like?"
	Prompt step, "What step size?"
	Prompt lowlimit, "What lower limit?"
	DoPrompt "If only they could see me now!", Spacing, step
	if (V_Flag==1)
		return 1
	endif
	
	LinePlotGenerate(ImageWave,smoothing,step,Spacing, lowlimit)

end

Function LinePlotGenerate(ImageWave,smoothingfactor, stepsize,spacingsize,lowlimit)
	wave ImageWave
	variable smoothingfactor, stepsize, spacingsize, lowlimit
	variable Spacing=spacingsize, step=stepsize

	variable i=0

	Make/O/Wave/N=(Dimsize(ImageWave,0)) wr,wl
	wr= SubroutineLinear(p,ImageWave,Spacing)
	
	String YesNo= "Yes;No"
	variable MoreSpace=1
	
	variable steps=(1/Dimdelta(ImageWave,0))
	print time() + ": Step=" + num2str(step) + " Spacing=" + num2str(Spacing)
	Wave w=wr[0]
	
	Smooth/S=2 smoothingfactor, w
	DoWindow/K LinePlot
	Display as "LinePlot";
	DoWindow/C LinePlot
	//wave tuv=wr[100000]

	variable minstep, counter = dimoffset(ImageWave,0)
	for (minstep=1; counter <= lowlimit; counter += dimdelta(ImageWave,0))
		minstep+=1
	endfor

	variable maxstep
	counter = dimoffset(ImageWave,0)
	for (maxstep=1; counter <= dimdelta(ImageWave,0)*2; counter += dimdelta(ImageWave,0))
		maxstep+=1
	endfor
	
	if (minstep == 1)
		AppendToGraph/C=(0,0,0) w
	endif

	for(i=step; i<Dimsize(ImageWave,0); i+=step)
		if (i <= maxstep && i >= minstep)
			WAVE w=wr[i]
			Smooth/S=2 smoothingfactor, w
			AppendToGraph/C=(0,0,0) w
		endif
	endfor
	
	ModifyGraph noLabel(left)=1
	ModifyGraph lblMargin(left)=10,lblLatPos=0
	ModifyGraph mirror(bottom)=1
	ModifyGraph mirror(left)=1
	ModifyGraph margin(left)=58,margin(bottom)=43,margin(top)=14,margin(right)=14
	Label left "\Z16Intensity (a.u.)"
	ModifyGraph width=216,height={Aspect,2}
//	ModifyGraph width=576,height=288
	SetAxis bottom -0.688, 0.688
	Label bottom "\Z16k\Bx\M (Å\S-1\M)"
	TextBox/C/N=text0/F=0/X=104.17/Y=6.24 "Step=\r"+num2str(step*Dimdelta(ImageWave,0))+"eV"
	TextBox/C/N=text1/F=0/X=2.78/Y=94.44/B=1 num2str(lowlimit)+"eV"
	TextBox/C/N=text2/F=0/X=2.44/Y=15.10/B=1 num2char(0xB5)
	
	DoWindow/K DataPlot
	Display as "DataPlot"; AppendImage ImageWave
	DoWindow/C DataPlot
	MoveWindow/W=DataPlot 334, 0, 0, 0
	ModifyGraph swapXY=1;DelayUpdate
	ModifyGraph margin(left)=58,margin(bottom)=43,margin(top)=14,margin(right)=14;DelayUpdate
	ModifyGraph width=216,height={Aspect,2};DelayUpdate
//	ModifyGraph width=576,height=288
	SetAxis bottom -0.688, 0.688
	Label bottom "\\Z16k\\Bx\\M (Å\\S-1\\M)";DelayUpdate
	Label left "\\Z16Binding Energy (eV)";DelayUpdate
	ModifyGraph lblMargin(left)=10;DelayUpdate
	ModifyGraph mirror(left)=1;DelayUpdate
	ModifyGraph mirror(bottom)=1;DelayUpdate
	SetAxis left lowlimit,0.5
	doupdate
//	
//	wl= SubroutineLog(p,ImageWave)
//	WAVE w2=wl[0]
//	Smooth/S=2 smoothingfactor, w2
//	DoWindow/K LinePlotLog
//	Display as "LinePlotLog";AppendToGraph/C=(0,0,0) w2
//	DoWindow/C LinePlotLog
//	for(i=step; i<(Dimsize(ImageWave,1)-1); i+=step)
//		WAVE w2=wl[i]
//		Smooth/S=2 smoothingfactor, w2
//		AppendToGraph/C=(0,0,0) w2
//	endfor
//	
//	ModifyGraph noLabel(left)=1
//	ModifyGraph lblMargin(left)=30
//	Label left "Intensity (a.u.)"
//	ModifyGraph width=200,height=432
//	Label bottom "Binding Energy (eV)"
//	TextBox/C/N=text0/F=0 "Step="+num2str(step*Dimdelta(ImageWave,1))+"eV"
//	MoveWindow 400, 0, 988, 600
//	SetAxis left 30000,*
//	ModifyGraph log(left)=1

//	do
//		doupdate
//		Prompt MoreSpace, "Different Spacing?", popup YesNo
//		DoPrompt "I'd take a goldfish now", MoreSpace
//		if(V_Flag==1)
//				return -1
//		endif
//		if (MoreSpace==1&&V_flag==0)
//			Prompt Spacing, "How much space"
//			DoPrompt "Who is bothering me now?", Spacing
//			if(V_Flag==1)
//				return -1
//			endif
//			wr= SubroutineLinear(p,ImageWave,Spacing)
//			duplicate/O wr[0] w
//			Smooth/S=2 smoothingfactor, w
//			DoWindow/K LinePlot
//			Display as "LinePlot";AppendToGraph/C=(0,0,0) w
//			DoWindow/C LinePlot
//
//			for(i=step; i<(Dimsize(ImageWave,1)-1); i+=step)
//				WAVE w=wr[i]
//				Smooth/S=2 smoothingfactor, w
//				AppendToGraph/C=(0,0,0) w
//			endfor
//		
//			ModifyGraph noLabel(left)=1,lblMargin(left)=50
//			Label left "Intensity (a.u.)"
//			ModifyGraph width=200,height=432
//			Label bottom "Binding Energy (eV)"
//			TextBox/C/N=text0/F=0 "Step="+num2str(step*Dimdelta(ImageWave,1))+"eV"
//		endif
//	while (MoreSpace!=2)
//	
//	newpath/O/C path
//	string filenameLinear="LinePlot_Linear_Step="+num2str(step*Dimdelta(ImageWave,1))+"eV_Spacing="+num2str(Spacing)+".bmp"
//	string filenameLog="LinePlot_Log_Step="+num2str(step*Dimdelta(ImageWave,1))+"eV_Spacing="+num2str(Spacing)+".bmp"
//	
//	DoWindow/F LinePlot
//	SavePICT/E=-4/P=path as filenameLinear
//	
//	DoWindow/F LinePlotLog
//	SavePICT/E=-4/P=path as filenameLog
	
end

Function/WAVE SubroutineLinear(i,ImageWave,Spacing)
	Variable i, Spacing
	Wave ImageWave
		
	Variable energy	
	energy=dimoffset(ImageWave,0)+dimdelta(ImageWave,0)*i
	String name = "Wave"+num2str(energy)

	// Create a wave with a computed name and also a wave reference to it
	
	Duplicate/O/R=[i][0,*] ImageWave, temp
	matrixtranspose temp
	Duplicate/O temp, $name
	KillWaves temp
	wave w=$name
	
	w=w+(i)*Spacing
	return w				// Return the wave reference to the calling routine
End

Function/WAVE SubroutineLog(i,ImageWave)
	Variable i
	Wave ImageWave
	
	Variable energy	
	energy=dimoffset(ImageWave,1)+dimdelta(ImageWave,1)*i
	String name = "LogEnergy"+num2str(energy)

	// Create a wave with a computed name and also a wave reference to it
	
	Duplicate/O/R=[0,*][i] ImageWave, $name
	wave w=$name
	w=w*(1.15)^i
	return w				// Return the wave reference to the calling routine
End

Function MymoveLine2(curval)
		Variable curval
		
		print "Current value of cursor is "+num2str(curval)

		Setdatafolder root:folder3D:
		String nameS,nameR,nameL
		nameS = ImageNameList("Angle_Energy", "" )
		nameL = StringFromList (0, nameS  , ";")
		nameR = StringFromList (1, nameS  , ";")
		
		ControlInfo /W=k_Space_2D check5
		variable help5 = V_value
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
				print ni
				mi = curval
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
				string kx
				sprintf kx, "%.3f", mi
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
				Variable C2 = 180/Pi
				wave LayerN_K
				
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
				variable C1
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
					TextBox/C/N=text1/X=30.00/Y=42.00/B=1 "\\K(65535,65535,65535)k\\Bx\\M="+kx
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

	return 0
End

Function MySetLayer()

	//print "My Set Layer Ran"
	ControlInfo /W=k_Space_2D SetLayers
	variable dval= V_value
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
					LayerN_K = LayerN_K^help2
				endif
				
				if(help1 == 1)
					ImageHistModification LayerN_K
					LayerN_K = M_ImageHistEq		
				endif
				
				Wavestats/Q/Z LayerN_K
				ModifyImage LayerN_K ctab= {*,*,Grays,0}
				DoUpdate
				Slider contrastmin,limits={V_min,V_max,0}
				Slider contrastmax,limits={V_min,V_max,0}
				DoUpdate
			break
			
		endswitch

	return 0
End

function/S mynum2str(input)
	variable input
	
	string mystring=""
	
	if(input>=0)
		mystring="+"
	else
		mystring="-"
	endif
	input=abs(input)
	if(10>input>1)
		mystring=mystring+num2istr(floor(input))+"p"
		input=input-floor(input)
	endif
	variable i=0
	for(i=0; i<3; i+=1)
		input=input*10
		if(10>input>1)
			mystring=mystring+num2istr(floor(input))
			input=input-floor(input)
		else
			mystring=mystring+"0"
		endif
	endfor
	
	return mystring
end


Function IntegrateImageY(startPos,endPos)
	variable startPos,endPos
	
	wave ImageY
	MymoveLine2(startPos)
	duplicate/O ImageY AngleIntegratedImageY
	variable i=0
	for (i=(startPos+1);i<(endPos+1);i+=1)
		MymoveLine2(i)
		AngleIntegratedImageY=AngleIntegratedImageY+ImageY
	endfor
	
	Display as "Angle Integrated Image Y"; AppendImage AngleIntegratedImageY
	
End	

function FindMyPeak(InputWave,StartValue,EndValue)
	wave InputWave
	variable StartValue, EndValue
	
	DoWindow/K FindingPeak
	DoWindow/K FitThePeak
	DoWindow/K MaxLocationPlot
	KillWaves/Z MaxLocation, MaxLocationGauss
	Display as "FindingPeak";AppendImage InputWave
	DoWindow/C FindingPeak
	ModifyGraph swapXY=1, width=288,height=288
	DoUpdate
	
	
	String Transpose="No;Yes"
	variable transposeprompt=0
	Prompt transposeprompt "Should I take the transpose?", popup Transpose
	
	DoPrompt "Think you got what it takes to make it, kid?", transposeprompt
	
	if (V_Flag==1)
		return -1
	endif
	
	if (transposeprompt==2)
		matrixtranspose InputWave
	endif
	
	variable start,endpoint
	variable/G Auto=0, k2
	
	start=Ceil((StartValue-dimoffset(InputWave,1))/dimdelta(InputWave,1))
	endpoint=floor((EndValue-dimoffset(InputWave,1))/dimdelta(InputWave,1))
	

	Duplicate/O InputWave, ImageWave_smth
	Smooth 30, ImageWave_smth
	make/O/N=(endpoint-start-1), MaxLocation, MaxLocationGauss
	variable ydelta=dimdelta(ImageWave_smth,1)
	SetScale/P x StartValue, ydelta,"", MaxLocation, MaxLocationGauss
	AppendToGraph/VERT MaxLocation, MaxLocationGauss

	variable i=0, j=0, k=0, tempmaxlocprev, tempmaxvalprev, lowerbound, upperbound, autoAbortSecs=0
	Make/O/N=(dimsize(ImageWave_smth,0)), tempwave
	
	variable xstart=dimoffset(ImageWave_smth,0), xdelta=dimdelta(ImageWave_smth,0)
	SetScale/P x xstart, xdelta,"", tempwave
	Display tempwave
	DoWindow/C FitThePeak
	ModifyGraph width=300,height=216
	MoveWindow 500, 0, 900, 300
	 
	String win=WinName(0,1)
	Cursor A, tempwave, -1.25
	Cursor B, tempwave, -0.65
//	Showinfo
	tempwave=ImageWave_smth[p][start]
	TextBox/C/N=text0/X=10.00/Y=10.00/F=0 "kx="+num2str(dimoffset(InputWave,1)+dimdelta(InputWave,1)*i)+""
	if(Auto==0)
		// print "not Automated"
		if (UserCursorAdjust(win,autoAbortSecs,0) != 0)
			return -1
		endif
	endif
	if (strlen(CsrWave(A))>0 && strlen(CsrWave(B))>0)	// Cursors are on trace?
		lowerbound=pcsr(A);
		upperbound=pcsr(B);
		// print lowerbound, upperbound
	else
		lowerbound=tempmaxlocprev-15*xdelta
		upperbound=tempmaxlocprev+15*xdelta
	endif
	findpeak/R=[lowerbound,upperbound]/M=(tempmaxvalprev*0.5) tempwave
	CurveFit/Q/NTHR=0 gauss  tempwave[lowerbound,upperbound] /D 
	if (V_flag==0)
		MaxLocation[0]=V_PeakLoc
		MaxLocationGauss[0]=k2
		tempmaxlocprev=V_PeakLoc
		tempmaxvalprev=V_PeakVal
	else
		MaxLocation[i]=tempmaxlocprev
	endif
	Cursor A, tempwave, tempmaxlocprev-30*xdelta
	Cursor B, tempwave, tempmaxlocprev+30*xdelta
	for(i=1; i<endpoint-start-1; i+=1)
			tempwave=ImageWave_smth[p][i+start]
			TextBox/C/N=text0/X=10.00/Y=10.00/F=0 "kx="+num2str(dimoffset(InputWave,1)+dimdelta(InputWave,1)*i)+""
		if(Auto==0)
			//print "not Automated"
			if (UserCursorAdjust(win,autoAbortSecs,0) != 0)
				return -1
			endif
		endif
		if (strlen(CsrWave(A))>0 && strlen(CsrWave(B))>0)	// Cursors are on trace?
			// print "using Cursors for bounds"
			lowerbound=pcsr(A);
			upperbound=pcsr(B);
			// print lowerbound, upperbound
		else
			lowerbound=tempmaxlocprev-15*xdelta
			upperbound=tempmaxlocprev+15*xdelta
		endif
			Cursor A, tempwave, tempmaxlocprev-30*xdelta
			Cursor B, tempwave, tempmaxlocprev+30*xdelta
//			lowerbound=pcsr(A)
			// print "the lowerbound is "+num2str(lowerbound)
//			upperbound=pcsr(B)
			// print "the upperbound is "+num2str(upperbound)
			
			findpeak/Q/R=[lowerbound,upperbound]/M=(tempmaxvalprev*0.5) tempwave
			CurveFit/Q/NTHR=0 gauss  tempwave[lowerbound,upperbound] /D 
			if (V_flag==0)
				MaxLocation[i]=V_PeakLoc
				MaxLocationGauss[i]=k2
				tempmaxlocprev=V_PeakLoc
				tempmaxvalprev=V_PeakVal
			else
				MaxLocation[i]=tempmaxlocprev
			endif
			
		endfor
//	DeletePoints endpoint, dimsize(MaxLocation,0)-endpoint, MaxLocation
//	DeletePoints 0,Start+1, MaxLocation
//	SetScale/P x ystart+Start*ydelta, ydelta,"", MaxLocation
	Display MaxLocation, MaxLocationGauss
	DoWindow/C MaxLocationPlot
	ModifyGraph width=400,height=150
	Legend/C/N=text0/F=0
	MoveWindow 650, 300, 988, 600
	Variable/G VBoffsetMaxFunc, VBoffsetGaussFunc, VBcurvatureMaxFunc, VBcurvatureGauss, MeffMaxFunc, MeffGauss
	CurveFit/NTHR=0 poly 3,  MaxLocation[0,*] /D
	VBoffsetMaxFunc=K0
	VBcurvatureMaxFunc=K2
	MeffMaxFunc=((1.055E-34)^2/2/(abs(K2)*1E-20*1.6E-19))/9.11E-31
	CurveFit/NTHR=0 poly 3,  MaxLocationGauss[0,*] /D
	VBoffsetGaussFunc=K0
	VBcurvatureGauss=K2
	MeffGauss=((1.055E-34)^2/2/(abs(K2)*1E-20*1.6E-19))/9.11E-31
	Print "The Valence Band offset from the Fermi Level for the Max fit is:"
	print num2str(round(VBoffsetMaxFunc*1000))+" meV"
	Print "The calculated effective mass ratio from the Max function is:"
	Print MeffMaxFunc
	Print "The Valence Band offset from the Fermi Level for the Guass fit is:"
	print num2str(round(VBoffsetGaussFunc*1000))+" meV"
	Print "The calculated effective mass ratio from the Gauss fit is:"
	Print MeffGauss
	Print "Adjust array Parameters by :"+num2str(K1/(2*K2))
	
	ModifyGraph rgb(fit_MaxLocation)=(0,65280,0);DelayUpdate
	ModifyGraph rgb(fit_MaxLocationGauss)=(0,0,65280)
	ModifyGraph mode(MaxLocation)=3,rgb(MaxLocation)=(0,0,0),mode(MaxLocationGauss)=3
	wave fit_MaxLocation
	DoWindow/F FindingPeak 
	Label left "\\Z14\\f01Binding energy (eV)"
	Label bottom "\\Z16\\f01K\\B||\\M\\Z16(\\Z12Å\\S-1\\M\\Z16)"
	AppendToGraph/VERT fit_MaxLocation
	doupdate
	
	String Redo="No;Yes"
	variable Redoprompt=0
	Prompt Redoprompt "Should I try again?", popup Redo
	
	DoPrompt "Why so serious?", Redoprompt
	variable newstartpoint=StartValue, newendpoint=EndValue
	if (Redoprompt==2)
		Prompt newstartpoint "New Startpoint"
		Prompt newendpoint "New Endpoint"
		SetArrayParams(inputwave)
		DoPrompt "Don't think you'll get away with this so easy" newstartpoint, newendpoint
		FindMyPeak(InputWave,newstartpoint,newendpoint)
	endif

end

function PlotRingCurrentandFlux()

	String scanchoice="NormalEmission;Fermi Surface"
	variable scanprompt=1, V_Flag
	Prompt scanprompt "What type of scan is this?", popup scanchoice
	DoPrompt "How may I serve you?", scanprompt

	if (V_Flag==1)
		return -1
	endif
	
	if (scanprompt == 1)
		PlotBeamParamsNormalEmission()
	else
		PlotBeamParamsFermiSurface()
	endif

end

function PlotBeamParamsNormalEmission ()
	
//	SetDataFolder root:folder3D

	String gratingchoice="1;2;3"
	variable gratingprompt=1, V_Flag
	Prompt gratingprompt "Which Grating number is this?", popup gratingchoice
	
	DoPrompt "WHY ARE YOU ALWAYS BUGGING ME?", gratingprompt
	
	if (V_Flag==1)
		return -1
	endif
	
	String Grating = num2str(gratingprompt)
	
	LoadWave/J/D/W/O/K=0
	wave hv, Ring_Current, Flux, Initial_Flux
	DoWindow/F BeamParameters
	if (V_Flag==0)
		Display Ring_Current vs hv as "BeamParameters"
		DoWindow/C BeamParameters
	else
		AppendToGraph/L Ring_Current vs hv
	endif
	
	ModifyGraph width=288,height=288
	AppendToGraph/R Initial_Flux vs hv
	AppendToGraph/R Flux vs hv
	Label right "Flux"
	ModifyGraph mode(Flux)=3
	ModifyGraph mode(Initial_Flux)=3
	ModifyGraph rgb(Flux)=(0,0,65280)
	ModifyGraph rgb(Initial_Flux)=(0,0,65280)
	Label left "\\K(65280,0,0)\\Z18Ring Current (mA)";DelayUpdate
	Label right "\\K(0,0,65280)\\Z18Beam Photocurrent (nA)"
	ModifyGraph prescaleExp(right)=9
	ModifyGraph mirror(bottom)=2;DelayUpdate
	ModifyGraph log(right)=1
	Label bottom "\\Z18 Photon Energy (eV)"
	ModifyGraph fSize=16,font="Times New Roman"
	ModifyGraph notation(right)=1
	ModifyGraph axRGB(left)=(65280,0,0),tlblRGB(left)=(65280,0,0), alblRGB(left)=(65280,0,0)
	ModifyGraph axRGB(right)=(0,0,65280),tlblRGB(right)=(0,0,65280), alblRGB(right)=(0,0,65280)
	
	String FluxWave, InitialFluxWave, hvWave, RingCurrentWave
	FluxWave="FluxG"+Grating
	InitialFluxWave="Initial_FluxG"+Grating
	hvWave="hvG"+Grating
	RingCurrentWave="Ring_CurrentG"+Grating
	KillWaves/Z $FluxWave
	rename Flux $FluxWave
	KillWaves/Z $InitialFluxWave, Flux
	rename Initial_Flux $InitialFluxWave
	KillWaves/Z $hvWave, Initial_Flux
	rename hv $hvWave
	KillWaves/Z $RingCurrentWave, hv
	rename Ring_Current $RingCurrentWave
	KillWaves/Z Ring_Current
	
End

function PlotBeamParamsFermiSurface ()
	
	SetDataFolder root:folder3D
	
	LoadWave/J/D/W/O/K=0
	wave Theta, Ring_Current, Flux, Initial_Flux
	
	DoWindow/K BeamParameters
	Display Ring_Current vs Theta as "BeamParameters"
	DoWindow/C BeamParameters
	
	ModifyGraph width=288,height=288
	AppendToGraph/R Initial_Flux vs Theta
	AppendToGraph/R Flux vs Theta
	Label right "Flux"
	ModifyGraph mode(Flux)=3
	ModifyGraph mode(Initial_Flux)=3
	ModifyGraph rgb(Flux)=(0,0,65280)
	ModifyGraph rgb(Initial_Flux)=(0,0,65280)
	Label left "\\K(65280,0,0)\\Z18Ring Current";DelayUpdate
	Label right "\\K(0,0,65280)\\Z18Flux"
	ModifyGraph mirror(bottom)=2;DelayUpdate
	Label bottom "\\Z18 Theta (Degrees)"
	ModifyGraph fSize=16,font="Times New Roman"
	ModifyGraph notation(right)=1
	ModifyGraph axRGB(left)=(65280,0,0),tlblRGB(left)=(65280,0,0), alblRGB(left)=(65280,0,0)
	ModifyGraph axRGB(right)=(0,0,65280),tlblRGB(right)=(0,0,65280), alblRGB(right)=(0,0,65280)
	
	String FluxWave, InitialFluxWave, ThetaWave, RingCurrentWave
	FluxWave="FluxG"
	InitialFluxWave="Initial_FluxG"
	ThetaWave="ThetaG"
	RingCurrentWave="Ring_CurrentG"
	KillWaves/Z $FluxWave
	rename Flux $FluxWave
	KillWaves/Z $InitialFluxWave, Flux
	rename Initial_Flux $InitialFluxWave
	KillWaves/Z $ThetaWave, Initial_Flux
	rename Theta $ThetaWave
	KillWaves/Z $RingCurrentWave, Theta
	rename Ring_Current $RingCurrentWave
	KillWaves/Z Ring_Current
	
end

Function SubtractBackground(InputWave,Ef)
	wave InputWave
	Variable Ef
		
	DoWindow/K LinarBackSubtract
	Display as "LinarBackSubtract";AppendImage InputWave
	DoWindow/C LinarBackSubtract
	ModifyGraph width=288,height=288
	DoUpdate
	
	
	String Transpose="No;Yes"
	variable transposeprompt=0
	Prompt transposeprompt "Should I take the transpose?", popup Transpose
	
	DoPrompt "Think you got what it takes to make it, kid?", transposeprompt
	
	if (V_Flag==1)
		return -1
	endif
	
	if (transposeprompt==2)
		matrixtranspose InputWave
	endif
	
	string name
	name = ImageNameList("", "" )
	name = StringFromList (0, name  , ";")
	
	Variable xoffset=dimoffset(InputWave,0),yoffset=dimoffset(InputWave,1),ydim=dimsize(InputWave,1),xdim=dimsize(InputWave,0), xdelta=dimdelta(InputWave,0), ydelta=dimdelta(InputWave,1)
		
	Execute "Cursor/W=# /P/I/H=3/C=(65280,0,0)/S=2 A "+name+" 0,"+num2str(round(0.93*ydim))
	Execute "Cursor/W=# /P/I/H=3/C=(65280,65280,0)/S=2 B "+name+" 0,"+num2str(round(0.05*ydim))
	Variable autoAbortSecs=0
	String win=WinName(0,1)
	Showinfo
	if (UserCursorAdjust(win,autoAbortSecs,0) != 0)
		return -1
	endif

End

Function FindFermiEdge()
// Incomplete???
	string name
	name = ImageNameList("", "" )
	name = StringFromList (0, name  , ";")
	
	Execute "Cursor/W=# /P/I/H=2/C=(65280,0,0)/S=2 A "+name+" 15,15"



End

Function FermiEdge(w,x): FitFunc
	Wave w
	variable x
	return w[0]/(Exp((x-w[1])/(8.617E-5*w[2]))+1)+w[3]
end

Function FermiEdgeLinearBack(w,x): FitFunc
	Wave w
	variable x
	return w[0]/(Exp((x-w[1])/(8.617E-5*w[2]))+1)*(w[3]*x+w[4])+w[5]
end


Function GaussconvFermiEdge(w,x): FitFunc
	Wave w
	variable x
	return w[0]*Exp(-((x-w[1])/w[2])^2)/(Exp((x-w[3])/(8.617E-5*w[4])))+w[5]*x+w[6]
	
end

// To use:
// 1) LayerN_K centered and in k-space
// 2) Select "Cursors" button in the k_Space_2D window
// 3) Select B/K on arbitrary window
// 4) Highlight k_Space_2D window
// 5) Run program
// Ouputs images to given path
function buildProjectionPlot ()

	variable k0=1.37614463
	Prompt k0, "What is the surface unit momentum?"
	DoPrompt "The power of NOW.", k0
	if (V_Flag==1)
		return 1
	endif
	
	NewPath/O path

	wave ArbCut
	
	DoWindow/F k_Space_2D
	
	print time() + ": Beginning extraction."
	
	getArbCut (0.5*k0, 0*k0, 0*k0, 0*k0, 2)
	Duplicate/O ArbCut temp1
	print time() + ": Cut 1 complete."
	
	getArbCut (0*k0, 0*k0, 0*k0, 0.5*k0, 1)
	Duplicate/O ArbCut temp2
	print time() + ": Cut 2 complete."	
	
	getArbCut (0*k0, 0.5*k0, 0.5*k0, 0.5*k0, 2)
	Duplicate/O ArbCut temp3
	print time() + ": Cut 3 complete."
	
	getArbCut (0.5*k0, 0.5*k0, 0*k0, 0*k0, 3)
	Duplicate/O ArbCut temp4
	print time() + ": Cut 4 complete."

	// AdjustWaveOffsetsForPlotting
	
	DoWindow/K X2G
	Display as "Extracted Cut X2-G";AppendImage temp1
	DoWindow/C X2G
	ModifyGraph swapXY=1
	SetAxis left -3,0.5
	SetAxis bottom 0.5*k0, 0
	ModifyGraph mirror(bottom)=1,standoff=0
	ModifyGraph manTick(bottom)={0,0.5*k0,0,1},manMinor(bottom)={0,0}
	ModifyGraph noLabel(bottom)=2
	ModifyGraph mirror(left)=0
	ModifyGraph fSize(left)=20,font(left)="Calibri";DelayUpdate
	Label left "\\F'Calibri'\\Z22Binding Energy (eV)"
	ModifyGraph height={Aspect,3}
	ModifyGraph width=144
	ModifyImage temp1 ctab= {*,*,Grays,0}
	
	Wavestats/Q/Z temp1
	DoUpdate
	variable low=V_min
	variable high = V_max
	Prompt low, "Minimum intensity value?"
	Prompt high, "Maximum intensity value?"
	DoPrompt "It's be a looong road gettin' from here to there...", low, high
	if (V_Flag==1)
		return 1
	endif
	
	ModifyImage temp1 ctab= {low,high,Grays,0}
	
	SavePICT/O/E=-7/B=576/P=path as "X2GX1MG01 Cut(X2-G).tif"
	
	DoWindow/K GX1
	Display as "Extracted Cut G-X1";AppendImage temp2
	DoWindow/C GX1
	ModifyGraph swapXY=1
	SetAxis left -3,0.5
	SetAxis bottom 0,0.5*k0
	ModifyGraph mirror(bottom)=1,standoff=0
	ModifyGraph manTick(bottom)={0,0.5*k0,0,1},manMinor(bottom)={0,0}
	ModifyGraph tick(left)=3
	ModifyGraph noLabel=2
	ModifyGraph mirror(left)=0
	ModifyGraph height={Aspect,3}
	ModifyGraph width=144
	ModifyGraph axThick(left)=0
	ModifyImage temp2 ctab= {low,high,Grays,0}
	SavePICT/O/E=-7/B=576/P=path as "X2GX1MG02 Cut(G-X1).tif"

	DoWindow/K X1M
	Display as "Extracted Cut X1-M";AppendImage temp3
	DoWindow/C X1M
	ModifyGraph swapXY=1
	SetAxis left -3,0.5
	SetAxis bottom 0,0.5*k0
	ModifyGraph mirror(bottom)=1,standoff=0
	ModifyGraph manTick(bottom)={0,0.5*k0,0,1},manMinor(bottom)={0,0}
	ModifyGraph tick(left)=3
	ModifyGraph noLabel=2
	ModifyGraph mirror(left)=0
	ModifyGraph height={Aspect,3}
	ModifyGraph width=144
	ModifyGraph axThick(left)=0
	ModifyImage temp3 ctab= {low,high,Grays,0}
	SavePICT/O/E=-7/B=576/P=path as "X2GX1MG03 Cut(X1-M).tif"
	
	DoWindow/K MG
	Display as "Extracted Cut M-G";AppendImage/T temp4
	DoWindow/C MG
	ModifyGraph swapXY=1
	SetAxis right -3,0.5
	SetAxis bottom 0.707107*k0, 0
	ModifyGraph mirror(bottom)=1,standoff=0
	ModifyGraph manTick(bottom)={0,0.707107*k0,0,1},manMinor(bottom)={0,0}
	ModifyGraph noLabel=2
	ModifyGraph mirror(right)=0
	ModifyGraph width=204
	ModifyGraph height=432
	ModifyImage temp4 ctab= {low,high,Grays,0}
	SavePICT/O/E=-7/B=576/P=path as "X2GX1MG04 Cut(M-G).tif"

	print time() + ": Images saved. Operation complete."
end


//To use select the "Cursors button in the k_Space_2D window then run program.
//Remember the k_Space_2D window uses swapped axis so x=vertical axis and y=horizontal axis
//Output is saved as wave "ArbCut"
function getArbCut (x1, y1, x2, y2, direction)
	variable x1, y1, x2, y2, direction
	
	wave LayerN_K
	DoWindow/F k_Space_2D
	
	variable xmin = dimoffset(LayerN_K,0)
	variable xmax = dimoffset(LayerN_K,0) + dimdelta(LayerN_K,0) * dimsize(LayerN_K,0)
	variable ymin = dimoffset(LayerN_K,1)
	variable ymax = dimoffset(LayerN_K,1) + dimdelta(LayerN_K,1) * dimsize(LayerN_K,1)
	
	switch (direction)
	case 1: //vertical slices	
		if (x1 > xmax || x1 < xmin)
			print "Error slice out of bounds."
			return 1
		endif
		
		if (y1 > y2)
			if (y1 > ymax)
				y1 = ymax
			endif
			if (y2 < ymin)
				y2 = ymin
			endif
		else
			if (y1 < ymin)
				y1 = ymin
			endif
			if (y2 > ymax)
				y2 = ymax
			endif
		endif
	break
	case 2: //horizontal slices	
		if (y1 > ymax || y1 < ymin)
			print "Error slice out of bounds."
			return 1
		endif
		
		if(x1 > x2)
			if (x1 > xmax)
				x1 = xmax
			endif
			if (x2 < xmin)
				x2 = xmin
			endif
		else
			if (x1 < xmin)
				x1 = xmin
			endif
			if (x2 > xmax)
				x2 = xmax
			endif
		endif
	break
	case 3: //diagonal slices	
		if(x1 > x2)
			if (x1 > xmax)
				y1 = y1*xmax/x1
				x1 = xmax
			endif
			if (x2 < xmin)
				y2 = y2*xmin/x2
				x2 = xmin
			endif
		else
			if (x1 < xmin)
				y1 = y1*xmin/x1
				x1 = xmin
			endif
			if (x2 > xmax)
				y2 = y2*xmax/x2
				x2 = xmax
			endif
		endif
		if (y1 > y2)
			if (y1 > ymax)
				x1 = x1*ymax/y1
				y1 = ymax
			endif
			if (y2 < ymin)
				x2 = x2*ymin/y2
				y2 = ymin
			endif
		else
			if (y1 < ymin)
				x1 = x1*ymin/y1
				y1 = ymin
			endif
			if (y2 > ymax)
				x2 = x2*ymax/y2
				y2 = ymax
			endif
		endif
	break
	endswitch
	
	print "1=(" + num2str(x1) + ", " + num2str(y1) + ") and 2=(" + num2str(x2) + ", " + num2str(y2) + ")"
	
	variable xcoord1 = (x1 - dimoffset(LayerN_K,0))/(dimdelta(LayerN_K,0))
	variable ycoord1 = (y1 - dimoffset(LayerN_K,1))/(dimdelta(LayerN_K,1))
	variable xcoord2 = (x2 - dimoffset(LayerN_K,0))/(dimdelta(LayerN_K,0))
	variable ycoord2 = (y2 - dimoffset(LayerN_K,1))/(dimdelta(LayerN_K,1))
	
	Cursor/W=# /P/I/H=0/S=0/C=(0,65280,0) I LayerN_K xcoord1,ycoord1
	Cursor/W=# /P/I/H=0/S=0/C=(0,65280,0) J LayerN_K xcoord2,ycoord2
	DoUpdate
	
	wave Plane1_B
	Duplicate/O Plane1_B ArbCut
end

function extractSliceForFermiEdgeFit(IncomingWave)

	wave IncomingWave
	variable length = dimsize(IncomingWave,0)
	Duplicate/O/R=[0,length](0,0) IncomingWave, ExtractedWave
	
	SetScale/P x, dimoffset(IncomingWave,0), dimdelta(IncomingWave,0), ExtractedWave
	Redimension/N=-1 ExtractedWave
	Display ExtractedWave
end

function FindFermiLevel2()
	wave ImageY
	
	SetDataFolder root:folder3D
	//Duplicate/O ImageY
	DoWindow/K OriginalBandStructure
	Display as "Original Band Structure";AppendImage ImageY
	DoWindow/C OriginalBandStructure
	ModifyGraph swapXY=1, width=288,height=288
	
	Duplicate/O ImageY, ImageWave_temp
	make/O/N=(dimsize(ImageWave_temp,1)), MinLocation
	variable i=0, j=0, k=0, tempminlocprev=420, tempminvalprev=0, lowerbound=395, upperbound=450, autoAbortSecs=0
	Make/O/N=(dimsize(ImageWave_temp,0)), tempwave
	
	variable xstart=dimoffset(ImageWave_temp,0), xdelta=dimdelta(ImageWave_temp,0)
	SetScale/P x xstart, xdelta,"", tempwave
	DoWindow/K LineProfile
	Display tempwave as "Line Profile of Slice"
	DoWindow/C LineProfile
	ModifyGraph width=300,height=216
	MoveWindow 500, 0, 900, 300
		
//	execute/Z/Q "Cursor/W=# /P/H=2/C=(0,0,0)/S=2 B tempwave 340"
//	execute/Z/Q "Cursor/W=# /P/H=2/C=(0,0,0)/S=2 A tempwave 500"
	variable/G Auto=0
	String win=WinName(0,1)
	Showinfo
	for(i=0; i<dimsize(ImageWave_temp,1); i+=1)
		tempwave=Imagewave_temp[p][i]
		TextBox/C/N=text0/X=10.00/Y=10.00/F=0 "hw="+num2str(dimoffset(ImageY,1)+dimdelta(ImageY,1)*i)+"eV"
		if(Auto==0)
			if (UserCursorAdjust(win,autoAbortSecs,1) != 0)
				return -1
			endif
		endif
		
		if (Auto != 1) // REDO NOT CLICKED
			
			if (strlen(CsrWave(A))>0 && strlen(CsrWave(B))>0)	// Cursors are on trace?
				lowerbound=pcsr(A);
				upperbound=pcsr(B);
				// print lowerbound, upperbound
			else
				lowerbound=tempminlocprev-10*xdelta
				upperbound=tempminlocprev+12*xdelta
			endif
		
			// Find edge store in MinLocation[i]
			Make/D/N=4/O W_coef
				W_coef[0] = {vcsr(A),(xcsr(A)+xcsr(B))/2,300,vcsr(B)}
			FuncFit/NTHR=0 FermiEdge W_coef  tempwave[pcsr(A),pcsr(B)] /D
			DoUpdate
		
			MinLocation[i]=W_coef[1]
			tempminlocprev=W_coef[1]
		else		//REDO CLICKED
				Auto = 0
				i = i-2
		endif
	endfor
	
	KillWindow win
	
	Duplicate/O MinLocation,MinLocation_smth
	Display MinLocation, MinLocation_smth
	ModifyGraph width=400,height=150
	MoveWindow 650, 300, 988, 600
	AdjustFermiLevel()
	
	Variable Smoothing=1
	String YesNo= "Yes;No"
	variable MoreSmooth=1
	do
		doupdate
		Prompt MoreSmooth, "More Smoothing", popup YesNo
		DoPrompt "I'd take a goldfish now", MoreSmooth
		if (V_Flag==1)
			return 1
		endif
		if (MoreSmooth==1)
			Prompt Smoothing, "How much more smoothing"
			DoPrompt "Who is bothering me now?", Smoothing
			if (V_Flag==1)
				return 1
			endif
			Smooth Smoothing, MinLocation_smth
			AdjustFermiLevel()
		endif
	while (MoreSmooth!=2)
	Wave AdjustedImage
//	LinePlots(AdjustedImage,15)	
end

//////////////////////////// Button and function controls for Waterfall plot used with Adjusted Image/////////////////////
Function CreateWaterfalls(ctrlName) : ButtonControl
	string ctrlName
	
	variable/G offset
	wave AdjustedImage
	PlotWaterfallwithOffset(offset,AdjustedImage)
	     
end

Function ChangeOffset(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum	// value of variable as number
	String varStr		// value of variable as string
	String varName	// name of variable
	
	variable/G offset=varNum
	wave AdjustedImage
	ModifyWaterfallwithOffset(offset,AdjustedImage)
end

Function ChangeSmoothing(ctrlName,varNum,varStr,varName) : SetVariableControl
	String ctrlName
	Variable varNum	// value of variable as number
	String varStr		// value of variable as string
	String varName	// name of variable
	
	variable/G smoothing=varNum
	variable/G offset
	wave AdjustedImage
	PlotWaterfallwithOffset(offset,AdjustedImage)
	
end

Function ModifyWaterfallwithOffset(offsetfactor,Image)
	variable offsetfactor
	Wave Image
	
	Variable range=dimsize(Image,1)
	variable i=0, eVstep=round(1*(1/dimdelta(Image,1)))
	String nametemp, theWave

	DoWindow/F WaterfallPlot
	do
		theWave="E="+num2str(dimoffset(Image,1)+i*dimdelta(Image,1))+"eV"
		Wave w=$theWave
		ModifyGraph offset($theWave)={0,range*offsetfactor*i*10}
     		i += eVStep
	while (i<dimsize(Image,1))
	
end

Function PlotWaterfallwithOffset(offsetfactor,Image)
	variable offsetfactor
	Wave Image

	
	Variable range=dimsize(Image,1)
	variable i=0, eVstep=62 //round(62*(1/dimdelta(Image,1)))
	String nametemp, theWave
	variable/G smoothing = 5
	print smoothing
	DoWindow/K WaterfallPlot
	Display/N=WaterfallPlot
	string lastEnergy
	do
		theWave="E="+num2str(dimoffset(Image,1)+i*dimdelta(Image,1))+"eV"
		lastEnergy=num2str(dimoffset(Image,1)+i*dimdelta(Image,1))
		Duplicate/O/R=[][i] Image $theWave
		Wave w=$theWave
		Smooth/S=2 smoothing*2+5, w
		AppendToGraph w
		ModifyGraph offset($theWave)={0,range*offsetfactor*i*10}
     		i += eVStep
	while (i<dimsize(Image,1))
	ModifyGraph width=216,height={Aspect,2},gfSize=18
	SetAxis bottom -3,0.5
	ModifyGraph tick(left)=3,tick(bottom)=2,mirror=2,noLabel(left)=1,axThick=1.5;DelayUpdate
	ModifyGraph lblPosMode(left)=3,lblPos(left)=30,standoff=0,btLen(bottom)=8;DelayUpdate
	ModifyGraph btThick(bottom)=1.5,stLen(bottom)=4,stThick(bottom)=1.5;DelayUpdate
	ModifyGraph rgb=(0,0,0)
	ModifyGraph lSize=1.5
	ModifyGraph margin(left)=50
	ModifyGraph margin(right)=50
	string firstEnergy=num2str(dimoffset(Image,1))
	TextBox/C/N=text0/F=0/A=RB/B=1/X=-20.00/Y=0.00 firstEnergy+"eV"
	TextBox/C/N=text1/F=0/B=1/X=-20.00/Y=10.00 lastEnergy+"eV"
	Label left "Intensity (a.u.)";DelayUpdate
	Label bottom "Binding Energy (eV)"

end