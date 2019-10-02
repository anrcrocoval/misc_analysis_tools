//start with atrial image openned
mydir=File.directory;
quantile_atrial_vascular=3;
quantile_free_base=5;
atrial=getTitle();
base=replace(atrial, "Atrial_Side", "Base");
run("32-bit");
getStatistics(area, mean, min, max, std, histogram);
changeValues(max,max,0) ;
getStatistics(area, mean, min, max, std, histogram);
maxatrial=max;
open(mydir+File.separator+base);
run("32-bit");
getStatistics(area, mean, min, max, std, histogram);
changeValues(max,max,0) ;
getStatistics(area, mean, min, max, std, histogram);
maxbase=max;

newImage("areatab", "16-bit",quantile_atrial_vascular, quantile_free_base,1);

for (a =0; a < quantile_atrial_vascular; a++) {
	selectWindow(atrial);
	run("Duplicate...", "title=dupatrial");
	//quantileatrial
	selectWindow("dupatrial");
	run("Select None");
	n=a+0.00001;
	setThreshold((n*maxatrial)/quantile_atrial_vascular,((n+1)*maxatrial)/quantile_atrial_vascular);
	run("Convert to Mask");
	for(b=0;b<quantile_free_base;b++){
		selectWindow(base);
		run("Duplicate...", "title=dupbase");
		n=b+0.00001;
		setThreshold((n*maxbase)/quantile_free_base,((n+1)*maxbase)/quantile_free_base);
		run("Convert to Mask");
		imageCalculator("AND create", "dupbase","dupatrial");
		result=getTitle();
		run("Analyze Particles...", "size=100-Infinity display");// warning for now double area are ealed with that to be tested further.
		waitForUser("check");
		selectWindow("areatab");
		setPixel(a, b, getResult("Area", nResults-1));
		selectWindow(result);
		close();
		selectWindow("dupbase");
		close();
		
	}
	selectWindow("dupatrial");
		close();
}

saveAs("Results", mydir+"ResultsArea_"+quantile_atrial_vascular+"_"+quantile_free_base+".txt");