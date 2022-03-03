//start with atrial NORMALIZED image openned

//create new tab with quantile in previous results and copy area



run("Set Measurements...", "area redirect=None decimal=5");

mydir=File.directory;
Dialog.create("Quantile choice");
Dialog.addNumber("Quantile Atrial to ventricular",3);
Dialog.addNumber("Quantile free to base",5);
Dialog.show();
quantile_atrial_vascular=Dialog.getNumber();
quantile_free_base=Dialog.getNumber();
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
	Th_atrial_min=(n*maxatrial)/quantile_atrial_vascular;
	Th_atrial_max=((n+1)*maxatrial)/quantile_atrial_vascular;
	run("Convert to Mask");
	for(b=0;b<quantile_free_base;b++){
		selectWindow(base);
		run("Duplicate...", "title=dupbase");
		n=b+0.00001;
		setThreshold((n*maxbase)/quantile_free_base,((n+1)*maxbase)/quantile_free_base);
		Th_base_min=(n*maxbase)/quantile_free_base;
		Th_base_max=((n+1)*maxbase)/quantile_free_base;
		run("Convert to Mask");
		imageCalculator("AND create", "dupbase","dupatrial");
		result=getTitle();
		run("Analyze Particles...", "size=100-Infinity display add");// warning for now double area are ealed with that to be tested further.
		roiManager("Select", roiManager("count")-1);
		roiManager("Rename", "atrial"+(a+1)+"_base"+(b+1));
		selectWindow("areatab");
		setPixel(a, b, getResult("Area", nResults-1));
		selectWindow(result);
		close();
		selectWindow("dupbase");
		close();
		setResult("Quantile_atrial", nResults-1, a);
		setResult("Quantile_base", nResults-1, b);
		setResult("Th_atrial_min", nResults-1, Th_atrial_min);
		setResult("Th_atrial_max", nResults-1, Th_atrial_max);
		setResult("Th_base_min", nResults-1, Th_base_min);
		setResult("Th_base_max", nResults-1, Th_base_max);
	}
	selectWindow("dupatrial");
		close();
}

roiManager("Deselect");
roiManager("Save", mydir+"RoiSet_quantile.zip");
waitForUser("done, ROI with valvular part were saved under" +mydir+"RoiSet_quantile.zip");