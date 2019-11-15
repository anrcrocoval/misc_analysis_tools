1) Jar is here (replace .jar in by these one) https://uncloud.univ-nantes.fr/index.php/s/CDHtwRtMGgseXtR (jar.zip, please unzip) with Maven I am including all libs which makes the file awfully heavy, hence the WIP) 
2) An example protocol for command line using the ec-clem block  (testProtpcolsinputcommandline.protocol )
3) here is the command line (the protocol given in example is assuming that the ROI are already loaded, please modify according to your protocol, see instructions at the end of the email). (I am on Windows, note that ICY is noty in nmy opath and that I need to launch the command line from the directiry where ICY is installed in order for prtocol plugin to be found)



D:\icy>java -jar "D:\icy\icy.jar" -hl -x plugins.adufour.protocols.Protocols protocol="C:\Users\paul-gilloteaux-p\Documents\GitHub\ANRCROCOVAL\misc_analysis_tools\exampleofICYProtocols\testProtocolsinputcommandline.protocol" source="EM_QDots100-HighMag.tif" target="Fluorescent micrograph-8bits.tif" output="test.tif"
Initializing...
Java(TM) SE Runtime Environment 1.8.0_221-b11 (64 bit)
Running on Windows 10 10.0 (amd64)
Number of processors : 6
System total memory : 33.3 GB
System available memory : 21.1 GB
Max java memory : 7.4 GB
Image cache initialized (reserved memory = 2894 MB, disk cache location = D:\tmpcache)
Headless mode.
java.lang.UnsatisfiedLinkError: D:\icy\lib\win64\vtk\vtkRenderingCoreJava.dll: Can't find dependent libraries
Cannot load VTK library...
Icy Version 2.0.3.0 started !
Loading workflow...
Resulting Transformation will be saved as:
EM_QDots100-HighMag.tif_to_Fluorescent micrograph-8bits_transfo.xml
and points used for the registration as:
EM_QDots100-HighMag.tif_to_Fluorescent micrograph-8bits_points.xml
Exiting...
EHCache disposed

and the other way just exchange source and target flag: 
D:\icy>java -jar "D:\icy\icy.jar" -hl -x plugins.adufour.protocols.Protocols protocol="C:\Users\paul-gilloteaux-p\Documents\GitHub\ANRCROCOVAL\misc_analysis_tools\exampleofICYProtocols\testProtocolsinputcommandline.protocol" target="EM_QDots100-HighMag.tif" source="Fluorescent micrograph-8bits.tif" output="testinverse.tif"
Initializing...
Java(TM) SE Runtime Environment 1.8.0_221-b11 (64 bit)
Running on Windows 10 10.0 (amd64)
Number of processors : 6
System total memory : 33.3 GB
System available memory : 21.0 GB
Max java memory : 7.4 GB
Image cache initialized (reserved memory = 2894 MB, disk cache location = D:\tmpcache)
Headless mode.
java.lang.UnsatisfiedLinkError: D:\icy\lib\win64\vtk\vtkRenderingCoreJava.dll: Can't find dependent libraries
Cannot load VTK library...
Icy Version 2.0.3.0 started !
Loading workflow...
Resulting Transformation will be saved as:
Fluorescent micrograph-8bits.tif_to_EM_QDots100-HighMag_transfo.xml
and points used for the registration as:
Fluorescent micrograph-8bits.tif_to_EM_QDots100-HighMag_points.xml
Exiting...
EHCache disposed

To add a command line input (to do once)  here is the procedure for example for your csv or other files) : 
- Load your protocol from Protocol in ICY 
- Right click on workspace, go to Read… then select File
- This will create a File block.
- Click on the small cubes icon of your block, then give an id (example in my command line : source, target, output,... ) and click on the checkbox icon next to it to save it.
- Connect your block (File output to input file from a File to sequence block for example, see example protocol provided)
- repeat for all file that you need to input /output from the command file

4) NOTE that the EC CLEM block has no output filename for the xml, since it's name is constructed from the source and target name files.
I ve also forgot to add in the xml file the source (Moving) and target (fixed) filename, this is a good thing (and quick) TODO
_points.xml contains the roi point (source and target)
_transfo.xml  contains the transfo matrix (final one)
