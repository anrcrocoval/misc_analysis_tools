//Open the exported image from QUPATH
run("8-bit");
run("To ROI Manager");

roiManager("Select", 0);

setBackgroundColor(0, 0, 0);
run("Clear Outside");
setForegroundColor(255, 255, 255);
run("Fill", "slice");

roiManager("Deselect");
roiManager("Delete");
roiManager("Open", "C:/Users/perri/GITHUB/misc_analysis_tools/histologicalslides/BleuAlcyan/test/RoiSet_quantile.zip");

getPixelSize(unit, pixelWidth, pixelHeight);
run("Set Measurements...", "area integrated display redirect=None decimal=3");
roiManager("Measure");
for (i = 0; i < nResults(); i++) {
    v = getResult('IntDen', i);
    area=getResult('Area', i);
    setResult('Area in '+unit, i, v* pixelWidth* pixelHeight/255);
    setResult('ratio', i, (v* pixelWidth* pixelHeight/255)/area);
}
updateResults();
