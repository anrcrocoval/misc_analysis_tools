import ij.plugin.frame.RoiManager

def path = 'C:\\Users\\paul-gilloteaux-p\\Desktop\\rois.zip';
selectObjectsByClassification("BA positive");
def annotations = getSelectedObjects();
def roiMan = new RoiManager(false)
double x = 0
double y = 0
double downsample = 1 // Increase if you want to export to work at a lower resolution
annotations.each {
  def roi = IJTools.convertToIJRoi(it.getROI(), x, y, downsample)
  roiMan.addRoi(roi)
}
roiMan.runCommand("Save", path)