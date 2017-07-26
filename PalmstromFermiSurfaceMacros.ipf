#pragma rtGlobals=3		// Use modern global access method and strict wave access.

// To setup run these command 
// Duplicate/O CutY_K_B Slice1
// Duplicate/O CutX_K_B Slice2
// Duplicate/O CutY_K_B Slice3
// Duplicate/O CutX_K_B Slice4
// Duplicate/O LayerN_K Slice5
function Make3DFermiImage(Slice1, Slice2, Slice3, Slice4, Slice5,MaxIntensity,totalwidth,FermiEnergy,BindingEnergyLimit)
wave Slice1, Slice2, Slice3, Slice4, Slice5
variable MaxIntensity,totalwidth,FermiEnergy, BindingEnergyLimit

if (BindingEnergyLimit>0)
	BindingEnergyLimit = -BindingEnergyLimit
endif

NewPath/O path

DoWindow/K Slice1Win
Display as "Slice1";AppendImage Slice1
DoWindow/C Slice1Win
ModifyGraph swapXY=1
SetAxis bottom -totalwidth*1.5,0;DelayUpdate
SetAxis left BindingEnergyLimit,FermiEnergy
ModifyGraph width=432,height=216
ModifyImage Slice1 ctab= {0,MaxIntensity,Grays,0}
ModifyGraph tick=3,noLabel=2
ModifyGraph axRGB=(65535,65535,65535)
ModifyGraph tick=0,mirror=0,nticks=3,fSize=28;DelayUpdate
ModifyGraph standoff=0,axRGB=(0,0,0);DelayUpdate
Label bottom "k\\By\\M (Å\\S-1\\M)";DelayUpdate
Label left "Binding Energy (eV)"
ModifyGraph noLabel=0
SavePICT/E=-6/B=288/P=path as "3DSlice1.jpg"

DoWindow/K Slice2Win
Display as "Slice2";AppendImage Slice2
DoWindow/C Slice2Win
ModifyGraph swapXY=1
SetAxis bottom -totalwidth/2,0;DelayUpdate
SetAxis left BindingEnergyLimit,FermiEnergy
ModifyGraph width=144,height=216
ModifyImage Slice2 ctab= {0,MaxIntensity,Grays,0}
ModifyGraph tick=3,noLabel=2
ModifyGraph axRGB=(65535,65535,65535)
SavePICT/E=-6/B=288/P=path as "3DSlice2.jpg"

DoWindow/K Slice3Win
Display as "Slice3";AppendImage Slice3
DoWindow/C Slice3Win
ModifyGraph swapXY=1
SetAxis bottom 0,totalwidth/2;DelayUpdate
SetAxis left BindingEnergyLimit,FermiEnergy
ModifyGraph width=144,height=216
ModifyImage Slice3 ctab= {0,MaxIntensity,Grays,0}
ModifyGraph tick=3,noLabel=2
ModifyGraph axRGB=(65535,65535,65535)
SavePICT/E=-6/B=288/P=path as "3DSlice3.jpg"

DoWindow/K Slice4Win
Display as "Slice4";AppendImage Slice4
DoWindow/C Slice4Win
ModifyGraph swapXY=1
SetAxis bottom 0,totalwidth/2;DelayUpdate
SetAxis left BindingEnergyLimit,FermiEnergy
ModifyGraph width=144,height=216
ModifyGraph tick=3,noLabel=2
ModifyImage Slice4 ctab= {0,MaxIntensity,Grays,0}
ModifyGraph fSize(bottom)=28;DelayUpdate
Label bottom "\\Z28k\\Bx\\M\\Z28 (Å\\S-1\\M\\Z28)"
ModifyGraph noLabel(bottom)=0
ModifyGraph tick(bottom)=0
ModifyGraph mirror(bottom)=0,standoff=0,axRGB(left)=(65535,65535,65535)
SavePICT/E=-6/B=288/P=path as "3DSlice4.jpg"

DoWindow/K Slice5Win
Display as "Slice5";AppendImage Slice5
DoWindow/C Slice5Win
ModifyGraph swapXY=1
ModifyGraph width=576,height=288
ModifyGraph tick=3,noLabel=2
ModifyImage Slice5 ctab= {0,*,Grays,0}
SetAxis bottom -totalwidth*1.5,totalwidth/2;DelayUpdate
SetAxis left -totalwidth/2,totalwidth/2
ModifyGraph mirror=1,standoff=0
ModifyGraph axRGB=(65535,65535,65535)
RemoveWaveArea(Slice5,-2,0,0,2)
SavePICT/E=-6/B=288/P=path as "3DSlice5.jpg"
end

function RemoveWaveArea(IncomingWave, xtrimstart,xtrimfinish,ytrimstart,ytrimfinish)
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

function Quick2DFermiImage(xlimit,ylimit,elow,ehigh)
	
	variable xlimit, ylimit, elow, ehigh
	Make2DFermiImage(-xlimit,xlimit,-ylimit,ylimit,elow,ehigh)

end

//Prep: Set X, Y, and LankerN_K to k-space desired images
function Make2DFermiImage (xlow, xhigh, ylow, yhigh,elow,ehigh)
variable xlow, xhigh, ylow, yhigh, elow, ehigh
wave LayerN_K, CutX_K_B, CutY_K_B

NewPath/O path

variable temp
if (xlow > xhigh)
	temp = xlow
	xlow = xhigh
	xhigh = temp
endif
if (ylow > yhigh)
	temp = ylow
	ylow = yhigh
	yhigh = temp
endif
if (elow > ehigh)
	temp = elow
	elow = ehigh
	ehigh = temp
endif

Duplicate/O LayerN_K FermiSurface
Duplicate/O CutX_K_B CutXNE
Duplicate/O CutY_K_B CutYNE

variable sizex=216, sizey=216, sizebe=288, xdelta=xhigh-xlow, ydelta=yhigh-ylow
if (xdelta>ydelta)
	sizex=sizey*xdelta/ydelta
endif
if (xdelta<ydelta)
	sizey=sizex*ydelta/xdelta
endif

DoWindow/K FermiSurfaceImage
Display as "Fermi Surface";AppendImage FermiSurface
DoWindow/C FermiSurfaceImage
ModifyGraph swapXY=1
ModifyGraph fSize=16;DelayUpdate
ModifyGraph manTick=0;DelayUpdate
Label bottom "\\Z16k\\By\\M\\Z16 (Å\\S-1\\M\\Z16)";DelayUpdate
Label left "\\Z16k\\Bx\\M\\Z16 (Å\\S-1\\M\\Z16)";DelayUpdate
SetAxis bottom ylow,yhigh;DelayUpdate
SetAxis left xlow,xhigh
ModifyGraph lblMargin(left)=3
ModifyGraph lblMargin(bottom)=7
ModifyGraph mirror=1
ModifyGraph standoff=0
ModifyGraph width=sizey,height=sizex
SavePICT/E=-6/B=288/P=path as "FermiSurface.jpg"

DoWindow/K CutXImage
Display as "X Projection"; AppendImage CutXNE
DoWindow/C CutXImage
ModifyGraph swapXY=1
ModifyGraph fSize=16;DelayUpdate
Label bottom "\\Z16k\\Bx\\M\\Z16 (Å\\S-1\\M\\Z16)";DelayUpdate
SetAxis bottom xlow,xhigh;DelayUpdate
ModifyGraph manTick=0;DelayUpdate
Label left "\\Z16Binding Energy (eV)"
ModifyGraph width=sizex,height=sizebe
ModifyGraph swapXY=0
ModifyGraph mirror=1
ModifyGraph standoff=0
ModifyGraph lblMargin(left)=3
ModifyGraph lblMargin(bottom)=0
SetAxis bottom ehigh,elow
SavePICT/E=-6/B=288/P=path as "X Projection.jpg"

DoWindow/K CutYImage
Display as "Y Projection"; AppendImage CutYNE
DoWindow/C CutYImage
ModifyGraph swapXY=1
ModifyGraph fSize=16;DelayUpdate
Label bottom "\\Z16k\\Bx\\M\\Z16 (Å\\S-1\\M\\Z16)";DelayUpdate
SetAxis left elow,ehigh
ModifyGraph manTick=0;DelayUpdate
Label left "\\Z16Binding Energy (eV)"
SetAxis bottom ylow,yhigh
ModifyGraph width=sizey,height=sizebe
ModifyGraph mirror=1
ModifyGraph standoff=0
ModifyGraph lblMargin(left)=0
ModifyGraph lblMargin(bottom)=7
Label bottom "\\Z16k\\By\\M\\Z16 (Å\\S-1\\M\\Z16)"
SavePICT/E=-6/B=288/P=path as "Y Projection.jpg"
end

function getSlice1 ()
	wave CutY_K_B
	Duplicate/O CutY_K_B Slice1
	print time() + ": Slice 1 duplicated. kx="
end

function getSlice2 ()
	wave CutX_K_B
	Duplicate/O CutX_K_B Slice2
	print time() + ": Slice 1 duplicated. ky="
end

function getSlice3 ()
	wave CutY_K_B
	Duplicate/O CutY_K_B Slice3
	print time() + ": Slice 1 duplicated. kx="
end

function getSlice4 ()
	wave CutX_K_B
	Duplicate/O CutX_K_B Slice4
	print time() + ": Slice 1 duplicated. ky="
end

function getSlice5 ()
	wave LayerN_K
	Duplicate/O LayerN_K Slice5
	print time() + ": Slice 1 duplicated. E="
end