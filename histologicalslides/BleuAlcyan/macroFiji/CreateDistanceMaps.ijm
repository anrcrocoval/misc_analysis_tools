//run("Options...", "iterations=1 count=1 black");

//dirwheretosave="F:/Analyses_histo/PluginCellularite/resultatstest/";
logwidth=true;
logBA=true;
dirwheretosave="C:/Users/perri/GITHUB/misc_analysis_tools/histologicalslides/BleuAlcyan/test/";
/**
 * identify valve
 */
distminhole=3;
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
setOption("BlackBackground", true);
run("Convert to Mask");


//run("Invert");

run("Keep Largest Region");
tmp1=getTitle();
run("Fill Holes (Binary/Gray)");

//run("Invert");
//run("Invert LUT");
selectWindow(tmp1);
close();
//adding report of manual selection
run("Restore Selection");
setBackgroundColor(0, 0, 0);
setForegroundColor(255,255,255);
run("Clear Outside");
//user interaction to clean for distance;
waitForUser("hello remove not valve part and click ok (clear outside the ROI if needed)");
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
	setOption("BlackBackground", false);
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





infinityvalue=sqrt(pow(width,2)+pow(height,2));


run("Tile");

waitForUser("ok?");
maxedgetouse=infinityvalue;//base
print(maxedgetouse);
/* Base normalized for quantile estimation
 *  
 */
edgetoprocess="distancemap"+name[1]; //base
edgetouse="distancemap"+name[3];//atrial
// get maxbase for base atrial normalization (not the same for ventricular/atrial)
selectWindow(edgetoprocess);//base
run("Duplicate...", "title=tmpbase");
selectWindow("tmpbase");
getStatistics(area, mean, min, max, std, histogram);
changeValues(max,max,0) ;

getStatistics(area, mean, min, max, std, histogram);
selectWindow("tmpbase");
close();
maxbase=max;
IJ.log("max for base "+maxbase);
createnewNormalizeddistancemapforbase(edgetoprocess,edgetouse,maxbase);
run("mpl-inferno");
setMinAndMax(0, 1);




run("Properties...", "channels=1 slices=1 frames=1 unit=um pixel_width="+pixelWidth+" pixel_height="+pixelWidth+" voxel_depth=1");
saveAs("Tiff", dirwheretosave+ori+"_distancemapnormalized_"+name[1]+".tif");
rename(edgetoprocess+"_normalized");


/**
 * ATRIAL normalized
 */
// Atrial normalized for quantile estimation
//maxedgetouse=100;
edgetoprocess="distancemap"+name[3]; //atrial
edgetouse="distancemap"+name[1];//base
IJ.log("max from "+ edgetoprocess+" using "+edgetouse+"= "+ maxedgetouse);
createnewNormalizeddistancemap(edgetoprocess,edgetouse,maxbase,logwidth,logBA); // change here for normalization purpose
run("mpl-inferno");
setMinAndMax(0, 1);

run("Tile");
waitForUser("check normalized maps for atrial and base has been generated");
selectWindow(edgetoprocess+"_normalized");


for(i=0;i<4;i++){	
	selectWindow("distancemap"+name[i]);
	run("Properties...", "channels=1 slices=1 frames=1 unit=um pixel_width="+pixelWidth+" pixel_height="+pixelWidth+" voxel_depth=1");
	saveAs("Tiff", dirwheretosave+ori+"_distancemap_"+name[i]+".tif");
}
selectWindow(edgetoprocess+"_normalized");
run("Properties...", "channels=1 slices=1 frames=1 unit=um pixel_width="+pixelWidth+" pixel_height="+pixelWidth+" voxel_depth=1");
saveAs("Tiff", dirwheretosave+ori+"_distancemapnormalized_"+name[3]+".tif");
waitForUser("Done. Results have been saved in "+dirwheretosave);

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

/**
 * Function create normalize dfor ATRIAL/VENTRICULAR
 */
function createnewNormalizeddistancemap(edgetoprocess,edgetouse,maxedgetouse,logwidth,logBA){
	
	newImage(edgetoprocess+"_normalized", "32-bit black", width, height, 1);
	setBatchMode(true);
	changeValues(0,0,infinityvalue) ;
	IJ.log(edgetoprocess+": max="+maxedgetouse);
	if (logwidth){
	IJ.log("will save the width as "+dirwheretosave+ori+"Absolutewidth.csv");	
	storewidthraw=newArray(maxedgetouse+1);
	storewidthum=newArray(maxedgetouse+1);
	storepos=newArray(maxedgetouse+1);
	storenormalizedpos=newArray(maxedgetouse+1);
	}
	if (logBA){
	IJ.log("will save the width as "+dirwheretosave+ori+"BApcline.csv");	
	storeBAraw=newArray(maxedgetouse+1);
	storeBApc=newArray(maxedgetouse+1);
	storeposBA=newArray(maxedgetouse+1);
	storenormalizedposBA=newArray(maxedgetouse+1);
	}
	for (v=0;v<=maxedgetouse;v++){
		
		showProgress(v/maxedgetouse);
		selectWindow(edgetouse);
		run("Duplicate...", "title=tmp");
		setThreshold(v, v);
		setOption("BlackBackground", false);
		run("Convert to Mask");
	    
		getStatistics(area, mean, min, max, std, histogram);

		if (logwidth){
		storenormalizedpos[v]=v/maxedgetouse;
		storepos[v]=v;
		}
		if (logBA){
		storenormalizedposBA[v]=v/maxedgetouse;
		storeposBA[v]=v;
		}
		if(area!=0){
			if(min!=max){

				run("Create Selection");
				Roi.getContainedPoints(xpoints, ypoints);
				selectWindow(edgetoprocess);
				linesvalues=newArray(xpoints.length);
				
				for (i = 0; i < xpoints.length; i++) {
					
						linesvalues[i]=getValue(xpoints[i], ypoints[i]);
						
				}
				
				Array.getStatistics(linesvalues, min, max, mean, stdDev) ;
				if (logwidth){
				storewidthraw[v]=max;
				storewidthum[v]=max*pixelWidth;
				}
				if (logBA){
				// go to the BA mask
				for (i = 0; i < xpoints.length; i++) {
					
						linesvaluesBA[i]=getValue(xpoints[i], ypoints[i]);
						
				}
				Array.getStatistics(linesvaluesBA, min, max, mean, stdDev) ;	
				storeBAraw[v]=(mean*xpoint.length)/255.0; // got nb of pixels by sum of intensity value /255 , integrated intensity been not directly availble, equivalent to mean * nb pixel on the line
				storeBApc[v]=mean/255.0; // divided by nb points = xpoint.length
				}
				selectWindow(edgetoprocess+"_normalized");
				for (i=0;i<xpoints.length;i++){
					setPixel(xpoints[i], ypoints[i], linesvalues[i]/max);
				}
				
			}
		}
		selectWindow("tmp");
		close();
	}
	setBatchMode(false);
	updateDisplay();
	if (logwidth){
	Array.show("Absolutewidth", storenormalizedpos, storewidthraw, storewidthum);
	selectWindow("Absolutewidth");
	saveAs("Results", dirwheretosave+ori+"Absolutewidth.csv");
	}
	if (logBA){
	Array.show("AbsoluteBA", storenormalizedposBA, storeBAraw, storeBApc);
	selectWindow("AbsoluteBA");
	saveAs("Results", dirwheretosave+ori+"AbsoluteBA.csv");
	}

}

/**
 * Function create normalize dfor BASE/FREE
 */
function createnewNormalizeddistancemapforbase(edgetoprocess,edgetouse,maxtouse){
	run("Duplicate...", " ");
	rename(edgetoprocess+"_normalized");

	run("32-bit");
	IJ.log(edgetoprocess+": max="+maxtouse);
	run("Divide...", "value="+maxtouse);
	run("Enhance Contrast", "saturated=0.35");
	getStatistics(area, mean, min, max, std, histogram);
	changeValues(max,max,infinityvalue) ;

	updateDisplay() ;
}