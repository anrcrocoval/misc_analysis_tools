// Macro written by Philippe Hulin, MicroPICell, to visualize slacks just acquired by the KIS SBFI system
//corrected by Perrine on the 25/06/2021
path = getDir("Imagestoberead");

list=getFileList(path); //liste des fichiers qui sont dans le dossier

// for(i=0; i<list.length; i++) { //passe dans tous les fichiers de ce dossier
for (i=0; i<list.length; i++) { //passe dans tous les fichiers de ce dossier
    if (endsWith(list[i], "Subtracted.tif")) { 
    //ne fait la suite que si le fichier est de type "subtracted.tif"
    choisis="Refresh";
    while(choisis=="Refresh"){
        run("Image Sequence...","open="+path+list[i]+" file=Subtracted.tif convert sort");
        run("StackReg", "transformation=Translation");
        run("Open in ClearVolume");
        waitForUser("Click OK to reload");
        Dialog.create("Refresh or quit?");
        items = newArray("Refresh","Quit");
        Dialog.addRadioButtonGroup("Choice",items, 1,2,"Refresh");
        Dialog.show;
        //run("Orthogonal Views");
        choisis=Dialog.getRadioButton();
        list=getFileList(path);
        close();
    } 
    break;
}
}
