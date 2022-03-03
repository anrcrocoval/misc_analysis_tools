setwd("C:/Users/paul-gilloteaux-p/Documents/GitHub/ANRCROCOVAL/misc_analysis_tools/histologicalslides/BleuAlcyan/test")
#file.choose()
# Install the released version from CRAN:
#install.packages("stringr")
#install.packages("zoo")
library("stringr")
library("zoo") #maybe to use rollmean
listfile=dir()

i=0
data=NULL
for (n in listfile)
{
	
	
	if (grepl("Absolutewidth.csv", n)==TRUE)
	{
		print(n)
		datW <-read.csv(n, sep=",")
		plot(datW$storenormalizedpos[-1],datW$storewidthum[-1],type="b",pch=20, col =2,ylim=c(0,350)) #plot all but first element
		
		par(new=TRUE)

		n=str_replace(n, "Absolutewidth.csv", "AbsoluteBA.csv")
		print(n)
		datBA <-read.csv(n, sep=",")
		plot(datBA$storenormalizedposBA[-1],datBA$storeBApc[-1]*datW$storewidthum[-1],type="b",pch=20,col=3, ylim=c(0,350),axes = FALSE, xlab="",ylab="") #plot all but first element
		title(str_replace(n, "AbsoluteBA.csv",""))
	
		readline(prompt="Press [enter] to continue")
		readline(prompt="Press [enter] to continue")
		par(new=FALSE)
		plot(rollmean(datBA$storeBApc[-1]*100,10),type="b",pch=20,col=3, ylim=c(0,100)) #plot all but first element
		title(str_replace(n, "AbsoluteBA.csv",""))
	
		readline(prompt="Press [enter] to continue")
		readline(prompt="Press [enter] to continue")

	}




}

