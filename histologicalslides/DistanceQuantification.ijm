//run("Options...", "iterations=1 count=1 black");

dirwheretosave="F:/Analyses_histo/PluginCellularite/resultatstest/";
/**
 * identify valve
 */
ori=getTitle();
run("Clear Results");
roiManager("reset");
// Work from one QupathRegion with one color (possibly optical sum) and with overlay
// Smooth to help
height=getHeight();
width=getWidth();
getPixelSize(unit, pixelWidth, pixelHeight);
run("8-bit");
run("Gaussian Blur...", "sigma=10");

// Create the mask and morphologically process it
setAutoThreshold("Otsu");
//setThreshold(0, 36);
setOption("BlackBackground", false);
run("Convert to Mask");


run("Invert");

run("Keep Largest Region");
tmp1=getTitle();
run("Fill Holes (Binary/Gray)");

//run("Invert");
//run("Invert LUT");
selectWindow(tmp1);
close();
//adding report of manual selection
run("Restore Selection");
setBackgroundColor(255, 255, 255);
run("Clear Outside");
//user interaction to clean for distance;
waitForUser("remove not valve part and click ok (clear outside the ROI if needed)");
mask=getTitle();
/*
 * identify borders
 */
run("Set Measurements...", "area display redirect=None decimal=5");
//setTool("wand");
run("Analyze Particles...", "add");
roiManager("Select", 0);
roiManager("Rename", "valve");
roiManager("Measure");
surfacevalve=getResult("Area", 0);
run("Clear Results");
// prepare the border identification
run("Enlarge...", "enlarge=-5");
run("Make Band...", "band=10");
roiManager("Add");
roiManager("Select", 1);
roiManager("Rename", "ring");

name=newArray("Free_Edge","Base","Ventricular_side","Atrial_Side")
for(i=0;i<2;i++){
	setTool("polygon");
	waitForUser("Select "+name[i]+" part of the valve as a rough polygon and clik ok");
	roiManager("Add");
	roiManager("Select", newArray(1,2+(i*2)));
	roiManager("AND");
	roiManager("Add");
	roiManager("Select", 3+(i*2));
	roiManager("Rename", name[i]);
}

setForegroundColor(255, 255, 255);

// use Base and Free_edge to create ventricular side and Atrial Side
newImage("edges", "8-bit black", width, height, 1);
selectROIbyname(name[0]);

run("Fill", "slice");
;
selectROIbyname(name[1]); //basis
run("Fill", "slice");

newImage("ring", "8-bit black", width, height, 1);
selectROIbyname("ring"); 
run("Fill", "slice");

imageCalculator("Subtract create", "ring","edges");
both=getTitle();
selectWindow("ring");
close();
selectWindow("edges");
close();

for(i=2;i<4;i++){
	selectWindow(both);
	roiManager("Show None");
	setTool("wand");
	waitForUser("Click on "+name[i]+" part of the valve and click ok");
	roiManager("Add");
	roiManager("Select", roiManager("count")-1);
	roiManager("Rename", name[i]);
}
selectWindow(both);
close();
/*
 * compute geodesic distance map using MorphoLibJ
 */


for(i=0;i<4;i++){
	newImage("marker"+name[i], "8-bit black", width, height, 1);
	selectROIbyname(name[i]);
	run("Fill", "slice");
	run("Geodesic Distance Map", "marker=marker"+name[i]+" mask="+mask+" distances=[Chessknight (5,7,11)] output=[16 bits] normalize");
	rename("distancemap"+name[i]);

}
/*
* Save nuclei ROI and measure for each nuceli is position on the geodeic distance map
*/
roiManager("Deselect");

roiManager("Save", dirwheretosave+ori+"_RoiSetdistance.zip");

// Now create Measure 
roiManager("Reset");


run("Set Measurements...", "mean max centroid display redirect=None decimal=5");
selectWindow(ori);

run("To ROI Manager");
roiManager("Deselect");

selectWindow("distancemap"+name[0]);
roiManager("Measure");
m0=newArray(nResults);
m1=newArray(nResults);
m2=newArray(nResults);
m3=newArray(nResults);
tab=newArray(nResults);
mnormalized=newArray(nResults);

x=newArray(nResults);
y=newArray(nResults);
n=nResults;
infinityvalue=sqrt(pow(width,2)+pow(height,2));
j=0;
for (i = 0; i < nResults; i++) {	
	tab[i]=getResult("Mean", i);
	if (tab[i]<infinityvalue)
	{

	m0[j]=tab[i];
	
	
	x[j]=getResult("X", i);
	y[j]=getResult("Y", i);
	j=j+1;
	}
}
m0=Array.trim(m0, j);
x=Array.trim(x, j);
y=Array.trim(y, j);

run("Clear Results");
selectWindow("distancemap"+name[1]);
roiManager("Measure");
j=0;
for (i = 0; i < nResults; i++) {	
	
	
	if (tab[i]<infinityvalue)
	{

	m1[j]=getResult("Mean", i);
	j++;
	
	}
}

m1=Array.trim(m1, j);

run("Clear Results");
selectWindow("distancemap"+name[2]);
roiManager("Measure");

j=0;
for (i = 0; i < nResults; i++) {	
	
	
	if (tab[i]<infinityvalue)
	{

	m2[j]=getResult("Mean", i);
	j++;
	
	}
}

m2=Array.trim(m2, j);

run("Clear Results");
selectWindow("distancemap"+name[3]);
roiManager("Measure");

j=0;
for (i = 0; i < nResults; i++) {		
	
	if (tab[i]<infinityvalue)
	{

	m3[j]=getResult("Mean", i);
	j++;
	
	}
}

m3=Array.trim(m3, j);

run("Clear Results");



waitForUser("ok?");
maxedgetouse=infinityvalue;//base
print(maxedgetouse);
// Base normalized for quantile estimation
edgetoprocess="distancemap"+name[1]; //base
edgetouse="distancemap"+name[3];//atrial
// get maxbase for base atrial normalization (not the same for ventricular/atrial)
selectWindow(edgetoprocess);//base
run("Duplicate...", " ");
getStatistics(area, mean, min, max, std, histogram);
changeValues(max,max,0) ;

getStatistics(area, mean, min, max, std, histogram);
close();
maxbase=max;
createnewNormalizeddistancemapforbase(edgetoprocess,edgetouse,maxbase);
waitForUser("check normalized map base has been generated");
run("Properties...", "channels=1 slices=1 frames=1 unit=um pixel_width="+pixelWidth+" pixel_height="+pixelWidth+" voxel_depth=1");
saveAs("Tiff", dirwheretosave+ori+"_distancemapnormalized_"+name[1]+".tif");

// Atrial normalized for quantile estimation
//maxedgetouse=100;
edgetoprocess="distancemap"+name[3]; //atrial
edgetouse="distancemap"+name[1];//base


createnewNormalizeddistancemap(edgetoprocess,edgetouse,maxedgetouse);
waitForUser("check normalized map has been generated");
selectWindow(edgetoprocess+"_normalized");
roiManager("Measure");
j=0;
for (i = 0; i < nResults; i++) {	
	if (tab[i]<infinityvalue)
	{

	mnormalized[j]=getResult("Mean", i);
	j++;
	
	}
	
	
}
mnormalized=Array.trim(mnormalized, j);
run("Clear Results");

for (i=0; i<m0.length; i++) {
      setResult("x", i,x[i]);
      setResult("y", i, y[i]);
      setResult(name[0]+"_raw", i, m0[i]);
      setResult(name[1]+"_raw", i, m1[i]);
      setResult(name[0]+"_rawum",i, m0[i]*pixelWidth);
      setResult(name[1]+"_rawum",i, m1[i]*pixelWidth);
 	 
      setResult(name[0]+"_normalized", i, m0[i]/maxbase);
      setResult(name[1]+"_normalized", i, m1[i]/maxbase);

      setResult(name[2]+"_raw", i, m2[i]);
       setResult(name[2]+"_rawum",i, m2[i]*pixelWidth);
      setResult(name[3]+"_raw", i, m3[i]);
      setResult(name[3]+"_rawum",i, m3[i]*pixelWidth);
       setResult(name[3]+"_normalized", i, mnormalized[i]);

      setResult("totalsurface", i, surfacevalve);
      setResult("totalsurfaceum",i,surfacevalve*pixelWidth*pixelWidth);
    }
saveAs("Results", dirwheretosave+ori+"_Results.csv");
for(i=0;i<4;i++){	
	selectWindow("distancemap"+name[i]);
	run("Properties...", "channels=1 slices=1 frames=1 unit=um pixel_width="+pixelWidth+" pixel_height="+pixelWidth+" voxel_depth=1");
	saveAs("Tiff", dirwheretosave+ori+"_distancemap_"+name[i]+".tif");
}
selectWindow(edgetoprocess+"_normalized");
run("Properties...", "channels=1 slices=1 frames=1 unit=um pixel_width="+pixelWidth+" pixel_height="+pixelWidth+" voxel_depth=1");
saveAs("Tiff", dirwheretosave+ori+"_distancemapnormalized_"+name[3]+".tif");
/**
 * Functions used 
 */
function selectROIbyname(nametotest){
	index=-1;
	for (i = 0; i <roiManager("count"); i++) {
		roiManager("select",i);
		if (Roi.getName==nametotest){
			index=i;
			print(nametotest +" " +index);
		}
	}
	roiManager("select",index);
}

function createnewNormalizeddistancemap(edgetoprocess,edgetouse,maxedgetouse){
newImage(edgetoprocess+"_normalized", "32-bit black", width, height, 1);
setBatchMode(true);

IJ.log(edgetoprocess+": max="+maxedgetouse);
	for (v=0;v<=maxedgetouse;v++){
		showProgress(v/maxedgetouse);
		selectWindow(edgetouse);
		run("Duplicate...", "title=tmp");
		setThreshold(v, v);
		setOption("BlackBackground", false);
		run("Convert to Mask");
	    
		getStatistics(area, mean, min, max, std, histogram);
		
		
		if(area!=0){
			if(min!=max){
			
				
			//problem identifie: pour la base on ne normalize pas par le max le long de la ligne...
				run("Create Selection");
				Roi.getContainedPoints(xpoints, ypoints);
				selectWindow(edgetoprocess);
				linesvalues=newArray(xpoints.length);
				for (i = 0; i < xpoints.length; i++) {
	
					linesvalues[i]=getValue(xpoints[i], ypoints[i]);
	
				}
				
				Array.getStatistics(linesvalues, min, max, mean, stdDev) ;
			
				selectWindow(edgetoprocess+"_normalized");
				for (i=0;i<xpoints.length;i++){
				setPixel(xpoints[i], ypoints[i], linesvalues[i]/max);
				}
				
			}
		}
		selectWindow("tmp");
		close();
	}
	setBatchMode(false)
	updateDisplay() ;
}
function createnewNormalizeddistancemapforbase(edgetoprocess,edgetouse,maxtouse){
run("Duplicate...", " ");
rename(edgetoprocess+"_normalized");

run("32-bit");
IJ.log(edgetoprocess+": max="+maxtouse);
run("Divide...", "value="+maxedgetouse);
run("Enhance Contrast", "saturated=0.35");
}