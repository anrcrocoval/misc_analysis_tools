setwd("C:/Users/paul-gilloteaux-p/Documents/GitHub/ANRCROCOVAL/misc_analysis_tools/histologicalslides/BleuAlcyan/test")
#file.choose()
# Install the released version from CRAN:
#install.packages("stringr")
library("stringr")
listfile=dir()

i=0
data=NULL

for (n in listfile)
{
	
	
	if (grepl("Absolutewidth.csv", n)==TRUE)
	{
		print(n)
		dat <-read.csv(n, sep=",")
		plot(dat$storenormalizedpos[-1],dat$storewidthum[-1],type="b",pch=20, col =2) #plot all but first element
		par(new=TRUE)
		n=str_replace(n, "Absolutewidth.csv", "AbsoluteBA.csv")
		print(n)
		dat <-read.csv(n, sep=",")
		plot(dat$storenormalizedposBA[-1],dat$storeBApc[-1]*100,type="b",,pch=20,col=3, axes = FALSE, xlab="",ylab="") #plot all but first element
		axis(side=4,at=pretty(range(dat$storeBApc[-1]*100)))		
		mtext("pc covered by BA on geodesic lines", side =4,line=3)
		title(str_replace(n, "AbsoluteBA.csv",""))

		readline(prompt="Press [enter] to continue")
	}


}

